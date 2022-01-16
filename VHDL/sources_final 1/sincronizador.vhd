library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--Este módulo se encarga de actualizar la salida solo cuando se generan pulsos positivos del reloj. 
entity sincronizador is
    Port ( 
        input   : in STD_LOGIC;            -- señal de entrada al módulo             
        output  : out STD_LOGIC;           -- señal de salida sincronizada
        clk     : in STD_LOGIC);           -- reloj que gobierna el módulo
end sincronizador;

architecture Behavioral of sincronizador is
begin
--------------------------------------------- proceso para sincronizar la salida al reloj
    process (clk)
    begin
        if rising_edge (clk) then          -- si se detecta flanco positivo del reloj se actualiza el valor de la salida
            output <= input;
        end if;
    end process;
end Behavioral;
