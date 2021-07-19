library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity G is
  port ( Gik : in std_logic;
         Ghj : in std_logic; -- h=k-1
         Pik : in std_logic;
         Gij : out std_logic);
end G;

architecture BEHAVIORAL of G is

  begin

    Gij <= Gik or (Pik and Ghj);

end BEHAVIORAL;

configuration CFG_G_BEHAVIORAL of G is
  for BEHAVIORAL
  end for;
end CFG_G_BEHAVIORAL;
