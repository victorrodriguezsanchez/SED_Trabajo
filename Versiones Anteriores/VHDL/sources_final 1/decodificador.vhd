library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--Este módulo se encarga de codificar los caracteres que se le pasan a un vector que indica los led de los displays que se deben encender
--para poder mostrar el carácter en el mismo.
--Como los displays de la placa nexys están pensados para mostrar números, la codificación de los caracteres está limitada a algunas letras.
entity decodificador is
    Port ( 
        caracter : character;                            -- carácter que se va a decodificar
        led_display : out STD_LOGIC_VECTOR (6 downto 0));-- salida con el código para el display
end decodificador;

architecture Behavioral of decodificador is
begin
----------------------------------------------------------- transforma la letra que se ha seleccionado en su equivalente a los pines de los displays
    WITH caracter SELECT
        led_display <=  "0000001" WHEN '0', -- 0
                        "1001111" WHEN '1', -- 1
                        "0010010" WHEN '2', -- 2
                        "0000110" WHEN '3', -- 3
                        "1001100" WHEN '4', -- 4
                        "0100100" WHEN '5', -- 5
                        "0100000" WHEN '6', -- 6
                        "0001111" WHEN '7', -- 7
                        "0000000" WHEN '8', -- 8
                        "0000100" WHEN '9', -- 9
                        "0111000" WHEN 'F'|'f', -- F
                        "0001000" WHEN 'A'|'a', -- A
                        "1001111" WHEN 'I'|'i', -- I
                        "1110001" WHEN 'L'|'l', -- L
                        "1000001" WHEN 'U'|'u', -- U
                        "0100100" WHEN 'S'|'s', -- S
                        "0110000" WHEN 'E'|'e', -- E
                        "0011000" WHEN 'P'|'p', -- P
                        "1111111" WHEN ' ', -- hueco vacío
                        "1111110" WHEN others;  -- guiones si no se manda un dígito correcto
end Behavioral;