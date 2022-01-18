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
signal clk       :  std_logic:='0';
signal producto  :  STD_LOGIC_VECTOR (3 downto 0);
signal done      :  std_logic;  
--------------------------------------------------------------- 
constant tiempo: time := 1 sec;                                  -- Tiempo de espera para la simulación 
---------------------------------------------------------------
begin

  
    uut: Selector_producto port map(          ---------------------- Unidad bajo testeo 
        productos => productos,
        clk => clk ,
        producto => producto,
        done => done
    );
    
 ---------------------------------------------------------------
    clk <= not clk after 100 ns;                                  -- Asinación del reloj 
---------------------------------------------------------------
    process
    begin
        productos <= "0001";                                      -- Asignación producto 1 
        wait for tiempo;
        productos <= "0000";                                      -- Asignación erronea 
        wait for tiempo;
        productos <= "0010";                                      -- Asignación producto 2 
        wait for tiempo;
        productos <= "0100";                                      -- Asignación producto 3 
        wait for tiempo;
        productos <= "1000";                                      -- Asignación producto 4 
        wait for tiempo;
        
        assert FALSE
        report "Fin Simulación ok"
        severity failure;
        
    end process; 
    
end Behavioral;
