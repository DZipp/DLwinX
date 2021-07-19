library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity comparator is
       Generic( numbit : integer := 32 );
       Port ( sub : in std_logic_vector(numbit-1 downto 0);
              cout : in std_logic;
              slt : in std_logic_vector(2 downto 0);
              output : out std_logic);
end comparator;

architecture Behavioral of comparator is 
   signal input : std_logic := '0';
   signal result_1 : std_logic_vector(5 downto 0);
begin

--ORR: for i in 0 to 31 generate
--     input <= input OR sub(i);    -- I can do also input == x"00000000"
--     end generate;
--     input <= NOT(input);

     input <= '1' when sub = x"00000000" else '0';

     result_1(0) <= cout AND NOT(input); -- A>B
     result_1(1) <= cout; -- A>=B
     result_1(2) <= NOT(cout); -- A<B
     result_1(3) <= NOT(cout) OR input; -- A<=B
     result_1(4) <= input; -- A=B
     result_1(5) <=  NOT(input); -- A!=B

     output <= result_1(to_integer(unsigned(slt)));

end Behavioral;
