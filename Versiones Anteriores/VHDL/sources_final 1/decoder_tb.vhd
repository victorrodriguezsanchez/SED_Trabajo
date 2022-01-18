library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity decoder_tb is
end decoder_tb;

architecture Behavioral of decoder_tb is
------------------------------------------------------------------------ declaraci�n del componente que se va a testear
    component decodificador port(
        caracter : in character;
        led_display : out STD_LOGIC_VECTOR (6 downto 0));
    end component;
------------------------------------------------------------------------ entradas del m�dulo de decodificador
    signal caracter : character;
------------------------------------------------------------------------ salidas del m�dulo de decodificador
    signal led_display : std_logic_vector(6 downto 0);
------------------------------------------------------------------------ constantes del programa
    constant tiempo:time :=25 ns;                                     -- marca el tiempo que tarda en variar la se�al c�digo
    constant rango_caracter: integer :=character'pos(character'right);-- indica el rango de la variable character
begin
------------------------------------------------------------------------ unidad bajo testeo
uut: decodificador port map(
    caracter => caracter,
    led_display => led_display);
------------------------------------------------------------------------ generaci�n de las se�ales de entrada del decodificador
    process
    begin
------------------------------------------------------------------------ modificaci�n de la entrada para ocupar todos los posibles casos
        for i in 0 to rango_caracter loop
            caracter<=character'val(i);
            wait for tiempo;
        end loop;
------------------------------------------------------------------------ terminaci�n de programa y env�o de mensaje
        assert false;
            report "decodificador: simulaci�n finalizada."
            severity failure;
    end process;
end Behavioral;