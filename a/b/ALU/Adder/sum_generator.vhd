library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity SUM_GENERATOR is
		generic (NBIT_PER_BLOCK: integer := 4;
			     NBLOCKS:	integer := 8);
		port (
			     A:	in	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0);
			     B:	in	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0);
			     Ci:	in	std_logic_vector(NBLOCKS-1 downto 0);
			     S:	out	std_logic_vector(NBIT_PER_BLOCK*NBLOCKS-1 downto 0));
end SUM_GENERATOR;

architecture STRUCTURAL of SUM_GENERATOR is

  component CSB is
    generic (numbit: integer := 4);
    port (Ac  : in std_logic_vector(NBIT_PER_BLOCK-1 downto 0);
          Bc  : in std_logic_vector(NBIT_PER_BLOCK-1 downto 0);
          Cin : in std_logic;
          sum : out std_logic_vector(NBIT_PER_BLOCK-1 downto 0));
  end component;

  begin

    P:for i in 0 to NBLOCKS-1 generate --1 CSB for block
      U_i: CSB generic map (numbit=>NBIT_PER_BLOCK)
         port map (A((i+1)*NBIT_PER_BLOCK-1 downto i*NBIT_PER_BLOCK), B((i+1)*NBIT_PER_BLOCK-1 downto i*NBIT_PER_BLOCK), Ci(i), S((i+1)*NBIT_PER_BLOCK-1 downto i*NBIT_PER_BLOCK));      
    end generate;
    
end STRUCTURAL;


 configuration CFG_SUM_GENERATOR_STRUCTURAL of SUM_GENERATOR is
   for STRUCTURAL
     for all : CSB
       use configuration WORK.CFG_CSB_STRUCTURAL;
     end for;
   end for;
 end CFG_SUM_GENERATOR_STRUCTURAL;
