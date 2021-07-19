library IEEE;
use IEEE.STD_logic_1164.all;

entity FF_D is
       generic ( numbit : integer ); -- Make generic one
       port ( clk: in std_logic;
              en: in std_logic;
              d: in std_logic_vector(numbit-1 downto 0);
              q: out std_logic_vector(numbit-1 downto 0));
end FF_D;

architecture Behavioral of FF_D is
begin
    process (clk,en)
    begin
        if (clk='1' and clk'EVENT) and en='1' then
            q <= d;
        end if;
    end process;
end Behavioral;
