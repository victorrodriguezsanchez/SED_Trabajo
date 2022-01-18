library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Este testbench se encarga de simular el modulo motor_salida

entity motor_salida_tb is
end motor_salida_tb;

architecture Behavioral of motor_salida_tb is
    component motor_salida port(                                -- componente motor salida y sus variables
            producto : in STD_LOGIC_VECTOR (3 downto 0);        -- LLegada del producto seleccionado
            clk      : in std_logic;                            -- Reloj que gobierna el funcionamiento del modulo
            motor    : out STD_LOGIC_VECTOR (3 downto 0)        -- Salida por los leds
    );
    end component;
--------------------------------------------------------------- varibles auxiliares  
  
signal producto : STD_LOGIC_VECTOR (3 downto 0);
signal motor    : STD_LOGIC_VECTOR (3 downto 0); 
signal clk      : std_logic:='0';

---------------------------------------------------------------
constant tiempo: time :=3 sec;                                  -- Tiempo de espera para la simulaci�n 
---------------------------------------------------------------

begin
---------------------------------------------------------------
    clk <= not clk after 100 ns;                                  -- Asignaci�n del reloj 
--------------------------------------------------------------- 
   
    uut : motor_salida port map (           ---------------------- Unidad bajo testeo 
            producto => producto ,
            clk => clk,
            motor => motor
    );

    process
    begin
        producto <= "0001";                                     -- Asignaci�n producto 1 
        wait for tiempo;
        producto <= "0000";                                     -- Asignaci�n erronea 
        wait for tiempo;
        producto <= "0010";                                     -- Asignaci�n producto 2
        wait for tiempo;
        producto <= "0100";                                     -- Asignaci�n producto 3
        wait for tiempo;
        producto <= "1000";                                     -- Asignaci�n producto 4
        wait for tiempo;
        
        assert FALSE
        report "Fin Simulaci�n ok"
        severity failure;
    end process; 

end Behavioral;
