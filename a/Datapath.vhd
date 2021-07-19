library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity DP is
       Generic(numbit : integer := 32);
       port(Clk : in std_logic; -- Clock
            Reset : in std_logic; -- Reset
            -- Interface with IRAM --
            Intruction : in std_logic_vector(numbit-1 downto 0);
            PC_IRAM : out std_logic_vector(numbit-1 downto 0);
            -- Interface with DRAM
            Dout : in std_logic_vector(numbit - 1 downto 0);
            Din : out std_logic_vector(numbit - 1 downto 0);
            RE,WE : out  std_logic;
            Add_WR, Add_RD : out std_logic_vector(5 downto 0);
            -- Interface with Control Unit   
            -- IF Control Signal       
            IR_LATCH_EN : in std_logic; -- Instruction Register Latch Enable
            NPC_LATCH_EN : in std_logic; -- NextProgramCounter Register Latch Enable
            -- ID Control Signals
            RegA_LATCH_EN : in std_logic; -- Register A Latch Enable
            RegB_LATCH_EN : in std_logic; -- Register B Latch Enable
            RegIMM_LATCH_EN : in std_logic; -- Immediate Register Latch Enable
            -- EX Control Signals
            MUXA_SEL : in std_logic; -- MUX-A Sel
            MUXB_SEL : in std_logic; -- MUX-B Sel
            ALU_OUTREG_EN : in std_logic; -- ALU Output Register Enable
            EQ_COND : in std_logic; -- Branch if (not) Equal to Zero
            ALU_OPCODE : in std_logic_vector(5 downto 0); -- ALU Operation Code
            -- MEM Control Signals
            DRAM_WE : in std_logic; -- Data RAM Write Enable
            LMD_LATCH_EN : in std_logic; -- LMD Register Latch Enable
            JUMP_EN : in std_logic; -- JUMP Enable Signal for PC input MUX
            BRANCH_EN: in std_logic; -- BRANCH Enable Signal
            PC_LATCH_EN : in std_logic; -- Program Counter Latch Enable
            -- WB Control signals
            WB_MUX_SEL : in std_logic; -- Write Back MUX Sel
            RF_WE : in std_logic); -- Register File Write Enable
end DP;

architecture RTL of DP is

component FF_D is -- Registri di stato
       generic ( numbit : integer ); -- Make generic one
       port ( clk: in std_logic;
              en: in std_logic;
              d: in std_logic_vector(numbit-1 downto 0);
              q: out std_logic_vector(numbit-1 downto 0));
end component;

component FF_Dbit is
       generic ( numbit : integer ); -- Make generic one
       port ( clk: in std_logic;
              en: in std_logic;
              d: in std_logic;
              q: out std_logic);
end component;

component CLA is -- Adder per NPC
       Generic( numbit : integer);
       Port( a,b : IN std_logic_vector(numbit-1 downto 0);
             cin : IN std_logic;
             S : OUT std_logic_vector(numbit-1 downto 0);
             cout : OUT std_logic);
end component;

component Mux is -- Multiplexer branch | Immediate/Register | PC/Register | Write back
       generic( numbit : integer );
       port (   A : in std_logic_vector(numbit-1 downto 0);
                B : in std_logic_vector(numbit-1 downto 0);
                sel : in std_logic;
                Z : out std_logic_vector(numbit-1 downto 0) );
end component;

component gen_register_file is
 generic (	address : integer := 5;  ---queste variabili vanno nella cartella constant, una volta creata quella, si può aggiustare questo generic
			numRows : integer := 32;
			numBit  : integer := 32); 
 port ( CLK: 	 IN std_logic;
        RESET: 	 IN std_logic;
	    ENABLE:  IN std_logic;
		RD: 	 IN std_logic;
		WR: 	 IN std_logic;
		ADD_WR:  IN std_logic_vector( (address-1) downto 0 );
		ADD_RD1:  IN std_logic_vector( (address-1) downto 0 );
    	ADD_RD2: IN std_logic_vector( (address-1) downto 0 );
		DATAIN:  IN std_logic_vector( (numBit-1) downto 0 );
		R_OUT1: 	 OUT std_logic_vector( (numBit-1) downto 0 );
		R_OUT2: 	 OUT std_logic_vector( (numBit-1) downto 0 ));
end component;

component ALU is
       Generic( numbit : integer := 32);
       Port( A,B : in std_logic_vector(numbit-1 downto 0);
             aluopcode : in std_logic_vector(5 downto 0);
             Z : out std_logic_vector(numbit-1 downto 0));
end component;

-- IF stage
signal PC_Add, Add_MUX, MUX_NPC1 : std_logic_vector(numbit-1 downto 0);
signal CoutAdd : std_logic;
-- ID stage
signal IR_out, RegA, RegB, Imm, NPC1_NPC2 : std_logic_vector(numbit-1 downto 0);
signal Imm_ext : std_logic_vector(15 downto 0) := (others => '0');
-- EX stage
signal NPC_MUX, A_out, B_out, Imm_out, IR1_IR2, MUXA_Alu, MUXB_Alu, ALU_out : std_logic_vector(numbit-1 downto 0);
signal Branch : std_logic;
-- MEM stage
signal ALU_Mem, IR2_IR3 : std_logic_vector(numbit-1 downto 0);
signal DRAM_address : std_logic_vector(5 downto 0);
signal BrJum, BrJum1, BrJum2 : std_logic; -- Branch for stage IF, 1 is after the branch anable (AND port)
-- WB stage
signal ALU_exe, LMD, MUX_RF, IR3_IR4 : std_logic_vector(numbit-1 downto 0);

