library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.ALL;

entity display is
    Port ( estado :     in STD_LOGIC_VECTOR (1 downto 0);               -- estado del fsm que decide que mensaje se va a escribir             
           monedero :   in STD_LOGIC_VECTOR (7 downto 0);               -- valores del contador de dinero para escribir en el estado "01"
           producto :   in STD_LOGIC_VECTOR (3 downto 0);               -- producto seleccionado para escribir en el estado "00"
           clk :        in STD_LOGIC;                                   -- reloj para sincronizar los displays con el programa
           posicion_led:out STD_LOGIC_VECTOR (7 downto 0);              -- vector de salida que devuelve el led que se debe encender en cada momento (siempre con solo uno de los dígitos con valor "0")
           codigo_led:  out STD_LOGIC_VECTOR(6 downto 0);               -- vector de salida con el código para encender los leds de los display para formar una letra o número
           done :       out STD_LOGIC);                                 -- señal que se devuelve al fsm
end display;

architecture Behavioral of display is
    COMPONENT decodificador
    PORT(
        codigo: in STD_LOGIC_VECTOR(4 downto 0);
        led_display: out STD_LOGIC_VECTOR(6 downto 0));
    END COMPONENT;
-------------------------------------------------------------------------- variables del programa
    signal doit         :   std_logic:='0';                             -- copia de la salida "done"
    signal codigo       :   std_logic_vector(4 downto 0):= "11111";     -- código del símbolo que se quiere decodificar
    signal posicion     :   std_logic_vector(7 downto 0):="11111110";   -- copia del parámetro "posición_led"
    signal monedero_int :   integer;
    signal centenas     :   integer;
    signal decenas      :   integer;
    signal unidades     :   integer;
-------------------------------------------------------------------------- constantes para establecer el valor del código del decodificador fácilmente
    constant F :            std_logic_vector(4 downto 0):= "10000";
    constant A :            std_logic_vector(4 downto 0):= "10001";
    constant I :            std_logic_vector(4 downto 0):= "10010";
    constant L :            std_logic_vector(4 downto 0):= "10011";
    constant U :            std_logic_vector(4 downto 0):= "10100";
    constant S :            std_logic_vector(4 downto 0):= "10101";
    constant E :            std_logic_vector(4 downto 0):= "10110";
    constant P :            std_logic_vector(4 downto 0):= "10111";
    constant VACIO:         std_logic_vector(4 downto 0):= "11111";
    
    
begin
-------------------------------------------------------------------------- el decodificador devuelve en cada ciclo el valor para poder dibujar el símbolo según el código enviado
instancia_decodificador:
    decodificador PORT MAP(codigo=>codigo,led_display=>codigo_led);
    
    process (clk) 
    begin
        if(rising_edge (clk)) then
-------------------------------------------------------------------------- cálculos previos antes de asignar el valor a los displays
            posicion <= posicion(6 downto 0) & posicion(7);             -- rotar el led que se va a encender uno a la izquierda
            posicion_led<=posicion;
            
            centenas <=  to_integer(unsigned(monedero))/100;            -- convertir el numero de la entrada a 3 digitos separados
            monedero_int <= to_integer(unsigned(monedero)) mod 100;
            decenas <= monedero_int/10;
            unidades <= monedero_int mod 10;
-------------------------------------------------------------------------- dibujar los mensajes dependiendo del estado en el que se está
            case estado is
-------------------------------------------------------------------------- mensaje de seleccionar producto: SEL P "producto seleccionado"
                when "00" =>
                    case posicion is
                        when "01111111" =>  codigo <=   S;
                        when "10111111" =>  codigo <=   E;
                        when "11011111" =>  codigo <=   L;
                        when "11101111" =>  codigo <=   VACIO;
                        when "11110111" =>  codigo <=   P;
                        when "11111011" =>  codigo <=   VACIO;
                        when "11111101" =>  codigo <=   VACIO;
                        when "11111110" =>  
                            case producto is
                                        when "0001" => codigo <= "00001";-- 1
                                        when "0010" => codigo <= "00010";-- 2
                                        when "0100" => codigo <= "00011";-- 3
                                        when "1000" => codigo <= "00100";-- 4
                                        when others => codigo <= VACIO;  -- si se pone un valor erroneo no dibuja nada
                            end case;
                        when others     =>  codigo <=   VACIO;
                    end case;
                    doit <= '1';
-------------------------------------------------------------------------- mensaje de insertar el dinero :  "dinero insertado"
                when "01" =>                                                
                    case posicion is
                        when "01111111" =>  codigo <=   VACIO;
                        when "10111111" =>  codigo <=   VACIO;
                        when "11011111" =>  codigo <=   VACIO;
                        when "11101111" =>  codigo <=   VACIO;
                        when "11110111" =>  codigo <=   VACIO;
                        when "11111011" =>  codigo <=   std_logic_vector(to_unsigned(centenas, codigo'length));
                        when "11111101" =>  codigo <=   std_logic_vector(to_unsigned(decenas, codigo'length));
                        when "11111110" =>  codigo <=   std_logic_vector(to_unsigned(unidades, codigo'length));
                        when others     =>  codigo <=   VACIO;
                    end case;
                    doit <= '1';
-------------------------------------------------------------------------- mensaje de finalizado : FULL
                when "10" =>
                    case posicion is
                        when "01111111" =>  codigo <=   F;
                        when "10111111" =>  codigo <=   U;
                        when "11011111" =>  codigo <=   L;
                        when "11101111" =>  codigo <=   L;
                        when "11110111" =>  codigo <=   VACIO;
                        when "11111011" =>  codigo <=   VACIO;
                        when "11111101" =>  codigo <=   VACIO;
                        when "11111110" =>  codigo <=   VACIO;
                        when others =>      codigo <=   VACIO;
                    end case;
                    doit <= '1';
-------------------------------------------------------------------------- mensaje de error: FAIL
                when "11" =>
                    case posicion is
                        when "01111111" =>  codigo <=   F;
                        when "10111111" =>  codigo <=   A;
                        when "11011111" =>  codigo <=   I;
                        when "11101111" =>  codigo <=   L;
                        when "11110111" =>  codigo <=   VACIO;
                        when "11111011" =>  codigo <=   VACIO;
                        when "11111101" =>  codigo <=   VACIO;
                        when "11111110" =>  codigo <=   VACIO;
                        when others =>      codigo <=   VACIO;
                    end case;
                    doit <= '1';
                when others => -- no hace nada
            end case;
        end if;
    end process;
    done<=doit;
end Behavioral;
