library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity PC is
    Port ( PCle :  in STD_LOGIC;
           PCie :  in STD_LOGIC;
           clk :   in std_logic;
           reset:  in std_logic;
           ALU_R:  in std_logic_vector(15 downto 0);
           PC_Out: out std_logic_vector(15 downto 0));
end PC;

architecture Behavioral of PC is
signal PCRegister: std_logic_vector(15 downto 0);

begin 
    process(clk)
    begin   
                 
    if (clk'event and clk = '1') then
        if (reset = '0') then
            PCRegister <= "0000000000000000";
        elsif (PCle = '0') then
            PCRegister <= ALU_R;
        elsif (PCie = '0') then
            PCRegister <= (std_logic_vector ( unsigned(ALU_R) + to_unsigned(2,4)  )    );   
        end if;
    end if;
end process;
PC_Out <= PCRegister;
end Behavioral;
