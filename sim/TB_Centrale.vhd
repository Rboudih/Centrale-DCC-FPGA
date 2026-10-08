----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.03.2026 11:31:50
-- Design Name: 
-- Module Name: TB_Centrale - Behavioral
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

entity TB_Centrale is
--  Port ( );
end TB_Centrale;

architecture Behavioral of TB_Centrale is
signal clk, reset : std_logic :='0';
signal Trame_DCC :std_logic_vector (50 downto 0);
signal SORTIE_DCC : std_logic;
begin

    Centrale: entity work.Centrale_DCC
                port map ( clk,reset,Trame_DCC,SORTIE_DCC);
            
clk <= not clk after 5 ns;
Reset <= '1', '0' after 2 ns;
Trame_DCC <= "11111111111111111111111" & "0" & "00000011" & "0" & "01101010" & "0" & "01101001" & "1",
             "11111111111111" & "0" & "00000010" & "0" & "11011110" & "0" & "00000010" & "0" & "11011110" & "1" after 20 ms;
end Behavioral;
