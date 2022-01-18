library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sincronizador is
    Port ( input : in STD_LOGIC;
           output : out STD_LOGIC;
           clk : in STD_LOGIC);
end sincronizador;

architecture Behavioral of sincronizador is
    signal aux: std_logic_vector (1 downto 0);
begin
    process (clk)
    begin
        if rising_edge (clk) then
            output <= aux(1);
            aux<= aux(0)&input;
        end if;
    end process;
end Behavioral;
