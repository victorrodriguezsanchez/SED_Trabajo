library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tratamientoseniales is
    generic(inputsize: integer:=4);                                  -- valor generalizado de tamaño del vector de entradas
    Port (                                                      
        input   : in STD_LOGIC_VECTOR (inputsize-1 downto 0);        -- vector de pines de entrada
        output  : out STD_LOGIC_VECTOR (inputsize-1 downto 0);       -- vector de salidas tratadas
        clk     : in STD_LOGIC);                                     -- reloj que gobierna el módulo
end tratamientoseniales;

architecture Behavioral of tratamientoseniales is
----------------------------------------------------------------------- instanciación de los componentes necesarios para tratar la señal
    component sincronizador port(
            input: in std_logic;
            output: out std_logic;
            clk: in std_logic);
    end component;
    component detectorflancos port(
            input: in std_logic;
            output: out std_logic;
            clk: in std_logic);
    end component;
----------------------------------------------------------------------- variables del módulo
    signal sinc: std_logic_vector (inputsize-1 downto 0):="0000";
begin
----------------------------------------------------------------------- tratamiento de cada uno de las posiciones del vector de entrada
ins:for i in 0 to inputsize-1 generate
    begin
----------------------------------------------------------------------- sincronizar cada posicion del vector de entradas
        instanciasincronizador:
            sincronizador PORT MAP (
                input=>input(i),
                output=>sinc(i),
                clk=>clk);
----------------------------------------------------------------------- tratar la señal contra el ruido en cada posición del vector
        instanciaflancos:
            detectorflancos PORT MAP (
                input=>sinc(i),
                output=>output(i),
                clk=>clk);
    end generate;
end Behavioral;