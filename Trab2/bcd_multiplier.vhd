----------------------------------------------------------------------------------
-- UFRJ: Universidade Federal do Rio de Janeiro
-- Professor: João Batista
-- Alunas: Mariana Garcia e Rebecca Simão
-- 
-- Module Name: bcd_multiplier - Behavioral 
-- Description: Este módulo realiza a multiplicação de dois números BCD de 4 dígitos,
--              utilizando multiplicadores de dígitos BCD (bcd_digit_multiplier) e somadores BCD (bcd_adder).
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bcd_multiplier is
    Port ( 
        A : in  STD_LOGIC_VECTOR (15 downto 0);  -- Primeiro número BCD de 4 dígitos
        B : in  STD_LOGIC_VECTOR (15 downto 0);  -- Segundo número BCD de 4 dígitos
        Z : out  STD_LOGIC_VECTOR (15 downto 0)  -- Resultado em BCD (8 dígitos)
    );
end bcd_multiplier;

architecture Behavioral of bcd_multiplier is

    -- Declaração do componente 'bcd_digit_multiplier'.
    component bcd_digit_multiplier is
        Port (
            A : in  STD_LOGIC_VECTOR (3 downto 0);
            B : in  STD_LOGIC_VECTOR (3 downto 0);
            Z : out  STD_LOGIC_VECTOR (15 downto 0)
        );
    end component;
    
    -- Declaração do componente 'bcd_adder'.
    component bcd_adder is
        Port (
            A : in  STD_LOGIC_VECTOR (15 downto 0);
            B : in  STD_LOGIC_VECTOR (15 downto 0);
            SUM : out  STD_LOGIC_VECTOR (15 downto 0)
        );
    end component;

    -- Sinais para os resultados das multiplicações parciais.
    signal M_parcial00, M_parcial01, M_parcial02, M_parcial03 : STD_LOGIC_VECTOR(15 downto 0);
    signal M_parcial10, M_parcial11, M_parcial12, M_parcial13 : STD_LOGIC_VECTOR(15 downto 0);
    signal M_parcial20, M_parcial21, M_parcial22, M_parcial23 : STD_LOGIC_VECTOR(15 downto 0);
    signal M_parcial30, M_parcial31, M_parcial32, M_parcial33 : STD_LOGIC_VECTOR(15 downto 0);

    -- Sinais para os resultados dos shifts.
    signal SHF00, SHF01, SHF02, SHF03 : STD_LOGIC_VECTOR(15 downto 0);
    signal SHF10, SHF11, SHF12 : STD_LOGIC_VECTOR(15 downto 0);
    signal SHF20, SHF21 : STD_LOGIC_VECTOR(15 downto 0);
    signal SHF30 : STD_LOGIC_VECTOR(15 downto 0);
    
    -- Sinais para os resultados das somas.
    signal Z0, Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8 : STD_LOGIC_VECTOR(15 downto 0);
    
    -- Separando A e B em dígitos individuais.
    signal A0, A1, A2, A3 : STD_LOGIC_VECTOR(3 downto 0);
    signal B0, B1, B2, B3 : STD_LOGIC_VECTOR(3 downto 0);
    
begin

    -- Separando os dígitos de A.
    A0 <= A(3 downto 0);
    A1 <= A(7 downto 4);
    A2 <= A(11 downto 8);
    A3 <= A(15 downto 12);

    -- Separando os dígitos de B.
    B0 <= B(3 downto 0);
    B1 <= B(7 downto 4);
    B2 <= B(11 downto 8);
    B3 <= B(15 downto 12);

    -- Realizando todas as multiplicações parciais.
    BLOCO_0 : bcd_digit_multiplier port map(A0, B0, M_parcial00);
    BLOCO_1 : bcd_digit_multiplier port map(A0, B1, M_parcial01);
    BLOCO_2 : bcd_digit_multiplier port map(A0, B2, M_parcial02);
    BLOCO_3 : bcd_digit_multiplier port map(A0, B3, M_parcial03);
    BLOCO_4 : bcd_digit_multiplier port map(A1, B0, M_parcial10);
    BLOCO_5 : bcd_digit_multiplier port map(A1, B1, M_parcial11);
    BLOCO_6 : bcd_digit_multiplier port map(A1, B2, M_parcial12);
    BLOCO_7 : bcd_digit_multiplier port map(A1, B3, M_parcial13);
    BLOCO_8 : bcd_digit_multiplier port map(A2, B0, M_parcial20);
    BLOCO_9 : bcd_digit_multiplier port map(A2, B1, M_parcial21);
    BLOCO_10 : bcd_digit_multiplier port map(A2, B2, M_parcial22);
    BLOCO_11 : bcd_digit_multiplier port map(A2, B3, M_parcial23);
    BLOCO_12 : bcd_digit_multiplier port map(A3, B0, M_parcial30);
    BLOCO_13 : bcd_digit_multiplier port map(A3, B1, M_parcial31);
    BLOCO_14 : bcd_digit_multiplier port map(A3, B2, M_parcial32);
    BLOCO_15 : bcd_digit_multiplier port map(A3, B3, M_parcial33);

    -- Lógica de shift para preparar os resultados para soma.
    SHF00 <= M_parcial00;
    SHF01 <= M_parcial01(11 downto 0) & "0000";
    SHF02 <= M_parcial02(7 downto 0) & "00000000";
    SHF03 <= M_parcial03(3 downto 0) & "000000000000";
    SHF10 <= M_parcial10(11 downto 0) & "0000";
    SHF11 <= M_parcial11(7 downto 0) & "00000000";
    SHF12 <= M_parcial12(3 downto 0) & "000000000000";
    SHF20 <= M_parcial20(7 downto 0) & "00000000";
    SHF21 <= M_parcial21(3 downto 0) & "000000000000";
    SHF30 <= M_parcial30(3 downto 0) & "000000000000";

    -- Lógica de soma para combinar os resultados dos shifts.
    SOMA_1 : bcd_adder port map(SHF00, SHF01, Z0);
    SOMA_2 : bcd_adder port map(Z0, SHF02, Z1);
    SOMA_3 : bcd_adder port map(Z1, SHF03, Z2);
    SOMA_4 : bcd_adder port map(Z2, SHF10, Z3);
    SOMA_5 : bcd_adder port map(Z3, SHF11, Z4);
    SOMA_6 : bcd_adder port map(Z4, SHF12, Z5);
    SOMA_7 : bcd_adder port map(Z5, SHF20, Z6);
    SOMA_8 : bcd_adder port map(Z6, SHF21, Z7);
    SOMA_9 : bcd_adder port map(Z7, SHF30, Z8);

    -- Saída do resultado BCD de 4 dígitos.
    Z <= Z8(15 downto 0);

end Behavioral;
