library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity TB_BIT1 is
--  Port ( );
end TB_BIT1;

architecture Behavioral of TB_BIT1 is
Signal clk ,reset,GO_1,DCC_1 : std_logic :='0';
Signal Fin_1: std_logic :='0';

procedure Check_DCC( signal DCC_1 : in std_logic;
                     exp_DCC_1 : in std_logic;
                     constant message_erreur : in string) is
   begin
      assert DCC_1 = exp_DCC_1 
      report message_erreur
      severity error;
end procedure;

procedure Pulse_GO(signal GO_1 : out std_logic) is
   begin
      GO_1 <= '1','0' after 20ns ;
end procedure;

begin

UUT: entity work.DCC_BIT_1
    port map (clk,reset,GO_1,Fin_1,DCC_1);
   
clk <= not clk after 5 ns;
Reset <= '1', '0' after 15 ns;
    
    process 
    begin 
        wait for 30 ns;
        -- verification etat initial
        Check_DCC(DCC_1, '0', "Erreur : DCC_1 doit etre a 0 initialement");
        Check_DCC(FIN_1, '0', "Erreur : FIN_1 doit etre a 0 initialement");
        -- lancement d'un bit 1
        Pulse_GO(GO_1);

        -- verification de fin_1
        wait until FIN_1 = '1' for 130 us;
        Check_DCC(FIN_1, '1', "Erreur : FIN_1 doit etre a 1 en fin de bit");
        Check_DCC(DCC_1, '0', "Erreur : DCC_1 doit etre a 0 en fin de bit");
        
        --
        wait for 50 ns;
        -- Deuxieme essai
        Pulse_GO(GO_1);
        --
        wait until FIN_1 = '1' for 130 us;
        Check_DCC(FIN_1, '1', "Erreur : FIN_1 doit etre a 1 en fin de bit");
        Check_DCC(DCC_1, '0', "Erreur : DCC_1 doit etre a 0 en fin de bit");
        wait;
    end process; 

end Behavioral;
