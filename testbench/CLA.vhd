library ieee;
use ieee.std_logic_1164.all;

entity CLA is
       Generic( numbit : integer);
       Port( a,b : IN std_logic_vector(numbit-1 downto 0);
             cin : IN std_logic;
             S : OUT std_logic_vector(numbit-1 downto 0);
             cout : OUT std_logic);
end CLA;

Architecture RTL of CLA is

  component SPG is 
       PORT( a,b,cin : IN std_logic;
             G,P,S : OUT std_logic);
  end component;

  signal STMP : std_logic_vector(numbit-1 downto 0);
  signal GTMP : std_logic_vector(numbit-1 downto 0);
  signal PTMP : std_logic_vector(numbit-1 downto 0);
  signal CTMP : std_logic_vector(numbit downto 0);

begin

  CTMP(0) <= Cin;
  S <= STMP;
  Cout <= CTMP(numbit);
  
  ADDER1: for I in 1 to numbit generate
    FAI : SPG 
	  Port Map (a => A(I-1), b => B(I-1), cin => CTMP(I-1), G => GTMP(I-1), P => PTMP(I-1), S => STMP(I-1)); 
  end generate;

  LOGIC: for I in 1 to numbit generate
    CTMP(I) <= GTMP(I-1) OR ( CTMP(I-1) AND PTMP(I-1));
  end generate;

end RTL;
