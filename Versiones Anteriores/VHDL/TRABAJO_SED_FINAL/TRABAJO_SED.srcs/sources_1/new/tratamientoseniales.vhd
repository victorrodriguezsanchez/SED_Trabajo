library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--Este módulo se encarga de acondicionar un bus de entradas.
--En caso de que se produzca ruido, este se filtrará pero debido a la codificación del módulo detector de flancos, si hay ruido cuando
--la señal es positiva y al finalizar el ruido sigue positiva(1->ruido->1), contará como una nueva pulsación.
entity tratamientoseniales is
    generic(
        inputsize: integer:=1;                                       -- numero de entradas en el vector de entradas
        sensibilidad: integer:=3);                                   -- cuantos '1' seguidos tienen que ocurrir despues de un 0 para que se considere la señal estable
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
    component detectorflancos 
    generic(sensibilidad: integer);
    port(
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
        instanciasincronizador:---------------------------------------- sincronizar cada posicion del vector de entradas
            sincronizador PORT MAP (
                input=>input(i),
                output=>sinc(i),
                clk=>clk);
        instanciaflancos:---------------------------------------------- tratar la señal contra el ruido en cada posición del vector
            detectorflancos 
            generic map (sensibilidad=>sensibilidad)
            PORT MAP (
                input=>sinc(i),
                output=>output(i),
                clk=>clk);
    end generate;
end Behavioral;