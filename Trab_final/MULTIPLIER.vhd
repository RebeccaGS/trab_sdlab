-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia
-- Mutiplicador em uma ALU - VHDL


-- entidade multiplicador
entity multiplier is
    port (
        A, B      : in  STD_LOGIC_VECTOR(3 downto 0); -- A e B: entradas
        Z         : out STD_LOGIC_VECTOR(7 downto 0); -- Z: saída com 8 casas
    );
end entity multiplier;

-- arquitetura do multiplicador
architecture Behavioral of multiplier is    
    begin
        -- definindo A como número fixo e Z como 0 0 0 0 B3 B2 B1 B0
        -- No deslocamento fica: A3 A2 A1 A0 e R R R R R B3 B2 B1
        Z <= '0000' & B(3 downto 1);
        -- criar loop para ver sempre ultimo bit de b (0 a 3 vezes: 4 vezes)
        -- nesse loop, colocar: se b(0) = 0 -> desloca Z: Z <= '0' & Z(7 downto i)
        -- Loop para calcular a multiplicação
        for i in 0 to 3 loop        
            if (Z(0) = 0) then
                Z <= '00';
            end if;
        end loop;
end Behavioral;























entity multiplicador is
    Port (
        a : in std_logic_vector(3 downto 0); -- multiplicando de 4 bits
        b : in std_logic_vector(3 downto 0); -- multiplicador de 4 bits
        resultado : out std_logic_vector(7 downto 0) -- resultado de 8 bits
    );
end multiplicador;

architecture Behavioral of multiplicador is
begin
    process(a, b)
        variable multiplicacao : std_logic_vector(7 downto 0);
    begin
        -- Inicializa a multiplicação com 0
        multiplicacao := (others => '0');
        
        -- Loop para calcular a multiplicação
        for i in 0 to 3 loop
            -- Se o bit do multiplicador for 1, soma o multiplicando ao resultado
            if b(i) = '1' then
                multiplicacao := std_logic_vector(unsigned(multiplicacao) + unsigned(a) * 2**i);
            end if;
        end loop;

        -- Atribui o resultado ao sinal de saída
        resultado <= multiplicacao;
    end process;
end Behavioral;
