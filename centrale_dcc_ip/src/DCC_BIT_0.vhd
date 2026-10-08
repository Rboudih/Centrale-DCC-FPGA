----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.03.2026 10:54:30
-- Design Name: 
-- Module Name: DCC_BIT_0 - Behavioral
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

entity DCC_BIT_0 is
    Port ( clk, reset, GO_0 	: in STD_LOGIC;
           FIN_0, DCC_0: out std_logic);
end DCC_BIT_0;

architecture Behavioral of DCC_BIT_0 is
Signal GO_cpt,Fin0,Fin1 : std_logic;
Signal clk_1M : std_logic;
begin
div_clk: entity work.CLK_DIV
    port map (reset,clk,clk_1M);
Cpt: entity work.compteur_0
    port map (clk_1M,reset,GO_cpt,Fin0 ,Fin1);
FSM: entity work.FSM
    port map (clk,reset,GO_0,Fin0 ,Fin1,FIN_0,DCC_0,GO_cpt);

end Behavioral;
