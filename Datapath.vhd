----------------------------------------------------------------------------------
-- Company: 		 South Dakota School of Mines and Technology
-- Engineer: 		 Musa Bah
-- Create Date:      19:32:07 02/13/2019
-- Module Name:      Datapath
-- Project Name:     Lab Three
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Datapath is 
    port(Asel:      in std_logic_vector(2 downto 0);
         Bsel:      in std_logic_vector(2 downto 0);
         Dsel:      in std_logic_vector(2 downto 0);
         reset:     in std_logic;
         clk:       in std_logic;        
         Data_In:   in std_logic_vector(15 downto 0);
         cw:        in std_logic_vector(16 downto 0);
  
         ALUfunc:   in std_logic_vector(3 downto 0);
         IMM:       in std_logic_vector(15 downto 0);
 
         Data_out:  out std_logic_vector(15 downto 0);
         Address:   out std_logic_vector(15 downto 0);
         Flags:     out std_logic_vector(3 downto 0)
         );
  end Datapath;
  
architecture struc of Datapath is 
--Signals for the CW
signal DIsel:  std_logic;
signal Dlen:   std_logic;
signal PCle:   std_logic;
signal PCie:   std_logic;
signal PCDsel: std_logic;
signal MARsel: std_logic;
signal MARle:  std_logic;
signal CCRle:  std_logic; 
signal IMMBsel:std_logic;
signal PCAsel: std_logic;

--Signals for A and B Bus
signal ABus: std_logic_vector(15 downto 0);
signal BBus: std_logic_vector(15 downto 0);

--Signal for the DBus and the data bing loaded into the register.
signal DBus: std_logic_vector(15 downto 0);
signal Regis_Data: std_logic_vector(15 downto 0);

--Signals for the A and B input to be loaded into the ALU.
signal A: std_logic_vector(15 downto 0);
signal B: std_logic_vector(15 downto 0);

--Signlas for the flags to be stored in the CCR
signal N: std_logic;
signal Z: std_logic;
signal C: std_logic;
signal V: std_logic;
signal R: std_logic_vector(15 downto 0);

--Signal for program conter output.
signal PC_Out: std_logic_vector(15 downto 0);

--Signal for the MAR out
signal MAROut: std_logic_vector(15 downto 0);

begin
--Mux for the Data  goinng into the registe file. 
Regis_Data <= Data_In when DIsel = '1' else DBus;

--Mux for the IMMB and PCA
B <= IMM when IMMBsel = '1' else BBus;
A <= PC_Out when PCAsel  = '1' else ABus;

--Mux for PC
DBus <= PC_Out when PCDsel = '1' else R;

--Mux for address
Address <= MAROut when MARSel = '1' else DBus;

--Data out connected to B
Data_Out <= B;

--Map the signal to the CW
DIsel  <= cw(16);
Dlen   <= cw(15);
PCASel <= cw(14);
PCle   <= cw(13);
PCie   <= cw(12);
PCDsel <= cw(11);
IMMBsel<= cw(10);
CCRle  <= cw(9);
MARle  <= cw(8);
MARsel <= cw(7);

DataMux: entity work.Register_File(struc)
          port map( Asel => Asel,
                    Bsel => Bsel,
                    Dsel => Dsel,
                    Dlen => Dlen,
                    reset => reset,
                    Regis_Data => Regis_Data,
                    clk  => clk,
                    ABus => ABus,
                    BBus => BBus);
                    
ALU: entity work.ALU(struc)
      port map( A => A,
                B => B,
                F => ALUfunc,
                C_In => C,
                R => R,
                N => N,
                Z => Z,
                C => C,
                V => V);
                
CCR: entity work.CCR(struc)
      port map(N => N,
               Z => Z,
               C => C,
               V => V,
               reset => reset,
               clk => clk,
               CCRle => CCRle,
               N_Out => Flags(0),
               Z_Out  => Flags(1),
               C_Out => Flags(2),
               V_Out => Flags(3));
               
PC: entity work.PC(Behavioral)
     port map(PCle => PCle,
              PCie => PCie,
              clk  => clk,
              reset => reset,
              ALU_R=> R,
              PC_Out => PC_Out);
 
MAR: entity work.MAR(struc)
      port map(MARle  => MARle,
               DBus   => DBus,
               clk    => clk,
               reset  => reset,
               MAROut => MAROut);
end struc;
         
         
