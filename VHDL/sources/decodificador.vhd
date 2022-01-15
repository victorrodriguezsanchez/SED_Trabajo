library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decodificador is
    Port ( 
        codigo : in STD_LOGIC_VECTOR (4 downto 0);       -- código de un símbolo que se va a decodificar
        led_display : out STD_LOGIC_VECTOR (6 downto 0));-- salida con el código para el display
end decodificador;

architecture Behavioral of decodificador is
begin
----------------------------------------------------------- transforma el código de la letra que se ha seleccionado en la variable "codigo" en su conversión a los pines de los displays
    WITH codigo SELECT
        led_display <=  "0000001" WHEN "00000", -- 0
                        "1001111" WHEN "00001", -- 1
                        "0010010" WHEN "00010", -- 2
                        "0000110" WHEN "00011", -- 3
                        "1001100" WHEN "00100", -- 4
                        "0100100" WHEN "00101", -- 5
                        "0100000" WHEN "00110", -- 6
                        "0001111" WHEN "00111", -- 7
                        "0000000" WHEN "01000", -- 8
                        "0000100" WHEN "01001", -- 9
                        "0111000" WHEN "10000", -- F
                        "0001000" WHEN "10001", -- A
                        "1001111" WHEN "10010", -- I
                        "1110001" WHEN "10011", -- L
                        "1000001" WHEN "10100", -- U
                        "0100100" WHEN "10101", -- S
                        "0110000" WHEN "10110", -- E
                        "0011000" WHEN "10111", -- P
                        "1111111" WHEN "11111", -- hueco vacío
                        "1111110" WHEN others;  -- guiones si no se manda un dígito correcto
end Behavioral;