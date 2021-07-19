library ieee;
use ieee.std_logic_1164.all;

entity RippleCarryAdder is
       Generic( numbit : integer);
       Port( a,b : IN std_logic_vector(numbit-1 downto 0);
             cin : IN std_logic;
             S : OUT std_logic_vector(numbit-1 downto 0);
             cout : OUT std_logic);
end RippleCarryAdder;

Architecture Structure of RippleCarryAdder is

  component FullAdder is 
            PORT( a,b,cin : IN std_logic;
                  S,cout : OUT std_logic);
  end component;

  signal STMP : std_logic_vector(numbit-1 downto 0);
  signal CTMP : std_logic_vector(numbit downto 0);

begin

  CTMP(0) <= Cin;
  S <= STMP;
  Cout <= CTMP(numbit);
  
  ADDER1: for I in 1 to numbit generate
    FAI : FullAdder
	  Port Map (A(I-1), B(I-1), CTMP(I-1), STMP(I-1), CTMP(I)); 
  end generate;

end Structure;
