
module pll_48_126 #(
    parameter ICE40_PAD = 0
) (
	input  clock_in,
	output clock_out,
	output locked
);

/**
 * PLL configuration
 *
 * This Verilog module was generated automatically
 * using the icepll tool from the IceStorm project.
 * Use at your own risk.
 *
 * Given input frequency:        48.000 MHz
 * Requested output frequency:  126.000 MHz
 * Achieved output frequency:   126.000 MHz
 */

generate
if (ICE40_PAD) begin: pll_pad

SB_PLL40_PAD #(
      .FEEDBACK_PATH("SIMPLE"),
      .DIVR(4'b0000),      // DIVR =  0
      .DIVF(7'b0010100),   // DIVF = 20
      .DIVQ(3'b011),    // DIVQ =  3
      .FILTER_RANGE(3'b100)   // FILTER_RANGE = 4
   ) uut (
      .LOCK(locked),
      .RESETB(1'b1),
      .BYPASS(1'b0),
      .PACKAGEPIN(clock_in),
      .PLLOUTCORE(clock_out)
      );

end else begin: pll_core

SB_PLL40_CORE #(
      .FEEDBACK_PATH("SIMPLE"),
      .DIVR(4'b0000),      // DIVR =  0
      .DIVF(7'b0010100),   // DIVF = 20
      .DIVQ(3'b011),    // DIVQ =  3
      .FILTER_RANGE(3'b100)   // FILTER_RANGE = 4
   ) uut (
      .LOCK(locked),
      .RESETB(1'b1),
      .BYPASS(1'b0),
      .REFERENCECLK(clock_in),
      .PLLOUTCORE(clock_out)
      );

end
endgenerate

endmodule
