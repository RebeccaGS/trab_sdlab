----------------------------------------------------------------------------------
-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia
-- 
-- Module Name:    FULL_ADDER_4BIT - Behavioral  
-- Description: Somador completo de 4 bits em uma ALU - VHDL  
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FULL_ADDER_4BITS is
    port (
        A, B : in  STD_LOGIC_VECTOR(3 downto 0);
        Cin : in STD_LOGIC;
        Sum : out STD_LOGIC_VECTOR(3 downto 0);
        Cout : out STD_LOGIC
    );
end entity FULL_ADDER_4BITS;

architecture Behavioral of FULL_ADDER_4BITS is
    
	 component ADDER_1BIT --Chama full adder 1 bit
        port (
            A, B, Cin : in  std_logic;
            Sum, Cout : out std_logic
        );
    end component;

    signal carry : std_logic_vector(3 downto 0);
	 
    begin
    -- Instanciando full adders para cada bit
    R0 : ADDER_1BIT port map(A(0), B(0), Cin, Sum(0), carry(0)); -- usa 4 somadores de 1 bit para realizar a lógica da soma
    R1 : ADDER_1BIT port map(A(1), B(1), carry(0), Sum(1), carry(1));
    R2 : ADDER_1BIT port map(A(2), B(2), carry(1), Sum(2), carry(2));
    R3 : ADDER_1BIT port map(A(3), B(3), carry(2), Sum(3), Cout);
	 
end Behavioral;