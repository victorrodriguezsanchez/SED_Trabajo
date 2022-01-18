library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Este testbench se encarga de simular el modulo Selector_producto 

entity Selector_producto_tb is
end Selector_producto_tb;

architecture Behavioral of Selector_producto_tb is
    component  Selector_producto port(                          -- componente motor salida y sus variables
            productos : in STD_LOGIC_VECTOR (3 downto 0);       -- Entrada del producto seleccionada mediante el switch
            clk       : in std_logic;                           -- Reloj que gobierna el funcionamiento del modulo
            producto  : out STD_LOGIC_VECTOR (3 downto 0);      -- Salida del producto seleccionado
            done      : out std_logic                           -- Salida de control para la fsm
    );
    end component ;
--------------------------------------------------------------- varibles auxiliares  
signal productos :  STD_LOGIC_VECTOR (3 downto 0);
signal clk       :  std_logic;
signal producto  :  STD_LOGIC_VECTOR (3 downto 0);
signal done      :  std_logic;  
--------------------------------------------------------------- 
constant tiempo: time := 1000 ns;                                  -- Tiempo de espera para la simulaci�n 
---------------------------------------------------------------
begin
---------------------------------------------------------------
    clk <= not clk after 100 ns;                                  -- Asinaci�n del reloj 
---------------------------------------------------------------
  
    uut: Selector_producto port map(          ---------------------- Unidad bajo testeo 
        productos => productos,
        clk => clk ,
        producto => producto,
        done => done
    );
    
    process
    begin
        productos <= "0001";                                      -- Asignaci�n producto 1 
        wait for tiempo;
        productos <= "0000";                                      -- Asignaci�n erronea 
        wait for tiempo;
        productos <= "0010";                                      -- Asignaci�n producto 2 
        wait for tiempo;
        productos <= "0100";                                      -- Asignaci�n producto 3 
        wait for tiempo;
        productos <= "1000";                                      -- Asignaci�n producto 4 
        wait for tiempo;
        
    end process; 
    
end Behavioral;
