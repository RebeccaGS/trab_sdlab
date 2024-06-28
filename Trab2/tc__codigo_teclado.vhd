----------------------------------------------------------------------------------
-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia 
-- 
-- Module Name:    
-- Description: pega a informação do teclado pelo pegar_dados ->
-- escreve na armazena_fifo -> pega no traduz_ascii e une tudo no codigo_teclado para gerenciar essa operação
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LogicAND is
    Port ( A : in  STD_LOGIC_VECTOR (3 downto 0); -- 4 bits: A0 A1 A2 A3
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           Z : out  STD_LOGIC_VECTOR (3 downto 0));
end LogicAND;

architecture Behavioral of LogicAND is

begin

	Z <= A and B;

end Behavioral;