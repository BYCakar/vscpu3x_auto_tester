// Run the existing timed SystemVerilog testbench, including its DPI UART.
#include "Vvscpu3x_test_tb.h"
#include "verilated.h"
#if VM_TRACE
#include "verilated_vcd_c.h"
#endif
#if VM_COVERAGE
#include "verilated_cov.h"
#endif

#include <csignal>
#include <cstdint>
#include <cstdio>
#include <limits>
#include <stdexcept>
#include <string>

namespace {
volatile std::sig_atomic_t interrupted = 0;

void on_signal(int signal) { interrupted = signal; }

struct Options {
    uint64_t max_time_ns = 0;
    std::string trace_file = "sim.vcd";
    std::string coverage_file = "coverage.dat";
};

uint64_t positive_integer(const std::string& value) {
    uint64_t result = 0;
    if (value.empty()) throw std::runtime_error("+MAX_SIM_TIME_NS needs a positive integer");
    for (char ch : value) {
        if (ch < '0' || ch > '9'
            || result > (std::numeric_limits<uint64_t>::max() - (ch - '0')) / 10) {
            throw std::runtime_error("invalid or overflowing +MAX_SIM_TIME_NS");
        }
        result = result * 10 + (ch - '0');
    }
    if (!result) throw std::runtime_error("+MAX_SIM_TIME_NS must be greater than zero");
    return result;
}

Options parse_options(int argc, char** argv) {
    Options options;
    const std::string names[] = {"+MAX_SIM_TIME_NS", "+TRACE_FILE", "+COVERAGE_FILE"};
    bool seen[] = {false, false, false};
    for (int i = 1; i < argc; ++i) {
        const std::string arg = argv[i];
        for (int kind = 0; kind < 3; ++kind) {
            const auto& name = names[kind];
            if (arg != name && arg.compare(0, name.size() + 1, name + "=") != 0) continue;
            if (seen[kind]) throw std::runtime_error("duplicate " + name);
            seen[kind] = true;
            if (arg.size() <= name.size() + 1) {
                throw std::runtime_error(name + " requires a nonempty value after '='");
            }
            const auto value = arg.substr(name.size() + 1);
            if (kind == 0) options.max_time_ns = positive_integer(value);
            if (kind == 1) {
#if VM_TRACE
                options.trace_file = value;
#else
                throw std::runtime_error("+TRACE_FILE requires a build with TRACE=1");
#endif
            }
            if (kind == 2) {
#if VM_COVERAGE
                options.coverage_file = value;
#else
                throw std::runtime_error("+COVERAGE_FILE requires a build with COVER=1");
#endif
            }
        }
    }
    return options;
}

uint64_t deadline_ticks(uint64_t nanoseconds, int precision) {
    // Verilator's event times are integer multiples of the model's timeprecision.
    for (int exponent = precision; exponent < -9; ++exponent) {
        if (nanoseconds > std::numeric_limits<uint64_t>::max() / 10) {
            throw std::runtime_error("+MAX_SIM_TIME_NS overflows simulation time");
        }
        nanoseconds *= 10;
    }
    for (int exponent = -9; exponent < precision; ++exponent) {
        if (nanoseconds % 10) {
            throw std::runtime_error("+MAX_SIM_TIME_NS is finer than the model timeprecision");
        }
        nanoseconds /= 10;
    }
    return nanoseconds;
}
}  // namespace

int main(int argc, char** argv) {
    try {
        const auto options = parse_options(argc, argv);
        std::setvbuf(stdout, nullptr, _IOLBF, 0);
        std::signal(SIGINT, on_signal);
        std::signal(SIGTERM, on_signal);
        VerilatedContext context;
        context.threads(1);
        context.commandArgs(argc, argv);
#if VM_TRACE
        context.traceEverOn(true);
#endif
        Vvscpu3x_test_tb top{&context};
        const auto deadline = deadline_ticks(options.max_time_ns, context.timeprecision());
#if VM_TRACE
        VerilatedVcdC trace;
        top.trace(&trace, 99);
        trace.open(options.trace_file.c_str());
        if (!trace.isOpen()) throw std::runtime_error("cannot open trace file: " + options.trace_file);
#endif
        int status = 0;
        while (!context.gotFinish() && !interrupted) {
            top.eval();
#if VM_TRACE
            trace.dump(context.time());
#endif
            if (context.gotFinish()) break;
            if (deadline && context.time() >= deadline) {
                std::fprintf(stderr, "[verilator] +MAX_SIM_TIME_NS=%llu reached before $finish\n",
                             static_cast<unsigned long long>(options.max_time_ns));
                status = 1;
                break;
            }
            if (!top.eventsPending()) {
                std::fprintf(stderr, "[verilator] simulation has no pending events before $finish\n");
                status = 1;
                break;
            }
            const auto next = top.nextTimeSlot();
            context.time(deadline && next > deadline ? deadline : next);
        }
        // Signal handlers only set a flag; all model and file cleanup runs here.
        top.final();
#if VM_TRACE
        trace.close();
#endif
#if VM_COVERAGE
        context.coveragep()->write(options.coverage_file.c_str());
#endif
        if (interrupted) {
            std::fprintf(stderr, "[verilator] interrupted by signal %d\n", int(interrupted));
            return 128 + interrupted;
        }
        return context.gotError() ? 1 : status;
    } catch (const std::exception& error) {
        std::fprintf(stderr, "[verilator] %s\n", error.what());
        return 1;
    }
}
