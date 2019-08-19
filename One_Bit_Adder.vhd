----------------------------------------------------------------------------------
-- Company: 		 South Dakota School of Mines and Technology
-- Engineer: 		 Musa Bah
-- Create Date:      19:32:07 01/29/2019
-- Module Name:      One_Bit_Adder 
-- Project Name:     Lab Two
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity One_Bit_Adder is
      Port(A : 			in   STD_LOGIC;
           B : 			in   STD_LOGIC;
           C_In : 	    in   STD_LOGIC;
           Sum  : 		out  STD_LOGIC;
           Carry :      out  STD_LOGIC
			  );
end One_Bit_Adder;

architecture struc of One_Bit_Adder is	
begin
	-- Define the function of the XOR part of the full adder.
	Sum <= A xor B xor C_In;
	
	-- Define the function of the OR part of the full adder. 
	Carry <= (A and B) or (C_In and (B or A));

end struc;

