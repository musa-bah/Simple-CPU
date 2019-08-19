----------------------------------------------------------------------------------
-- Company: 		 South Dakota School of Mines and Technology
-- Engineer: 		 Musa Bah
-- Create Date:      19:32:07 02/12/2019
-- Module Name:      Logic_Unit 
-- Project Name:     Lab Two
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity Logic_Unit is
    Generic (BTA: integer:= 16);
    Port(A:   in              std_logic_vector(BTA - 1 downto 0);
         B:   in              std_logic_vector(BTA - 1 downto 0);
         R:   out             std_logic_vector(BTA - 1 downto 0);
         Sel: in              std_logic_vector(1 downto 0)
         );
End Logic_Unit;

Architecture struc of Logic_Unit is 
Begin
    R <= (not B)   when Sel = "00" else
         (A and B) when Sel = "01" else
         (A or B)  when Sel = "10" else 
         (A xor B) when Sel = "11";
end struc;
