library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--Este módulo coge una señal sincronizada y devuelve un pulso si detecta un flanco positivo, además tiene código para tratar el ruido.
--El genérico sensibilidad indica cuantos '1' seguidos tienen que ocurrir despues de un 0 para que se considere la señal estable.
--Cuanto mayor es la sensibilidad mayor es la inmunidad ante el ruido pero tambien hay mas retraso desde que se produce el pulso hasta
--que se genera el pulso a la salida.
entity detectorflancos is
    generic(
        sensibilidad:integer :=3);                            -- cuantas muestras se toman para verificar que la señal es estable
    Port ( 
        input   : in STD_LOGIC;                               -- señal de entrada
        output  : out STD_LOGIC;                              -- señal de salida tratada
        clk     : in STD_LOGIC);                              -- reloj que gobierna el módulo
end detectorflancos;

architecture Behavioral of detectorflancos is
begin
---------------------------------------------------------------- proceso sincronizado con el reloj
    process (clk)
        variable aux: std_logic_vector(sensibilidad downto 0);-- vector que recoge las ultimas muestras de la entrada
        variable flag: std_logic:='0';                        -- si es 1 se cumple que la señal tiene solo un vector de '1' despues del ultimo '0'
    begin
        if rising_edge (clk) then
            flag:='0';                                        -- se reinicia el valor de la flag cada tick
            aux:=aux(sensibilidad-1 downto 0) & input;        -- actualizar los ultimos n valores de la señal
            if aux(sensibilidad)='0' then                     -- si el ultimo valor del vector aux es 0 
                flag:='1';                                    -- se pone la flag a 1
                for i in 0 to sensibilidad-1 loop             -- se comprueban el resto de digitos del vector aux
                    if aux(i)='0' then flag:='0';             -- si solo hay '1' la flag sigue en '1' y si no se resetea
                    end if;
                end loop;
            end if;
            output<=flag;                                     -- se asigna el valor del output al de la flag
        end if;
    end process;
end Behavioral;