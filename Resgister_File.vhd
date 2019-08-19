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

entity Register_File is
    port(Asel: in std_logic_vector(2 downto 0);
         Bsel: in std_logic_vector(2 downto 0);
         Dsel: in std_logic_vector(2 downto 0);
         Dlen: in std_logic;
         Regis_Data: in std_logic_vector(15 downto 0);
         clk : in std_logic;
         reset : in std_logic;
         ABus: out std_logic_vector(15 downto 0);
         BBus: out std_logic_vector(15 downto 0)
         );
 end Register_File;
 
architecture struc of Register_File is 
type Regis is array (0 to 7) of std_logic_vector(15 downto 0);
signal Register_Info: Regis;

begin 
    process(clk, reset)
    begin 
        --Reset all registers if reset is high.
        if (clk'event and clk = '1') then
            if (reset = '0') then 
                Register_Info <= (others => "0000000000000000");
            elsif (Dlen = '0') then
                Register_Info(to_integer(unsigned(Dsel))) <= Regis_Data; 
            end if;             
                ABus <= Register_Info(to_integer(unsigned(Asel)));
                BBus <= Register_Info(to_integer(unsigned(Bsel)));
        end if;  
     end process;
end struc;