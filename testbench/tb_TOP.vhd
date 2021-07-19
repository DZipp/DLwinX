library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_TOP is
end TB_TOP;

architecture TEST of TB_TOP is
    component TOP is
       port (   A : in std_logic_vector(15 downto 0);
                B : out std_logic_vector(15 downto 0));
    end component;

    constant Period: time := 1 ns; -- Clock period (1 GHz)

    signal A : std_logic_vector(15 downto 0):=(others => '0');
    signal Z : std_logic_vector(15 downto 0);

begin

  SHI: entity work.TOP(Behavioral)
               port map (A, Z);


  STIMULUS1: process
  begin
    A <= std_logic_vector(to_signed(to_integer(signed(A)) + 2860, A'LENGTH)); -- +10 degrees
    wait for 2 * PERIOD;
  end process STIMULUS1; 
	
end TEST;
