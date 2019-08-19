library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity barrel_shifter is
    Port ( A   : in STD_LOGIC_VECTOR  (15 downto 0);
           B   : in  STD_LOGIC_VECTOR  (4 downto 0);
           sel : in  STD_LOGIC_VECTOR  (1 downto 0);
           R   : out STD_LOGIC_VECTOR (15 downto 0);
           C, V: out STD_LOGIC );
           
end barrel_shifter;

architecture modular of barrel_shifter is
signal R_lsl, R_rsl, R_rsa : STD_LOGIC_VECTOR(15 downto 0);
signal C_lsl, C_rsl, C_rsa, V_lsl : STD_LOGIC; 
begin

    --mux for result
    with sel select R <=
    R_lsl when "01",
    R_rsl when "10",
    R_rsa when "11",
    "0000000000000000" when others;
    
    --mux for C
    with sel select C <=
    C_lsl when "01",
    C_rsl when "10",
    C_rsa when "11",
    '0' when others;
     
    --mux for V
    V <= V_lsl when sel = "01" else '0';
    
    --set up all three shifters
    left_shift_logical: entity work.lsl(arch1)
    port map( A => A,
              B => B,
              R => R_lsl,
              C => C_lsl,
              V => V_lsl );
              
    right_shift_logcial: entity work.rsl(arch1)
    port map( A => A,
              B => B,
              R => R_rsl,
              C => C_rsl );
              
    right_shift_arith : entity work.rsa(arch1)
    port map( A => A,
              B => B,
              R => R_rsa,
              C => C_rsa );              
    
end modular;
