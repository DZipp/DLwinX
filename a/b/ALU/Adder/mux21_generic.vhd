library IEEE;
use IEEE.std_logic_1164.all;
--use WORK.constants.all;

entity MUX21_GENERIC is
  Generic (NBIT: integer:= 4);
           --DELAY_MUX: Time:= tp_mux);
  Port (	A:	In	std_logic_vector(NBIT-1 downto 0);
		B:	In	std_logic_vector(NBIT-1 downto 0);
		SEL:	In	std_logic;
		Y:	Out	std_logic_vector(NBIT-1 downto 0));
end MUX21_GENERIC;

architecture BEHAVIORAL of MUX21_GENERIC is --normal multiplexer
  begin
    
    Y <= A when SEL='1'  else B;

end BEHAVIORAL;

configuration CFG_MUX21_GEN_BEHAVIORAL of MUX21_GENERIC is
	for BEHAVIORAL
	end for;
end CFG_MUX21_GEN_BEHAVIORAL;


