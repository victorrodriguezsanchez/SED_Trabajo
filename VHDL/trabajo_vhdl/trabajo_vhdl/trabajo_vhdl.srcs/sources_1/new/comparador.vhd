
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparador is
    Port ( count : in STD_LOGIC_VECTOR (7 downto 0);
           lower : out STD_LOGIC;
           greater : out STD_LOGIC;
           equal : out STD_LOGIC);
end comparador;

architecture Behavioral of comparador is

begin
greater<='1' when count>"01100100" else '0';
lower<='1' when count<"01100100" else '0'; 
equal<='1' when count="01100100" else '0';

end Behavioral;
