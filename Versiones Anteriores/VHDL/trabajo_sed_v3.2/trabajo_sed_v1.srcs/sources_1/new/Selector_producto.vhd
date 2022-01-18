----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.01.2022 11:27:40
-- Design Name: 
-- Module Name: Selector_producto - Behavioral
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

entity Selector_producto is
    Port ( 
        productos : in STD_LOGIC_VECTOR (3 downto 0);
        producto  : out STD_LOGIC_VECTOR (3 downto 0);
        done      : out std_logic  
    );
end Selector_producto;

architecture Behavioral of Selector_producto is
signal doit : std_logic  := '0';

begin
       process(productos) 
       begin
                case productos is
                    
                    when "0001" => producto(0) <= '1';
                                   doit <= '1';
                    when "0010" => producto(1) <= '1';
                                   doit <= '1';
                    when "0100" => producto(2) <= '1';
                                   doit <= '1';
                    when "1000" => producto(3) <= '1';
                                   doit <= '1';
                    when others => producto <= "0000";
                                   
                end case;
                
        end process;
    done <= doit;
end Behavioral;
