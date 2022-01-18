----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity monedero is
    port(
    clk : in std_logic;
    reset : in std_logic;
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
            cnt <= "00000";
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

