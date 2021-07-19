library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Module is
       port (   xin : in std_logic_vector(15 downto 0);
                yin : in std_logic_vector(15 downto 0);
                zin : in std_logic_vector(15 downto 0);
                j : in std_logic_vector(3 downto 0);
                xout : out std_logic_vector(15 downto 0);
                yout : out std_logic_vector(15 downto 0);
                zout : out std_logic_vector(15 downto 0));
end Module;

architecture behavioral of Module is
   
  component shifter is
       Port( A : in std_logic_vector(15 downto 0);
             B : in std_logic_vector(3 downto 0);
             Z : out std_logic_vector(15 downto 0));
  end component;

    component CLA is
        Generic( numbit : integer);
        Port( a,b : IN std_logic_vector(numbit-1 downto 0);
              cin : IN std_logic;
              S : OUT std_logic_vector(numbit-1 downto 0);
              cout : OUT std_logic);
    end component;

signal shifterx, shiftery : std_logic_vector(15 downto 0);
signal addx, addy, addz : std_logic_vector(15 downto 0);
signal CoutX, CoutY, CoutZ : std_logic;
signal Cix, Ciy, Ciz : std_logic;

type mem_array is array (integer range 0 to 9) of std_logic_vector(15 downto 0);
signal LutZ : mem_array := (X"3243", -- 12867 srl 14       2 bit _ 14 bit     Valori per atan(2^-i)
                            X"1dac", -- 7596 srl 14
                            X"0fae", -- 4014 srl 14
                            X"07f5", -- 2037 srl 14
                            X"03ff", -- 1023 srl 14
                            X"0200", -- 512 srl 14
                            X"0100", -- 256 srl 14
                            X"0080", -- 128 srl 14
                            X"0040", -- 64 srl 14
                            X"0020"); -- 32 srl 14

begin

  SHIX: entity work.shifter(Behavioral)
               port map (xin, j, shifterx);

  SHIY: entity work.shifter(Behavioral)
               port map (yin, j, shiftery);


  ADDERX: entity work.CLA(RTL)  generic map (16)
               port map (xin, addx, Cix, xout, CoutX);

  ADDERY: entity work.CLA(RTL)  generic map (16)
               port map (yin, addy, Ciy, yout, CoutY);

  ADDERZ: entity work.CLA(RTL)  generic map (16)
               port map (zin, addz, Ciz, zout, CoutZ);

DELTA : PROCESS(j,shifterx,shiftery,xin,yin,zin)
begin
if zin(15) = '0' then
      addx <= NOT(shiftery);
      Cix <= '1';
      addy <= shifterx;
      Ciy <= '0';
      addz <= NOT(LutZ(to_integer(unsigned(j))));
      Ciz <= '1';
else
      addx <= shiftery;
      Cix <= '0';
      addy <= NOT(shifterx);
      Ciy <= '1';
      addz <= LutZ(to_integer(unsigned(j)));
      Ciz <= '0';
end if;
end process;

end behavioral;
