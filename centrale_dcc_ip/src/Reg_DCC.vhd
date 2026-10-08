----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.03.2026 10:16:53
-- Design Name: 
-- Module Name: Reg_DCC - Behavioral
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

entity Reg_DCC is

    Port (clk, reset: in std_logic;
          COM: in std_logic_vector( 1 downto 0 );
          Trame_DCC: in std_logic_vector(50 downto 0);
          Trame_trans: out std_logic_vector(50 downto 0)
           );
end Reg_DCC;

architecture Behavioral of Reg_DCC is
signal Reg: std_logic_vector (50 downto 0);
begin
    process(clk, reset)
    begin
        if reset='1' then Reg <= ( others => '0');
        elsif rising_edge(clk) then
            case (COM) is
                when "00" | "01" => null;
                when "10" => Reg <= Trame_DCC; -- chargement
                when "11" => Reg <= Reg(49 downto 0) &'0'; -- décalage
                when others => NULL;
            end case;    
        end if;
    end process;
    
   Trame_trans <= Reg;
    
end Behavioral;