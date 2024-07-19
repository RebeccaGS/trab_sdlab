library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ENTIDADE
entity tc_traduz_ascii is
    port (
        tecla_entrada: in std_logic_vector(7 downto 0); -- código da tecla recebida do teclado.
        tecla_bcd: out std_logic_vector(3 downto 0)     -- código BCD correspondente à tecla pressionada.
    );
end tc_traduz_ascii;

-- ARQUITETURA
architecture Behavioral of tc_traduz_ascii is
    signal tecla_ascii: std_logic_vector(7 downto 0);
begin
    -- Conversão dos códigos de tecla para códigos ASCII:
    with tecla_entrada select
        tecla_ascii <=
            --   ascii           teclado
            "00110000" when "01000101",  -- 0
            "00110001" when "00010110",  -- 1
            "00110010" when "00011110",  -- 2
            "00110011" when "00100110",  -- 3
            "00110100" when "00100101",  -- 4
            "00110101" when "00101110",  -- 5
            "00110110" when "00110110",  -- 6
            "00110111" when "00111101",  -- 7
				 "00111000" when "00111110",  -- 8
            "00111001" when "01000110",  -- 9
            "00001101" when "01011010",  -- (enter, cr)
            "00101010" when others;      -- *

    -- Conversão de ASCII para BCD:
    process(tecla_ascii)
    begin
	  case tecla_ascii is
            when "00110000" => tecla_bcd <= "0000"; -- 0
            when "00110001" => tecla_bcd <= "0001"; -- 1
            when "00110010" => tecla_bcd <= "0010"; -- 2
            when "00110011" => tecla_bcd <= "0011"; -- 3
            when "00110100" => tecla_bcd <= "0100"; -- 4
            when "00110101" => tecla_bcd <= "0101"; -- 5
            when "00110110" => tecla_bcd <= "0110"; -- 6
				when "00110111" => tecla_bcd <= "0111"; -- 7
            when "00111000" => tecla_bcd <= "1000"; -- 8
            when "00111001" => tecla_bcd <= "1001"; -- 9
            when others => tecla_bcd <= "1111";     -- Valor inválido ou especial
        end case;
    end process;
end Behavioral;