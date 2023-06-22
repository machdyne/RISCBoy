#include <iostream>
#include <fstream>
#include <cstdint>
#include <string>
#include <cstdio>
#include <cstdlib>

// TODO:
// - Add stall-gates-aphase (as this is caused by e.g. APB accesses in real system)
// - Inject real random DMA port traffic and check the results

// Device-under-test model generated by CXXRTL:
#include "dut.cpp"
#include <backends/cxxrtl/cxxrtl_vcd.h>

// There must be a better way
#ifdef __x86_64__
#define I64_FMT "%ld"
#else
#define I64_FMT "%lld"
#endif

// -----------------------------------------------------------------------------

static const int MEM_SIZE = 64;
uint8_t downstream_mem[MEM_SIZE];
uint8_t shadow_mem[MEM_SIZE];

// This RNG is xoroshiro256** by David Blackman and Sebastiano Vigna:

static inline uint64_t rotl(const uint64_t x, int k) {
	return (x << k) | (x >> (64 - k));
}

// Some output from /dev/urandom
static uint64_t s[4] = {
	0xf92bb0952f68b61full,
	0x5a4d868f74ce0b49ull,
	0xcc47fa8276f5e597ull,
	0xcf9946dace3262faull
};

uint64_t xrand(void) {
	const uint64_t result = rotl(s[1] * 5, 7) * 9;

	const uint64_t t = s[1] << 17;

	s[2] ^= s[0];
	s[3] ^= s[1];
	s[1] ^= s[2];
	s[0] ^= s[3];

	s[2] ^= t;

	s[3] = rotl(s[3], 45);

	return result;
}

// -----------------------------------------------------------------------------

