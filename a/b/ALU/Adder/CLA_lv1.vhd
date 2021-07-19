library ieee;
use ieee.std_logic_1164.all;

entity CLA_HR1 is
       Port( a,b : IN std_logic_vector(15 downto 0);
             cin : IN std_logic;
             S : OUT std_logic_vector(15 downto 0);
             G,P : OUT std_logic);
end CLA_HR1;

Architecture RTL_lv1 of CLA_HR1 is

  component CLA_HR0 is
       Generic( numbit : integer);
       Port( a,b : IN std_logic_vector(numbit-1 downto 0);
             cin : IN std_logic;
             S : OUT std_logic_vector(numbit-1 downto 0);
             G,P : OUT std_logic);
  end component;

  signal GTMP : std_logic_vector(3 downto 0);
  signal PTMP : std_logic_vector(3 downto 0);
  signal CTMP : std_logic_vector(3 downto 0);
  signal STMP : std_logic_vector(15 downto 0);

begin

  CTMP(0) <= Cin;
  S <= STMP;
  G <= GTMP(3) OR (GTMP(2) AND PTMP(3)) OR (GTMP(1) AND PTMP(3) AND PTMP(2)) OR (GTMP(0) AND PTMP(3) AND PTMP(2) AND PTMP(1));
  P <= PTMP(3) AND PTMP(2) AND PTMP(1) AND PTMP(0);
  
  ADDER1: for I in 0 to 3 generate
    FAI : CLA_HR0 
      Generic Map (numbit => 4)
	  Port Map (a => A(I*4+3 downto I*4), b => B(I*4+3 downto I*4), cin => CTMP(I), S => STMP(I*4+3 downto I*4), G => GTMP(I), P => PTMP(I)); 
  end generate;

  LOGIC: for I in 1 to 3 generate
    CTMP(I) <= GTMP(I-1) OR ( CTMP(I-1) AND PTMP(I-1));
  end generate;

end RTL_lv1;
