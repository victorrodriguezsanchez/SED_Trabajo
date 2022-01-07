----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.01.2022 12:58:01
-- Design Name: 
-- Module Name: sincronizador - Behavioral
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
