library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity decoder_tb is
end decoder_tb;

architecture Behavioral of decoder_tb is
------------------------------------------------------------------------ declaración del componente que se va a testear
    component decodificador port(
        caracter : in character;
        led_display : out STD_LOGIC_VECTOR (6 downto 0));
    end component;
------------------------------------------------------------------------ entradas del módulo de decodificador
    signal caracter : character;
------------------------------------------------------------------------ salidas del módulo de decodificador
    signal led_display : std_logic_vector(6 downto 0);
------------------------------------------------------------------------ constantes del programa
    constant tiempo:time :=25 ns;                                     -- marca el tiempo que tarda en variar la señal código
    constant rango_caracter: integer :=character'pos(character'right);-- indica el rango de la variable character
begin
------------------------------------------------------------------------ unidad bajo testeo
uut: decodificador port map(
    caracter => caracter,
    led_display => led_display);
------------------------------------------------------------------------ generación de las señales de entrada del decodificador
    process
    begin
------------------------------------------------------------------------ modificación de la entrada para ocupar todos los posibles casos
        for i in 0 to rango_caracter loop
            caracter<=character'val(i);
            wait for tiempo;
        end loop;
------------------------------------------------------------------------ terminación de programa y envío de mensaje
        assert false;
            report "decodificador: simulación finalizada."
            severity failure;
    end process;
end Behavioral;