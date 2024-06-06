----------------------------------------------------------------------------------
-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia
-- 
-- Module Name:    SUBTRACTOR - Behavioral 
-- Description: Subtrator em uma ALU - VHDL
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SUBTRACTOR is
    Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           Z : out  STD_LOGIC_VECTOR (3 downto 0));
end SUBTRACTOR;

architecture Behavioral of SUBTRACTOR is

    -- lógica: Z = A + (B em complemento de 2)
    component COMPLEMENT_2 is
        Port (
            B : in  STD_LOGIC_VECTOR (3 downto 0); -- Entrada
            Z : out STD_LOGIC_VECTOR (3 downto 0)  -- Saída
        );
    end component;


    -- Declaração do componente FULL_ADDER_4BIT
    component FULL_ADDER_4BIT is
        Port ( A, B : in  STD_LOGIC_VECTOR (3 downto 0);
                Cin : in  STD_LOGIC;
                Sum : out  STD_LOGIC_VECTOR (3 downto 0);
                Cout : out  STD_LOGIC);
    end component;

    signal B2 : STD_LOGIC_VECTOR (3 downto 0); -- Saída do complemento de 2 de B

begin

    -- Instância do complemento de 2
    comp2: complement_2 port map(
        B => B,
        Z => B2
    );

	-- Instâncias do full adder para realizar a soma
    U1: FULL_ADDER_4BIT Port map (A, B2,'0', Z, Cout);

end Behavioral;