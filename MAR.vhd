library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity MAR is
    Port ( MARle : in STD_LOGIC;
           DBus : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in std_logic;
           reset: in std_logic;
           MAROut : out STD_LOGIC_VECTOR (15 downto 0));
end MAR;

architecture struc of MAR is
signal MARegister: std_logic_vector(15 downto 0);

begin 
   process(clk)
    begin    
    if (clk'event and clk = '1')then
        if (reset = '0') then 
            MARegister <= "0000000000000000";
        elsif( MARle = '0') then
            MARegister <= DBus;
        end if;
   end if;
  end process;
 MAROut <= MARegister;
end struc;
