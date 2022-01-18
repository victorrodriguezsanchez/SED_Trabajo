library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Este módulo se encarga de conectar todos los otros submódulos entre sí y de conectar las entradas y salidas a la placa

entity TOP is
    generic(frecuenciarelojKhz:integer:=100000);
    Port (
            product_sel  : in std_logic_vector(3 downto 0);                     -- Entrada del producto seleccionado con los switches del 0 al 3
            monedas_in   : in std_logic_vector(3 downto 0);                     -- Entrada que simula las monedas introducidas mediante botones  
            CLK          : in std_logic;                                        -- Reloj que contola el sistema
            RESET        : in std_logic;                                        -- Activo a nivel bajo resetea la maquina 
            posicion_led : out std_logic_vector (7 downto 0);                   -- Posición del display en la que se va a mostrar el dígito o la letra 
            display_leds : out std_logic_vector (6 downto 0);                   -- Contiene el codigo para dibujar el dígito o la letra
            motor_leds   : out std_logic_vector (3 downto 0);                   -- Salida que simula mediante leds el proceso en el que la maquina saca el producto 
            estados      : out std_logic_vector(1 downto 0)                     -- salida del estado actual utilizada para el testbench
    );
end TOP;

architecture Behavioral of TOP is
---------------------------------------------------------------------------------- Declaración de componenetes
    component tratamientoseniales                                               -- Componente tratamientoseniales, acondiciona las señales para su uso
        generic(
            inputsize   : integer;
            sensibilidad: integer);
        port(
            input  : in STD_LOGIC_VECTOR (3 downto 0);
            output : out STD_LOGIC_VECTOR (3 downto 0);
            clk    : in STD_LOGIC);
    end component;
    component monedero                                                          -- Componente monedero que cuenta las monedas introducidas
        port(
            clk     : in std_logic;
            reset   : in std_logic;
            cent100 : in std_logic;
            cent50  : in std_logic;
            cent20  : in std_logic;
            cent10  : in std_logic;
            count   : out std_logic_vector(7 downto 0));
    end component;
    component Selector_producto                                                 -- Componente Selector_producto, se usa para elegir el producto
        port(
            productos : in STD_LOGIC_VECTOR (3 downto 0);
            clk       : in std_logic;
            producto  : out STD_LOGIC_VECTOR (3 downto 0);
            done      : out std_logic);
    end component;
    component motor_salida                                                      -- Componente motor_salida, manda una señal a la salida dependiendo del producto
        port(
            producto : in STD_LOGIC_VECTOR (3 downto 0);
            clk       : in std_logic;
            motor    : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    component FSM                                                               -- Componente FSM, máquina de estados del sistema
        generic(frecuenciarelojKHz:integer);
        port(
            RESET              : in std_logic ; 
            CLK                : in std_logic ;  
            monedero_in        : in std_logic_vector (7 downto 0); 
            select_product_in  : in std_logic_vector (3 downto 0); 
            select_done        : in std_logic ;
            reset_monedero     : out std_logic ;
            out_motor          : out std_logic_vector (3 downto 0); 
            select_product_out : out std_logic_vector (3 downto 0); 
            monedero_out       : out std_logic_vector (7 downto 0); 
            state              : out std_logic_vector (1 downto 0));
    end component;
    component display                                                           -- Componente display, módulo encargado de escribir mensajes en los displays
        port(
            estado       : in STD_LOGIC_VECTOR (1 downto 0);                           
            monedero     : in STD_LOGIC_VECTOR (7 downto 0);
            producto     : in STD_LOGIC_VECTOR (3 downto 0);
            clk          : in STD_LOGIC;
            posicion_led : out STD_LOGIC_VECTOR (7 downto 0);               
            codigo_led   : out STD_LOGIC_VECTOR(6 downto 0));
    end component;
---------------------------------------------------------------------------------- Declaracion de señales de conexión entre módulos
signal salida_tratada          : std_logic_vector (3 downto 0);                 -- Salida del modulo tratamientoseniales que llega al modulo monedero
signal cuenta_monedero         : std_logic_vector(7 downto 0);                  -- Salida que lleva el valor del monedero a la fsm 
signal producto_elegido        : std_logic_vector (3 downto 0);                 -- Salida del modulo Selector_producto con el producto seleccionado que lo lleva a la fsm
signal producto_fsm_to_motor   : std_logic_vector (3 downto 0);                 -- Conexion entre la fsm y motor para mandar el producto seleccionado
signal producto_fsm_to_display : std_logic_vector (3 downto 0);                 -- Conexion entre la fsm y display para mandar el producto seleccionado
signal monedero_fsm_to_display : std_logic_vector(7 downto 0);                  -- Conexion entre la fsm y display para mandar el valor del monedero 
signal estado_actual           : std_logic_vector (1 downto 0);                 -- Salida de la fsm para mandar el estado al display 
signal done_out_select         : std_logic;                                     -- Salida de control del modulo Selector_producto con la fsm                                      
signal reset_fsm_to_contador   : std_logic;                                     -- Salida reset del modulo fsm para resetear el contador
begin
---------------------------------------------------------------------------------- acondicionamiento de las señales de entrada
insta_tratamientoseniales:
    tratamientoseniales 
        generic map(
            inputsize=>4,
            sensibilidad=>5)
        port map( 
            input => monedas_in, 
            output=> salida_tratada, 
            clk => CLK);
---------------------------------------------------------------------------------- gestión de la cuenta de las monedas introducidas       
insta_monedero :
    monedero  
        port map(
            clk=> CLK,
            reset => reset_fsm_to_contador,
            cent100=> salida_tratada(3),
            cent50=> salida_tratada(2),
            cent20=> salida_tratada(1),
            cent10=> salida_tratada(0),
            count=> cuenta_monedero);
---------------------------------------------------------------------------------- selección del producto
insta_Selector_producto:
    Selector_producto 
        port map(
            productos=>product_sel,
            clk      => CLK,
            producto=> producto_elegido,
            done=>done_out_select);
---------------------------------------------------------------------------------- señal de salida al finalizar el proceso
insta_motor_salida:
    motor_salida 
        port map(
            producto=> producto_fsm_to_motor,
            clk => CLK,
            motor=> motor_leds);
---------------------------------------------------------------------------------- gestión de los estados del sistema
insta_fsm:
    FSM
        generic map(
            frecuenciarelojKHz=>frecuenciarelojKhz ) 
	   port map(
            RESET=> RESET, 
            CLK =>CLK,
            monedero_in => cuenta_monedero,
            select_product_in => producto_elegido,
            select_done => done_out_select,
            reset_monedero => reset_fsm_to_contador,
            out_motor=> producto_fsm_to_motor,
            select_product_out=>producto_fsm_to_display, 
            monedero_out=> monedero_fsm_to_display,
            state => estado_actual);

            estados<=estado_actual;                                             -- salida del estado para mostrarse en el testbench
---------------------------------------------------------------------------------- representación del mensaje en función del estado
insta_display:
    display 
        port map(
            estado =>  estado_actual,                         
            monedero => monedero_fsm_to_display,
            producto => producto_fsm_to_display,
            clk => CLK,
            posicion_led => posicion_led,               
            codigo_led => display_leds);
end Behavioral;