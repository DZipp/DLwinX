-----------------------------------------------------------
-- OpenSPARC T2 ISA -> Logicals  AND,NAND, OR,NOR, XOR,XNOR
-----------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity LogicalT2 is
       Generic (numbit : integer :=32);
       Port ( A,B : in std_logic_vector(numbit-1 downto 0);
              control : in std_logic_vector(3 downto 0);
              Z : out std_logic_vector(numbit-1 downto 0));
end LogicalT2;

architecture Behavioral of LogicalT2 is

-- 2 Layer di AND, NOR and AND possono essere eseguiti con un solo layer A'B'=(A+B)'
-- quindi per essi potremmo non usare questo, ma lo useremo
-- evitiamo di usare ulteriori risorse

signal ctl0,ctl1,ctl2,ctl3 : std_logic_vector(numbit-1 downto 0);
signal temp0,temp1,temp2,temp3 : std_logic_vector(numbit-1 downto 0);

begin

ctl0 <= (others => control(0));
ctl1 <= (others => control(1));
ctl2 <= (others => control(2));
ctl3 <= (others => control(3));

temp0 <= ctl0 AND NOT(A) AND NOT(B); -- Layer 1 di AND/INV
temp1 <= ctl1 AND NOT(A) AND B;
temp2 <= ctl2 AND A AND NOT(B);
temp3 <= ctl3 AND A AND B;

Z <= NOT( NOT(temp0) AND NOT(temp1) AND NOT(temp2) AND NOT(temp3));

end Behavioral;
