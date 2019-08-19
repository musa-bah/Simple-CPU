----------------------------------------------------------------------------------
--Engineer: Musa Bah
--Instruction decoder.
----------------------------------------------------------------------------------


library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Instruction_Decoder is
--These inputs and outputs will have to be modified to match the ones on the schematic.
port(Instruction:                 in std_logic_vector(15 downto 0);
     Flags:                       in std_logic_vector(3  downto 0);
     ALUfunc:                    out std_logic_vector(3  downto 0);
     Asel, Bsel, Dsel :          out std_logic_vector(2  downto 0);
     IT :                        out std_logic_vector(3  downto 0);
     CW :                        out std_logic_vector(16 downto 0);
     IMM :                       out std_logic_vector(15 downto 0));
 end Instruction_Decoder;

architecture struc of Instruction_Decoder is
signal DIsel, DIen:                 std_logic;
signal PCAsel, PCle, PCie, PCDsel:  std_logic;
signal IMMBsel:                     std_logic;
signal CCRle, MEMRe:                std_logic;
signal MARle, MARsel, MEMen:        std_logic;
signal MemByte, MEMWr, CLKEN:       std_logic;
signal IT_Type_One:                 std_logic_vector(2 downto 0);
signal IT_Type_Two:                 std_logic_vector(1 downto 0);
signal IT_Type_Three:               std_logic_vector(3 downto 0);
signal op, res:                     std_logic_vector(1 downto 0);
signal om, MT_One_Bit, sz:          std_logic;
signal rd, rb, ra, rs:              std_logic_vector(2 downto 0);
signal ImmU8:                       std_logic_vector(7 downto 0);
signal Imm5:                        std_logic_vector(4 downto 0);
signal MT_Three_Bit:                std_logic_vector(2 downto 0);
signal Immhi:                       std_logic_vector(1 downto 0);
signal Immlo:                       std_logic_vector(4 downto 0);
signal Uoffset:                     std_logic_vector(7 downto 0);
signal Offset:                      std_logic_vector(6 downto 0);
signal cond, res2:                  std_logic_vector(3 downto 0);
signal BTUOut, op_br:               std_logic;

