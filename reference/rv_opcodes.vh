// Auto-generated RISC-V opcode header

localparam RV_BEQ                         = 32'b?????????????????000?????1100011;
localparam RV_BNE                         = 32'b?????????????????001?????1100011;
localparam RV_BLT                         = 32'b?????????????????100?????1100011;
localparam RV_BGE                         = 32'b?????????????????101?????1100011;
localparam RV_BLTU                        = 32'b?????????????????110?????1100011;
localparam RV_BGEU                        = 32'b?????????????????111?????1100011;
localparam RV_JALR                        = 32'b?????????????????000?????1100111;
localparam RV_JAL                         = 32'b?????????????????????????1101111;
localparam RV_LUI                         = 32'b?????????????????????????0110111;
localparam RV_AUIPC                       = 32'b?????????????????????????0010111;
localparam RV_ADDI                        = 32'b?????????????????000?????0010011;
localparam RV_SLLI                        = 32'b000000???????????001?????0010011;
localparam RV_SLTI                        = 32'b?????????????????010?????0010011;
localparam RV_SLTIU                       = 32'b?????????????????011?????0010011;
localparam RV_XORI                        = 32'b?????????????????100?????0010011;
localparam RV_SRLI                        = 32'b000000???????????101?????0010011;
localparam RV_SRAI                        = 32'b010110???????????101?????0010011;
localparam RV_ORI                         = 32'b?????????????????110?????0010011;
localparam RV_ANDI                        = 32'b?????????????????111?????0010011;
localparam RV_ADD                         = 32'b0000000??????????000?????0110011;
localparam RV_SUB                         = 32'b0110010??????????000?????0110011;
localparam RV_SLL                         = 32'b0000000??????????001?????0110011;
localparam RV_SLT                         = 32'b0000000??????????010?????0110011;
localparam RV_SLTU                        = 32'b0000000??????????011?????0110011;
localparam RV_XOR                         = 32'b0000000??????????100?????0110011;
localparam RV_SRL                         = 32'b0000000??????????101?????0110011;
localparam RV_SRA                         = 32'b0110010??????????101?????0110011;
localparam RV_OR                          = 32'b0000000??????????110?????0110011;
localparam RV_AND                         = 32'b0000000??????????111?????0110011;
localparam RV_ADDIW                       = 32'b?????????????????000?????0011011;
localparam RV_SLLIW                       = 32'b0000000??????????001?????0011011;
localparam RV_SRLIW                       = 32'b0000000??????????101?????0011011;
localparam RV_SRAIW                       = 32'b0110010??????????101?????0011011;
localparam RV_ADDW                        = 32'b0000000??????????000?????0111011;
localparam RV_SUBW                        = 32'b0110010??????????000?????0111011;
localparam RV_SLLW                        = 32'b0000000??????????001?????0111011;
localparam RV_SRLW                        = 32'b0000000??????????101?????0111011;
localparam RV_SRAW                        = 32'b0110010??????????101?????0111011;
localparam RV_LB                          = 32'b?????????????????000?????0000011;
localparam RV_LH                          = 32'b?????????????????001?????0000011;
localparam RV_LW                          = 32'b?????????????????010?????0000011;
localparam RV_LD                          = 32'b?????????????????011?????0000011;
localparam RV_LBU                         = 32'b?????????????????100?????0000011;
localparam RV_LHU                         = 32'b?????????????????101?????0000011;
localparam RV_LWU                         = 32'b?????????????????110?????0000011;
localparam RV_SB                          = 32'b?????????????????000?????0100011;
localparam RV_SH                          = 32'b?????????????????001?????0100011;
localparam RV_SW                          = 32'b?????????????????010?????0100011;
localparam RV_SD                          = 32'b?????????????????011?????0100011;
localparam RV_FENCE                       = 32'b?????????????????000?????0001111;
localparam RV_FENCE_I                     = 32'b?????????????????001?????0001111;
localparam RV_ECALL                       = 32'b00000000000000000000000001110011;
localparam RV_EBREAK                      = 32'b00000000000100000000000001110011;
localparam RV_URET                        = 32'b00000000001000000000000001110011;
localparam RV_SRET                        = 32'b00010000001000000000000001110011;
localparam RV_MRET                        = 32'b00110000001000000000000001110011;
localparam RV_DRET                        = 32'b01111011001000000000000001110011;
localparam RV_SFENCE_VMA                  = 32'b0001001??????????000000001110011;
localparam RV_WFI                         = 32'b00010000010100000000000001110011;
localparam RV_CSRRW                       = 32'b?????????????????001?????1110011;
localparam RV_CSRRS                       = 32'b?????????????????010?????1110011;
localparam RV_CSRRC                       = 32'b?????????????????011?????1110011;
localparam RV_CSRRWI                      = 32'b?????????????????101?????1110011;
localparam RV_CSRRSI                      = 32'b?????????????????110?????1110011;
localparam RV_CSRRCI                      = 32'b?????????????????111?????1110011;

localparam RV_C_ADDI4SPN                  = 16'b000???????????00;
localparam RV_C_FLD                       = 16'b001???????????00;
localparam RV_C_LW                        = 16'b010???????????00;
localparam RV_C_FLW                       = 16'b011???????????00;
localparam RV_C_FSD                       = 16'b101???????????00;
localparam RV_C_SW                        = 16'b110???????????00;
localparam RV_C_FSW                       = 16'b111???????????00;
localparam RV_C_ADDI                      = 16'b000???????????01;
localparam RV_C_JAL                       = 16'b001???????????01;
localparam RV_C_LI                        = 16'b010???????????01;
localparam RV_C_LUI                       = 16'b011???????????01;
localparam RV_C_SRLI                      = 16'b100?00????????01;
localparam RV_C_SRAI                      = 16'b100?01????????01;
localparam RV_C_ANDI                      = 16'b100?10????????01;
localparam RV_C_SUB                       = 16'b100?11???00???01;
localparam RV_C_XOR                       = 16'b100?11???01???01;
localparam RV_C_OR                        = 16'b100?11???10???01;
localparam RV_C_AND                       = 16'b100?11???11???01;
localparam RV_C_SUBW                      = 16'b100?11???00???01;
localparam RV_C_ADDW                      = 16'b100?11???01???01;
localparam RV_C_J                         = 16'b101???????????01;
localparam RV_C_BEQZ                      = 16'b110???????????01;
localparam RV_C_BNEZ                      = 16'b111???????????01;
localparam RV_C_SLLI                      = 16'b000???????????10;
localparam RV_C_FLDSP                     = 16'b001???????????10;
localparam RV_C_LWSP                      = 16'b010???????????10;
localparam RV_C_FLWSP                     = 16'b011???????????10;
localparam RV_C_MV                        = 16'b100???????????10;
localparam RV_C_ADD                       = 16'b100???????????10;
localparam RV_C_FSDSP                     = 16'b101???????????10;
localparam RV_C_SWSP                      = 16'b110???????????10;
localparam RV_C_FSWSP                     = 16'b111???????????10;

