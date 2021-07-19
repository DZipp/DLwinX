library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity carry_generator is
  generic (M : integer := 32; --number of bits of the operand
           k : integer := 8 ; --number of blocks
           n : integer := 4); --number of bits per block => n=M/k
  port (A   : in std_logic_vector(M-1 downto 0);
        B   : in std_logic_vector(M-1 downto 0);
        Cin  : in std_logic;
        Cout: out std_logic_vector(k-1 downto 0));
end carry_generator;

architecture STRUCTURAL of carry_generator is

  component PGNB is
    port ( a : in std_logic;
           b : in std_logic;
           p : out std_logic;
           g : out std_logic);
  end component;

  component PG is
    port ( Gik : in std_logic;
           Ghj : in std_logic; -- h=k-1
           Pik : in std_logic;
           Phj : in std_logic; -- h=k-1
           Gij : out std_logic;
           Pij : out std_logic);
  end component;

  component G is
    port ( Gik : in std_logic;
           Ghj : in std_logic; -- h=k-1
           Pik : in std_logic;
           Gij : out std_logic);
  end component;

  constant D : integer := integer(ceil(log2(real(M)))); --tree depth
  
  type signalVector is array (0 to D) of std_logic_vector(M-1 downto 0);

  signal p : signalVector;
  signal gl : signalVector;
  signal and1 : std_logic;
  signal xor1 : std_logic;

  begin
  
    p(0)(0) <= '0';

    PG_network : for i in 0 to M-1 generate ---define the PG network
      
      B1 : if i=0 generate -- the first block works also as a Gblock so in the
                           -- end generates G[1,0] thet here is defined as g(0)(0)
                   and1 <= A(0) and B(0);
                   xor1 <= A(0) xor B(0);
                   G_b : G port map ( and1, Cin, xor1, gl(0)(i));
      end generate;

      B2 : if i>0 generate
        PGN : PGNB port map (A(i), B(i), p(0)(i), gl(0)(i));
      end generate;
      
    end generate;


    P0 : for level in 0 to D-1 generate
      
      P1 : for i in M-1 downto 0 generate
        
        P2 : if (i mod (2**(level+1)) = (2**(level+1)-1)) generate--here we
                                                                  --select the
                                                                  --carry lines

          P3 : if (i > 2**(level+1)-1) generate --if this condition is respected
                                              --then we are in a PG block
            PG1 : PG port map (gl(level)(i), gl(level)(i-(2**level)), p(level)(i), p(level)(i-(2**level)), gl(level+1)(i), p(level+1)(i));

            P3_a : if (2**level > n) generate -- with this we add blocks that
                                              -- are missing to carry lines

             P3_b : for j in (i-n) downto (i+1-2**(level)) generate

               P3_c : if ((j mod n) = n-1) generate
                 PG2 : PG port map (gl(level)(j), gl(level)(i-(2**level)), p(level)(j), p(level)(i-(2**level)), gl(level+1)(j), p(level+1)(j));                 
               end generate;               
             end generate;              
            end generate;
          end generate;

          P4 : if (i = 2**(level+1)-1) generate

            G1 : G port map (gl(level)(i), gl(level)(i-(2**level)), p(level)(i), gl(level+1)(i));

            GEN_a : if (i >= n-1) generate

              Cout(i/n) <= gl(level+1)(i);

            end generate;

            P4_a : if (2**level > n) generate -- with this we add blocks that
                                              -- are missing to carry lines

             P4_b : for j in (i-n) downto (i+1-(2**level)) generate

               P4_c : if ((j mod n) = n-1) generate

                 G2 : G port map (gl(level)(j), gl(level)(i-(2**level)), p(level)(j), gl(level+1)(j));

                 GEN_b : if (i >= n-1) generate

                   Cout(j/n) <= gl(level+1)(j);
                   
                 end generate;
                 
               end generate;
             end generate;              
            end generate;            
          end generate;          
        end generate;
        --if the signal has to be brought to the next line
        P5 : if ((2**level >= n) and (i mod 2**(level+1) < 2**level) and (i mod 2**(level+1) >= 0) and ((i+1) mod n = 0)) generate
           p(level+1)(i)<=p(level)(i);
           gl(level+1)(i)<=gl(level)(i);
        end generate;
      end generate;      
    end generate;

end STRUCTURAL;




    
                                   
    
  
