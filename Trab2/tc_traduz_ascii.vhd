----------------------------------------------------------------------------------
-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia 
-- 
-- Module Name:    
-- Description: tabela que pega o dado enviado pelo teclado (tecla_entrada) e o converte para ascii (tecla_ascii)
--
----------------------------------------------------------------------------------

-- BIBLIOTECAS
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- ENTIDADE
entity tc_traduz_ascii is
    port (
        tecla_entrada: in std_logic_vector(7 downto 0); -- código da tecla recebida do teclado.
        tecla_ascii: out std_logic_vector(7 downto 0) -- código ASCII correspondente à tecla pressionada.
    );
end tc_traduz_ascii;


-- ARQUITETURA
-- conversão dos códigos de tecla para códigos ASCII:
architecture Behavioral of tc_traduz_ascii is
    begin
    with tecla_entrada select
        tecla_ascii <=
        -- saida eh isso >quando< entrada do teclado for aquilo, -- num correspondente
        --   ascii           teclado
            "00110000" when "01000101",  -- 0
            "00110001" when "00010110",  -- 1
            "00110010" when "00011110",  -- 2
            "00110011" when "00100110",  -- 3
            "00110100" when "00100101",  -- 4
            "00110101" when "00101110",  -- 5
            "00110110" when "00110110",  -- 6
            "00110111" when "00111101",  -- 7
            "00111000" when "00111110",  -- 8
            "00111001" when "01000110",  -- 9

            "00001101" when "01011010",  -- (enter, cr)
            "00101010" when others;      -- *
end Behavioral;