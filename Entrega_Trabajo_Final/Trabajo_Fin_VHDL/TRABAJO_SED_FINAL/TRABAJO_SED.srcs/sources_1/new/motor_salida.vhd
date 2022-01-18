library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Este modulo se encarga de simular el motor de la maquina expendedora mientras nos dá el producto 
-- Dependiendo del producto seleccionado se encederá uno de los leds de la placa un determinado teimpo 
entity motor_salida is
    Port ( 
            producto : in STD_LOGIC_VECTOR (3 downto 0);            -- LLegada del producto seleccionado
            clk      : in std_logic;                                -- Reloj que gobierna el funcionamiento del modulo 
            motor    : out STD_LOGIC_VECTOR (3 downto 0)            -- Salida por los leds
          );
end motor_salida;

architecture Behavioral of motor_salida is
begin
       process(clk)
       begin
                if rising_edge (clk) then  
                    case producto is -------------------------------- dependiendo del producto seleccionado se enciende su correspondiente led
                        when "0001" => motor <= "0001";                       
                        when "0010" => motor <= "0010";                   
                        when "0100" => motor <= "0100";         
                        when "1000" => motor <= "1000";
                        when others => motor <= "0000";
                    end case;
                end if;
                
         end process;
end Behavioral;