library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM_tb is
end FSM_tb;

architecture Behavioral of FSM_tb is
---------------------------------------------------------------------- declaración del componente que se va a testear
    component FSM is
        generic(frecuenciarelojKHz: integer);
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
    end component ;
---------------------------------------------------------------------- variables de entrada al módulo
        signal RESET                : std_logic:='1';
        signal CLK                  : std_logic:='0';
        signal select_done          : std_logic:='0';
        signal monedero_in          : std_logic_vector (7 downto 0);
        signal select_product_in    : std_logic_vector (3 downto 0);
---------------------------------------------------------------------- variables de salida del módulo
        signal reset_monedero       : std_logic;
        signal out_motor            : std_logic_vector(3 downto 0);
        signal select_product_out   : std_logic_vector(3 downto 0);
        signal monedero_out         : std_logic_vector(7 downto 0);
        signal state                : std_logic_vector(1 downto 0);
---------------------------------------------------------------------- constantes del programa
        constant periodo:time :=1 ms;                               -- periodo de oscilación de la señal clk
begin
---------------------------------------------------------------------- unidad bajo testeo
uut: FSM generic map (frecuenciarelojKHz=>1) port map(            
            RESET               => RESET,
            CLK                 => CLK,
            monedero_in         => monedero_in,
            select_product_in   => select_product_in,      
            select_done         => select_done,
            reset_monedero      => reset_monedero,
            out_motor           => out_motor,
            select_product_out  => select_product_out,
            monedero_out        => monedero_out,
            state               => state);
---------------------------------------------------------------------- actualización de la señal del reloj
    clk<= not clk after periodo/2;
---------------------------------------------------------------------- generación de las señales de entrada al módulo
    process
    begin
---------------------------------------------------------------------- inicialmente se está en estado 0, se selecciona el producto
        select_product_in<="0001";
        select_done<='1';
        wait for 4 sec;
---------------------------------------------------------------------- ahora se pasa al estado1, se ponen centimos en el monedero
        select_done<='0';
        monedero_in <= "00001010";
        wait for 1 sec;
---------------------------------------------------------------------- como no ha cambiado todavia el estado se pone el monedero a 100 cents para que pase a estado2
        monedero_in <= "01100100";
        wait for 5 sec;
---------------------------------------------------------------------- tras 5 segundos se ha completado de sobra el estado del estado2 y se ha vuelto al estado0
        monedero_in <="00000000";
        select_product_in<="1000";
        select_done<='1';
        wait for 4 sec;
---------------------------------------------------------------------- ahora se simula que se introducen mas de 100 centimos para pasar al estado3
        select_done<='0';
        monedero_in<="01110110";
        wait for 4 sec;
---------------------------------------------------------------------- por último se vuelve al estado1 otra vez y se presiona el reset
        monedero_in <="00000000";
        select_product_in <="0100";
        select_done<='1';
        wait for 4 sec;
        select_done<='0';
        RESET<='0';
        wait for 3 sec;
---------------------------------------------------------------------- terminación de programa y envío de mensaje
        assert false
            report "FSM: simulación finalizada"
            severity failure;
    end process;
end Behavioral;
