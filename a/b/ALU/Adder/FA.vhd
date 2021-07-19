library ieee;
use ieee.std_logic_1164.all;

entity FullAdder is 
       PORT( a,b,cin : IN std_logic;
             S,cout : OUT std_logic);
end FullAdder;

Architecture Behavioral of FullAdder is
begin  

     cout <=  (a and b) OR (a and cin) OR (b and cin);
     S <= a XOR b XOR cin;

end Behavioral;
