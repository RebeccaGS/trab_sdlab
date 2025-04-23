----------------------------------------------------------------------------------
-- UFRJ: Universidade Federal do Rio de Janeiro
-- Professor: João Batista
-- Alunas: Mariana Garcia e Rebecca Simão
-- 
-- Module Name: bcd_digit_adder - Behavioral 
-- Description: Este módulo realiza a soma de dois dígitos BCD (Binary-Coded Decimal).
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bcd_digit_adder is
    Port (
        A : in  STD_LOGIC_VECTOR (3 downto 0);       -- Primeiro dígito BCD de 4 bits
        B : in  STD_LOGIC_VECTOR (3 downto 0);       -- Segundo dígito BCD de 4 bits
        CIN : in STD_LOGIC;                          -- Carry-in 
        SUM : out  STD_LOGIC_VECTOR (3 downto 0);    -- Saída da soma de 4 bits
        COUT : out STD_LOGIC                         -- Carry-out 
    );
end bcd_digit_adder;


architecture Behavioral of bcd_digit_adder is

begin
    -- Processo principal que realiza a soma BCD.
    process (A, B)
        -- Variável temporária para armazenar a soma intermediária com 5 bits.
        variable temp_sum : STD_LOGIC_VECTOR(4 downto 0);
        -- Variável para armazenar a soma ajustada (se necessário) de 4 bits.
        variable adjusted_sum : STD_LOGIC_VECTOR(3 downto 0);
        -- Variável para armazenar o carry.
        variable carry : STD_LOGIC;


    begin
        -- Realiza a soma inicial incluindo o carry-in.
        temp_sum := ("0" & A) + ("0" & B) + ("0000" & CIN);
        carry := '0';  -- Inicializa o carry como '0'.
        
        -- Verifica se a soma excede 9 (maior valor BCD).
        if temp_sum > "01001" then
            -- Se exceder, ajusta a soma adicionando 6 (0110).
            adjusted_sum := temp_sum(3 downto 0) + "0110";
            carry := '1';  -- Seta o carry como '1'.
        else
            -- Caso contrário, a soma ajustada é a soma inicial.
            adjusted_sum := temp_sum(3 downto 0);
        end if;
        
        -- Atualiza as saídas SUM e COUT com os valores calculados.
        SUM <= adjusted_sum;
        COUT <= carry;

    
    end process;
end Behavioral;
