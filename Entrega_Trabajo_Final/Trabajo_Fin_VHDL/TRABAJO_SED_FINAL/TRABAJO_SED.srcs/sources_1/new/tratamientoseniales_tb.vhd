library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tratamientoseniales_tb is
end tratamientoseniales_tb;

architecture Behavioral of tratamientoseniales_tb is
    component tratamientoseniales port(
        input : in STD_LOGIC_VECTOR (3 downto 0);
        output : out STD_LOGIC_VECTOR (3 downto 0);
        clk : in STD_LOGIC);
    end component;
------------------------------------------------------------- variables de entrada del módulo
    signal input: std_logic_vector(3 downto 0):= "0000";
    signal clk: std_logic:='0';
------------------------------------------------------------- variables de salida del módulo
    signal output: std_logic_vector(3 downto 0);
------------------------------------------------------------- constantes del módulo
    constant tiempo_clk: time := 25 ns;                    -- periodo del reloj del sistema
    constant numero_oscilaciones: integer:= 15;            -- cantidad de oscilaciones que se producen cada vez que se simula el ruido
begin
------------------------------------------------------------- unidad bajo testeo
uut: tratamientoseniales port map(
    input => input,
    output => output,
    clk => clk);
------------------------------------------------------------- eneración del reloj que gobierna el programa
    clk <= not clk after tiempo_clk*0.5;
------------------------------------------------------------- generación de las señales de entrada del módulo
    process
    begin
------------------------------------------------------------- esperar un rato con todas las señales en LOW
        wait for 20*tiempo_clk;
------------------------------------------------------------- generación de un ruido que termina en un valor LOW
        for j in 0 to numero_oscilaciones loop
            for i in 0 to input'high loop
                input(i)<='1';
            end loop;
            wait for tiempo_clk;
            for i in 0 to input'high loop
                input(i)<='0';
            end loop;
            wait for tiempo_clk;
        end loop;
------------------------------------------------------------- esperar un rato con todas las señales en LOW
        wait for 35*tiempo_clk;
------------------------------------------------------------- generación de un ruido que termina en un valor HIGH
        for j in 0 to numero_oscilaciones loop
            for i in 0 to input'high loop
                input(i)<='0';
            end loop;
            wait for tiempo_clk;
            for i in 0 to input'high loop
                input(i)<='1';
            end loop;
            wait for tiempo_clk;
        end loop;
------------------------------------------------------------- esperar un rato con el valor HIGH (aqui se genera el pulso a la salida)
        wait for 50*tiempo_clk;
------------------------------------------------------------- generación de un pulso que termina en un valor LOW
        for j in 0 to numero_oscilaciones loop
            for i in 0 to input'high loop
                input(i)<='1';
            end loop;
            wait for tiempo_clk;
            for i in 0 to input'high loop
                input(i)<='0';
            end loop;
            wait for tiempo_clk;
        end loop;
------------------------------------------------------------- esperar un rato en LOW
        wait for 19*tiempo_clk;
------------------------------------------------------------- terminación de programa y envío de mensaje
        assert false;
            report "tratamientoseniales: se ha finalizado la simulación"
            severity failure;
    end process;
end Behavioral;
