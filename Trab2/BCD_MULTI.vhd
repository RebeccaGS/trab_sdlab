library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bcd_multiplier is
    Port (
        A : in  STD_LOGIC_VECTOR (15 downto 0);  -- 4 dígitos BCD
        B : in  STD_LOGIC_VECTOR (15 downto 0);  -- 4 dígitos BCD
        Z : out  STD_LOGIC_VECTOR (31 downto 0)  -- Resultado em BCD (8 dígitos)
    );
end bcd_multiplier;

architecture Behavioral of bcd_multiplier is

    component bcd_digit_multiplier is
        Port (
            A : in  STD_LOGIC_VECTOR (3 downto 0);
            B : in  STD_LOGIC_VECTOR (3 downto 0);
            Z : out  STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    component bcd_digit_adder is
        Port (
            A : in  STD_LOGIC_VECTOR (3 downto 0);
            B : in  STD_LOGIC_VECTOR (3 downto 0);
            CIN : in STD_LOGIC;
            SUM : out  STD_LOGIC_VECTOR (3 downto 0);
            COUT : out STD_LOGIC
        );
    end component;
	 
	 
    -- sinais resultados da multiplicação
    signal mult_result : std_logic_vector(31 downto 0);
	 
	 -- sinais resultados das somas
	 signal adder_sum: std_logic_vector(3 downto 0);
	 signal adder_carry: std_logic;
	 
	 -- sinais resultados do shift 
    signal shifted_result : std_logic_vector(31 downto 0);

    signal SHF00, SHF01, SHF02, SHF03 : STD_LOGIC_VECTOR(31 downto 0);
    signal SHF10, SHF11, SHF12 : STD_LOGIC_VECTOR(31 downto 0);
    signal SHF20, SHF21 : STD_LOGIC_VECTOR(31 downto 0);
    signal SHF30 : STD_LOGIC_VECTOR(31 downto 0);

begin

    -- Instâncias do multiplicador de 4 bits para cada conjunto de 4 dígitos
    gen_mults: for i in 0 to 3 generate
        multiplier_inst : bcd_digit_multiplier
            port map (
                A => A(i*4 + 3 downto i*4),
                B => B(i*4 + 3 downto i*4),
                Z => mult_result(i*8 + 7 downto i*8)
            );
    end generate gen_mults;

    -- Lógica de shift para preparar os resultados para soma
    SHF00 <= mult_result(31 downto 0);                       -- Shift left 00 em nada
    SHF01 <= mult_result(27 downto 0) & "0000";              -- Shift left 01 em 4 bits
    SHF02 <= mult_result(23 downto 0) & "00000000";          -- Shift left 02 em 8 bits
    SHF03 <= mult_result(19 downto 0) & "000000000000";      -- Shift left 03 em 12 bits

    SHF10 <= mult_result(27 downto 0) & "0000";              -- Shift left 10 em 4 bits
    SHF11 <= mult_result(23 downto 0) & "00000000";          -- Shift left 11 em 8 bits
    SHF12 <= mult_result(19 downto 0) & "000000000000";      -- Shift left 12 em 12 bits

    SHF20 <= mult_result(23 downto 0) & "00000000";          -- Shift left 20 em 8 bits
    SHF21 <= mult_result(19 downto 0) & "000000000000";      -- Shift left 21 em 12 bits

    SHF30 <= mult_result(19 downto 0) & "000000000000";      -- Shift left 30 em 12 bits


	shifted_result <= STD_LOGIC_VECTOR(
													unsigned(SHF00)+
													unsigned(SHF01)+
													unsigned(SHF02)+
													unsigned(SHF03)+
													
													unsigned(SHF10)+
													unsigned(SHF11)+
													unsigned(SHF12)+
		
													unsigned(SHF20)+
													unsigned(SHF21)+
													
													unsigned(SHF30));	


--    -- Instâncias dos somadores de dígitos BCD para combinar os resultados
--    gen_adders: for j in 0 to 2 generate
--        adder_inst : bcd_digit_adder
--            port map (
--                A => shifted_result(j*8 + 3 downto j*8),
--                B => shifted_result(j*8 + 7 downto j*8 + 4),
--                CIN => '0',  -- Inicialmente sem carry in
--                SUM => adder_sum,
--                COUT => adder_carry
--            );
--
--        -- Conecta os resultados dos somadores ao resultado final
--        shifted_result((j+1)*8 + 3 downto (j+1)*8) <= adder_sum;
--    end generate gen_adders;
--

    -- Saída final em formato BCD de 32 bits
   Z <= shifted_result;

end Behavioral;