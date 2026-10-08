----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.03.2026 10:41:56
-- Design Name: 
-- Module Name: TB_Reg - Behavioral
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

entity TB_Reg is
--  Port ( );
end TB_Reg;

architecture Behavioral of TB_Reg is
Signal Clk: std_logic :='0' ;
signal Reset: std_logic;
signal Com : std_logic_vector (1 downto 0);
Signal trame_dcc, Trame_trans : std_logic_vector (50 downto 0);
begin

    Reg: entity work.Reg_DCC
        port map(Clk,Reset,Com,trame_dcc,Trame_trans);

clk <= not clk after 5 ns;
Reset <= '1', '0' after 2 ns;
trame_dcc <= "11111111111111111111111" & "0" & "00000011" & "0" & "01101010" & "0" & "01101001" & "1";
com <= "00", "10" after 10ns , "11" after 30 ns, "01" after 60ns, "11" after 90 ns;
end Behavioral;
