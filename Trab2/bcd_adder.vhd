----------------------------------------------------------------------------------
-- UFRJ: Universidade Federal do Rio de Janeiro
-- Professor: João Batista
-- Alunas: Mariana Garcia e Rebecca Simão
-- 
-- Module Name: bcd_adder - Behavioral 
-- Description: Este módulo realiza a soma de dois números BCD de 16 bits,
--              utilizando somadores de dígitos BCD (bcd_digit_adder) em cascata.
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity bcd_adder is
    Port ( 
        A : in  STD_LOGIC_VECTOR (15 downto 0);     -- Primeiro número BCD de 16 bits
        B : in  STD_LOGIC_VECTOR (15 downto 0);     -- Segundo número BCD de 16 bits
        SUM : out  STD_LOGIC_VECTOR (15 downto 0);  -- Saída da soma BCD de 16 bits
        CARRY_OUT : out  STD_LOGIC                  -- Carry-out global
    );
end bcd_adder;


architecture Behavioral of bcd_adder is

    -- Sinais intermediários para armazenar as somas de cada dígito BCD.
    signal digit0_sum, digit1_sum, digit2_sum, digit3_sum : STD_LOGIC_VECTOR(3 downto 0);
    -- Sinais intermediários para armazenar os carry-outs de cada dígito.
    signal carry0, carry1, carry2, carry3 : STD_LOGIC;


    -- Declaração do componente 'bcd_digit_adder' para reutilização no somador.
    component bcd_digit_adder
        Port (
            A : in  STD_LOGIC_VECTOR (3 downto 0);
            B : in  STD_LOGIC_VECTOR (3 downto 0);
            CIN : in STD_LOGIC;
            SUM : out  STD_LOGIC_VECTOR (3 downto 0);
            COUT : out STD_LOGIC
        );
    end component;


begin
    -- Instancia o primeiro somador de dígitos BCD (dígito menos significativo).
    digit0_adder: bcd_digit_adder
        Port map (
            A => A(3 downto 0),
            B => B(3 downto 0),
            CIN => '0',                -- Carry-in inicial é 0
            SUM => digit0_sum,         -- Saída da soma do dígito
            COUT => carry0             -- Carry-out para o próximo dígito
        );
		  
    -- Instancia o segundo somador de dígitos BCD.
    digit1_adder: bcd_digit_adder
        Port map (
            A => A(7 downto 4),
            B => B(7 downto 4),
            CIN => carry0,             -- Carry-in do carry-out anterior
            SUM => digit1_sum,         -- Saída da soma do dígito
            COUT => carry1             -- Carry-out para o próximo dígito
        );
		  
    -- Instancia o terceiro somador de dígitos BCD.
    digit2_adder: bcd_digit_adder
        Port map (
            A => A(11 downto 8),
            B => B(11 downto 8),
            CIN => carry1,             -- Carry-in do carry-out anterior
            SUM => digit2_sum,         -- Saída da soma do dígito
            COUT => carry2             -- Carry-out para o próximo dígito
        );
		  
    -- Instancia o quarto somador de dígitos BCD (dígito mais significativo).
    digit3_adder: bcd_digit_adder
        Port map (
            A => A(15 downto 12),
            B => B(15 downto 12),
            CIN => carry2,             -- Carry-in do carry-out anterior
            SUM => digit3_sum,         -- Saída da soma do dígito
            COUT => carry3             -- Carry-out global
        );
		  
   
        -- Combina as saídas dos somadores de dígitos BCD para formar a soma final.
    SUM <= digit3_sum & digit2_sum & digit1_sum & digit0_sum;
   
    -- Define o carry-out global.
    CARRY_OUT <= carry3;

end Behavioral;
