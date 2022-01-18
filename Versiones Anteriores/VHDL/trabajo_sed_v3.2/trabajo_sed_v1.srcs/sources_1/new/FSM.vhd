----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.01.2022 11:19:26
-- Design Name: 
-- Module Name: FSM - Behavioral
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

entity FSM is
    Port (
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
end FSM;

architecture Behavioral of FSM is
    type STATES is(S0,S1,S2,S3);
    signal current_state : STATES := S0;
    signal next_state: STATES;
    signal reset_monedero_out : std_logic:= '1';
   -- signal greater : std_logic;
    --signal lower   : std_logic;
    --signal equal   : std_logic;
begin
    state_register:
        process(RESET,CLK)
        begin
            if RESET ='0' then
                current_state  <= S0;
            elsif rising_edge (CLK) then
                   current_state <= next_state;
            end if;
        end process ;
   
     nextstate_code:
         process(current_state,monedero_in,select_product_in)
         begin
                next_state <= current_state ;
                case current_state is
                    when S0 => 
                              if select_done = '1' then
                                    state <= "00";
                                    select_product_out <= select_product_in;
                                    if display_done = '1' then
                                        next_state <= S1;
                                    end if;
                              end if;
                    when S1 => 
                              monedero_out <= monedero_in;
                              if (monedero_in > "01100100") then
                                   state <= "11";
                                   next_state <= S3;
                              elsif (monedero_in = "01100100")then
                                   state <= "10";
                                   next_state <= S2;
                              elsif (monedero_in < "01100100")then
                                   state <= "01";
                              end if;
                    when S2 =>
                                  state <= "10";
                                  out_motor <= select_product_in;
                                  reset_monedero_out <= '0';
                                  if (motor_done = '1') then
                                       if (display_done='1') then
                                            next_state <= S0;
                                       end if;
                                  end if;
                    when S3 =>
                              state <= "11";
                              reset_monedero_out <= '0';
                              if display_done = '1' then
                                    next_state <= S0;
                              end if;
                end case;
             
         end process;
        reset_monedero <= reset_monedero_out;
                              
end Behavioral;
