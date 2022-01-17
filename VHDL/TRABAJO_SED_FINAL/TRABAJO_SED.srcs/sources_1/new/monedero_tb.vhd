library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity monedero_tb is
end monedero_tb;

architecture Behavioral of monedero_tb is
    component monedero port(
              clk     : in std_logic;                   
              reset   : in std_logic;                   
              cent100 : in std_logic;                   
              cent50  : in std_logic;                  
              cent20  : in std_logic;                   
              cent10  : in std_logic;                    
              count: out std_logic_vector(7 downto 0));
    end component;
--------------------------------------------------------------- varibles entradas 
signal cent100 : std_logic:='0';
signal cent50  : std_logic:='0';
signal cent20  : std_logic:='0';
signal cent10  : std_logic:='0';
signal clk     : std_logic:='0';
signal reset   : std_logic:='1';
--------------------------------------------------------------- varibles salida
signal count : std_logic_vector (7 downto 0);
--------------------------------------------------------------- constantes
constant tiempo: time :=100 ns;
begin
---------------------------------------------------------------unidad bajo testeo 

uut: monedero port map(
              clk => clk,                   
              reset => reset,                  
              cent100 => cent100,                    
              cent50 => cent50,                 
              cent20 => cent20,                   
              cent10 => cent10,                  
              count => count);
              
    clk <= not clk after 0.5*tiempo;
    
    process 
    begin   
    
            wait for tiempo;
            cent100 <= '1';
            wait for tiempo;
            reset  <= '0';
            cent100 <= '0';
            wait for tiempo;
            reset  <= '1';
            cent50 <= '1';
            wait for tiempo;
            cent50 <= '0';
            cent20 <= '1';
            wait for tiempo;
            cent20 <= '0';
            cent10 <= '1';
            wait for tiempo;
            cent10 <= '0';
            cent20 <= '1';
            wait for tiempo;
            reset  <= '0';
            cent20 <= '0';
            wait for tiempo;
            reset  <= '1';
            cent100 <= '1';
            wait for tiempo;
            cent100 <= '0';
            cent50 <= '1';
            wait for tiempo;
            
            assert false;
            report "monedero: simulación finalizada."
            severity failure;
    end process ;
        
end Behavioral;
