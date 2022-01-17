library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP_tb is
end TOP_tb;

architecture Behavioral of TOP_tb is
----------------------------------------------------------------  declaraci�n del componente que se va a testear
    component TOP is 
        generic(frecuenciarelojKHz:integer);
        port(
            product_sel  : in std_logic_vector(3 downto 0);
            monedas_in   : in std_logic_vector(3 downto 0); 
            CLK          : in std_logic;
            RESET        : in std_logic;
            posicion_led : out std_logic_vector (7 downto 0);
            display_leds : out std_logic_vector (6 downto 0);
            motor_leds   : out std_logic_vector (3 downto 0);
            estados      : out std_logic_vector (1 downto 0));
    end component ;
---------------------------------------------------------------- variables de entrada al m�dulo
    signal product_sel  : std_logic_vector(3 downto 0):="0000";
    signal monedas_in   : std_logic_vector(3 downto 0):="0000"; 
    signal CLK          : std_logic:='0';
    signal RESET        : std_logic:='1';
---------------------------------------------------------------- variables de salida del m�dulo
    signal posicion_led : std_logic_vector (7 downto 0);
    signal display_leds : std_logic_vector (6 downto 0);
    signal motor_leds   : std_logic_vector (3 downto 0);
    signal estados : std_logic_vector(1 downto 0);
---------------------------------------------------------------- constantes del programa
    constant periodo: time := 1ms;                            -- periodo de duraci�n del reloj
begin
---------------------------------------------------------------- unidad bajo testeo
uut: 
    TOP 
        generic map(frecuenciarelojKHz=>1)                    -- frecuencia de reloj baja para mayor velocidad de simulaci�n
        port map(
            product_sel  => product_sel,
            monedas_in   => monedas_in ,
            CLK          => CLK,
            RESET        => RESET,
            posicion_led => posicion_led,
            display_leds => display_leds,
            motor_leds   => motor_leds,
            estados => estados);
---------------------------------------------------------------- generaci�n de la se�al de reloj
    clk<=not clk after periodo/2;
---------------------------------------------------------------- generaci�n de las se�ales de entrada al m�dulo
    process
    begin
        wait for 100 ms;---------------------------------------- se selecciona el producto 1 
        product_sel<="0001";
        wait for 3 sec;
        product_sel<="0000";
        wait for 0.2 sec;--------------------------------------- tras el tiempo de delay se empizan a a�adir monedas
        monedas_in<="0010";-- 20 cents
        wait for 0.2 sec;
        monedas_in<="0001";-- 10 cents
        wait for 0.1 sec;
        monedas_in<="0000";
        wait for 0.1 sec;
        monedas_in<="0010";-- 10 cents
        wait for 0.2 sec;
        monedas_in<="0100";-- 50 cents
        wait for 5 sec;----------------------------------------- al introducir 100 cents se pasa al estado 2 y el motor empieza a funcionar, despues vuelve al inicio
        product_sel<="1000";                                  -- se selecciona ahora el producto 4
        wait for 5 sec;----------------------------------------- se introducen m�s de 100 centimos
        monedas_in<="0010";                             
        wait for 0.2 sec;
        monedas_in<="1000";
        wait for 8 sec;----------------------------------------- pasa al estado de error y despues de 3 segundos vuelve al inicio
---------------------------------------------------------------- terminaci�n de programa y env�o de mensaje
        assert false
            report "Top: simulaci�n finalizada"
            severity failure;
    end process;
end Behavioral;
