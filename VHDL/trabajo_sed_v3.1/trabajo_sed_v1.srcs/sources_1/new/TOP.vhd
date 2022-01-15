----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.01.2022 13:04:21
-- Design Name: 
-- Module Name: TOP - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TOP is
    Port (
            product_sel  : in std_logic_vector(3 downto 0);
            monedas_in   : in std_logic_vector(3 downto 0);
            CLK          : in std_logic;
            RESET        : in std_logic;
            posicion_led : out std_logic_vector (7 downto 0);
            display_leds : out std_logic_vector (6 downto 0);
            motor_leds   : out std_logic_vector (3 downto 0)
    
    );
end TOP;

architecture Behavioral of TOP is
    
    component tratamientoseniales
        port(
            input  : in STD_LOGIC_VECTOR (3 downto 0);
            output : out STD_LOGIC_VECTOR (3 downto 0);
            clk    : in STD_LOGIC
        );
    end component;
    
    component monedero
        port(
            clk     : in std_logic;
            reset   : in std_logic;
            enable  : in std_logic;
            cent100 : in std_logic;
            cent50  : in std_logic;
            cent20  : in std_logic;
            cent10  : in std_logic;
            count   : out std_logic_vector(7 downto 0)
        );
    end component;
    
    component Selector_producto
        port(
            productos : in STD_LOGIC_VECTOR (3 downto 0);
            producto  : out STD_LOGIC_VECTOR (3 downto 0);
            done      : out std_logic  
        );
    end component;
    
    component motor_salida
        port(
            producto : in STD_LOGIC_VECTOR (3 downto 0);
            motor    : out STD_LOGIC_VECTOR (3 downto 0);
            done     : out std_logic 
        );
    end component;
    
    component FSM
        port(
            RESET              : in std_logic ; -- Reset activo a nivel bajo
            CLK                : in std_logic ; --Reloj 
            monedero_in        : in std_logic_vector (7 downto 0); -- numero que llega desde el bloque monedero y actualiza la cuenta
            select_product_in  : in std_logic_vector (3 downto 0); --producto selecionado que llega a la fsm
            display_done       : in std_logic;
            motor_done         : in std_logic ;
            select_done        : in std_logic ;
            reset_monedero     : out std_logic ;
            out_motor          : out std_logic_vector (3 downto 0); --Señal que le llega al motor Activación del led según el producto selecionado
            select_product_out : out std_logic_vector (3 downto 0); --producto selecionado que llega al display
            monedero_out       : out std_logic_vector (7 downto 0); -- numero que le llega al display
            state              : out std_logic_vector (1 downto 0) -- stado que le llega al display
        );
    end component;
    
    component display
        port(
            estado       : in STD_LOGIC_VECTOR (1 downto 0);                           
            monedero     : in STD_LOGIC_VECTOR (7 downto 0);
            producto     : in STD_LOGIC_VECTOR (3 downto 0);
            clk          : in STD_LOGIC;
            posicion_led : out STD_LOGIC_VECTOR (7 downto 0);               
            codigo_led   : out STD_LOGIC_VECTOR(6 downto 0);
            done         : out STD_LOGIC
        );
    end component;

signal salida_trata : std_logic_vector (3 downto 0);
signal enable_fsm_mon : std_logic;
signal cuenta_monedero : std_logic_vector(7 downto 0);
signal producto_elegido: std_logic_vector (3 downto 0);
signal producto_fsm_to_motor : std_logic_vector (3 downto 0);
signal done_out_select: std_logic;
signal done_out_motor: std_logic;

begin

    insta_tratamientoseniales:
        tratamientoseniales port map( input => monedas_in, output=> salida_trata,clk => CLK  );
    insta_monedero :
        monedero  port map(
            clk=> CLK,
            reset => RESET,
            enable=> enable_fsm_mon,
            cent100=> salida_trata(3),
            cent50=> salida_trata(2),
            cent20=> salida_trata(1),
            cent10=> salida_trata(0),
            count=> cuenta_monedero
        );

    insta_Selector_producto:
        Selector_producto port map(
            productos=>product_sel,
            producto=> producto_elegido,
            done=>done_out_select
        );
        
     insta_motor_salida:
        motor_salida port map(
            producto=> producto_fsm_to_motor,
            motor=> motor_leds,     
            done=> done_out_motor
        );
end Behavioral;
