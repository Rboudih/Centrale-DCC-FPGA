----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.03.2026 10:57:42
-- Design Name: 
-- Module Name: compteur_0 - Behavioral
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

entity compteur_0 is
    Port (
        clk_1M  : in  std_logic;
        reset   : in  std_logic;
        GO_cpt  : in  std_logic;
        Fin0    : out std_logic;
        Fin1    : out std_logic 
        );        
end compteur_0;

architecture Behavioral of compteur_0 is
signal Cpt   : integer range 0 to 199 := 0;
signal Fin0_i, Fin1_i : std_logic := '0';
begin
    process(clk_1M, reset)
    begin
        if reset = '1' then
            Cpt    <= 0;
            Fin0_i <= '0';
            Fin1_i <= '0';

        elsif rising_edge(clk_1M) then
            -- Par défaut, les sorties sont à 0
            Fin0_i <= '0';
            Fin1_i <= '0';

            -- Comptage si démarré
            if GO_cpt= '1' then
                if Cpt = 99 then
                    Fin0_i <= '1';
                    Cpt <= Cpt + 1;

                elsif Cpt = 199 then
                    Fin1_i <= '1';
                    Cpt <= 0;

                else
                    Cpt <= Cpt + 1;
                end if;
            else
                Cpt <= 0;
            end if;
        end if;
    end process;

    Fin0 <= Fin0_i;
    Fin1 <= Fin1_i;

end Behavioral;
