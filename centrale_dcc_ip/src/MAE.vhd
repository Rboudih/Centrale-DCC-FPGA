----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.03.2026 11:39:53
-- Design Name: 
-- Module Name: MAE - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MAE is
    Port (clk, reset: in std_logic;
          Trame_DCC : in std_logic_vector (50 downto 0);
          Fin_Tempo, FIN_1, FIN_0: in std_logic;
          Start_Temp, GO_1, GO_0: out std_logic;
          COM : out std_logic_vector (1 downto 0) );
end MAE;

architecture Behavioral of MAE is
-- Definition d'un type etat
type etat is(S0,S1,S2,S3,S4,S5,S6,S7,S8);
signal EP, EF: etat;
begin
    -- Process du Registre d'etats
    process(clk,reset)
    begin
        if reset='1' then EP <= S0; 
        elsif rising_edge(clk) then EP <= EF;
        end if;
    end process;
    
    -- Combinatoire des etats
    process(EP, Fin_Tempo, FIN_1, FIN_0, Trame_DCC)
    begin
        EF  <= EP;   -- valeur par d?faut si aucune codition n'est vraie 
        case (EP) is
         when S0 => EF<=S1;
         when S1 => if Trame_DCC = (50 downto 0 => '0') then EF<=S7;
                    elsif Trame_DCC(50)='0' then EF<=S4; 
                    else EF<=S2;
                    end if;
         when S2 => EF<=S3;
         when S3 => EF<=S3; if FIN_1='1' then EF<=S6; end if;
         when S4 => EF<=S5; 
         when S5 => EF<=S5; if FIN_0 ='1' then EF<=S6; end if;
         when S6 => EF<=S1;
         when S7 => EF<=S8; 
         when S8 => EF<=S8; if Fin_Tempo ='1' then EF<=S0; end if;
         end case;
    end process;

        -- Combinatoire des sorties
    process(EP)
    begin
        case (EP) is
         when S0 => Start_Temp <= '0'; GO_1 <='0'; GO_0 <= '0'; COM <="10";  --chargement 
         when S1 => Start_Temp <= '0'; GO_1 <='0'; GO_0 <= '0'; COM <="00";   -- Test
         when S2 => Start_Temp <= '0'; GO_1 <='1'; GO_0 <= '0'; COM <="00";   --Enoie de 1
         when S3 => Start_Temp <= '0'; GO_1 <='0'; GO_0 <= '0'; COM <="00";   --ATT FIN 1
         when S4 => Start_Temp <= '0'; GO_1 <='0'; GO_0 <= '1'; COM <="00";   --Envoie de 0 
         when S5 => Start_Temp <= '0'; GO_1 <='0'; GO_0 <= '0'; COM <="00";   --ATT FIN0
         when S6 => Start_Temp <= '0'; GO_1 <='0'; GO_0 <= '0'; COM <="11";   --SHIFT
         when S7 => Start_Temp <= '1'; GO_1 <='0'; GO_0 <= '0'; COM <="00";   --TEMPO
         when S8 => Start_Temp <= '0'; GO_1 <='0'; GO_0 <= '0'; COM <="00";   --ATT FIN Tempo
        end case;
    end process;

end Behavioral;
