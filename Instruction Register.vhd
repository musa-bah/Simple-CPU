----------------------------------------------------------------------------------
-- Company: 		 South Dakota School of Mines and Technology
-- Engineer: 		 Musa Bah
-- Create Date:      19:32:07 02/13/2019
-- Module Name:      Register File
-- Project Name:     Lab Three
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Ins_Register is
    port(
         clk, en, reset : in std_logic;
         Instruction_In: in std_logic_vector(15 downto 0);
         Instruction_Out: out std_logic_vector(15 downto 0) );
 end Ins_Register;
 
architecture Behavioral of Ins_Register is 
signal Regis: std_logic_vector(15 downto 0);

begin 
    Regis <= Instruction_In;
    process(clk, reset)
    begin 
        --Reset all registers if reset is high.
        if (clk'event and clk = '1') then
            if (reset = '0') then 
                Regis <= "0000000000000000";
            elsif (en = '0') then
                Instruction_Out <= Regis; 
            end if;             
        end if;  
     end process;
end Behavioral;