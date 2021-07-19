library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity TB_shifter is
end TB_shifter;

architecture TEST of TB_shifter is
    component shifter is
        Port( A : in std_logic_vector(15 downto 0);
              B : in std_logic_vector(3 downto 0);
              Z : out std_logic_vector(15 downto 0));
    end component;

    component LFSR16 
        port (CLK, RESET, LD, EN : in std_logic; 
              DIN : in std_logic_vector(15 downto 0); 
              PRN : out std_logic_vector(15 downto 0); 
              ZERO_D : out std_logic);
    end component;

    constant Period: time := 1 ns; -- Clock period (1 GHz)
    signal CLK : std_logic :='0';
    signal RESET,LD,EN,ZERO_D : std_logic;
    signal DIN, PRN : std_logic_vector(15 downto 0);

    signal A : std_logic_vector(15 downto 0):=(others => '0');
    signal B : std_logic_vector(3 downto 0):=(others => '0');
    signal Z : std_logic_vector(15 downto 0);

begin



  SHI: entity work.shifter(Behavioral)
               port map (A, B, Z);

  A(0) <= PRN(0);
  A(3) <= PRN(4);
  A(1) <= PRN(6);
  A(2) <= PRN(10);
  A(4) <= PRN(0);
  A(5) <= PRN(4);
  A(6) <= PRN(6);
  A(7) <= PRN(10);
  A(8) <= PRN(0);
  A(9) <= PRN(4);
  A(10) <= PRN(6);
  A(11) <= PRN(10);
  A(12) <= PRN(0);
  A(13) <= PRN(4);
  A(14) <= PRN(6);
  A(15) <= PRN(10);

  B(0) <= PRN(15);
  B(3) <= PRN(11);
  B(1) <= PRN(9);
  B(2) <= PRN(5);

-- Instanciate the Unit Under Test (UUT)
  UUT: LFSR16 port map (CLK=>CLK, RESET=>RESET, LD=>LD, EN=>EN, 
                        DIN=>DIN,PRN=>PRN, ZERO_D=>ZERO_D);
-- Create the permanent Clock and the Reset pulse
  CLK <= not CLK after Period/2;
  RESET <= '1', '0' after Period;
-- Open file, make a load, and wait for a timeout in case of design error.
  STIMULUS1: process
  begin
    DIN <= "0000000000000001";
    EN <='1';
    LD <='1';
    wait for 2 * PERIOD;
    LD <='0';
    wait for (65600 * PERIOD);
  end process STIMULUS1; 
	
end TEST;
