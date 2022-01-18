library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.ALL;
--Este módulo se encarga de dibujar el carácter que se debe representar en cada display dependiendo del estado
--Para ello, devuelve el display en el que va a dibujar y el carácter que escribirá.
--Las salidas están codificadas para poder ser conectadas directamente a la placa.
--El display que se escribe rota cada ciclo del programa para que a la vista del usuario parezca que todos los displays están encendidos a la vez.
entity display is
    generic(prescaler:integer:=1000);                                   -- sirve para modificar la velocidad de rotación del display que se va a escribir
    Port ( estado :     in STD_LOGIC_VECTOR (1 downto 0);               -- estado del fsm que decide que mensaje se va a escribir             
           monedero :   in STD_LOGIC_VECTOR (7 downto 0);               -- valores del contador de dinero para escribir en el estado "01"
           producto :   in STD_LOGIC_VECTOR (3 downto 0);               -- producto seleccionado para escribir en el estado "00"
           clk :        in STD_LOGIC;                                   -- reloj para sincronizar los displays con el programa
           posicion_led:out STD_LOGIC_VECTOR (7 downto 0);              -- vector de salida que devuelve el led que se debe encender en cada momento 
           codigo_led:  out STD_LOGIC_VECTOR(6 downto 0));              -- vector de salida con el código para encender los leds de los display para formar una letra o número
end display;

architecture Behavioral of display is
-------------------------------------------------------------------------- declaración del decodificador del mensaje
    COMPONENT decodificador
    PORT(
        caracter    : in character;
        led_display : out STD_LOGIC_VECTOR(6 downto 0));
    END COMPONENT;
-------------------------------------------------------------------------- variables del programa
    signal caracter     :   character;                                  -- carácter que se le va a pasar al decodificador
    signal posicion     :   std_logic_vector(7 downto 0):="11111110";   -- copia del parámetro "posición_led"
    signal monedero_int :   integer;                                    -- señales auxiliares para escribir números variables en los mensajes
    signal centenas     :   integer;
    signal decenas      :   integer;
    signal unidades     :   integer;
begin
-------------------------------------------------------------------------- el decodificador devuelve en cada ciclo el valor para poder dibujar el símbolo según el carácter enviado
instancia_decodificador:
    decodificador PORT MAP(caracter=>caracter,led_display=>codigo_led);
-------------------------------------------------------------------------- con cada tick del programa actualizar el valor de la posicion y el codigo_led  
    process (clk)
    variable contador:integer :=0;
    begin
        if(rising_edge (clk)) then
-------------------------------------------------------------------------- cálculos previos antes de asignar el valor a los displays
            contador:=contador+1;
            if contador>prescaler then
                contador:=0; 
                posicion <= posicion(6 downto 0) & posicion(7);         -- rotar el led que se va a encender, 
                posicion_led<=posicion;
            end if;
            centenas <=  to_integer(unsigned(monedero))/100;            -- convertir el numero de la entrada a 3 digitos separados
            monedero_int <= to_integer(unsigned(monedero)) mod 100;
            decenas <= monedero_int/10;
            unidades <= monedero_int mod 10;
-------------------------------------------------------------------------- dibujar los mensajes dependiendo del estado en el que se está
            case estado is
                when "00" =>---------------------------------------------- mensaje de seleccionar producto: SEL P "producto seleccionado"
                    case posicion is
                        when "01111111" =>  caracter <=   'S';
                        when "10111111" =>  caracter <=   'E';
                        when "11011111" =>  caracter <=   'L';
                        when "11101111" =>  caracter <=   ' ';
                        when "11110111" =>  caracter <=   'P';
                        when "11111011" =>  caracter <=   ' ';
                        when "11111101" =>  caracter <=   ' ';
                        when "11111110" =>  
                            case producto is
                                        when "0001" => caracter <= '1';-- 1
                                        when "0010" => caracter <= '2';-- 2
                                        when "0100" => caracter <= '3';-- 3
                                        when "1000" => caracter <= '4';-- 4
                                        when others => caracter <= ' ';-- si se pone un valor erroneo no dibuja nada
                            end case;
                        when others     =>  caracter <=   ' ';
                    end case;
                when "01" =>---------------------------------------------- mensaje de insertar el dinero :  "dinero insertado"                                           
                    case posicion is
                        when "01111111" =>  caracter <=   ' ';
                        when "10111111" =>  caracter <=   ' ';
                        when "11011111" =>  caracter <=   ' ';
                        when "11101111" =>  caracter <=   ' ';
                        when "11110111" =>  caracter <=   ' ';
                        when "11111011" =>  caracter <=   character'val(centenas+character'pos('0'));
                        when "11111101" =>  caracter <=   character'val(decenas+character'pos('0'));
                        when "11111110" =>  caracter <=   character'val(unidades+character'pos('0'));
                        when others     =>  caracter <=   ' ';
                    end case;
                when "10" =>---------------------------------------------- mensaje de finalizado : FULL
                    case posicion is
                        when "01111111" =>  caracter <=   'F';
                        when "10111111" =>  caracter <=   'U';
                        when "11011111" =>  caracter <=   'L';
                        when "11101111" =>  caracter <=   'L';
                        when "11110111" =>  caracter <=   ' ';
                        when "11111011" =>  caracter <=   ' ';
                        when "11111101" =>  caracter <=   ' ';
                        when "11111110" =>  caracter <=   ' ';
                        when others =>      caracter <=   ' ';
                    end case;
                when "11" =>---------------------------------------------- mensaje de error: FAIL
                    case posicion is
                        when "01111111" =>  caracter <=   'F';
                        when "10111111" =>  caracter <=   'A';
                        when "11011111" =>  caracter <=   'I';
                        when "11101111" =>  caracter <=   'L';
                        when "11110111" =>  caracter <=   ' ';
                        when "11111011" =>  caracter <=   ' ';
                        when "11111101" =>  caracter <=   ' ';
                        when "11111110" =>  caracter <=   ' ';
                        when others =>      caracter <=   ' ';
                    end case;
                when others => ------------------------------------------- solo para que compile :D
            end case;
        end if;
    end process;
end Behavioral;
