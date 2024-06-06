----------------------------------------------------------------------------------
-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia
-- 
-- Module Name:    COMPLEMENT_2 - Behavioral 
-- Description: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entidade para o gerador de complemento de 2
entity COMPLEMENT_2 is
    Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
           Z : out  STD_LOGIC_VECTOR (3 downto 0));
end COMPLEMENT_2;

architecture Behavioral of COMPLEMENT_2 is
    -- Declaração do componente FULL_ADDER_4BIT
    component FULL_ADDER_4BIT is
        Port ( A, B : in  STD_LOGIC_VECTOR (3 downto 0);
               Cin : in  STD_LOGIC;
               Sum : out  STD_LOGIC_VECTOR (3 downto 0);
               Cout : out  STD_LOGIC);
    end component;

    -- Sinais auxiliares
    signal not_A : STD_LOGIC_VECTOR (3 downto 0);
    signal Cout : STD_LOGIC;

begin
    -- Inverte os bits de A para obter o complemento de 1
    not_A <= not A;

    -- Adiciona 1 ao complemento de 1 para obter o complemento de 2
    U1: FULL_ADDER_4BIT Port map (not_A, "0001",'0', Z, Cout);
end Behavioral;
