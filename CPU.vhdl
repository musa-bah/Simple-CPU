----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2019 12:10:37 PM
-- Design Name: 
-- Module Name: CPU - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CPU is
  port(
    clock  : in  std_logic;
    reset  : in  std_logic; -- active low
    Menable: out std_logic; -- active low
    Mbyte  : out std_logic; -- active low
    Mread  : out std_logic; -- active low
    Mwrite : out std_logic; -- active low
    Mready : in  std_logic; -- active low (memory signals transaction complete)
    MAddr  : out std_logic_vector(15 downto 0);
    MDatao : out std_logic_vector(15 downto 0);
    MDatai : in  std_logic_vector(15 downto 0)    
    );
end CPU;

architecture Behavioral of CPU is
signal Instruction        : std_logic_vector(15 downto 0);
    signal ALUfunc            : std_logic_vector(3  downto 0);
    signal Asel, Bsel, Dsel   : std_logic_vector(2  downto 0);
    signal IT, Flags          : std_logic_vector(3  downto 0);
    signal CW, temp_cwout     : std_logic_vector(16 downto 0);
    signal IMM, Address       : std_logic_vector(15 downto 0);
    signal Data_in, Data_out  : std_logic_vector(15 downto 0);  --add address in here when it isn't an output anymore
    signal en:                  std_logic;
    signal Temp_Instruction   : std_logic_vector(15 downto 0);
   
begin 

MByte   <= temp_cwout(5);
Menable <= temp_cwout(6);
Mread   <= temp_cwout(4);
Mwrite  <= temp_cwout(3);
en      <= temp_cwout(2);
MAddr   <= Address;
MDatao  <= Data_Out;

IR: entity work.Ins_Register(Behavioral)
    port map(clk            => clock,
             Instruction_In => MDatai,
             en             => en,
             Instruction_Out=> Temp_Instruction,
             reset          => reset);
    
ID: entity work.Instruction_Decoder(struc)
    port map(ALUFunc => ALUFunc,
             ASel    => ASel,
             Bsel    => BSel,
             Dsel    => DSel,
             IT      => IT,
             CW      => CW,
             IMM     => IMM,
             Instruction => Temp_Instruction,
             Flags   => Flags);

SQ: entity work.sequencer(multi_segment)
    port map(clk    => clock,
             cwin   => CW,
             ready  => Mready,
             reset  => reset,
             IT     => IT,
             CWout  => Temp_cwout);
    
DP: entity work.Datapath(struc)
    port map(ALUFunc => ALUFunc,
             IMM     => IMM,
             ASel    => ASel,
             BSel    => BSel,
             DSel    => DSel,
             clk     => clock,
             cw      => temp_cwout,
             Data_In => MDatai,
             reset   => reset,
             Address => Address,
             Flags   => Flags,
             Data_Out => Data_Out);
end Behavioral;
