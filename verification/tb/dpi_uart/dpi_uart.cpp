// dpi_uart.cpp — Simple PTY-backed UART for SystemVerilog DPI
//
// Build (for Questa/ModelSim 64-bit):
//   g++ -m64 -fPIC -shared -o dpi_uart.so dpi_uart.cpp -I"$QUESTA_HOME/include"
//
// Enable debug printing (RX/TX bytes):
//   g++ -m64 -fPIC -shared -DDEBUG_UART -o dpi_uart.so dpi_uart.cpp -I"$QUESTA_HOME/include"

#include <fcntl.h>
#include <stdio.h>
#include <termios.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

// =========================================================
// Simple global variables
// =========================================================
static int  mfd = -1;   // PTY master file descriptor
static char buf = 0;    // last received byte

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
        fprintf(stderr, "[dpi-uart] RX: 0x%02X '%c'\n",
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
        fprintf(stderr, "[dpi-uart] TX: 0x%02X '%c'\n",
                c, (c >= 0x20 && c <= 0x7E) ? c : '.');
#endif
    (void)w;
}

} // extern "C"
