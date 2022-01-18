library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Este modulo se encarga de simular la seleccion del producto por la persona 
-- Para seleccionar el producto se debe activar el switch correspondiente

entity Selector_producto is
    Port ( 
        productos : in STD_LOGIC_VECTOR (3 downto 0);               -- Entrada del producto seleccionada mediante el switch
        clk       : in std_logic;                                   -- Reloj que gobierna el funcionamiento del modulo
        producto  : out STD_LOGIC_VECTOR (3 downto 0);              -- Salida del producto seleccionado 
        done      : out std_logic                                   -- Salida de control para la fsm
    );
end Selector_producto;


architecture Behavioral of Selector_producto is
begin
       process(clk) 
       begin
                if rising_edge(clk) then -------------------------------- dependiendo del producto seleccionado se pasa a la señal de salida 
                    done <= '0';
                    case productos is
        
                            when "0001" => producto <= "0001";
                                           done <= '1';
                                           
                            when "0010" => producto <= "0010";
                                           done <= '1';
                                           
                            when "0100" => producto <= "0100";
                                           done <= '1';
                                           
                            when "1000" => producto <= "1000";
                                           done <= '1';
                                           
                            when others => producto <= "0000";
                                           done <= '0';
                    end case;
                end if;
                
        end process;
end Behavioral;