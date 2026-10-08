----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.03.2026 11:06:02
-- Design Name: 
-- Module Name: Centrale_DCC - Behavioral
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

entity Centrale_DCC is
    Port ( clk, reset : in std_logic;
           Trame_DCC : in std_logic_vector (50 downto 0);
           SORTIE_DCC : out std_logic
           );
end Centrale_DCC;

architecture Behavioral of Centrale_DCC is
signal clk_1M : std_logic;
signal nreset : std_logic;
signal Fin_Tempo, FIN_1,FIN_0: std_logic;
signal Start_Temp, GO_1, GO_0: std_logic;
signal Trame_trans : std_logic_vector(50 downto 0);
signal DCC_1, DCC_0 : std_logic;
signal COM : std_logic_vector (1 downto 0) ;
begin
    nreset <= not(reset);
    clk1M: entity work.CLK_DIV
               port map(nreset, clk,clk_1M);
           
    Reg: entity work.Reg_DCC
            port map(clk,nreset,COM,Trame_DCC,Trame_trans); 
                      
    MAE: entity work.MAE
               port map(clk,nreset,Trame_trans,Fin_Tempo, FIN_1,
                        FIN_0,Start_Temp, GO_1, GO_0,COM);
             
    TEMPO: entity work.COMPTEUR_TEMPO
                port map(clk,nreset,clk_1M,Start_Temp,Fin_Tempo);

    
    
    
    BIT1: entity work.DCC_BIT_1 
            port map(clk,nreset,GO_1,FIN_1,DCC_1);
    
    BIT0: entity work.DCC_BIT_0 
            port map(clk,nreset,GO_0,FIN_0,DCC_0);
        
    SORTIE_DCC <= DCC_1 or DCC_0;        

end Behavioral;
