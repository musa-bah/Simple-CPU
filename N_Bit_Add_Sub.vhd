----------------------------------------------------------------------------------
-- Company: 		 South Dakota School of Mines and Technology
-- Engineer: 		 Musa Bah
-- Create Date:      19:32:07 01/29/2019
-- Module Name:      N_Bit_Adder_Sub
-- Project Name:     Lab One
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity N_Bit_Add_Sub is
		--BTA means Bits To Add
	Generic (BTA: integer := 16); 
    Port ( A :            in     std_logic_vector((BTA - 1) downto 0);
           B :            in     std_logic_vector((BTA - 1) downto 0) ;
           C_In :         in     std_logic;
		   Sel :          in     std_logic_vector(1 downto 0);
           Sum :          out    std_logic_vector((BTA - 1) downto 0);
           Carry:         out    std_logic;
	       Over_Flow:     out    std_logic
		  );
end N_Bit_Add_Sub;

Architecture struc of N_Bit_Add_Sub is
--Signal for temporary carry over holder.
Signal Temp_Carry: std_logic_vector(BTA downto 0);
Signal Temp_B: std_logic_vector((BTA - 1) downto 0);


Begin
--Using selct signal manipulation, the following add and or subtract with and without carry.

    Temp_B <= (std_logic_vector  (   not unsigned(B)  +  to_unsigned(1,BTA)   )  ) when (Sel = "11") else 
              B when (Sel = "01") else 
              (std_logic_vector  (   not unsigned(B)  +  to_unsigned(1,BTA)   )  ) when (Sel = "10") else 
              B when (Sel = "00");

   Temp_Carry(0) <= C_In when (Sel = "11") else
                    C_In when (Sel = "01") else
                    '0'  when (Sel = "10") else
                    '0'  when (Sel = "00") ;
                    
Generate_N: for i in 0 to (BTA - 1) generate
		Adder: entity work.One_Bit_Adder(struc) 
		   port map(A     => A(i), 
					B     => Temp_B(i),
				    C_In  => Temp_Carry(i), 
					Sum   => Sum(i),
					Carry => Temp_Carry(i + 1));
end generate Generate_N;
--Determins the carry and overflow bits.
Carry <= Temp_Carry(BTA);
Over_Flow <= Temp_Carry(BTA) xor Temp_Carry( BTA - 1);

end struc;