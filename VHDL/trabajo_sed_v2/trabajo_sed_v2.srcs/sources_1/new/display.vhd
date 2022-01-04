library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.ALL;

entity display is
    Port ( estado :     in STD_LOGIC_VECTOR (1 downto 0);                           
           monedero :   in STD_LOGIC_VECTOR (7 downto 0);
           producto :   in STD_LOGIC_VECTOR (3 downto 0);
           clk :        in STD_LOGIC;
           posicion_led:out STD_LOGIC_VECTOR (7 downto 0);              --devuelve 
           codigo_led:  out STD_LOGIC_VECTOR(6 downto 0);
           done :       out STD_LOGIC);
end display;

architecture Behavioral of display is
    COMPONENT decodificador
    PORT(
        codigo: in STD_LOGIC_VECTOR(4 downto 0);
        led_display: out STD_LOGIC_VECTOR(6 downto 0)
    );END COMPONENT;
    signal doit         :   std_logic:='0';
    signal codigo       :   std_logic_vector(4 downto 0):= "11111";
    signal selecproducto:   std_logic_vector(3 downto 0);
    signal posicion     :   std_logic_vector(7 downto 0):="11111110";
    signal monedero_int :   integer;
    signal centenas     :   integer;
    signal decenas      :   integer;
    signal unidades     :   integer;
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
instancia_decodificador:
    decodificador PORT MAP(codigo=>codigo,led_display=>codigo_led);
    
process (clk) 
begin
    if(rising_edge (clk)) then
        posicion <= posicion(6 downto 0) & posicion(7);         -- rotar el led que se va a encender
        
        centenas <=  to_integer(unsigned(monedero))/100;        -- convertir el numero de la entrada a 3 digitos separados
        monedero_int <= to_integer(unsigned(monedero)) mod 100;
        decenas <= monedero_int/10;
        unidades <= monedero_int mod 10;
                                            
        case estado is                                          --dibujar los mensajes dependiendo del estado en el que se esté
            when "00" =>                                        --mensaje de seleccionar producto: SEL P "producto seleccionado"
                case posicion is
                when "10000000" =>  codigo <=   S;
                when "01000000" =>  codigo <=   E;
                when "00100000" =>  codigo <=   L;
                when "00010000" =>  codigo <=   VACIO;
                when "00001000" =>  codigo <=   P;
                when "00000100" =>  codigo <=   VACIO;
                when "00000010" =>  codigo <=   VACIO;
                when "00000001" =>  
                    case producto is
                                when "1000" => codigo<= "00001";--1
                                when "0100" => codigo<= "00010";--2
                                when "0010" => codigo<= "00011";--3
                                when "0001" => codigo<= "00100";--4
                                when others => codigo<= VACIO;--si se pone un valor erroneo no dibuja nada
                    end case;
                when others     =>  codigo <=   VACIO;
                end case;
                doit <= '1';
            when "01" =>                                        --mensaje de insertar el dinero :  "dinero insertado"
                case posicion is
                when "10000000" =>  codigo <=   VACIO;
                when "01000000" =>  codigo <=   VACIO;
                when "00100000" =>  codigo <=   VACIO;
                when "00010000" =>  codigo <=   VACIO;
                when "00001000" =>  codigo <=   VACIO;
                when "00000100" =>  codigo <=   std_logic_vector(to_unsigned(centenas, codigo'length));
                when "00000010" =>  codigo <=   std_logic_vector(to_unsigned(decenas, codigo'length));
                when "00000001" =>  codigo <=   std_logic_vector(to_unsigned(unidades, codigo'length));
                when others     =>  codigo <=   VACIO;
                end case;
                doit <= '1';
            when "10" =>                                      --mensaje de finalizado : FULL
                case posicion is
                when "10000000" =>  codigo <=   F;
                when "01000000" =>  codigo <=   U;
                when "00100000" =>  codigo <=   L;
                when "00010000" =>  codigo <=   L;
                when "00001000" =>  codigo <=   VACIO;
                when "00000100" =>  codigo <=   VACIO;
                when "00000010" =>  codigo <=   VACIO;
                when "00000001" =>  codigo <=   VACIO;
                when others =>      codigo <=   VACIO;
                end case;
                doit <= '1';
            when "11" =>                                        --mensaje de error: FAIL
                case posicion is
                when "10000000" =>  codigo <=   F;
                when "01000000" =>  codigo <=   A;
                when "00100000" =>  codigo <=   I;
                when "00010000" =>  codigo <=   L;
                when "00001000" =>  codigo <=   VACIO;
                when "00000100" =>  codigo <=   VACIO;
                when "00000010" =>  codigo <=   VACIO;
                when "00000001" =>  codigo <=   VACIO;
                when others =>      codigo <=   VACIO;
                end case;
                doit <= '1';
        end case;
    end if;
end process;
done<=doit;
end Behavioral;
