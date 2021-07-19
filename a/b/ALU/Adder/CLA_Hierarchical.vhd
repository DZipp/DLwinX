library ieee;
use ieee.std_logic_1164.all;

entity CLA_HR2 is
       Port( a,b : IN std_logic_vector(31 downto 0);
             cin : IN std_logic;
             S : OUT std_logic_vector(31 downto 0);
             G,P : OUT std_logic);
end CLA_HR2;

Architecture RTL_lv2 of CLA_HR2 is

  component CLA_HR1 is
       Port( a,b : IN std_logic_vector(15 downto 0);
             cin : IN std_logic;
             S : OUT std_logic_vector(15 downto 0);
             G,P : OUT std_logic);
  end component;

  signal GTMP : std_logic_vector(1 downto 0);
  signal PTMP : std_logic_vector(1 downto 0);
  signal CTMP : std_logic_vector(1 downto 0);
  signal STMP : std_logic_vector(31 downto 0);

begin

  CTMP(0) <= Cin;
  S <= STMP;
  G <= GTMP(1) OR (GTMP(0) AND PTMP(1));
  P <= PTMP(1) AND PTMP(0);
  
  ADDER1: for I in 0 to 1 generate
    FAI : CLA_HR1 
	  Port Map (a => A(I*16+15 downto I*16), b => B(I*16+15 downto I*16), cin => CTMP(I), S => STMP(I*16+15 downto I*16), G => GTMP(I), P => PTMP(I)); 
  end generate;

    CTMP(1) <= GTMP(0) OR ( CTMP(0) AND PTMP(0));

end RTL_lv2;
