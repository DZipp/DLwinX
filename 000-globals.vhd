library ieee;
use ieee.std_logic_1164.all;

package globals is

  constant NUMBIT : integer := 32; --bits
  
  
  -- Size of the LUT within the CU Hardwired (taking into account unused operations)
  constant SIZE_LUT : integer := 62;
  -- CW size
  constant CW_SIZE : integer := 15;
  -- ALU Operation
  constant ALUOP_SIZE : integer := 6;
  -- OPCODE
  constant OPCODE_SIZE : integer := 6;
  -- FUNCTION FIELD SIZE
  constant FUNC_SIZE : integer := 11;

  -- FUNC FIELDS FOR EACH INSTRUCTION
  constant FUNC_SLL      : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000000100";
  constant FUNC_SRL      : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000000110";
  constant FUNC_SRA      : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000000111";
  constant FUNC_ADD      : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000100000";
  constant FUNC_ADDU     : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000100001";
  constant FUNC_SUB      : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000100010";
  constant FUNC_SUBU     : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000100011";
  constant FUNC_AND      : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000100100";
  constant FUNC_OR       : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000100101";
  constant FUNC_XOR      : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000100110";
  constant FUNC_SEQ      : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000101000";
  constant FUNC_SNE      : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000101001";
  constant FUNC_SLT      : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000101010";
  constant FUNC_SGT      : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000101011";
  constant FUNC_SLE      : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000101100";
  constant FUNC_SGE      : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000101101";
  constant FUNC_MOVS2I   : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000110001";
  constant FUNC_SLTU     : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000111010";
  constant FUNC_SGTU     : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000111011";
  constant FUNC_SGEU     : std_logic_vector(FUNC_SIZE-1 downto 0) := "00000111101";


  -- OPCODE FIELD
  constant RTYPE  : std_logic_vector (OPCODE_SIZE-1 downto 0) := "000000";
  constant J      : std_logic_vector (OPCODE_SIZE-1 downto 0) := "000010";
  constant JAL   : std_logic_vector (OPCODE_SIZE-1 downto 0) := "000011";
  constant BEQZ  : std_logic_vector (OPCODE_SIZE-1 downto 0) := "000100";
  constant BNEZ  : std_logic_vector (OPCODE_SIZE-1 downto 0) := "000101";
  constant ADDI   : std_logic_vector (OPCODE_SIZE-1 downto 0) := "001000";
  constant ADDUI  : std_logic_vector (OPCODE_SIZE-1 downto 0) := "001001";
  constant SUBI   : std_logic_vector (OPCODE_SIZE-1 downto 0) := "001010";
  constant SUBUI  : std_logic_vector (OPCODE_SIZE-1 downto 0) := "001011";
  constant ANDI   : std_logic_vector (OPCODE_SIZE-1 downto 0) := "001100";
  constant ORI    : std_logic_vector (OPCODE_SIZE-1 downto 0) := "001101";
  constant XORI   : std_logic_vector (OPCODE_SIZE-1 downto 0) := "001110";
  constant LHI    : std_logic_vector (OPCODE_SIZE-1 downto 0) := "001111";
  constant JR     : std_logic_vector (OPCODE_SIZE-1 downto 0) := "010010";
  constant JALR   : std_logic_vector (OPCODE_SIZE-1 downto 0) := "010011";
  constant SLLI   : std_logic_vector (OPCODE_SIZE-1 downto 0) := "010100";
  constant NOP    : std_logic_vector (OPCODE_SIZE-1 downto 0) := "010101";
  constant SRLI   : std_logic_vector (OPCODE_SIZE-1 downto 0) := "010110";
  constant SRAI   : std_logic_vector (OPCODE_SIZE-1 downto 0) := "010111";
  constant SEQI   : std_logic_vector (OPCODE_SIZE-1 downto 0) := "011000";
  constant SNEI   : std_logic_vector (OPCODE_SIZE-1 downto 0) := "011001";
  constant SLTI   : std_logic_vector (OPCODE_SIZE-1 downto 0) := "011010";
  constant SGTI   : std_logic_vector (OPCODE_SIZE-1 downto 0) := "011011";
  constant SLEI   : std_logic_vector (OPCODE_SIZE-1 downto 0) := "011100";
  constant SGEI   : std_logic_vector (OPCODE_SIZE-1 downto 0) := "011101";
  constant LB     : std_logic_vector (OPCODE_SIZE-1 downto 0) := "100000";
  constant LW     : std_logic_vector (OPCODE_SIZE-1 downto 0) := "100011";
  constant LBU    : std_logic_vector (OPCODE_SIZE-1 downto 0) := "100100";
  constant LHU    : std_logic_vector (OPCODE_SIZE-1 downto 0) := "100101";
  constant SB     : std_logic_vector (OPCODE_SIZE-1 downto 0) := "101000";
  constant SW     : std_logic_vector (OPCODE_SIZE-1 downto 0) := "101011";
  constant SLTUI  : std_logic_vector (OPCODE_SIZE-1 downto 0) := "111010";
  constant SGTUI  : std_logic_vector (OPCODE_SIZE-1 downto 0) := "111011";
  constant SGEUI  : std_logic_vector (OPCODE_SIZE-1 downto 0) := "111101";

  -- ALU OPERATION
  constant ALUOP_SLL      : std_logic_vector(ALUOP_SIZE-1 downto 0) := "000001";
  constant ALUOP_SRL      : std_logic_vector(ALUOP_SIZE-1 downto 0) := "000010";
  constant ALUOP_SRA      : std_logic_vector(ALUOP_SIZE-1 downto 0) := "000011";
  constant ALUOP_ADD      : std_logic_vector(ALUOP_SIZE-1 downto 0) := "000100";
  constant ALUOP_ADDU     : std_logic_vector(ALUOP_SIZE-1 downto 0) := "000101";
  constant ALUOP_SUB      : std_logic_vector(ALUOP_SIZE-1 downto 0) := "000110";
  constant ALUOP_SUBU     : std_logic_vector(ALUOP_SIZE-1 downto 0) := "000111";
  constant ALUOP_AND      : std_logic_vector(ALUOP_SIZE-1 downto 0) := "001000";
  constant ALUOP_OR       : std_logic_vector(ALUOP_SIZE-1 downto 0) := "001001";
  constant ALUOP_XOR      : std_logic_vector(ALUOP_SIZE-1 downto 0) := "001010";
  constant ALUOP_SEQ      : std_logic_vector(ALUOP_SIZE-1 downto 0) := "001011";
  constant ALUOP_SNE      : std_logic_vector(ALUOP_SIZE-1 downto 0) := "001100";
  constant ALUOP_SLT      : std_logic_vector(ALUOP_SIZE-1 downto 0) := "001101";
  constant ALUOP_SGT      : std_logic_vector(ALUOP_SIZE-1 downto 0) := "001110";
  constant ALUOP_SLE      : std_logic_vector(ALUOP_SIZE-1 downto 0) := "001111";
  constant ALUOP_SGE      : std_logic_vector(ALUOP_SIZE-1 downto 0) := "010000";
  constant ALUOP_MOVS2I   : std_logic_vector(ALUOP_SIZE-1 downto 0) := "000000";
  constant ALUOP_SLTU     : std_logic_vector(ALUOP_SIZE-1 downto 0) := "010001";
  constant ALUOP_SGTU     : std_logic_vector(ALUOP_SIZE-1 downto 0) := "010010";
  constant ALUOP_SGEU     : std_logic_vector(ALUOP_SIZE-1 downto 0) := "010011";

end globals;