begin

-- IF stage

  FF_PC: entity work.FF_D(Behavioral) generic map (32)
               port map (clk => Clk, en => PC_LATCH_EN, d => MUX_NPC1, q => PC_Add);

  PC_IRAM <= PC_Add;

  AddNPC: entity work.CLA(RTL) generic map (32)
               port map (a => PC_Add, b => x"00000004", cin => '0', S => Add_MUX, cout => CoutAdd);

  MUXIF: entity work.Mux(behavioral) generic map (32)
               port map (A => Add_MUX, B => ALU_Mem, sel => BrJum2, Z => MUX_NPC1);

-- Pipeline FF_D IF/ID

  FF_NPC: entity work.FF_D(Behavioral) generic map (32)
               port map (clk => Clk, en => NPC_LATCH_EN, d => MUX_NPC1, q => NPC1_NPC2);

  FF_IR: entity work.FF_D(Behavioral) generic map (32)
               port map (clk => Clk, en => IR_LATCH_EN, d => Intruction, q => IR_out);

-- ID stage

  REGISTERF: entity work.gen_register_file(registerfile) generic map (address => 5, numRows => 32, numBit => 32)
               port map (CLK => Clk, RESET => Reset, ENABLE => '1', RD => '1', WR => RF_WE, ADD_WR => IR3_IR4(20 downto 16), ADD_RD1 => IR_out(15 downto 11), ADD_RD2 => IR_out(10 downto 6), DATAIN => MUX_RF, R_OUT1 => RegA, R_OUT2 => RegB);

  Imm <= Imm_ext & IR_out(15 downto 0);

-- Pipeline FF_D ID/EX

  FF_NPC2: entity work.FF_D(Behavioral) generic map (32)
               port map (clk => Clk, en => '1', d => NPC1_NPC2, q => NPC_MUX);

  FF_REGA: entity work.FF_D(Behavioral) generic map (32)
               port map (clk => Clk, en => RegA_LATCH_EN, d => RegA, q => A_out);

  FF_REGB: entity work.FF_D(Behavioral) generic map (32)
               port map (clk => Clk, en => RegB_LATCH_EN, d => RegB, q => B_out);

  FF_REGIMM: entity work.FF_D(Behavioral) generic map (32)
               port map (clk => Clk, en => RegIMM_LATCH_EN, d => Imm, q => Imm_out);

  FF_IREX: entity work.FF_D(Behavioral) generic map (32)
               port map (clk => Clk, en => '1', d => IR_out, q => IR1_IR2);

-- EX stage

  MUXREGA: entity work.Mux(behavioral) generic map (32)
               port map (A => NPC_MUX, B => A_out, sel => MUXA_SEL, Z => MUXA_Alu);

  MUXREGB: entity work.Mux(behavioral) generic map (32)
               port map (A => Imm_out, B => B_out, sel => MUXB_SEL, Z => MUXB_Alu);

  ALUo: entity work.ALU(RTL) generic map (32)
               port map (A => MUXA_Alu, B => MUXB_Alu, aluopcode => ALU_OPCODE, Z => ALU_out);

  BRA0: PROCESS(A_out)
  begin
  if (A_out = x"00000000") and (EQ_COND = '0') then
	Branch <= '1';
  elsif (A_out /= x"00000000") and (EQ_COND = '1') then
	Branch <= '1';
  else
	Branch <= '0';
  end if;
  end process;

-- Pipeline FF_D EX/MEM

  FF_BREN: entity work.FF_Dbit(Behavioral) generic map (1)
               port map (clk => Clk, en => '1', d => Branch, q => BrJum);

  FF_ALU: entity work.FF_D(Behavioral) generic map (32)
               port map (clk => Clk, en => ALU_OUTREG_EN, d => ALU_out, q => ALU_Mem);

  FF_REGBMEM: entity work.FF_D(Behavioral) generic map (6)
               port map (clk => Clk, en => '1', d => B_out(5 downto 0), q => DRAM_address);

  FF_IRMEM: entity work.FF_D(Behavioral) generic map (32)
               port map (clk => Clk, en => '1', d => IR1_IR2, q => IR2_IR3);

-- MEM stage

  BrJum1 <= BrJum AND BRANCH_EN; -- IF branch
  BrJum2 <= BrJum1 OR JUMP_EN; -- IF jump

  RE <= NOT(DRAM_WE);
  WE <= DRAM_WE;

  Add_WR <= DRAM_address;
  Add_RD <= DRAM_address;

  Din <= ALU_Mem;

-- Pipeline FF_D MEM/WB

  FF_LMD: entity work.FF_D(Behavioral) generic map (32)
               port map (clk => Clk, en => LMD_LATCH_EN, d => Dout, q => LMD);

  FF_ALUout: entity work.FF_D(Behavioral) generic map (32)
               port map (clk => Clk, en => '1', d => ALU_Mem, q => ALU_exe);

  FF_IRWB: entity work.FF_D(Behavioral) generic map (32)
               port map (clk => Clk, en => '1', d => IR2_IR3, q => IR3_IR4);

-- WB stage

  MUXWB: entity work.Mux(behavioral) generic map (32)
               port map (A => LMD, B => ALU_exe, sel => WB_MUX_SEL, Z => MUX_RF);

end RTL;
