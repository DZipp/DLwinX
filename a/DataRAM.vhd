--------------------------------------------------------------------------
-- Asynchronous RAM memory with rising edge asynchronous reset
--------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Data memory for DLwinX

entity DRAM is
    generic (RAM_width : integer := 48; -- 64 nel DLX
             numbit : integer :=32);
    port (Rst,RE,WE : in  std_logic; -- Read Enable and Write Enable
          Add_WR, Add_RD : in std_logic_vector(5 downto 0);
          Din : in std_logic_vector(numbit - 1 downto 0);
          Dout : out std_logic_vector(numbit - 1 downto 0));
end DRAM;

architecture Behavioral of DRAM is
type RAM_type is array (0 to RAM_width-1) of std_logic_vector(numbit-1 downto 0);
signal RAM : RAM_type := (others =>(others =>'0'));
begin

  PROCESS(Rst,RE,WE,Add_WR,Add_RD) is
  begin
     if (Rst='1') then -- Asynchronous reset
        RAM <= (others =>(others =>'0'));
     else
        if WE='1' then -- Write
           RAM(to_integer(unsigned(Add_WR))) <= Din;
        end if;
        if RE='1' then -- Read
           Dout <= RAM(to_integer(unsigned(Add_RD)));
        end if;
     end if;
  end process;

end Behavioral;
