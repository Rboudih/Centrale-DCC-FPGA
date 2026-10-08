library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity compteur_1 is
    port(
        clk_1M  : in  std_logic;
        reset   : in  std_logic;
        GO_cpt  : in  std_logic;
        Fin0    : out std_logic;
        Fin1    : out std_logic
    );
end compteur_1;

architecture Behavioral of compteur_1 is
signal Cpt   : integer range 0 to 115 := 0;
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
                if Cpt = 57 then
                    Fin0_i <= '1';
                    Cpt <= Cpt + 1;

                elsif Cpt = 115 then
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