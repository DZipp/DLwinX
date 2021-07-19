library ieee;
use ieee.std_logic_1164.all;

entity SPG is 
       PORT( a,b,cin : IN std_logic;
             G,P,S : OUT std_logic);
end SPG;

Architecture Behavioral of SPG is
begin  

     G <= a AND b;
     P <= a XOR b;
     S <= a XOR b XOR cin;

end Behavioral;
