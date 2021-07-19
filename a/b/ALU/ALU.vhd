----------------------------------------
-- ALU basedon Niagara processor, T2 ALU
----------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
       Generic( numbit : integer := 32);
       Port( A,B : in std_logic_vector(numbit-1 downto 0);
             aluopcode : in std_logic_vector(5 downto 0);
             Z : out std_logic_vector(numbit-1 downto 0));
end ALU;

architecture RTL of ALU is

component CLA is
       Generic( numbit : integer);
       Port( a,b : IN std_logic_vector(numbit-1 downto 0);
             cin : IN std_logic;
             S : OUT std_logic_vector(numbit-1 downto 0);
             cout : OUT std_logic);
end component;

component comparator is
       Generic( numbit : integer := 32 );
       Port ( sub : in std_logic_vector(numbit-1 downto 0);
              cout : in std_logic;
              slt : in std_logic_vector(2 downto 0);
              output : out std_logic);
end component;

component LogicalT2 is
       Generic (numbit : integer :=32);
       Port ( A,B : in std_logic_vector(numbit-1 downto 0);
              control : in std_logic_vector(3 downto 0);
              Z : out std_logic_vector(numbit-1 downto 0));
end component;

component shifter is
       Generic( numbit : integer );
       Port( A,B : in std_logic_vector(numbit-1 downto 0);
             sel : in std_logic_vector(4 downto 0); -- sel_lshift sel_rshift sel_rax sel_ra sel_rshiftx
             Z : out std_logic_vector(numbit-1 downto 0));
end component;

signal Bnew : std_logic_vector(numbit-1 downto 0); -- Ci permette di scegliere se Addizione o Sottrazione | Addizione B, Sottrazione B'
signal Cin : std_logic; -- Carry in Addizione | Sottrazione
signal ctl : std_logic_vector(3 downto 0); -- Control signal logical
signal slc : std_logic_vector(4 downto 0); -- select shifter operation
signal slt : std_logic_vector(2 downto 0); -- select for comparator option < <= = >= >
signal Cout : std_logic; -- colleghiamo adder e comparator
signal Zshifter, Zadd, Zlogic :  std_logic_vector(numbit-1 downto 0);
signal Zcomparator : std_logic; -- unsigned and signed

begin

  ADDER: entity work.CLA(RTL) generic map (32)
               port map (A, Bnew, Cin, Zadd, Cout);

  COMP: entity work.comparator(Behavioral) generic map (32)
               port map (Zadd, Cout, slt, Zcomparator);

  LOGIC: entity work.LogicalT2(Behavioral) generic map (32)
               port map (A, B, Ctl, Zlogic);

  SHIFT: entity work.shifter(Behavioral) generic map (32)
               port map (A, B, slc, Zshifter);

ALUOP : PROCESS (A,B,Zshifter,Zadd,Zlogic,Zcomparator,aluopcode)
variable Zcomps : std_logic;
begin
  case aluopcode is
    when "000001" => -- SLL
                     slc <= "10000";
                     Z <= Zshifter;
    when "000010" => -- SRL
                     slc <= "01000";
                     Z <= Zshifter;
    when "000011" => -- SRA
                     slc <= "01010";
                     Z <= Zshifter;
    when "000100" => -- ADD
                     Bnew <= B;
                     Cin <= '0';
                     Z <= Zadd;
    when "000101" => -- ADDU
                     Bnew <= B;
                     Cin <= '0';
                     Z <= Zadd;
    when "000110" => -- SUB
                     Bnew <= NOT(B);
                     Cin <= '1';
                     Z <= Zadd;
    when "000111" => -- SUBU
                     Bnew <= NOT(B);
                     Cin <= '1';
                     Z <= Zadd;
    when "001000" => -- AND
                     Ctl <= "1000";
                     Z <= Zlogic;
    when "001001" => -- OR"001010"
                     Ctl <= "1110";
                     Z <= Zlogic;
    when "001010" => -- XOR
                     Ctl <= "0110";
                     Z <= Zlogic;
    when "001011" => -- SEQ
                     Bnew <= NOT(B);
                     Cin <= '1';
                     slt <= "100";
                     Z <= x"0000000" & "000" & Zcomparator;
    when "001100" => -- SNE
                     Bnew <= NOT(B);
                     Cin <= '1';
                     slt <= "101";
                     Z <= x"0000000" & "000" & Zcomparator;
    when "001101" => -- SLT
                     Bnew <= NOT(B);
                     Cin <= '1';
                     slt <= "010";
                     Zcomps := (Zcomparator AND (NOT(B(numbit-1)) OR A(numbit-1))) OR (A(numbit-1) AND NOT(B(31))); -- Se A o B sono negativi il primo bit è uno
                     Z <= x"0000000" & "000" & Zcomps;
    when "001110" => -- SGT
                     Bnew <= NOT(B);
                     Cin <= '1';
                     slt <= "000";
                     Zcomps := (Zcomparator AND (NOT(A(numbit-1)) OR B(numbit-1))) OR (B(numbit-1) AND NOT(A(31))); -- quindi il confronto si inverte
                     Z <= x"0000000" & "000" & Zcomps;
    when "001111" => -- SLE
                     Bnew <= NOT(B);
                     Cin <= '1';
                     slt <= "011";
                     Zcomps := (Zcomparator AND (NOT(B(numbit-1)) OR A(numbit-1))) OR (A(numbit-1) AND NOT(B(31)));
                     Z <= x"0000000" & "000" & Zcomps;
    when "010000" => -- SGE
                     Bnew <= NOT(B);
                     Cin <= '1';
                     slt <= "001";
                     Zcomps := (Zcomparator AND (NOT(A(numbit-1)) OR B(numbit-1))) OR (B(numbit-1) AND NOT(A(31)));
                     Z <= x"0000000" & "000" & Zcomps;
    when "000000" => -- MOVS2I
--                     Z <= 
    when "010001" => -- SLTU
                     Bnew <= NOT(B);
                     Cin <= '1';
                     slt <= "010";
                     Z <= x"0000000" & "000" & Zcomparator;
    when "010010" => -- SGTU
                     Bnew <= NOT(B);
                     Cin <= '1';
                     slt <= "000";
                     Z <= x"0000000" & "000" & Zcomparator;
    when "010101" => -- SLEU
                     Bnew <= NOT(B);
                     Cin <= '1';
                     slt <= "011";
                     Z <= x"0000000" & "000" & Zcomparator;
    when "010011" => -- SGEU
                     Bnew <= NOT(B);
                     Cin <= '1';
                     slt <= "001";
                     Z <= x"0000000" & "000" & Zcomparator;
    when others => -- nop
--                     Z <= 
  end case;
end process;
end RTL;
                     
    


