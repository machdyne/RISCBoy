/*******************************************************************************
*                          AUTOGENERATED BY REGBLOCK                           *
*                            Do not edit manually.                             *
*          Edit the source file (or regblock utility) and regenerate.          *
*******************************************************************************/

#ifndef _DISPCTRL_DVI_REGS_H_
#define _DISPCTRL_DVI_REGS_H_

// Block name           : dispctrl_dvi
// Bus type             : apb
// Bus data width       : 32
// Bus address width    : 16

#define DISPCTRL_DVI_CSR_OFFS 0

/*******************************************************************************
*                                     CSR                                      *
*******************************************************************************/

// Control and status register for the LCD interface

// Field: CSR_EN  Access: RW
// Write 1 to enable the DVI controller. When going from disabled to enabled
// state, the controller always starts from the beginning of the vertical
// blanking interval.
#define DISPCTRL_DVI_CSR_EN_LSB  0
#define DISPCTRL_DVI_CSR_EN_BITS 1
#define DISPCTRL_DVI_CSR_EN_MASK 0x1
// Field: CSR_DISPTYPE  Access: RO
// Encodes the type of display controller. All RISCBoy display controllers have
// this field. 0x1 means DVI.
#define DISPCTRL_DVI_CSR_DISPTYPE_LSB  28
#define DISPCTRL_DVI_CSR_DISPTYPE_BITS 4
#define DISPCTRL_DVI_CSR_DISPTYPE_MASK 0xf0000000

#endif // _DISPCTRL_DVI_REGS_H_
