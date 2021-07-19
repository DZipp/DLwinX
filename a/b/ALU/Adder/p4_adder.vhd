library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity P4_ADDER is
		generic (NBIT   : integer := 32;
                 NBLOCK : integer := 8);
		port (	A    : in std_logic_vector(NBIT-1 downto 0);
			B    : in std_logic_vector(NBIT-1 downto 0);
			Cin  : in std_logic;
			S    : out std_logic_vector(NBIT-1 downto 0);
			Cout : out std_logic);
end P4_ADDER;

architecture STRUCTURAL of P4_ADDER is

	component SUM_GENERATOR is
		generic (NBIT_PER_BLOCK : integer := 4;
                         NBLOCKS        : integer := 8);
		port ( A : in	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0);
		       B : in	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0);
		       Ci: in	std_logic_vector(NBLOCKS-1 downto 0);
		       S : out	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0));
	end component;

	component carry_generator is
		generic (M : integer := 32; --number of bits of the operand
                         k : integer := 8 ; --number of blocks
                         n : integer := 4); --number of bits per block => n=M/k
                port (A   : in std_logic_vector(M-1 downto 0);
                      B   : in std_logic_vector(M-1 downto 0);
                      Cin  : in std_logic;
                      Cout: out std_logic_vector(k-1 downto 0));
	end component;

        constant k : integer := NBLOCK;
        
        signal Coutoff : std_logic_vector(NBLOCK-1 downto 0); -- Cout
        signal Coutofftemp : std_logic_vector(NBLOCK-1 downto 0); -- Cin

begin

    CG : carry_generator generic map (M => NBIT, k => NBLOCK, n => NBIT/NBLOCK)
                          port map (A, B, Cin, Coutoff);
    
    Coutofftemp<=Coutoff(k-2 downto 0) & Cin;
    
    SG :  SUM_GENERATOR  generic map (NBIT_PER_BLOCK => NBIT/NBLOCK, NBLOCKS => NBLOCK)
                         port map (A, B, Coutofftemp, S);
    Cout<=Coutoff(k-1);

end STRUCTURAL;

 configuration CFG_P4_ADDER_STRUCTURAL of P4_ADDER is
   for STRUCTURAL
   end for;
 end CFG_P4_ADDER_STRUCTURAL;
