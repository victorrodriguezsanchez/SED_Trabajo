library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
--Este m�dulo hace el testbench del m�dulo display
--Para el estado 00: prueba los 4 casos que puede tener el producto
--Para el estado 01: prueba la cantidad de valores que se le establezca en la constante "rango_monedero" (por defecto 150)
--Para el estado 10: escribe el mensaje durante un ciclo de escritura
--Para el estado 11: escribe el mensaje durante un ciclo de escritura
entity display_tb is
end display_tb;

architecture Behavioral of display_tb is
---------------------------------------------------------------------- declaraci�n del componente que se va a testear
    component display port(
        estado :     in STD_LOGIC_VECTOR (1 downto 0);                           
        monedero :   in STD_LOGIC_VECTOR (7 downto 0);
        producto :   in STD_LOGIC_VECTOR (3 downto 0);
        clk :        in STD_LOGIC;
        posicion_led:out STD_LOGIC_VECTOR (7 downto 0);               
        codigo_led:  out STD_LOGIC_VECTOR(6 downto 0));
    end component;
---------------------------------------------------------------------- entradas al m�dulo display
    signal estado: std_logic_vector(1 downto 0):="00";
    signal monedero: std_logic_vector(7 downto 0):="00000000";
    signal producto: std_logic_vector(3 downto 0):="0001";
    signal clk: std_logic:='0';
---------------------------------------------------------------------- salidas del m�dulo display
    signal posicion_led:std_logic_vector(7 downto 0);
    signal codigo_led:std_logic_vector(6 downto 0);
    signal done:std_logic;
---------------------------------------------------------------------- constantes del programa
    constant rango_monedero: integer := 150;                        -- indica hasta que valor se hace la cuenta del monedero en el estado 01
    constant tiempo_clk:time :=25 ns;                               -- periodo del reloj de la simulaci�n
    constant tiempo_escritura:time :=8*tiempo_clk;                  -- tiempo que tarda el m�dulo display en escribir en cada uno de los displays una vez
begin
---------------------------------------------------------------------- unidad bajo testeo
uut: display port map( 
        estado => estado,               
        monedero=> monedero,
        producto =>producto,
        clk => clk,
        posicion_led=> posicion_led, 
        codigo_led=>codigo_led);
---------------------------------------------------------------------- generaci�n del reloj que gobierna el programa
    clk<=not clk after tiempo_clk/2; 
---------------------------------------------------------------------- generaci�n de las se�ales de entrada del m�dulo display
    process
    begin
---------------------------------------------------------------------- estado 00 : se prueban los 4 casos posibles del valor producto que es el par�metro que se dibuja en este estado
        wait for tiempo_escritura;
        producto<= "0010";
        wait for tiempo_escritura;
        producto<= "0100";
        wait for tiempo_escritura;
        producto<= "1000";
        wait for tiempo_escritura;
---------------------------------------------------------------------- estado 01 : se prueban algunos valores del par�metro monedero para ver como se muestran en su posici�n de los displays
        estado<= "01";
        for i in 0 to rango_monedero loop
            monedero<=std_logic_vector(to_unsigned(i, monedero'length));
            wait for tiempo_escritura ;
        end loop;
---------------------------------------------------------------------- estado 10 : se observa durante un ciclo de escritura de los leds el mensaje que deber�a salir "FULL"
        estado<="10";
        wait for tiempo_escritura;
---------------------------------------------------------------------- estado 11 : se observa durante un cicle de escritura de los leds el mensaje que deber�a salir "FAIL"
        estado<="11";
        wait for tiempo_escritura;
---------------------------------------------------------------------- terminaci�n de programa y env�o de mensaje
        assert false;
            report "simulaci�n terminada"
            severity failure;
    end process;
end Behavioral;