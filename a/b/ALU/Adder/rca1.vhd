library ieee;
--use WORK.constants.all;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity RCA is 
	generic (NBIT: integer:= 4;
                 DRCAS : 	Time := 0 ns;
	         DRCAC : 	Time := 0 ns);
	Port (	A:	In	std_logic_vector(NBIT-1 downto 0);
		B:	In	std_logic_vector(NBIT-1 downto 0);
		Ci:	In	std_logic;
		S:	Out	std_logic_vector(NBIT-1 downto 0);
		Co:	Out	std_logic);
end RCA; 


architecture BEHAVIORAL of RCA is

begin
PROCESS(A,B,Ci)

variable temp:std_logic_vector (NBIT-2 DOWNTO 0) := (others => '0');
variable tempbit: std_logic_vector (NBIT DOWNTO 0);

begin
S <= std_logic_vector(A + B + (temp & Ci)) after DRCAS;
tempbit := std_logic_vector( ('0'& A) + ('0' & B) + ('0' & temp & Ci));
Co <= tempbit(NBIT) after DRCAC;
end PROCESS;
end BEHAVIORAL;

configuration CFG_RCA_BEHAVIORAL of RCA is
  for BEHAVIORAL 
  end for;
end CFG_RCA_BEHAVIORAL;
