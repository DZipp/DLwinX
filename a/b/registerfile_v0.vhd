library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.math_real.all;
use WORK.all;--dentro questa cartella ci sarà il file "constant" contenente tutte le variabili custom

entity gen_register_file is
 generic (	address : integer := 5;  ---queste variabili vanno nella cartella constant, una volta creata quella, si può aggiustare questo generic
			numRows : integer := 32;
			numBit  : integer := 32); 
 port ( CLK: 	 IN std_logic;
        RESET: 	 IN std_logic;
	    ENABLE:  IN std_logic;
		RD: 	 IN std_logic;
		WR: 	 IN std_logic;
		ADD_WR:  IN std_logic_vector( (address-1) downto 0 );
		ADD_RD1:  IN std_logic_vector( (address-1) downto 0 );
    	ADD_RD2: IN std_logic_vector( (address-1) downto 0 );
		DATAIN:  IN std_logic_vector( (numBit-1) downto 0 );
		R_OUT1: 	 OUT std_logic_vector( (numBit-1) downto 0 );
		R_OUT2: 	 OUT std_logic_vector( (numBit-1) downto 0 ));
end gen_register_file;

architecture registerfile of gen_register_file is

    
    subtype REG_ADDR is natural range 0 to numRows-1; -- using natural type
	type REG_ARRAY is array(REG_ADDR) of std_logic_vector(numBit-1 downto 0); 
	signal REGISTERS : REG_ARRAY; 

	
begin 

REGISTERS(0) <= (others => '0');

R1: process(CLK)
        begin 
		if rising_edge(CLK) then
			--synchronous reset 
			if (RESET = '1') then
				REGISTERS <= (others =>(others => '0'));
			else
				--enable signal
				if (ENABLE = '1') then		
					if (WR = '1') then
						if (ADD_WR /= x"00000") then
							REGISTERS(conv_integer(ADD_WR)) <= DATAIN;
						end if;
					end if;
		
					if (RD = '1') then
						R_OUT1 <= REGISTERS(conv_integer(ADD_RD1));
						R_OUT2 <= REGISTERS(conv_integer(ADD_RD2));
					end if;
				end if;
			end if;
		end if;
     	end process R1;
end registerfile;

