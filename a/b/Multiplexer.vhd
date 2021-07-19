library IEEE;
use IEEE.std_logic_1164.all;

entity Mux is
       generic( numbit : integer );
       port (   A : in std_logic_vector(numbit-1 downto 0);
                B : in std_logic_vector(numbit-1 downto 0);
                sel : in std_logic;
                Z : out std_logic_vector(numbit-1 downto 0) );
end Mux;

architecture behavioral of Mux is
  begin
   
  Z <= A when (sel = '0') else B; -- if sel==0 then Z=A --> else Z=B

end behavioral;
