----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.01.2022 13:09:24
-- Design Name: 
-- Module Name: decodificador - Behavioral
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

entity decodificador is
    Port ( codigo : in STD_LOGIC_VECTOR (4 downto 0);
           led_display : out STD_LOGIC_VECTOR (6 downto 0));
end decodificador;

architecture Behavioral of decodificador is

begin
    WITH codigo SELECT
        led_display <=  "0000001" WHEN "00000", --0
                        "1001111" WHEN "00001", --1
                        "0010010" WHEN "00010", --2
                        "0000110" WHEN "00011", --3
                        "1001100" WHEN "00100", --4
                        "0100100" WHEN "00101", --5
                        "0100000" WHEN "00110", --6
                        "0001111" WHEN "00111", --7
                        "0000000" WHEN "01000", --8
                        "0000100" WHEN "01001", --9
                        "0111000" WHEN "10000", --F
                        "0001000" WHEN "10001", --A
                        "1001111" WHEN "10010", --I
                        "0001110" WHEN "10011", --L
                        "1000001" WHEN "10100", --U
                        "0100100" WHEN "10101", --S
                        "0110000" WHEN "10110", --E
                        "0011000" WHEN "10111", --P
                        "1111111" WHEN "11111", --hueco vacío
                        "1111110" WHEN others;

end Behavioral;