begin

    --create Control word
    CW <= DIsel & DIen & PCASel & PCle & PCie & PCDsel & IMMBsel & CCRle & MARle & MARsel & MEMen & MemByte & MEMRe & MEMWr & "000";
    --There are three type of instruction types. Three bits, two bits and four bits ITs.
    --They are stored here to enable to decoder decide how to decode based on the muxes below (ifs).

    IT_Type_One   <= Instruction(15 downto 13);
    IT_Type_Two   <= Instruction(15 downto 14);
    IT_Type_Three <= Instruction(15 downto 12);
    MT_One_Bit    <= Instruction(10);
    MT_Three_Bit  <= Instruction(10 downto 8);
    
   process(Instruction)
   
  -------------------------------------------
  --               3 Bit IT                --
  -------------------------------------------
    begin 
     if (IT_Type_One = "100") then
            
            IT <= "0100";
            ----- RR instruction -----
            if (MT_One_Bit = '1') then
                op   <= Instruction(12 downto 11);
                om   <= Instruction(8);
                res  <= "00";
                rb   <= Instruction(5 downto 3);
                rd   <= Instruction(2 downto 0); 
                
                -- Datapath signals
                ALUFunc <= ('1' & op & om);
                Bsel    <= rb;
                Dsel    <= rd;
                DISel   <= '0';
                DIen    <= '0';
                PCAsel  <= '0';
                PCle    <= '1';
                PCie    <= '0';
                PCDsel  <= '0';
                IMMBsel <= '0';
                CCRle   <= '0';
                MARle   <= '1';
                MARsel  <= '0';
                MEMen   <= '1';
                    
            ---- RRR instruction -----
            elsif (MT_One_Bit = '0') then
                op <= Instruction(12 downto 11);
                om <= Instruction(9);
                rb <= Instruction(8 downto 6);
                ra <= Instruction(5 downto 3);
                rd <= Instruction(2 downto 0);
                
               --Datapath signals
                ALUFunc <= (om & op & om);
                Asel    <= ra;
                Bsel    <= rb;
                Dsel    <= rd;
                DISel   <= '0';
                DIen    <= '0';
                PCAsel  <= '0';
                PCle    <= '1';
                PCie    <= '0';
                PCDsel  <= '0';
                IMMBsel <= '0';
                CCRle   <= '0';
                MARle   <= '1';
                MARSel  <= '0';
                MEMen   <= '1';
             
             ----- CMPR instruction -----         
             elsif (MT_Three_Bit = "110") then
                res <= "00";
                rb  <= Instruction(5 downto 3);
                ra  <= Instruction(2 downto 0);
                
               --Datapath signals
               ALUFunc <= "0100";
               Asel    <= ra;
               Bsel    <= rb;
               DIen    <= '1';
               PCAsel  <= '0';
               PCle    <= '1';
               PCie    <= '0';
               PCDsel  <= '0';
               IMMBsel <= '0';
               CCRle   <= '0';
               MARle   <= '1';
               MARsel  <= '0';
               MEMen   <= '1';
               
            ----- CMPI instruction -----
            elsif (MT_Three_Bit = "111") then
                Immhi <= Instruction(12 downto 11);
                Immlo <= Instruction(7 downto 3);
                ra    <= Instruction(2 downto 0); 
                
                --Datapath signals
                ALUFunc <= "0100";
                Asel    <= ra;
                IMM     <= ("000000000" & Immhi & Immlo);
                DIen    <= '1';
                PCAsel  <= '0';
                PCle    <= '1';
                PCie    <= '0';
                PCDsel  <= '0';
                IMMBsel <= '0';
                CCRle   <= '0';
                MARle   <= '1';
                MARsel  <= '0';
                MEMen   <= '1';
                
           end if;
     
     ----- RI instruction -----
     elsif(IT_Type_One = "110") then
               IT <= "0110";
               op    <= Instruction(12 downto 11);
               ImmU8 <= Instruction(10 downto 3);
               rd    <=  Instruction(2 downto 0);
               
               --Datapath signals 
               Dsel    <= rd;
               if (op = "00") then
                    ALUFunc <= "0001";
               else 
                    ALUFunc <= ('1' & op & '1'); 
               end if;
               IMM   <= ("00000000" & ImmU8); --unsigned immediate value
               DIsel   <= '0';
               DIen    <= '0';
               PCASel  <= '0';
               PCle    <= '1';
               PCie    <= '0';
               PCDsel  <= '0';
               IMMBsel <= '1';
               CCRle   <= '0';
               MARle   <= '1';
               MARsel  <= '0';
               MEMen   <= '1';
  
     ----- RRI instruction -----
     elsif(IT_Type_One = "101") then
               IT <= "0101";
               op   <= Instruction(12 downto 11);
               Imm5 <= Instruction(10 downto 6);
               ra   <= Instruction(5 downto 3);
               rd   <= Instruction(2 downto 0);
               
               --Datapath signals
               if (op = "00") then 
                    ALUFunc <= ('0' & op & '0');
                    if(IMM5(4) = '0') then             --IMM is sign extended for add
                        IMM <= ("00000000000" & Imm5);
                    else
                        IMM <= ("11111111111" & Imm5);
                    end if;
               else
                    AluFunc <= ('1' & op & '0');               
                    IMM     <= ("00000000000" & Imm5); --IMM is unsigned for shifts
               end if;
               Asel    <= ra;
               Dsel    <= rd;
               DIsel   <= '0';
               DIen    <= '0';
               PCAsel  <= '0';
               PCle    <= '1';
               PCie    <= '0';
               PCDsel  <= '0';
               IMMBsel <= '1';
               CCRle   <= '0';
               MARle   <= '1';
               MARSel  <= '0';
               MEMen   <= '1';
                
      -------------------------------------------
      --               2 Bit IT                --
      -------------------------------------------
      ----- PCRL instruction -----
      elsif (IT_Type_Two = "00") then
            if (MT_Three_Bit = "111") then
                Uoffset      <= Instruction(13 downto 6);
                rd           <= Instruction(2 downto 0);
                
                --Datapath signals
                Dsel    <= rd;
                
                --Shift offset left 1 bit
                IMM <= "0000000" & Uoffset & '0';
                ALUFunc <= "0000";
                DIsel   <= '0';
                DIen    <= '0';
                PCAsel  <= '1';
                PCle    <= '1';
                PCie    <= '1';
                PCDsel  <= '0';
                IMMBsel <= '1';
                CCRle   <= '0';
                MARle   <= '1';
                MARSel  <= '0';
                MEMen   <= '1';
                
        ----- LOAD instruction -----
        else
            IT <= "0000";
            Offset <= Instruction(13 downto 7);
            sz     <= Instruction(6);
            ra     <= Instruction(5 downto 3);
            rd     <= Instruction(2 downto 0);
            
            --Datapath signals
            Asel    <= ra;
            Dsel    <= rd; -- TODO Need to clarify the return addresss.
            
            --Sign extend offset
            if( Offset(6) = '0') then
                IMM     <= ("000000000" & Offset);
            else
                IMM     <= ("111111111" & Offset);
            end if;
            ALUfunc <= "0000";
            PCAsel  <= '1';
            PCle    <= '1';
            PCie    <= '1';
            PCDsel  <= '0';
            IMMBsel <= '1';
            CCRle   <= '0';
            MARle   <= '0';
            MARsel  <= '0';
            MEMen   <= '1'; 
            if (sz = '1') then 
                MemByte <= '0';
            elsif (sz = '0') then 
                MemByte <= '1';
            end if;
            Memen   <= '0';
            MEMRe   <= '0';
            MEMWr   <= '1';
   
       end if;
   
       ---- STORE instruction -----      
       elsif (IT_Type_Two = "01") then
            IT <= "0001";
            Offset <= Instruction(13 downto 7);
            sz     <= Instruction(6);
            ra     <= Instruction(5 downto 3);
            rs     <= Instruction(2 downto 0);
            
            --Datapath signals
            Asel    <= ra;
            
            --Sign extend offset
            if(Offset(6) = '0') then
                IMM     <= ("000000000" & Offset);
            else
                IMM     <= ("111111111" & Offset);
            end if;
            
            ALUFunc <= "0000";
            PCAsel  <= '0';
            PCle    <= '1';
            PCie    <= '1';
            PCDsel  <= '0';
            IMMBsel <= '1';
            CCRle   <= '0';
            MARle   <= '0';
            MARsel  <= '0';
            MEMen   <= '1';
            if (sz = '1') then 
                MemByte <= '0';
            elsif (sz = '0') then 
                MemByte <= '1';
            end if;
            Memen   <= '0';
            MEMRe   <= '0';
            MEMWr   <= '1';
                
       -------------------------------------------
       --               4 Bit IT                --
       ------------------------------------------- 
       ----- BR instruction -----   
       elsif (IT_Type_Three = "1110") then
            IT <= "1110";
            op_br   <= Instruction(11);
            cond <= Instruction(10 downto 7);
            res2 <= Instruction(6 downto 3);
            ra   <= Instruction(2 downto 0);
            
            --Datapath signals
            Asel    <= ra;
            Dsel    <= "111";
            ALUFunc <= "0000";
            IMM     <= "0000000000000000"; --This one is okay!
            DIsel   <= '0';
            DIen    <= (Instruction(11) or not(BTUout));
            PCAsel  <= '0';
            PCle    <= (not BTUOut);
            PCIe   <= '1';
            PCDsel  <= '1';
            IMMBsel <= '1';
            CCRle   <= '1';
            MARle   <= '1';
            MARsel  <= '0';
            MEMen   <= '1';
           
       ----- BPCR instruction -----
       elsif (IT_Type_Three = "1111") then
            IT <= "1111";
            op_br       <= Instruction(11);
            cond     <= Instruction(10 downto 7);
            offset   <= Instruction (6 downto 0);
            
            --Datapath signals
            Dsel    <= "111";
            
            --Sign extend  IMM and shift left by 1 bit
            if(offset(6) = '0') then
                IMM <= "00000000" & offset & '0';
            else
                IMM <= "11111111" & offset & '0';
            end if;
            
            ALUfunc <= "0000";
            DIsel   <= '0';
            DIen    <= (Instruction(11) or not(BTUout));
            PCAsel  <= '1';
            PCle    <= (not BTUOut);
            PCie    <= '1';
            PCDsel  <= '1';
            IMMBsel <= '1';
            CCRle   <= '0';
            MARle   <= '1';
            MARsel  <= '0';
            MEMen   <= '1';
            
    ----- ILLEGAL Instruction ------
    else 
    --clk <= '0'; --Not sure what he means by 'Disable CPU CLK"
        end if;   
end process; 
     
     BTU: entity work.BTU(Behavioral)
        port map(encoding => cond,
                 CCR      => Flags,
                 Result   => BTUOut); 
                 
end struc;