int main(int argc, char **argv) {

	bool dump_waves = true;
	std::string waves_path = "waves.vcd";
	int64_t max_cycles = 10000;

	cxxrtl_design::p_riscboy__sram__ctrl top;

	std::ofstream waves_fd;
	cxxrtl::vcd_writer vcd;
	if (dump_waves) {
		waves_fd.open(waves_path);
		cxxrtl::debug_items all_debug_items;
		top.debug_info(all_debug_items);
		vcd.timescale(1, "us");
		vcd.add(all_debug_items);
	}

	// Initialise both memories with the same random contents
	for (int i = 0; i < MEM_SIZE; ++i) {
		downstream_mem[i] = xrand() & 0xff;
		shadow_mem[i] = downstream_mem[i];
	}

	// Set bus interfaces to generate good OKAY responses at first

	bool next_sram_oe_n = true;
	bool next_sram_ce_n = true;
	bool next_sram_we_n = true;
	uint8_t next_sram_byte_n = 0xff;
	uint32_t next_sram_addr = 0;
	uint16_t next_sram_rdata = 0;



	// AHB data-phase tracking
	bool dph_valid = false;
	bool dph_write = false;
	uint8_t dph_size = 0;
	uint32_t dph_addr = 0;

	uint8_t next_htrans = 0;
	bool next_hwrite = false;
	uint8_t next_hsize = 0;
	uint32_t next_haddr = 0;
	uint32_t next_hwdata = 0;

	bool hwrite_q;

	// Reset + initial clock pulse

	top.step();
	top.p_clk.set<bool>(true);
	top.p_ahbls__hready.set<bool>(true);
	top.step();
	top.p_clk.set<bool>(false);
	top.p_rst__n.set<bool>(true);
	top.step();
	top.step(); // workaround for github.com/YosysHQ/yosys/issues/2780

	bool fail = false;
	for (int64_t cycle = 0; cycle < max_cycles || max_cycles == 0; ++cycle) {
		bool quit_loop = fail;
		top.p_clk.set<bool>(false);
		top.step();
		top.step();
		if (dump_waves)
			vcd.sample(cycle * 2);
		top.p_clk.set<bool>(true);
		top.step();
		top.step();

		// Always tie hready_resp back to hready, combinatorially
		top.p_ahbls__hready.set<bool>(top.p_ahbls__hready__resp.get<bool>());

		// Register new AHB outputs (from tb point of view)
		top.p_ahbls__htrans.set<uint8_t>(next_htrans);
		top.p_ahbls__hwrite.set<bool>(next_hwrite);
		top.p_ahbls__hsize.set<uint8_t>(next_hsize);
		top.p_ahbls__haddr.set<uint32_t>(next_haddr);
		top.p_ahbls__hwdata.set<uint32_t>(next_hwdata);
		// Register in SRAM contents read on previous cycle (matching DQ input registers in FPGA SRAM PHY)
		top.p_sram__dq__in.set<uint16_t>(next_sram_rdata);
		next_sram_rdata = 0;
		// Randomly toggle DMA port address valid
		top.p_dma__addr__vld.set<bool>(xrand() & 0x1);

		// Need to step here again to make combinatorial AHB-aphase-dependent
		// outputs (SRAM control signals) visible, and also comb SRAM -> AHB
		// paths (DQ -> HRDATA).
		top.step();
		top.step();

		// Apply SRAM operation registered into TB PHY model on previous cycle
		if (!next_sram_ce_n && !next_sram_we_n) {
			uint16_t sram_wdata = top.p_sram__dq__out.get<uint16_t>();
			if (!(next_sram_byte_n & 0x1)) {
				downstream_mem[next_sram_addr * 2 + 0] = sram_wdata & 0xff;
			}
			if (!(next_sram_byte_n & 0x2)) {
				downstream_mem[next_sram_addr * 2 + 1] = sram_wdata >> 8;
			}
		} else if (!next_sram_ce_n && !next_sram_oe_n) {
			next_sram_rdata = downstream_mem[2 * next_sram_addr + 0] |
				((uint16_t)downstream_mem[2 * next_sram_addr + 1] << 8);
		}

		// Sample SRAM control bus, and read/write memory contents accordingly
		next_sram_oe_n = top.p_sram__oe__n.get<bool>();
		next_sram_we_n = top.p_sram__we__n.get<bool>();
		next_sram_ce_n = top.p_sram__ce__n.get<bool>();
		next_sram_byte_n = top.p_sram__byte__n.get<uint8_t>();
		next_sram_addr = top.p_sram__addr.get<uint32_t>();

		// If the current data phase ends this cycle, check (on read) or
		// update (on write) the shadow memory according to the AHB data buses.
		if (dph_valid && top.p_ahbls__hready.get<bool>()) {
			if (dph_write) {
				uint32_t wdata = top.p_ahbls__hwdata.get<uint32_t>();
				printf("W %02x (%u) <- %08x\n", dph_addr, dph_size, wdata);
				for (int a = dph_addr; a < dph_addr + (1 << dph_size); ++a) {
					shadow_mem[a] = (wdata >> 8 * (a % 4)) & 0xff;
				}
			} else {
				uint32_t rdata = top.p_ahbls__hrdata.get<uint32_t>();
				printf("R %02x (%u) -> %08x\n", dph_addr, dph_size, rdata);
				for (int a = dph_addr; a < dph_addr + (1 << dph_size); ++a) {
					uint8_t rdata_actual = (rdata >> 8 * (a % 4)) & 0xff;
					if (rdata_actual != shadow_mem[a]) {
						printf("At address %02x, expected %02x, got %02x\n", a, shadow_mem[a], rdata_actual);
						fail = true;
					}
				}
			}
		}

		// Progress current address phase to data phase
		if (top.p_ahbls__hready.get<bool>()) {
			dph_valid = top.p_ahbls__htrans.get<uint8_t>() & 0x2;
			dph_write = top.p_ahbls__hwrite.get<bool>();
			dph_size = top.p_ahbls__hsize.get<uint8_t>();
			dph_addr = top.p_ahbls__haddr.get<uint32_t>();
			if (dph_write) {
				next_hwdata = xrand();
			} else {
				next_hwdata = 0;
			}
			// Clear all existing address phase signals, not just HTRANS, to
			// make sure they aren't sampled outside of their validity window
			next_htrans = 0;
			next_hwrite = false;
			next_hsize = 0;
			next_haddr = 0;
		} 

		// Generate random AHB stimulus
		if (top.p_ahbls__htrans.get<uint8_t>() == 0) {
			if (xrand() & 0x1) {
				next_htrans = 0x2;
				uint size = xrand() % 3;
				uint addr = xrand() % MEM_SIZE;
				addr &= -1 << size;
				next_haddr = addr;
				next_hsize = size;
				next_hwrite = xrand() & 0x1;
			}
		}

		if (dump_waves) {
			// The extra step() is just here to get the bus responses to line up nicely
			// in the VCD (hopefully is a quick update)
			top.step();
			vcd.sample(cycle * 2 + 1);
			waves_fd << vcd.buffer;
			vcd.buffer.clear();
		}

		// We let the sim run for one more cycle after failure, because it makes the waves nicer
		if (quit_loop) {
			break;
		}
	}

	return fail;
}
