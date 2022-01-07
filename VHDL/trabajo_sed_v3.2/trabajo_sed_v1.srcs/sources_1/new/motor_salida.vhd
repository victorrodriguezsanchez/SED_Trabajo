----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.01.2022 11:54:04
-- Design Name: 
-- Module Name: motor_salida - Behavioral
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

entity motor_salida is
    Port ( 
            producto : in STD_LOGIC_VECTOR (3 downto 0);
            motor    : out STD_LOGIC_VECTOR (3 downto 0);
            done     : out std_logic 
          );
end motor_salida;

architecture Behavioral of motor_salida is
signal doit : std_logic  := '0';
constant timer : time := 2 sec;


begin
       process 
       begin
                case producto is
                    
                    when "0001" => motor(0) <= '1';
                                   wait for timer;
                                   doit <= '1';
                    when "0010" => motor(1) <= '1';
                                   wait for timer;
                                   doit <= '1';
                    when "0100" => motor(2) <= '1';
                                   wait for timer;
                                   doit <= '1';
                    when "1000" => motor(3) <= '1';
                                   wait for timer;
                                   doit <= '1';
                    when others => motor <= "0000";
                                   wait for timer;
                end case;
                
         end process;
       done <= doit;
end Behavioral;
