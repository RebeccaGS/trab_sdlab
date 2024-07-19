----------------------------------------------------------------------------------
-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia 
-- 
-- Module Name:    
-- Description: converte ascii para linguagem de teclado
--
----------------------------------------------------------------------------------

-- BIBLIOTECAS
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


-- ENTIDADE
entity display_traduz_BCD is
    Port ( ascii : in STD_LOGIC_VECTOR (7 downto 0);
           BCD : out STD_LOGIC_VECTOR (3 downto 0));
end display_traduz_BCD;




-- ARQUITETURA
architecture Behavioral of display_traduz_BCD is

    begin
        with ascii select
            BCD <=
            -- transforma em BCD 0000 quando ascii eh 00110000 e assim por diante
                "0000" when "00110000", -- 0 
                "0001" when "00110001", -- 1
                "0010" when "00110010", -- 2
                "0011" when "00110011", -- 3
                "0100" when "00110100", -- 4
                "0101" when "00110101", -- 5
                "0110" when "00110110", -- 6
                "0111" when "00110111", -- 7
                "1000" when "00111000", -- 8
                "1001" when "00111001" -- 9;

end Behavioral;