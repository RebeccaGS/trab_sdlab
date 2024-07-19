library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bcd_digit_multiplier is
    Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           Z : out  STD_LOGIC_VECTOR (15 downto 0));
end bcd_digit_multiplier;

   architecture Behavioral of bcd_digit_multiplier is

begin
 
    process(A, B)
	  variable product_bin : UNSIGNED(7 downto 0);
     variable tens : UNSIGNED(3 downto 0);
     variable unit : UNSIGNED(3 downto 0);
	 
    begin
        -- Multiplicação binária
        product_bin := unsigned(A) * unsigned(B);

        -- Separar produto em dígitos das unidades e dezenas
        unit := product_bin(3 downto 0);
        tens := product_bin(7 downto 4);

        -- Corrigir unidades se necessário
        if unit > 9 then
            unit := unit + 6; -- Adiciona 6 para corrigir para BCD
				tens := tens + 1; -- Propaga carry para dezenas
        end if;
		  

        -- Corrigir dezenas se necessário
        if tens > 9 then
            tens := tens + 6; -- Adiciona 6 para corrigir para BCD
        end if;

        -- Concatenar dígitos corrigidos para o produto final em BCD
        Z <= "00000000" & std_logic_vector(tens & unit);
    end process;

end Behavioral;