library IEEE;
use IEEE.STD_logic_1164.all;

entity FF_Dbit is
       generic ( numbit : integer ); -- Make generic one
       port ( clk: in std_logic;
              en: in std_logic;
              d: in std_logic;
              q: out std_logic);
end FF_Dbit;

architecture Behavioral of FF_Dbit is
begin
    process (clk,en)
    begin
        if (clk='1' and clk'EVENT) and en='1' then
            q <= d;
        end if;
    end process;
end Behavioral;
