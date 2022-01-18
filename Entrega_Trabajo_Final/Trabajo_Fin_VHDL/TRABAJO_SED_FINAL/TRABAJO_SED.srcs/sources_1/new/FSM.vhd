library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--Este módulo se encarga de gestionar los estados por los que pasa la máquina y de enviar y recibir datos de otros módulos.
--Para todos los estados manda datos al módulo display.
--Para el estado S0: recibe datos del selector de productos.
--Para el estado S1: recibe datos del monedero y al llegar a 100 pasa al estado s2 y si pasa de 100 va al estado S3.
--Para el estado S2: manda el código del producto al motor.
--Para el estado S3: entra en fase de error.
--El tiempo que se tarda en pasar de un estado a otro se calcula con la frecuencia de reloj de la señal clk, hay que establecer la frecuencia en el
--genérico "frecuenciarelojkHz" en khz, si se pone mal los tiempos no coincidirán con los reales.
entity FSM is
    generic(
        frecuenciarelojKHz:integer:=100000;                                 -- frecuencia a la que funciona el reloj del sistema
        esperaS0ms:integer:=3000;                                           -- tiempo de espera para pasar al siguiente estado 
        esperaS1ms:integer:=3000;                                           
        esperaS2ms:integer:=3000;                                           
        esperaS3ms:integer:=3000);
    Port (
        RESET              : in std_logic ;                                 -- reset activo a nivel bajo
        CLK                : in std_logic ;                                 -- reloj que gobierna el funcionamiento del módulo
        monedero_in        : in std_logic_vector (7 downto 0);              -- entrada del contador de dinero del módulo monedero
        select_product_in  : in std_logic_vector (3 downto 0);              -- entrada del producto seleccionado                              
        select_done        : in std_logic ;                                 -- indicador de que el producto ha sido seleccionado
        reset_monedero     : out std_logic;                                 -- reseteo del contador de monedero
        out_motor          : out std_logic_vector (3 downto 0);             -- señal de activación del led según el producto seleccionado
        select_product_out : out std_logic_vector (3 downto 0);             -- señal que va al display con el producto seleccionado
        monedero_out       : out std_logic_vector (7 downto 0);             -- señal que va al display con el dinero insertado
        state              : out std_logic_vector (1 downto 0));            -- señal que va al display con el estado actual
end FSM;

architecture Behavioral of FSM is
------------------------------------------------------------------------------ declaración de señales de la máquina de estados
    type STATES is(S0,S1,S2,S3);
    signal current_state: STATES := S0;                                     -- estado actual de la máquina
    signal select_product: std_logic_vector (3 downto 0):="0000";           -- señal para guardar el valor del producto seleccionado en el primer estado
begin
    process(RESET,CLK)
------------------------------------------------------------------------------ declaración de variables para poder hacer esperas
        variable contador1,contador_ms:integer :=0;                         -- contador1 aumenta cada tick y contador_ms aumenta cada ms (solo si el genérico "frecuenciarelojKHz" es igual a la frecuencia real)
        variable flagS0,flagS1,flagS2,flagS3: std_logic :='0';              -- flags usadas para resetear el contador_ms una única vez cuando pase un evento
    begin
------------------------------------------------------------------------------ resetear al estado S0 y resetear el contador si RESET
        if RESET ='0' then
            current_state  <= S0;
            reset_monedero<='0';
------------------------------------------------------------------------------ parte síncrona del programa
        elsif rising_edge (CLK) then
------------------------------------------------------------------------------ contador que cuenta el tiempo que ha pasado con cada tick de clk
            contador1:=contador1+1;
            if contador1>=frecuenciarelojKHz then
                contador1:=0;
                contador_ms:=contador_ms+1;
            end if;
------------------------------------------------------------------------------ máquina de estados
        case current_state is
            when S0 =>-------------------------------------------------------- S0:manda información a display y si se selecciona un producto pasa al siguiente estado tras un tiempo
                state <= "00";
                if flagS0='0' then
                if select_done = '1' then                    -- reset del contador
                    flagS0:='1';
                    contador_ms:=0;
                    select_product <= select_product_in;
                    select_product_out <=select_product_in;
                else 
                    select_product<="0000";
                    select_product_out<="0000";
                end if;
                end if;
                if contador_ms>esperaS0ms and flagS0='1' then               -- si contador pasa del tiempo de espera pasa al siguiente estado
                    current_state <= S1;
                    flagS0:='0';
                end if;
            when S1 =>-------------------------------------------------------- S1:lee el valor del monedero y lo manda al display
                state <= "01";
                reset_monedero <= '1';                                      -- quita el reset al monedero
                monedero_out <= monedero_in;
                if monedero_in>="01100100" and flagS1='0' then              -- reset del contador
                    flagS1:='1';
                    contador_ms:=0;
                end if;
                if contador_ms>esperaS1ms and flagS1='1' then               -- si el contador mayor que la espera pasa al siguiente estado
                    flagS1:='0';
                    reset_monedero <= '0';                                  -- pone el reset al monedero
                    if (monedero_in > "01100100") then current_state <= S3;    -- si se pasa de la cantidad pasa al estado de error
                    elsif (monedero_in = "01100100")then current_state <= S2;  -- si se pone la cantidad exacta pasa al estado de soltar el producto 
                    end if;
                end if;
            when S2 =>-------------------------------------------------------- S2:manda la señal al motor de que funcione y al display
                state <= "10";
                out_motor <= select_product;
                if flagS2='0' then                                          -- reset contador
                    flagS2:='1';
                    contador_ms:=0;
                end if;
                if contador_ms>esperaS2ms and flagS2='1' then               -- si el contador es mayor que la espera pasa al estado S0
                    flagS2:='0';
                    out_motor<="0000";
                    current_state <= S0;
                end if;
            when S3 =>-------------------------------------------------------- S3:escribe el mensaje de error y tras un tiempo se va al S0            
                state <= "11";
                if flagS3='0' then
                    flagS3:='1';
                    contador_ms:=0;
                end if;
                if contador_ms>esperaS3ms and flagS3='1' then
                    flagS3:='0';
                    current_state <= S0;
                end if;
            end case;
        end if;
    end process;             
end Behavioral;