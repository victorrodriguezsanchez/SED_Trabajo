library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tratamientoseniales is
    Port ( input : in STD_LOGIC_VECTOR (3 downto 0);
           output : out STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC);
end tratamientoseniales;

architecture Behavioral of tratamientoseniales is
    component sincronizador 
        port  (
            input: in std_logic;
            output: out std_logic;
            clk: in std_logic
            );
    end component;
    component detectorflancos
        port  (
            input: in std_logic;
            output: out std_logic;
            clk: in std_logic
            );
    end component;
    signal sinc: std_logic_vector (3 downto 0):="0000";
    
begin
instancia1sincronizador: sincronizador PORT MAP (input=>input(0),output=>sinc(0),clk=>clk);
instancia2sincronizador: sincronizador PORT MAP (input=>input(1),output=>sinc(1),clk=>clk);
instancia3sincronizador: sincronizador PORT MAP (input=>input(2),output=>sinc(2),clk=>clk);
instancia4sincronizador: sincronizador PORT MAP (input=>input(3),output=>sinc(3),clk=>clk);

instancia1flancos: detectorflancos PORT MAP (input=>sinc(0),output=>output(0),clk=>clk);
instancia2flancos: detectorflancos PORT MAP (input=>sinc(1),output=>output(1),clk=>clk);
instancia3flancos: detectorflancos PORT MAP (input=>sinc(2),output=>output(2),clk=>clk);
instancia4flancos: detectorflancos PORT MAP (input=>sinc(3),output=>output(3),clk=>clk);
end Behavioral;
