----------------------------------------------------------------------------------
-- Company: 		 South Dakota School of Mines and Technology
-- Engineer: 		 Musa Bah, Anneka Swedlund
-- Create Date:      19:32:07 02/13/2019
-- Module Name:      ALU
-- Project Name:     Lab Two
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity ALU is
    Generic (BTA: integer:= 16);
    Port (A:         in  std_logic_vector(BTA - 1 downto 0);
          B:         in  std_logic_vector(BTA - 1 downto 0);
          F:         in  std_logic_vector(3 downto 0);
          C_In:      in  std_logic;
          R:         out std_logic_vector(BTA - 1 downto 0);
          C:         out std_logic;
          V:         out std_logic;
          N:         out std_logic;
          Z:         out std_logic
          );
End ALU;

Architecture struc of ALU is
--Zero flag for operators.
Signal AS_Zero_Flag: std_logic;
Signal LU_Zero_Flag: std_logic;
Signal PB_Zero_Flag: std_logic;
Signal shifter_Zero_Flag: std_logic;

--Negative flag operators.
Signal AS_Negative_Flag: std_logic;
Signal LU_Negative_Flag: std_logic;
Signal PB_Negative_Flag: std_logic;
Signal shifter_Negative_Flag: std_logic;

--Store leftmost and rightmost bits of F in one variable.
Signal Function_Selector: std_logic_vector(1 downto 0);

--Store middle bits of F in one variable.
Signal Operation_Selector: std_logic_vector(1 downto 0);

--Store answers from each operator
Signal Add_Sub_Ans: std_logic_vector(BTA - 1 downto 0);
Signal Add_Sub_Carry: std_logic;
Signal Add_Sub_Over_Flow: std_logic;

Signal Shifter_Ans: std_logic_vector(BTA - 1 downto 0);
Signal Shifter_Carry: std_logic;
Signal Shifter_Over_Flow: std_logic;

Signal Logic_Unit_Ans: std_logic_vector(BTA - 1 downto 0);

Signal Pass_B: std_logic_vector(BTA - 1 downto 0);

--Store B in a temporary array to trncate for the shifter.
Signal Temp_B: std_logic_vector(BTA - 1 downto 0);
Signal Temp_B_Shifter: std_logic_vector(4 downto 0);

Begin

Temp_B <= B;
--Tuncate B for the shifter input.
Temp_B_Shifter <= (Temp_B(4 downto 0)) when Function_Selector = "10";

--Selects the operator and operation.
Function_Selector  <= (F(3) & F(0));
Operation_Selector <= (F(2) & F(1));

--Passes B For Last mux value
Pass_B <= B;

--Check for flag negative for operators.
AS_Negative_Flag <= '1' when Add_Sub_Ans(BTA - 1)   = '1' else '0';
LU_Negative_Flag <= '1' when Logic_Unit_Ans(BTA -1) = '1' else '0';
PB_Negative_Flag <= '1' when Pass_B(BTA -1)         = '1' else '0';
shifter_Negative_Flag <= '1' when Shifter_Ans(BTA - 1) = '1' else '0'; 

--Checks for zero flags for operators.
AS_Zero_Flag     <= '1' when (unsigned(Add_Sub_Ans))    = to_unsigned(0,BTA) else '0';
LU_Zero_Flag     <= '1' when (unsigned(Logic_Unit_Ans)) = to_unsigned(0,BTA) else '0';
PB_Zero_Flag     <= '1' when (unsigned(Pass_B))         = to_unsigned(0,BTA) else '0';
shifter_Zero_Flag <= '1' when (unsigned(Shifter_Ans))   = to_unsigned(0,BTA) else '0';


Adder: Entity work.N_Bit_Add_Sub(struc)
        port map(A         => A,
                 B         => Temp_B,
                 C_In      => C_In,
                 Sel       => Operation_Selector,
                 Sum       => Add_Sub_Ans,
                 Carry     => Add_Sub_Carry,
                 Over_Flow => Add_Sub_Over_Flow);
        
Logic: Entity work.Logic_Unit(struc)
        port map(A        => A,
                 B        => Temp_B,
                 R        => Logic_Unit_Ans,
                 Sel      => Operation_Selector);
                 
 Shifter: Entity work.barrel_shifter(modular)
        port map(A       => A,
                 B       => Temp_B_Shifter,
                 Sel     => Operation_Selector,
                 R       => Shifter_Ans,
                 C       => Shifter_Carry,
                 V       => Shifter_Over_Flow);

Four_One_Mux: Entity work.Four_One_Mux(struc)
        port map(Add_Sub               => Add_Sub_Ans,
                 Add_Sub_Carry         => Add_Sub_Carry ,
                 Add_Sub_Over_Flow     => Add_Sub_Over_Flow,
                 AS_Negative_Flag      => AS_Negative_Flag,
                 AS_Zero_Flag          => AS_Zero_Flag,
                 
                 Logic_Unit            => Logic_Unit_Ans,
                 LU_Negative_Flag      => LU_Negative_Flag,
                 LU_Zero_Flag          => LU_Zero_Flag,
                 
                 Shifter_Ans           => Shifter_Ans,
                 Shifter_Carry         => Shifter_Carry,
                 Shifter_Over_Flow     => Shifter_Over_Flow,
                 Shifter_Negative_Flag => shifter_Negative_Flag,
                 Shifter_Zero_Flag     => shifter_Zero_Flag,
                 
                 Pass_B                => Pass_B,
                 PB_Negative_Flag      => PB_Negative_Flag,
                 PB_Zero_Flag          => PB_Zero_Flag,
                 
                 Sel                   => Function_Selector,
                 R                     => R,
                 C                     => C,
                 V                     => V,
                 N                     => N,
                 Z                     => Z);
End struc;