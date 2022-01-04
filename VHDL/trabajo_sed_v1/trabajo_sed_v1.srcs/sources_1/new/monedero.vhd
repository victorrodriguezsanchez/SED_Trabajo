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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity monedero is
    port(
        clk : in std_logic;
        reset : in std_logic;
        enable : in std_logic;
        cent100 : in std_logic;
        cent50 : in std_logic;
        cent20 : in std_logic;
        cent10 : in std_logic;
        count: out std_logic_vector(7 downto 0)
    );
end monedero;


architecture Behavioral of monedero is
signal cnt : std_logic_vector(7 downto 0) := "00000000";
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
