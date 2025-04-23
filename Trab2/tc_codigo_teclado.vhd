----------------------------------------------------------------------------------
-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia 
-- 
-- Module Name: tc_codigo_teclado
-- Description: Este módulo pega a informação do teclado usando pegar_dados,
--              armazena na armazena_fifo, e traduz os dados com traduz_ascii.
--
----------------------------------------------------------------------------------

-- BIBLIOTECAS
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ENTIDADE
entity tc_codigo_teclado is
    generic(largura_endereco_tamanho: integer := 1); -- Largura do endereço configurável
    port (
        sinal_clock, sinal_reset: in  std_logic; -- Sinais de clock e reset
        dados_teclado, clock_teclado: in  std_logic; -- Sinais do teclado
        receptor_on: in std_logic; -- Habilita o receptor
        final_recebimento_byte: out  std_logic; -- Indica o final do recebimento de um byte
        dados_saida: out std_logic_vector(7 downto 0) -- Dados de saída
    );
end tc_codigo_teclado;

-- ARQUITETURA
architecture Behavioral of  tc_codigo_teclado is
    constant BRK: std_logic_vector(7 downto 0) := "11110000"; -- Código de break (F0)
    type statetype is (wait_brk, get_code); -- Definição dos estados da FSM
    signal estado_atual, estado_prox: statetype; -- Sinais para estado atual e próximo da FSM
    signal scan_saida, dados_entrada: std_logic_vector(7 downto 0); -- Sinais para dados de saída do scanner e dados a serem escritos na FIFO
    signal dados_encontrados, dados_coletados: std_logic; -- Sinais de conclusão da recepção de dados e de obtenção de um código
    signal tecla_entrada: std_logic_vector(7 downto 0); -- Código da tecla

    -- Definição de Componentes a serem usados
    component tc_pegar_dados is
        port (
            sinal_clock, sinal_reset: in  std_logic;
            dados_teclado, clock_teclado: in  std_logic;
            receptor_on: in std_logic; -- Habilita o receptor
            final_recebimento: out  std_logic; -- Indica quando um byte de dados foi completamente recebido
            dados_saida: out std_logic_vector(7 downto 0) -- Dados de saída
        );
    end component;

    component tc_traduz_ascii is
        port (
            tecla_entrada: in std_logic_vector(7 downto 0); -- Código da tecla recebida do teclado
            tecla_bcd: out std_logic_vector(3 downto 0)     -- Código BCD correspondente à tecla pressionada
        );
    end component;

    component tc_armazena_fifo is
        generic(
            largura_dados: natural := 8;
            largura_endereco: natural := 4
        );
        port (
            dados_entrada: in std_logic_vector (largura_dados - 1 downto 0);
            leitura, escrita: in std_logic;
            sinal_clock, sinal_reset: in std_logic;
            fila_vazia, fila_cheia: out std_logic;
            dados_saida: out std_logic_vector (largura_dados - 1 downto 0)
        );
    end component;

begin
    -- Instancia os componentes dentro da arquitetura
    -- <nome_entidade>: <nome_componente> port map (variável_original => novo_valor/nome, ...);

    -- Instância do receptor do teclado sempre com enable = 1
    pegar_dados: tc_pegar_dados port map (
        sinal_clock => sinal_clock, 
        sinal_reset => sinal_reset, 
        receptor_on => '1',
        dados_teclado => dados_teclado, 
        clock_teclado => clock_teclado,
        final_recebimento => dados_encontrados,
        dados_saida => scan_saida
    );

    -- Instância do armazena_fifo
    armazena_fifo: tc_armazena_fifo 
    generic map (
        largura_dados => 8,
        largura_endereco => largura_endereco_tamanho
    )
    port map (
        sinal_clock => sinal_clock,
        sinal_reset => sinal_reset,
        leitura => receptor_on,
        escrita => dados_coletados,
        fila_vazia => final_recebimento_byte,
        fila_cheia => open,
        dados_entrada => scan_saida,
        dados_saida => tecla_entrada
    );

    -- Instância do traduz_ascii
    traduz_ascii: tc_traduz_ascii port map (
        tecla_entrada => tecla_entrada,
        tecla_bcd => dados_saida (3 downto 0)
    );

    -- Processo de controle de estado da FSM
    process (sinal_clock, sinal_reset)
    begin
        if sinal_reset = '1' then
            estado_atual <= wait_brk;
        elsif (sinal_clock'event and sinal_clock = '1') then
            estado_atual <= estado_prox;
        end if;
    end process;

    -- Processo de transição de estados da FSM
    process (estado_atual, dados_encontrados, scan_saida)
    begin
        dados_coletados <= '0';
        estado_prox <= estado_atual;
        case estado_atual is
            when wait_brk => -- Espera pelo código de break (F0)
                if dados_encontrados = '1' and scan_saida = BRK then
                    estado_prox <= get_code;
                end if;
            when get_code => -- Obtém o código de varredura seguinte
                if dados_encontrados = '1' then
                    dados_coletados <= '1';
                    estado_prox <= wait_brk;
                end if;
        end case;
    end process;

end Behavioral;
