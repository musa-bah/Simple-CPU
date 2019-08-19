library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rsa is
    Port ( A   : in  STD_LOGIC_VECTOR  (15 downto 0);
           B   : in  STD_LOGIC_VECTOR  (4 downto 0);
           R   : out STD_LOGIC_VECTOR  (15 downto 0);
           C   : out STD_LOGIC );
           
end rsa;

architecture arch1 of rsa is
signal A_buff, A0, A1, A2, A3, A4 : std_logic_vector(31 downto 0);
signal pad0 : std_logic;
signal pad1 : std_logic_vector(1 downto 0);
signal pad2 : std_logic_vector(3 downto 0);
signal pad3 : std_logic_vector(7 downto 0);
signal pad4 : std_logic_vector(15 downto 0);
signal sign : std_logic; 
begin
------------ ARITHMETIC SHIFT RIGHT -------------------------

sign <= A(15);
A_buff <= A & "0000000000000000";
pad0 <= sign;
pad1 <= pad0 & pad0;
pad2 <= pad1 & pad1;
pad3 <= pad2 & pad2;
pad4 <= pad3 & pad3;

--shift 0: shift by 1 bit
A0 <=   pad0 & A_buff(31 downto 1) when B(0) = '1' 
        else A_buff;
--shift 1: shift by 2 bits
A1 <=   pad1 & A0(31 downto 2) when B(1) = '1' 
        else A0;
--shift 2: shift by 4 bits
A2 <=   pad2 & A1(31 downto 4) when B(2) = '1' 
        else A1;
--shift 3: shift by 8 bits
A3 <=   pad3 & A2(31 downto 8) when B(3) = '1' 
        else A2;
--shift 4: shift by 16 bits
A4 <=   pad4 & A when B(4) = '1' 
        else A3;

--C: Result bit 17, last bit that was shifted out
C <= A4(15);
R <= A4(31 downto 16);

end arch1;