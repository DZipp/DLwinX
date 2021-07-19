library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity PGNB is
  port ( a : in std_logic;
         b : in std_logic;
         p : out std_logic;
         g : out std_logic);
end PGNB;

architecture BEHAVIORAL of PGNB is

  begin

    p <= a xor b;
    g <= a and b;

end BEHAVIORAL;

configuration CFG_PG_NET_B_BEHA of PGNB is
  for BEHAVIORAL
  end for;
end CFG_PG_NET_B_BEHA;
 
