library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lsl is
    Port ( A    : in  STD_LOGIC_VECTOR  (15 downto 0);
           B    : in  STD_LOGIC_VECTOR  (4  downto 0);
           R    : out STD_LOGIC_VECTOR  (15 downto 0);
           C, V : out STD_LOGIC );
           
end lsl;

architecture arch1 of lsl is
signal A_buff : std_logic_vector(31 downto 0);
signal A0, A1, A2, A3, A4 : std_logic_vector(31 downto 0);
begin

------------ LOGICAL SHIFT LEFT -------------------------

--buffer A with 16 bits on the left
A_buff <= "0000000000000000" & A;
--shift 0: shift by 1 bit
A0 <=   A_buff(30 downto 0) & '0' when B(0) = '1' 
        else A_buff;
--shift 1: shift by 2 bits
A1 <=   A0(29 downto 0) & "00" when B(1) = '1' 
        else A0;
--shift 2: shift by 4 bits
A2 <=   A1(27 downto 0) & "0000" when B(2) = '1' 
        else A1;
--shift 3: shift by 8 bits
A3 <=   A2(23 downto 0) & "00000000" when B(3) = '1'
        else A2;
--shift 4: shift by 16 bits
A4 <=   A & "0000000000000000" when B(4) = '1'
        else A3;
        
--C: bit 16 is the last bit that was shifted out
C <= A4(16);

--V: Result bit 16, overflow bit (true if any bit shifted out was 1)
V <= '0' when A4(31 downto 16) = "0000000000000000" else '1';

R <= A4(15 downto 0);

end arch1;
