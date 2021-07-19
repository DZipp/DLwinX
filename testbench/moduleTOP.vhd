library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity TOP is
       port (   A : in std_logic_vector(15 downto 0);
                B : out std_logic_vector(15 downto 0));
end TOP;

architecture behavioral of TOP is
   
  component Module is
       port (   xin : in std_logic_vector(15 downto 0);
                yin : in std_logic_vector(15 downto 0);
                zin : in std_logic_vector(15 downto 0);
                j : in std_logic_vector(3 downto 0);
                xout : out std_logic_vector(15 downto 0);
                yout : out std_logic_vector(15 downto 0);
                zout : out std_logic_vector(15 downto 0));
end component;

type mem_array is array (integer range 0 to 9) of std_logic_vector(15 downto 0);
signal xvec,yvec,zvec : mem_array;

type mem_int is array (integer range 0 to 9) of std_logic_vector(3 downto 0);
signal j : mem_int;

signal try : std_logic_vector(3 downto 0);

begin

xvec(0) <= X"26DC";
yvec(0) <= X"0000";
zvec(0) <= A;
B <= yvec(9);

GEN : for i in 0 to 8 generate
    j(i) <= std_logic_vector(to_unsigned(i, try'LENGTH));
    MODULEX : entity work.Module(behavioral)
              port map (xin => xvec(i), yin => yvec(i) , zin => zvec(i) , j => j(i), xout => xvec(i+1), yout => yvec(i+1) , zout => zvec(i+1) );
      end generate GEN;
end behavioral;
