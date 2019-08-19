----------------------------------------------------------------------------------
-- Company: SDSMT
-- Engineer: Anneka Swedlund
-- 
-- Create Date: 04/02/2019 10:25:11 PM
--
-- Module Name: BTU - Behavioral
-- Project Name: Decoder
-- Target Devices: xc7a100tcsg324-2
-- Description: Branch Test Unit for the LPU Decoder
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BTU is
  Port ( 
        encoding : in std_logic_vector(3 downto 0); --encoding for branch test type
        CCR      : in std_logic_vector(3 downto 0); --CCR flags from Datapatg
        result   : out std_logic                    --final decision for branching
        );
end BTU;

architecture Behavioral of BTU is
    signal N, Z, C, V : std_logic := '0';           --intermediate NZCV signals
begin

process(CCR)
begin
    --assign N, Z, C, V the corresponding values from CCR
    N <= CCR(3);
    Z <= CCR(2);
    C <= CCR(1);
    V <= CCR(0);
end process;

process(encoding)
begin
    --switch statement based on encoding
    case encoding is
        --al : default)
        when "0000" => result <= '1';
        
        --mi : res less than zero
        when "0001" => result <= N;
            
        --pl : res greater than or eq to zero
        when "0010" => result <= not(N);
        
        --eq: equal to
        when "0011" => result <= Z;
        
        --ne: not equal to
        when "0100" => result <= not(Z);
            
        --cs: carry set
        --hs: higher than or same as
        --uv: unsigned overflow
        when "0101" => result <= C;
        
        --cc: carry clear
        --lo: lower than
        when "0110" => result <= not(Z);
        
        --vs: overflow
        when "0111" => result <= V;
        
        --vc: no overflow
        when "1000" => result <= not(V);
        
        --lt: less than
        when "1001" => result <= N xor V;
        
        --gt: greater than
        when "1010" => 
        result <= not(Z) and ((N and v) or (not(N) and not(V)));
    
        --le: less than or eq to
        when "1011" => result <= Z or (N xor V);
        
        --ge: greater than or equal to
        when "1100" =>
        result <= (N and v) or (not(N) and not(V));
        
        --hi: higher than
        when "1101" => result <= C and not(Z);
        
        --ls: lower than or same as
        when "1110" => result <= not(C) or not(Z);
        
        when others => result <= '0';
        
    end case;
end process;

end Behavioral;
