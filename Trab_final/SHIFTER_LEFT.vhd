-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia
-- Deslocador em uma ALU - VHDL


-- entidade deslocador para esquerda
entity shifter_left is
    port (
        A         : in  STD_LOGIC_VECTOR(3 downto 0); -- A: entrada
        -- Q: quantidade de deslocamentos, quero até 3 deslocamentos para fazer o multiplicador 4 bits
        Q         : in  STD_LOGIC_VECTOR(1 downto 0); -- 2 bits de deslocamento (de (00: 0) a (11: 3) deslocamentos)
        Z         : out STD_LOGIC_VECTOR(3 downto 0); -- Z: saída
    );
end entity shifter_left;

-- arquitetura do deslocador
architecture Behavioral of shifter_left is
    begin
    -- Criando processo para ligar a quantidade de deslocamentos e a entrada a com sua respectiva saída
------------------------------------------------------------------------------------------------------
-- COMO NA MAIN EU NAO SEI SE A SINTASE DO PROCESS TA CERTA
    P1: process(Q, A, Z)
        begin
            if (Q = "00") then -- 0 deslocamentos
                Z <= A;
            elsif (Q = "01") then -- 1 deslocamentos
                Z <= '0' & A(3 downto 1);
            elsif (Q = "10") then -- 2 deslocamentos
                Z <= '00' & A(3 downto 2);
            elsif (Q = "11") then -- 3 deslocamentos
                Z <= '000' & A(3);
            end if;
    end process P1; 
end Behavioral;
