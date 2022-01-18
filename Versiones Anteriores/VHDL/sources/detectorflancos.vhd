library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity detectorflancos is
    Port ( 
        input   : in STD_LOGIC;                 -- se�al de entrada
        output  : out STD_LOGIC;                -- se�al de salida tratada
        clk     : in STD_LOGIC);                -- reloj que gobierna el m�dulo
end detectorflancos;

architecture Behavioral of detectorflancos is
-------------------------------------------------- variables del sistema
    signal aux: std_logic_vector (3 downto 0);
begin
-------------------------------------------------- proceso sincronizado con el reloj
    process (clk)
    begin
        if rising_edge (clk) then
            aux<=aux(2 downto 0) & input;       -- actualizar los �ltimos 4 valores de la se�al
        end if;
    end process;
-------------------------------------------------- parte para comprobar que la se�al es estable y positiva
    with aux select
        output <=   '1' when "0111",            -- si los �ltimos 3 valores han sido 1 y el 4 ha sido 0 devuelve 1 a la salida
                    '0' when others;            -- esto se hace para generar un solo tick a la salida en vez de 1 mientras la entrada valga 1
end Behavioral;
