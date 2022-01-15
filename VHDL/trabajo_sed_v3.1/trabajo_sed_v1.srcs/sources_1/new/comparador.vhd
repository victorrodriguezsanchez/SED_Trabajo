----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.01.2022 11:19:26
-- Design Name: 
-- Module Name: FSM - Behavioral
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

entity comparador is
    Port ( count : in STD_LOGIC_VECTOR (7 downto 0);
           lower : out STD_LOGIC;
           greater : out STD_LOGIC;
           equal : out STD_LOGIC);
end comparador;

architecture Behavioral of comparador is

begin
    greater <='1' when count>"01100100" else '0';
    lower <='1' when count<"01100100" else '0'; 
    equal <='1' when count="01100100" else '0';

end Behavioral;



