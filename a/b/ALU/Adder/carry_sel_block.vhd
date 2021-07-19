library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity CSB is
  generic (numbit: integer := 4);
  port (Ac : in std_logic_vector(numbit-1 downto 0);
        Bc : in std_logic_vector(numbit-1 downto 0);
        Cin : in std_logic;
        sum : out std_logic_vector(numbit-1 downto 0));
end CSB;

architecture STRUCTURAL of CSB is

  component RCA is
    Generic (NBIT: integer:= 4);
    Port (A : in std_logic_vector(numbit-1 downto 0);
	      B : in std_logic_vector(numbit-1 downto 0);
	      Ci: in std_logic;
	      S : out std_logic_vector(numbit-1 downto 0);
	      Co: out std_logic);
  end component;

  component MUX21_GENERIC is
    Generic (NBIT: integer:= 4);
    Port (A  :	In	std_logic_vector(numbit-1 downto 0);
	      B  :	In	std_logic_vector(numbit-1 downto 0);
	      SEL:	In	std_logic;
	      Y  :	Out	std_logic_vector(numbit-1 downto 0));
  end component;

  signal out1, out2 : std_logic_vector(numbit-1 downto 0);
  signal carry_out : std_logic;

  begin

    S1 :  RCA generic map(NBIT=>numbit) --adder with Cin
              port map (Ac, Bc,'1', out1, carry_out);
    S2 :  RCA generic map(NBIT=>numbit) --adder without
              port map (Ac, Bc,'0', out2, carry_out);
    M : MUX21_GENERIC generic map(NBIT=>numbit) --Mux Cin controlled
                      port map (out1, out2, Cin, sum);

 end STRUCTURAL;


 configuration CFG_CSB_STRUCTURAL of CSB is
   for STRUCTURAL
     for all : RCA
       use configuration WORK.CFG_RCA_BEHAVIORAL;
     end for;
     for all : MUX21_GENERIC
       use configuration WORK.CFG_MUX21_GEN_BEHAVIORAL;
     end for;
   end for;
 end CFG_CSB_STRUCTURAL;
   
           
