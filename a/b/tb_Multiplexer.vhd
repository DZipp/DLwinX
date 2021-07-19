library IEEE;
use IEEE.std_logic_1164.all;

entity TB_mux is
end TB_mux;

architecture Test of TB_mux is

component Mux is
          generic( numbit : integer );
          port (   A : in std_logic_vector(numbit-1 downto 0);
                   B : in std_logic_vector(numbit-1 downto 0);
                   sel : in std_logic;
                   Z : out std_logic_vector(numbit-1 downto 0) );
end component;

signal X,Y,C : std_logic_vector(3 downto 0);
signal selex : std_logic := '0';

begin

  MULTIPLEXER : entity work.Mux(behavioral) generic map(numbit => 4)
                                            port map( A => X , B => Y , sel => selex , Z => C );

  selex <= not selex after 0.5 ns;

  X <= "0010";
  Y <= "0001";

  CHECKX : process
       begin
       wait for 0.2 ns;
       assert ( C=X ) report "Sbagliato a mux=0";
       wait for 0.8 ns;
  end process;

  CHECKY : process
       begin
       wait for 0.7 ns;
       assert ( C=Y ) report "Sbagliato a mux=1";
       wait for 0.3 ns;
  end process;

end Test;

