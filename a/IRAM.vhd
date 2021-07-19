------------------------------------------------------------------------------------
-- Synchronous/Asynchronous RAM only read memory with rising edge asynchronous reset
------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

-- Instruction memory for DLwinX
-- Memory filled by a process which reads from a file
-- File name is "<FileName>.asm.mem" -> compiled with the given compiler and converted in mem

entity IRAM is
    generic (RAM_width : integer := 48;
             InstructionSize : integer :=32);
    port (Rst,Enable : in  std_logic;
          -- Clk : in  std_logic;
          Address : in std_logic_vector(5 downto 0);
          Dout : out std_logic_vector(InstructionSize - 1 downto 0));
end IRAM;

architecture Behavioral of IRAM is
type RAM_type is array (0 to RAM_width-1) of std_logic_vector(InstructionSize-1 downto 0);
signal RAM : RAM_type := (others =>(others =>'0'));

begin

-- SYNCHRONOUS

--  PROCESS(Rst,Enable,Clk,Address) is
--  FILE mem_fp: text;
--  variable file_line : line;
--  variable i : integer := 0;
--  variable tmp_data_u : std_logic_vector(InstructionSize-1 downto 0);
--  begin
--     if (Rst='1') then -- Asynchronous reset
--        i := 0;
--        Dout <= (others =>'0');
--        file_open(mem_fp,"test.asm.mem",READ_MODE);
--        while (not endfile(mem_fp)) loop
--          readline(mem_fp,file_line);
--          hread(file_line,tmp_data_u);
--          RAM(i) <= tmp_data_u;
--          i := i+1;
--          end loop;
--          file_close(mem_fp);
--     elsif (Clk='1' and Clk'Event and ENABLE='1') then
--           Dout <= RAM(to_integer(unsigned(Address)));
--     end if;
--  end process;


-- ASYNCHRONOUS

  PROCESS(Rst,Enable,Address) is
  FILE mem_fp: text;
  variable file_line : line;
  variable i : integer := 0;
  variable tmp_data_u : std_logic_vector(InstructionSize-1 downto 0);
  begin
     if (Rst='1') then -- Asynchronous reset
        RAM <= (others =>(others =>'0'));
        i := 0;
        Dout <= (others =>'0');
        file_open(mem_fp,"test.asm.mem",READ_MODE);
        while (not endfile(mem_fp)) loop
          readline(mem_fp,file_line);
          hread(file_line,tmp_data_u);
          RAM(i) <= tmp_data_u;
          i := i+1;
          end loop;
          file_close(mem_fp);
     else
        Dout <= RAM(to_integer(unsigned(Address)));
     end if;
  end process;

end Behavioral;
