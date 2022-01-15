----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.01.2022 12:58:01
-- Design Name: 
-- Module Name: detectorflancos - Behavioral
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

entity detectorflancos is
    Port ( input : in STD_LOGIC;
           output : out STD_LOGIC;
           clk : in STD_LOGIC);
end detectorflancos;

architecture Behavioral of detectorflancos is
 signal aux: std_logic_vector (3 downto 0);
begin
    process (clk)
    begin
        if rising_edge (clk) then
            aux<=aux(2 downto 0) & input;
        end if;
    end process;
    with aux select
        output <= '1' when "1000",
                '0' when others;
end Behavioral;
