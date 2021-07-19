------------------------------------------------------
-- T2 shifter from OpenSPARC T2
------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity shifter is
       Generic( numbit : integer );
       Port( A,B : in std_logic_vector(numbit-1 downto 0);
             sel : in std_logic_vector(4 downto 0); -- sel_lshift sel_rshift sel_rax sel_ra sel_rshiftx
             Z : out std_logic_vector(numbit-1 downto 0));
end shifter;

-- SRLX, SRAX and SLX is not implemented since register are from 32 on DLwinX

architecture Behavioral of shifter is

signal B1 : std_logic_vector(4 downto 0);
signal A1 : std_logic_vector(numbit-1 downto 0);
signal A2 : std_logic_vector(numbit-1 downto 0) := (others => '0'); -- 0 array

begin

B1 <= B(4 downto 0);

Shift : PROCESS(B1,A,sel) is
        begin
        case (sel) is
          when "10000" => case (B1) is -- Shift left logic (SLL)
                             when "00001" => Z <= A(numbit-1-1 downto 0) & A2(0);
                             when "00010" => Z <= A(numbit-1-2 downto 0) & A2(1 downto 0);
                             when "00011" => Z <= A(numbit-1-3 downto 0) & A2(2 downto 0);
                             when "00100" => Z <= A(numbit-1-4 downto 0) & A2(3 downto 0);
                             when "00101" => Z <= A(numbit-1-5 downto 0) & A2(4 downto 0);
                             when "00110" => Z <= A(numbit-1-6 downto 0) & A2(5 downto 0);
                             when "00111" => Z <= A(numbit-1-7 downto 0) & A2(6 downto 0);
                             when "01000" => Z <= A(numbit-1-8 downto 0) & A2(7 downto 0);
                             when "01001" => Z <= A(numbit-1-9 downto 0) & A2(8 downto 0);
                             when "01010" => Z <= A(numbit-1-10 downto 0) & A2(9 downto 0);
                             when "01011" => Z <= A(numbit-1-11 downto 0) & A2(10 downto 0);
                             when "01100" => Z <= A(numbit-1-12 downto 0) & A2(11 downto 0);
                             when "01101" => Z <= A(numbit-1-13 downto 0) & A2(12 downto 0);
                             when "01110" => Z <= A(numbit-1-14 downto 0) & A2(13 downto 0);
                             when "01111" => Z <= A(numbit-1-15 downto 0) & A2(14 downto 0);
                             when "10000" => Z <= A(numbit-1-16 downto 0) & A2(15 downto 0);
                             when "10001" => Z <= A(numbit-1-17 downto 0) & A2(16 downto 0);
                             when "10010" => Z <= A(numbit-1-18 downto 0) & A2(17 downto 0);
                             when "10011" => Z <= A(numbit-1-19 downto 0) & A2(18 downto 0);
                             when "10100" => Z <= A(numbit-1-20 downto 0) & A2(19 downto 0);
                             when "10101" => Z <= A(numbit-1-21 downto 0) & A2(20 downto 0);
                             when "10110" => Z <= A(numbit-1-22 downto 0) & A2(21 downto 0);
                             when "10111" => Z <= A(numbit-1-23 downto 0) & A2(22 downto 0);
                             when "11000" => Z <= A(numbit-1-24 downto 0) & A2(23 downto 0);
                             when "11001" => Z <= A(numbit-1-25 downto 0) & A2(24 downto 0);
                             when "11010" => Z <= A(numbit-1-26 downto 0) & A2(25 downto 0);
                             when "11011" => Z <= A(numbit-1-27 downto 0) & A2(26 downto 0);
                             when "11100" => Z <= A(numbit-1-28 downto 0) & A2(27 downto 0);
                             when "11101" => Z <= A(numbit-1-29 downto 0) & A2(28 downto 0);
                             when "11110" => Z <= A(numbit-1-30 downto 0) & A2(29 downto 0);
                             when "11111" => Z <= A(numbit-1-31) & A2(30 downto 0);
                             when others => Z <= A;
                          end case;
          when "01010" => case (B1) is -- Shift right arithmetic (SRA) -- error
                             when "00001" => Z <= A(0) & A(numbit-1 downto 1);
                             when "00010" => Z <= A(1 downto 0) & A(numbit-1 downto 2);
                             when "00011" => Z <= A(2 downto 0) & A(numbit-1 downto 3);
                             when "00100" => Z <= A(3 downto 0) & A(numbit-1 downto 4);
                             when "00101" => Z <= A(4 downto 0) & A(numbit-1 downto 5);
                             when "00110" => Z <= A(5 downto 0) & A(numbit-1 downto 6);
                             when "00111" => Z <= A(6 downto 0) & A(numbit-1 downto 7);
                             when "01000" => Z <= A(7 downto 0) & A(numbit-1 downto 8);
                             when "01001" => Z <= A(8 downto 0) & A(numbit-1 downto 9);
                             when "01010" => Z <= A(9 downto 0) & A(numbit-1 downto 10);
                             when "01011" => Z <= A(10 downto 0) & A(numbit-1 downto 11);
                             when "01100" => Z <= A(11 downto 0) & A(numbit-1 downto 12);
                             when "01101" => Z <= A(12 downto 0) & A(numbit-1 downto 13);
                             when "01110" => Z <= A(13 downto 0) & A(numbit-1 downto 14);
                             when "01111" => Z <= A(14 downto 0) & A(numbit-1 downto 15);
                             when "10000" => Z <= A(15 downto 0) & A(numbit-1 downto 16);
                             when "10001" => Z <= A(16 downto 0) & A(numbit-1 downto 17);
                             when "10010" => Z <= A(17 downto 0) & A(numbit-1 downto 18);
                             when "10011" => Z <= A(18 downto 0) & A(numbit-1 downto 19);
                             when "10100" => Z <= A(19 downto 0) & A(numbit-1 downto 20);
                             when "10101" => Z <= A(20 downto 0) & A(numbit-1 downto 21);
                             when "10110" => Z <= A(21 downto 0) & A(numbit-1 downto 22);
                             when "10111" => Z <= A(22 downto 0) & A(numbit-1 downto 23);
                             when "11000" => Z <= A(23 downto 0) & A(numbit-1 downto 24);
                             when "11001" => Z <= A(24 downto 0) & A(numbit-1 downto 25);
                             when "11010" => Z <= A(25 downto 0) & A(numbit-1 downto 26);
                             when "11011" => Z <= A(26 downto 0) & A(numbit-1 downto 27);
                             when "11100" => Z <= A(27 downto 0) & A(numbit-1 downto 28);
                             when "11101" => Z <= A(28 downto 0) & A(numbit-1 downto 29);
                             when "11110" => Z <= A(29 downto 0) & A(numbit-1 downto 30);
                             when "11111" => Z <= A(30 downto 0) & A(31);
                             when others => Z <= A;
                          end case;
          when others => case (B1) is -- Shift right logic (SRL)
                             when "00001" => Z <= A2(0) & A(numbit-1 downto 1);
                             when "00010" => Z <= A2(1 downto 0) & A(numbit-1 downto 2);
                             when "00011" => Z <= A2(2 downto 0) & A(numbit-1 downto 3);
                             when "00100" => Z <= A2(3 downto 0) & A(numbit-1 downto 4);
                             when "00101" => Z <= A2(4 downto 0) & A(numbit-1 downto 5);
                             when "00110" => Z <= A2(5 downto 0) & A(numbit-1 downto 6);
                             when "00111" => Z <= A2(6 downto 0) & A(numbit-1 downto 7);
                             when "01000" => Z <= A2(7 downto 0) & A(numbit-1 downto 8);
                             when "01001" => Z <= A2(8 downto 0) & A(numbit-1 downto 9);
                             when "01010" => Z <= A2(9 downto 0) & A(numbit-1 downto 10);
                             when "01011" => Z <= A2(10 downto 0) & A(numbit-1 downto 11);
                             when "01100" => Z <= A2(11 downto 0) & A(numbit-1 downto 12);
                             when "01101" => Z <= A2(12 downto 0) & A(numbit-1 downto 13);
                             when "01110" => Z <= A2(13 downto 0) & A(numbit-1 downto 14);
                             when "01111" => Z <= A2(14 downto 0) & A(numbit-1 downto 15);
                             when "10000" => Z <= A2(15 downto 0) & A(numbit-1 downto 16);
                             when "10001" => Z <= A2(16 downto 0) & A(numbit-1 downto 17);
                             when "10010" => Z <= A2(17 downto 0) & A(numbit-1 downto 18);
                             when "10011" => Z <= A2(18 downto 0) & A(numbit-1 downto 19);
                             when "10100" => Z <= A2(19 downto 0) & A(numbit-1 downto 20);
                             when "10101" => Z <= A2(20 downto 0) & A(numbit-1 downto 21);
                             when "10110" => Z <= A2(21 downto 0) & A(numbit-1 downto 22);
                             when "10111" => Z <= A2(22 downto 0) & A(numbit-1 downto 23);
                             when "11000" => Z <= A2(23 downto 0) & A(numbit-1 downto 24);
                             when "11001" => Z <= A2(24 downto 0) & A(numbit-1 downto 25);
                             when "11010" => Z <= A2(25 downto 0) & A(numbit-1 downto 26);
                             when "11011" => Z <= A2(26 downto 0) & A(numbit-1 downto 27);
                             when "11100" => Z <= A2(27 downto 0) & A(numbit-1 downto 28);
                             when "11101" => Z <= A2(28 downto 0) & A(numbit-1 downto 29);
                             when "11110" => Z <= A2(29 downto 0) & A(numbit-1 downto 30);
                             when "11111" => Z <= A2(30 downto 0) & A(31);
                             when others => Z <= A;
                          end case;
          end case;
        end process;
end Behavioral;
