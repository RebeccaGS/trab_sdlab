----------------------------------------------------------------------------------
-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia
-- 
-- Module Name:    MULTIPLIER - Behavioral 
-- Description: Mutiplicador em uma ALU - VHDL
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MULTIPLIER is
    Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           Z : out  STD_LOGIC_VECTOR (3 downto 0)
	 );
end MULTIPLIER;

architecture Behavioral of MULTIPLIER is 

	 component ADDER_1BIT is --Chama full adder 1 bit
        Port (A, B, Cin : in  STD_LOGIC;
              Sum, Cout : out STD_LOGIC
        );
        end component;
	 
    signal Carry0, Carry1, Carry2, Carry3, Carry4, Carry5, Carry6, Sum1, Sum2, Sum3 : STD_LOGIC;
    signal R0, R1, R2, R3, R4, R5, R6, R7, R8 : STD_LOGIC;

begin

    -- PRIMEIRO BIT
    Z(0) <= A(0) and B(0);
    
    -- SEGUNDO BIT
    R0 <= A(1) and B(0);
    R1 <= A(0) and B(1);
	 
    -- TERCEIRO BIT
    R2 <= A(2) and B(0);
    R3 <= A(1) and B(1);
    R4 <= A(0) and B(2);
	 
    -- QUARTO BIT
    R5 <= A(3) and B(0);
    R6 <= A(2) and B(1);
    R7 <= A(1) and B(2);
    R8 <= A(0) and B(3);
    Carry6 <= Carry1 xor Carry2;
	 
	 SOMA1: ADDER_1BIT port map (R0, R1, '0', Z(1), Carry0);
	 
    SOMA2: ADDER_1BIT port map (R2, R3, Carry0, Sum1, Carry1);
    SOMA3: ADDER_1BIT port map (Sum1, R4, '0', Z(2), Carry2);	 
	 
    SOMA4: ADDER_1BIT port map (R5, R6, Carry6, Sum2, Carry3);
    SOMA5: ADDER_1BIT port map (Sum2, R7, '0', Sum3, Carry4);
    SOMA6: ADDER_1BIT port map (Sum3, R8, '0', Z(3), Carry5);

end Behavioral;
			