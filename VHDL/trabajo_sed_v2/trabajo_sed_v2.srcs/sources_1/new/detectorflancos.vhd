library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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
