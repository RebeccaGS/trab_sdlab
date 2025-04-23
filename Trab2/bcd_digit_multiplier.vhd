----------------------------------------------------------------------------------
-- UFRJ: Universidade Federal do Rio de Janeiro
-- Professor: João Batista
-- Alunas: Mariana Garcia e Rebecca Simão
-- 
-- Module Name: bcd_digit_multiplier - Behavioral 
-- Description: Este módulo realiza a multiplicação de dois dígitos BCD (Binary-Coded Decimal).
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bcd_digit_multiplier is
    Port ( 
        A : in  STD_LOGIC_VECTOR (3 downto 0);  -- Primeiro dígito BCD
        B : in  STD_LOGIC_VECTOR (3 downto 0);  -- Segundo dígito BCD
        Z : out  STD_LOGIC_VECTOR (15 downto 0) -- Produto em formato BCD de 16 bits
    );
end bcd_digit_multiplier;


architecture Behavioral of bcd_digit_multiplier is

begin
    -- Processo principal que realiza a multiplicação BCD.
    process(A, B)

        -- Variável para armazenar o produto binário intermediário de 8 bits.
        variable product_bin : UNSIGNED(7 downto 0);

        -- Variáveis para armazenar as unidades e dezenas em formato BCD.
        variable tens : UNSIGNED(3 downto 0);
        variable unit : UNSIGNED(3 downto 0);

    begin
        -- Multiplicação binária dos dígitos BCD.
        product_bin := unsigned(A) * unsigned(B);

        -- Separar o produto em dígitos das unidades e dezenas.
        unit := product_bin(3 downto 0);
        tens := product_bin(7 downto 4);

        -- Corrigir unidades se necessário.
        if unit > 9 then
            unit := unit + 6;  -- Adiciona 6 para corrigir para BCD.
            tens := tens + 1;  -- Propaga carry para dezenas.
        end if;
		  
        -- Corrigir dezenas se necessário.
        if tens > 9 then
            tens := tens + 6;  -- Adiciona 6 para corrigir para BCD.
        end if;

        -- Concatenar dígitos corrigidos para o produto final em BCD.
        Z <= "00000000" & std_logic_vector(tens & unit);

    end process;
end Behavioral;
