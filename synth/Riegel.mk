CHIPNAME=riscboy_riegel
DOTF=$(HDL)/riscboy_fpga/riscboy_fpga_riegel.f
BOOTAPP=riscboy_bootloader

DEVICE=hx4k
PACKAGE=bg121
PNR_OPT=--timing-allow-fail
#PNR_OPT=--pre-place $(CHIPNAME)_preplace.py --timing-allow-fail

include $(SCRIPTS)/synth_ice40.mk

# romfiles is a prerequisite for synth
romfiles::
	@echo ">>> Bootcode"
	@echo
	make -C $(SOFTWARE)/build APPNAME=$(BOOTAPP) MARCH=rv32i_zicsr CCFLAGS="-Os -DCLK_SYS_MHZ=36 -DUART_BAUD=115200"
	cp $(SOFTWARE)/build/$(BOOTAPP)8.hex bootram_init8.hex
	$(SCRIPTS)/vhexwidth bootram_init8.hex -w 32 -b 0x00100000 -o bootram_init32.hex


clean::
	make -C $(SOFTWARE)/build APPNAME=$(BOOTAPP) clean
	rm -f bootram_init*.hex
	rm -f riscboy_riegel.asc
	rm -f riscboy_riegel.bin
	rm -f riscboy_riegel.json

prog: bit
	ldprog -s $(CHIPNAME).bin
