library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CCR is
    Port ( N : in STD_LOGIC;
           Z : in STD_LOGIC;
           C : in STD_LOGIC;
           V : in STD_LOGIC;
           reset: in std_logic;
           N_Out: out std_logic;
           Z_Out: out std_logic;
           C_Out: out std_logic;
           V_Out: out std_logic;
           
           clk: in std_logic;
           CCRle: in STD_LOGIC);
end CCR;

architecture struc of CCR is
signal CCRegister: std_logic_vector(3 downto 0);

begin
    process (clk)
    begin
        if (clk'event and clk = '1') then
            if (reset = '0') then
                CCRegister <= "0000";
            elsif (CCRle = '0') then
                   CCRegister(0) <= N;
                   CCRegister(1) <= Z;
                   CCRegister(2) <= C;
                   CCRegister(3) <= V;
            end if;
     end if;
    end process;
 N_Out <= CCRegister(0);
 Z_Out <= CCRegister(1);
 C_Out <= CCRegister(2);
 V_Out <= CCRegister(3);
 
end struc;
