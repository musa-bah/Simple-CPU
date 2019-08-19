----------------------------------------------------------------------------------
-- Company: 		 South Dakota School of Mines and Technology
-- Engineer: 		 Musa Bah
-- Create Date:      19:32:07 02/13/2019
-- Module Name:      Four to one Mux
-- Project Name:     Lab Two
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Four_One_Mux is
  Generic (BTA: integer:= 16);
     Port (Add_Sub :           in STD_LOGIC_VECTOR (BTA - 1 downto 0);
           Add_Sub_Carry :     in STD_LOGIC;
           Add_Sub_Over_Flow : in STD_LOGIC;
           AS_Negative_Flag:   in STD_LOGIC;
           AS_Zero_Flag:       in STD_LOGIC;
           
           Logic_Unit :        in STD_LOGIC_VECTOR (BTA - 1 downto 0);
           LU_Zero_Flag:       in STD_LOGIC;
           LU_Negative_Flag:   in STD_LOGIC;
           
           Shifter_Ans:        in STD_LOGIC_VECTOR (BTA - 1 downto 0);
           Shifter_Carry:      in STD_LOGIC;
           Shifter_Over_Flow:  in STD_LOGIC;
           Shifter_Negative_Flag: in STD_LOGIC;
           Shifter_Zero_Flag:     in STD_LOGIC;
           
           Pass_B :            in STD_LOGIC_VECTOR (BTA - 1 downto 0);
           PB_Negative_Flag:   in STD_LOGIC;
           PB_Zero_Flag:       in STD_LOGIC;
           
           Sel :               in STD_LOGIC_VECTOR (1 downto 0);
           R:                  out STD_LOGIC_VECTOR(BTA - 1 downto 0);
           C:                  out STD_LOGIC;
           V:                  out STD_LOGIC;
           N:                  out STD_LOGIC;
           Z:                  out STD_LOGIC
           );
end Four_One_Mux;

architecture struc of Four_One_Mux is
begin  

--Mux the result based on the incoming signal
    R <= Add_Sub      when Sel = "00" else
         Logic_Unit   when Sel = "11" else
         Pass_B       when Sel = "01" else
         Shifter_Ans  when Sel = "10" ;
        
--Mux the carry flag based on the incoming signal
    C <= Add_Sub_Carry      when Sel = "00" else
         '0'                when Sel = "11" else
         '0'                when Sel = "01" else
         Shifter_Carry      when Sel = "10";
    
--Mux the overflow flag based on the incoming signal
    V <= Add_Sub_Over_Flow  when Sel = "00" else
        '0'                 when Sel = "11" else
        '0'                 when Sel = "01" else
        Shifter_Over_Flow   when Sel = "10";
 
--Mux the negative flag based on the incoming signal.
    N <= AS_Negative_Flag   when Sel = "00" else
         LU_Negative_Flag   when Sel = "11" else
         PB_Negative_Flag   when Sel = "01" else 
         Shifter_Negative_Flag when Sel = "10";
    
--Mux the negative flag based on the incoming signal.
    Z <= AS_Zero_Flag       when Sel = "00" else
         LU_Zero_Flag       when Sel = "11" else
         PB_Zero_Flag       when Sel = "01" else
         Shifter_Zero_Flag  when Sel = "10";
        
end struc;
