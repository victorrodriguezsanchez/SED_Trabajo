library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity decoder_tb is
end decoder_tb;

architecture Behavioral of decoder_tb is
    component decodificador port(
        codigo : in STD_LOGIC_VECTOR (4 downto 0);
        led_display : out STD_LOGIC_VECTOR (6 downto 0));
    end component;
---------------------------------------------------------------------- entradas del módulo de decodificador
    signal codigo : std_logic_vector(4 downto 0);
---------------------------------------------------------------------- salidas del módulo de decodificador
    signal led_display : std_logic_vector(6 downto 0);
---------------------------------------------------------------------- constantes del programa
    constant rango_codigo: integer := 150;                          -- indica hasta que valor se hace la cuenta del código
    constant tiempo:time :=25 ns;                                   -- marca el tiempo que tarda en variar la señal código
begin
---------------------------------------------------------------------- unidad bajo testeo
uut: decodificador port map(
    codigo => codigo,
    led_display => led_display);
---------------------------------------------------------------------- generación de las señales de entrada del decodificador
    process
    begin
---------------------------------------------------------------------- modificación de la entrada para ocupar todos los posibles casos
        for i in 0 to 32 loop
            codigo<=std_logic_vector(to_unsigned(i,codigo'length));
            wait for tiempo;
        end loop;
---------------------------------------------------------------------- terminación de programa y envío de mensaje
        assert false;
            report "decodificador: simulación finalizada."
            severity failure;
    end process;
end Behavioral;