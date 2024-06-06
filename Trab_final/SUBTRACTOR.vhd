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

    component ADDER_1BIT is
        port (
			  A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           Cin : in  STD_LOGIC;
           Sum : out  STD_LOGIC;
           Cout : out  STD_LOGIC);
    end component;


    signal B2 : STD_LOGIC_VECTOR (3 downto 0); -- Saída do complemento de 2 de B
    signal carry : STD_LOGIC_VECTOR (3 downto 0); -- Sinal carry para ser usado nas somas
    signal Sum : STD_LOGIC_VECTOR (3 downto 0); -- Sinal de soma

begin

    -- Instância do complemento de 2
    comp2: complement_2 port map(
        B => B,
        Z => B2
    );

	    -- Instâncias do full adder para realizar a soma
    R0: ADDER_1BIT port map(A(0), B2(0), '0', Sum(0), carry(0));
    R1: ADDER_1BIT port map(A(1), B2(1), carry(0), Sum(1), carry(1));
    R2: ADDER_1BIT port map(A(2), B2(2), carry(1), Sum(2), carry(2));
    R3: ADDER_1BIT port map(A(3), B2(3), carry(2), Sum(3), carry(3));

    -- Atribui a soma ao sinal de saída Z
    Z <= Sum;

end Behavioral; 