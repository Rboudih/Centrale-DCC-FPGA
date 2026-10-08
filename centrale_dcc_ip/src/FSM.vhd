----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.03.2026 10:37:16
-- Design Name: 
-- Module Name: FSM1 - Behavioral
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

entity FSM is
    port( clk,reset: in std_logic;
          Go, Fin0 ,Fin1: in std_logic;
          Fin, DCC, GO_cpt: out std_logic);
end FSM;

architecture Behavioral of FSM is
-- Definition d'un type etat
type etat is(S0,S1,S2,S3);
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
    process(EP,Go, Fin0 ,Fin1)
    begin
        EF  <= EP;   -- valeur par d?faut si aucune codition n'est vraie 
        case (EP) is
         when S0 => EF<=S0; if Go='1' then EF<=S1; end if;
         when S1 => EF<=S1; if Fin0='1' then EF<=S2; end if;
         when S2 => EF<=S2; if Fin1='1' then EF<=S3; end if;
         when S3 => EF<=s0;
         end case;
    end process;

    -- Combinatoire des sorties
    process(EP)
    begin
        case (EP) is
         when S0 => Fin<='0'; DCC<='0'; GO_cpt<='0';
         when S1 => Fin<='0'; DCC<='0'; GO_cpt<='1';
         when S2 => Fin<='0'; DCC<='1'; GO_cpt<='1';
         when S3 => Fin<='1'; DCC<='0'; GO_cpt<='0';
        end case;
    end process;

end Behavioral;
