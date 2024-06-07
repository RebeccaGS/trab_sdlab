-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia
-- Transformar clock da placa em 2segundos - VHDL

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Entidade
entity CLK is
    port (
        clock_O   : in std_logic;
        clock_f  : out std_logic
        ) ;
end clk;

-- Arquitetura
architecture behavioral of CLK is --
    signal aux : integer;
    begin
    process(clock_O)
    begin
        if (rising_edge(clock_O) )then
        -- o clock interno da placa possui freq de 50MHz.
        -- VamosS multiplicar seu periodo por
        -- 100 milhoes para ter um periodo de 2 segundos
            if(aux = 100000000 ) then -- variavel auxiliar vai de zero ate 100 milhoes e volta
                aux<=0;
            else
                aux <= aux + 1;
            end if;
        
            if(aux >= 50000000) then -- metado do tempo ela ta em high, metade em low
                clock_f <='1';
            else
                clock_f <='0';
            end if;
        end if;
    end process;

end architecture;
   