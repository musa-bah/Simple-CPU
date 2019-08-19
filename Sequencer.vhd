----------------------------------------------------------------------------------
-- Company: SDSMT
-- Engineer: Anneka Swedlund
-- 
-- Create Date: 05/01/2019 10:05:16 PM
-- Module Name: sequencer - Behavioral
-- Project Name: LPU
-- Target Devices: 
-- Description: 
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sequencer is
    port(
        clk, reset, ready : in std_logic;
        CWin              : in std_logic_vector(16 downto 0);
        IT                : in std_logic_vector(3 downto 0);
        CWout             : out std_logic_vector(16 downto 0));
end sequencer;

architecture multi_segment of sequencer is
    type reg_state_type is (Start, Fetch1, Fetch2, Ex1, Ex2);
    --states
    signal CS, NS:                      reg_state_type;
    --for moore outputs and state conditions
    signal MARsel, MARle, PCie:         std_logic;
    signal is_load_store:               std_logic;
    --for control word/mealy
    signal DIsel, DIen:                 std_logic;
    signal PCAsel, PCle, PCDsel:        std_logic;
    signal IMMBsel:                     std_logic;
    signal CCRle:                       std_logic;
    --memory inputs
    signal Menable, MByte:              std_logic;
    signal Mread, Mwrite:               std_logic;
    signal IRen:                        std_logic;
    signal safeDPCW:                    std_logic_vector(16 downto 0);
begin

    -- DO NOTHING CONTROL WORD --
    safeDPCW <= "01011001101111001";
    
    -- CHECK FOR LOAD AND STORE --
    is_load_store <= '0';
    
    ------- STATE REGISTER --------
    process(clk,reset)
    begin
        if(clk'event and clk='1') then
            CS <= NS;
        elsif(reset = '0') then
            CS <= Start;
        end if;
     end process;
     
     ------- NEXT STATE LOGIC -------
     process(CS, ready, reset, is_load_store)
     begin
        case CS is
            when Start =>
                if reset = '1' then
                    NS <= Fetch1;
                end if;
            when Fetch1 =>
                if ready = '0' then
                    NS <= Fetch2;
                else
                    NS <= Ex1;
                end if;
            when Fetch2 =>
                if ready = '0' then
                    NS <= Fetch2;
                else
                    NS <= Ex1;
                end if;
            when Ex1 =>
                if (is_load_store = '0') or (ready = '1') then
                    NS <= Fetch1;
                elsif (is_load_store = '1') and (ready = '0') then
                    NS <= Ex2;
                end if;
            when Ex2 =>
                if ready = '0' then
                    NS <= Ex2;
                else
                    NS <= Fetch1;
                end if;
         end case;
     end process;
     
     -------- MOORE OUTPUT LOGIC -------
     process(CS)
     begin
        case CS is
            when Fetch1 =>
            
                -- provide control words to load next instruction into IR
                -- using the PC to provide instruction address
                
                --put PC on D bus
                DIen   <= '1';
                CCRle  <= '1';
                PCDsel <= '1';
                PCle   <= '1';
                PCAsel  <= '0';
                IMMBsel <= '0';
                
                -- set to read from memory
                Mbyte   <= '0';
                Menable <= '0';
                Mread   <= '0';
                Mwrite  <= '1';
                
                -- latch onto MAR
                MARsel <= '0';
                MARle  <= '0';
                
                -- increment program counter
                PCie   <= '0';
                
                -- load onto IR (enable)
                IRen <= '0';
                
                -- build CW
                CWout <= '0' & DIen & PCAsel & PCle & PCie & PCDsel & IMMBsel & CCRle & MARle & MARsel & Menable & MByte & Mread & MWrite & "00" & IRen;
                
                
            when Fetch2 =>
                -- Stop loading D bus onto MAR, load MAR onto address
                MARsel <= '1';
                MARle  <= '1';
                
                -- set to read from memory
                Mbyte   <= '0';
                Menable <= '0';
                Mread   <= '0';
                Mwrite  <= '1';
                
                -- Load onto IR
                IRen <= '0';
                
                -- Set Control Word to safe default
                CWout <= safeDPCW(16 downto 9) & MARle & MARsel & Menable & MByte & MRead & MWrite & "00" & IRen;

            when Ex1 =>

                -- overwrite MAR and PC (don't increment)
                MARsel <= '0';
                MARle  <= '0';
                PCie   <= '1';
                
                -- Don't load onto IR
                IRen <= '1';
                
                -- Pass through ID control word
                CWout <= CWin(16 downto 13) & PCie & CWin(11 downto 9) & MARle & MARsel & CWin(6 downto 1) & IRen;
                
            when Ex2 =>
                
                -- overwrite MAR and PC (don't increment)             
                MARsel <= '1';
                MARle  <= '1';
                PCie   <= '1';
                
                -- Don't load onto IR
                IRen <= '1';
                
                -- Pass through ID control word
                CWout <= CWin(16 downto 13) & PCie & CWin(11 downto 9) & MARle & MARsel & CWin(6 downto 1) & IRen;
                
             when others => 
             ----Do nothing.
         end case;
     end process;
     
end multi_segment;
