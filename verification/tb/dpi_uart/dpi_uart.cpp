// dpi_uart.cpp — Simple PTY-backed UART for SystemVerilog DPI
//
// Build (for Questa/ModelSim 64-bit):
//   g++ -std=c++11 -m64 -fPIC -shared -o dpi_uart.so dpi_uart.cpp -I"$QUESTA_HOME/include"
//
// Enable debug printing (RX/TX bytes):
//   g++ -std=c++11 -m64 -fPIC -shared -DDEBUG_UART -o dpi_uart.so dpi_uart.cpp -I"$QUESTA_HOME/include"

#include <fcntl.h>
#include <stdio.h>
#include <termios.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <poll.h>
#include <sys/ioctl.h>
#include <chrono>

// =========================================================
// Simple global variables
// =========================================================
static int  mfd = -1;   // PTY master file descriptor
static char buf = 0;    // last received byte

static int configure_slave_raw(const char *slave_path) {
    int sfd = open(slave_path, O_RDWR | O_NOCTTY | O_NONBLOCK);
    if (sfd < 0) {
        fprintf(stderr, "[dpi-uart] open slave PTY failed: %s\n", strerror(errno));
        return -1;
    }

    struct termios tio;
    if (tcgetattr(sfd, &tio) != 0) {
        fprintf(stderr, "[dpi-uart] tcgetattr failed: %s\n", strerror(errno));
        close(sfd);
        return -1;
    }

    tio.c_iflag &= ~(IGNBRK | BRKINT | PARMRK | ISTRIP | INLCR | IGNCR |
                     ICRNL | IXON | IXOFF | IXANY);
    tio.c_oflag &= ~(OPOST);
    tio.c_lflag &= ~(ECHO | ECHONL | ICANON | ISIG | IEXTEN);
#ifdef ECHOCTL
    tio.c_lflag &= ~(ECHOCTL);
#endif
    tio.c_cflag &= ~(CSIZE | PARENB | CSTOPB);
    tio.c_cflag |= (CS8 | CREAD | CLOCAL);
    tio.c_cc[VMIN] = 0;
    tio.c_cc[VTIME] = 0;

    if (tcsetattr(sfd, TCSANOW, &tio) != 0) {
        fprintf(stderr, "[dpi-uart] tcsetattr raw failed: %s\n", strerror(errno));
        close(sfd);
        return -1;
    }

    close(sfd);
    return 0;
}

// =========================================================
// External interface for SystemVerilog DPI
// =========================================================
extern "C" {

// ---------------------------------------------------------
// Helper: open a new pseudo-terminal and return its slave path
// ---------------------------------------------------------
static int open_pty(char *out_path, size_t out_sz) {
    int fd = posix_openpt(O_RDWR | O_NOCTTY | O_NONBLOCK);
    if (fd < 0) {
        fprintf(stderr, "[dpi-uart] posix_openpt failed: %s\n", strerror(errno));
        return -1;
    }

    if (grantpt(fd) != 0 || unlockpt(fd) != 0) {
        fprintf(stderr, "[dpi-uart] grantpt/unlockpt failed: %s\n", strerror(errno));
        close(fd);
        return -1;
    }

    char *slave = ptsname(fd);
    if (!slave) {
        fprintf(stderr, "[dpi-uart] ptsname failed: %s\n", strerror(errno));
        close(fd);
        return -1;
    }

    if (configure_slave_raw(slave) != 0) {
        close(fd);
        return -1;
    }

    // Set non-blocking mode
    int flags = fcntl(fd, F_GETFL, 0);
    fcntl(fd, F_SETFL, flags | O_NONBLOCK);

    snprintf(out_path, out_sz, "%s", slave);
    return fd;
}

// ---------------------------------------------------------
// SystemVerilog-visible functions
// ---------------------------------------------------------

// Called once at simulation startup
void uart_init(void) {
    char pts_path[128];
    mfd = open_pty(pts_path, sizeof(pts_path));

    if (mfd < 0) {
        fprintf(stderr, "[dpi-uart] Failed to open PTY, falling back to stdin.\n");
        mfd = 0; // fallback (stdin)
        return;
    }

    fprintf(stderr,
            "[dpi-uart] PTY ready: %s  (connect using: screen %s 115200)\n",
            pts_path, pts_path);
}

// Called repeatedly from SV to check if there is data
int uart_tx_is_data_available(void) {
    if (mfd < 0) return 0;

    ssize_t r = read(mfd, &buf, 1);
    if (r == 1) {
#ifdef DEBUG_UART
        fprintf(stderr, "[dpi-uart] TX: 0x%02X '%c'\n",
                (unsigned char)buf,
                (buf >= 0x20 && buf <= 0x7E) ? buf : '.');
#endif
        return 1;  // one byte received
    }
    return 0;      // no data available
}

// Called by SV to get the received byte
int uart_tx_get_data(void) {
    return (unsigned char)buf;
}

// Called by SV when it sends a new byte
void uart_rx_new_data(unsigned char chr) {
    if (mfd < 0) return;

    unsigned char c = (unsigned char)chr;
    ssize_t w = write(mfd, &c, 1);

#ifdef DEBUG_UART
    if (w == 1)
        fprintf(stderr, "[dpi-uart] RX: 0x%02X '%c'\n",
                c, (c >= 0x20 && c <= 0x7E) ? c : '.');
#endif
    (void)w;
}

// Wait for the host to consume the final UART response before the simulator
// closes the PTY master. Closing a master discards unread slave-side input;
// tcdrain(master) only waits for the write into the PTY, not the host's read.
// This entry point is imported only by the Verilator testbench.
int uart_flush(void) {
    const char *slave = mfd >= 0 ? ptsname(mfd) : nullptr;
    int sfd = slave ? open(slave, O_RDONLY | O_NOCTTY | O_NONBLOCK) : -1;
    if (sfd < 0) {
        fprintf(stderr, "[dpi-uart] Cannot inspect final response queue: %s\n",
                strerror(errno));
        return 0;
    }

    const auto deadline = std::chrono::steady_clock::now() + std::chrono::seconds(1);
    int pending = 0;
    for (;;) {
        // Linux N_TTY poll synchronizes the flip-buffer worker when the read
        // queue appears empty. FIONREAD alone can report zero before a recent
        // master write has reached that queue. If poll saw data which the host
        // consumed concurrently, retry to synchronize any remaining writes.
        struct pollfd descriptor = {sfd, POLLIN, 0};
        int ready = poll(&descriptor, 1, 0);
        if (ready < 0 && errno == EINTR) continue;
        if (ready < 0 || (descriptor.revents & (POLLERR | POLLHUP | POLLNVAL)) ||
            ioctl(sfd, FIONREAD, &pending) != 0) {
            fprintf(stderr, "[dpi-uart] Failed to inspect final response queue\n");
            close(sfd);
            return 0;
        }
        if (ready == 0 && pending == 0) {
            close(sfd);
            return 1;
        }
        if (std::chrono::steady_clock::now() >= deadline) {
            fprintf(stderr, "[dpi-uart] Timed out draining final response (%d unread bytes)\n",
                    pending);
            close(sfd);
            return 0;
        }
        usleep(1000);
    }
}

} // extern "C"
