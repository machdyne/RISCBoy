module riscboy_fpga (
	input wire        clk_osc,

	output wire       led,

	output wire       uart_tx,
	input  wire       uart_rx,

	input  wire       flash_miso,
	output wire       flash_mosi,
	output wire       flash_sclk,
	output wire       flash_cs,

   output wire [17:0] sram_a,
   inout wire [15:0] sram_d,
   inout wire        sram_ce,
   inout wire        sram_oe,
   inout wire        sram_lb,
   inout wire        sram_ub,
   inout wire        sram_we,

	output wire [3:0]  dvi_p,
	output wire [3:0]  dvi_n
);

`include "gpio_pinmap.vh"

// Clock + Reset resources

wire clk_bit_unbuffered;
wire clk_bit;
wire clk_pix;
wire clk_sys;
wire pll_lock;
wire rst_n_por;

pll_48_126 #(
	.ICE40_PAD (1)
) pll_bit (
	.clock_in  (clk_osc),
	.clock_out (clk_bit),
	.clock_out (clk_bit_unbuffered),
);

pll_126_36 #(
	.ICE40_PAD (0)
) pll_sys (
   .clock_in  (clk_bit),
   .clock_out (clk_sys),
   .locked    (pll_lock)
);

SB_GB promote_bit_clock (
	.USER_SIGNAL_TO_GLOBAL_BUFFER (clk_bit_unbuffered),
	.GLOBAL_BUFFER_OUTPUT         (clk_bit)
);

fpga_reset #(
	.SHIFT (3),
	.COUNT (200)
) rstgen (
	.clk         (clk_bit),
	.force_rst_n (pll_lock),
	.rst_n       (rst_n_por)
);

// Pixel clock: 126 / 5 -> 25.2 MHz
reg [4:0] clkdiv_pix;
assign clk_pix = clkdiv_pix[0];
always @ (posedge clk_bit or negedge rst_n_por)
	if (!rst_n_por)
		clkdiv_pix <= 5'b11100;
	else
		clkdiv_pix <= {clkdiv_pix[0],  clkdiv_pix[4:1]};

// Instantiate the actual logic

localparam N_PADS = N_GPIOS;

wire [N_PADS-1:0] padout;
wire [N_PADS-1:0] padoe;
wire [N_PADS-1:0] padin;

riscboy_core #(
	.BOOTRAM_PRELOAD   ("bootram_init32.hex"),

	.DISPLAY_TYPE      ("DVI"),

	.CUTDOWN_PROCESSOR (1),
	.STUB_SPI          (1),
	.STUB_PWM          (1),
	.NO_SRAM_WRITE_BUF (1),
	.UART_FIFO_DEPTH   (1)
) core (
	.clk_sys     (clk_sys),
	.clk_lcd_pix (clk_pix),
	.clk_lcd_bit (clk_bit),
	.rst_n       (rst_n_por),

	.lcd_pwm     (/* unused */),

	.uart_tx     (uart_tx),
	.uart_rx     (uart_rx),
	.uart_rts    (/* unused */),
	.uart_cts    (/* unused */),

	.spi_sclk    (flash_sclk),
	.spi_cs      (flash_cs),
	.spi_sdo     (flash_mosi),
	.spi_sdi     (flash_miso),

   .sram_addr   (sram_addr),
   .sram_dq     (sram_d),
   .sram_ce_n   (sram_ce_n),
   .sram_we_n   (sram_we_n),
   .sram_oe_n   (sram_oe_n),
   .sram_byte_n ({sram_ub, sram_lb}),

	.lcdp        (dvi_p),
	.lcdn        (dvi_n),

	.padout      (padout),
	.padoe       (padoe),
	.padin       (padin)
);

wire blink;

blinky #(
   .CLK_HZ   (36_000_000),
   .BLINK_HZ (1),
   .FANCY    (0)
) blinky_u (
   .clk   (clk_sys),
   .blink (blink)
);

assign led = blink;

endmodule
