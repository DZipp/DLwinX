------------------------------------------------------
-- T2 shifter from OpenSPARC T2
------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity shifter is
       Port( A : in std_logic_vector(15 downto 0);
             B : in std_logic_vector(3 downto 0);
             Z : out std_logic_vector(15 downto 0));
end shifter;

architecture Behavioral of shifter is

signal A2 : std_logic_vector(15 downto 0) := (others => '0'); -- 0 array

begin


Shift : PROCESS(B,A) is
        begin
          case (B) is -- Shift right logic (SRL)
                             when "0001" => Z <= A2(0) & A(15 downto 1);
                             when "0010" => Z <= A2(1 downto 0) & A(15 downto 2);
                             when "0011" => Z <= A2(2 downto 0) & A(15 downto 3);
                             when "0100" => Z <= A2(3 downto 0) & A(15 downto 4);
                             when "0101" => Z <= A2(4 downto 0) & A(15 downto 5);
                             when "0110" => Z <= A2(5 downto 0) & A(15 downto 6);
                             when "0111" => Z <= A2(6 downto 0) & A(15 downto 7);
                             when "1000" => Z <= A2(7 downto 0) & A(15 downto 8);
                             when "1001" => Z <= A2(8 downto 0) & A(15 downto 9);
                             when "1010" => Z <= A2(9 downto 0) & A(15 downto 10);
                             when "1011" => Z <= A2(10 downto 0) & A(15 downto 11);
                             when "1100" => Z <= A2(11 downto 0) & A(15 downto 12);
                             when "1101" => Z <= A2(12 downto 0) & A(15 downto 13);
                             when "1110" => Z <= A2(13 downto 0) & A(15 downto 14);
                             when others => Z <= A;
                          end case;
        end process;
end Behavioral;
