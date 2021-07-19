library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity PG is
  port ( Gik : in std_logic;
         Ghj : in std_logic; -- h=k-1
         Pik : in std_logic;
         Phj : in std_logic; -- h=k-1
         Gij : out std_logic;
         Pij : out std_logic);
end PG;

architecture BEHAVIORAL of PG is

  begin

    Gij <= Gik or (Pik and Ghj);
    Pij <= Pik and Phj;

end BEHAVIORAL;

configuration CFG_PG_BEHAVIORAL of PG is
  for BEHAVIORAL
  end for;
end CFG_PG_BEHAVIORAL;

  
