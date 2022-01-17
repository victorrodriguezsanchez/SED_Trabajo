----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.01.2022 11:20:47
-- Design Name: 
-- Module Name: monedero - Behavioral
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

--Este bloque es un contador síncrono que aumenta en función de la moneda introducida
entity monedero is
    port(
        clk : in std_logic; --entrada de reloj
        reset : in std_logic; --entrada de RESET
        cent100 : in std_logic; --entrada moneda de 1 euro
        cent50 : in std_logic; --entrada moneda 50 céntimos
        cent20 : in std_logic; --entrada moneda 20 céntimos
        cent10 : in std_logic; --entrada moneda 10 céntimos
        count: out std_logic_vector(7 downto 0) --salida valor de la cuenta
    );
end monedero;
------------------------------------------------------------------------------------------------------------------------------------------------------------------

architecture Behavioral of monedero is
signal cnt : std_logic_vector(7 downto 0) := "00000000"; --se inicia el valor de la ceunta a cero
begin
    process (clk, reset)
    begin
        if (reset = '0') then 
            cnt <= "00000000";
        elsif rising_edge(clk) then
            if (cent100 = '1') then
                cnt <= cnt + "01100100"; 
            end if;
            if (cent50 = '1') then
                cnt <= cnt + "00110010"; 
            end if;
            if (cent20 = '1') then
                cnt <= cnt + "00010100";
            end if;
            if (cent10 = '1') then
                cnt <= cnt + "00001010"; 
            end if;
        end if;
    end process;
    count <= cnt;
end Behavioral;
