----------------------------------------------------------------------------------
-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia 
-- 
-- Module Name:    
-- Description: pega a informação do teclado pelo pegar_dados ->
-- escreve na armazena_fifo -> pega no traduz_ascii e une tudo no codigo_teclado para gerenciar essa operação
--
----------------------------------------------------------------------------------

-- BIBLIOTECAS
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- ENTIDADE
entity tc_codigo_teclado is
	generic(largura_endereco_tamanho:integer:=1);
    port (
        sinal_clock, sinal_reset: in  std_logic;
        dados_teclado, clock_teclado: in  std_logic;
        receptor_enable: in std_logic;
        final_recebimento_byte: out  std_logic;
        dados_saida: out std_logic_vector(7 downto 0)
    );
end tc_codigo_teclado;



-- ARQUITETURA
architecture Behavioral of  tc_codigo_teclado is
    constant BRK: std_logic_vector(7 downto 0):="11110000"; --  Código de break (F0).
    type statetype is (wait_brk, get_code); -- arquivo possui uma pequena máquina com dois estados wait_brk e get_code para implementar a lógica principal
    signal estado_atual, estado_prox: statetype; -- Sinais para estado atual e próximo da FSM.
    signal scan_out, dados_entrada: std_logic_vector(7 downto 0); -- Sinais para dados de saída do scanner e dados a serem escritos na FIFO.
    signal scan_done_tick, got_code_tick: std_logic; -- conclusão da recepção de um byte de dados e que um código foi obtido.
    signal key_code: std_logic_vector(7 downto 0); -- Código da tecla.
    -- scan_done_tick que está ligado ao sinal de finalização do receptor e administra o got_code_tick que se comunica com o bit de escrita da fifo.


    -- Definição de Componentes a serem usados
    component tc_pegar_dados is
        port (
        sinal_clock, sinal_reset: in  std_logic;
        dados_teclado, clock_teclado: in  std_logic;
        receptor_enable: in std_logic; -- habilita o receptor
        final_recebimento_byte: out  std_logic; -- indica quando um byte de dados foi completamente recebido.
        dados_saida: out std_logic_vector(7 downto 0)
        );
    end component;


    component tc_traduz_ascii is
        port (
            tecla_entrada: in std_logic_vector(7 downto 0); -- código da tecla recebida do teclado.
            tecla_ascii: out std_logic_vector(7 downto 0) -- código ASCII correspondente à tecla pressionada.
        );
    end component;


    component tc_armazena_fifo is
            generic(
                largura_dados: natural:=8;
                largura_endereco: natural:=4);
    
            port(
                dados_entrada: in std_logic_vector (largura_dados-1 downto 0);
                leitura, escrita: in std_logic;
                sinal_clock, sinal_reset: in std_logic;
                fila_vazia, fila_cheia: out std_logic;
                dados_saida: out std_logic_vector (largura_dados-1 downto 0));

    end component;


    begin
    -- instancia dentro da arquitetura
    -- <nome entidade>: <nome do arquivo> port map (variavel original => novo valor/nome, ...);

    -- receptor do teclado sempre com enable = 1
    pegar_dados: tc_pegar_dados port map (
        sinal_clock=>sinal_clock, 
        sinal_reset=>sinal_reset, 
        receptor_enable=>'1',
        dados_teclado=>dados_teclado, 
        clock_teclado=>clock_teclado,
        final_recebimento_byte=>scan_done_tick,
        dados_saida=>scan_out
    );


    armazena_fifo: tc_armazena_fifo 
    generic map (
        largura_dados=>8,
        largura_endereco=>largura_endereco_tamanho
    )
    port map(
        sinal_clock => sinal_clock,
        sinal_reset => sinal_reset,
        leitura => leitura_key_code,
        escrita => got_code_tick,
        fila_vazia => kb_buf_fila_vazia,
        fila_cheia => open,
        dados_entrada => scan_out,
        dados_saida => key_code
    );


    traduz_ascii: tc_traduz_ascii port map(
        tecla_entrada: in std_logic_vector(7 downto 0); -- código da tecla recebida do teclado.
        tecla_ascii: out std_logic_vector(7 downto 0)
    );
            
    -------------------------------------------------------------------------------        
    process (sinal_clock, sinal_reset)
    begin
        if sinal_reset='1' then
            estado_atual <= wait_brk;
        elsif (sinal_clock'event and sinal_clock='1') then
            estado_atual <= estado_prox;
        end if;
    end process;

    process(estado_atual, scan_done_tick, scan_out)
    begin
        got_code_tick <='0';
        estado_prox <= estado_atual;
        case estado_atual is
            when wait_brk => -- wait for F0 of break code
                if scan_done_tick='1' and scan_out=BRK then
                estado_prox <= get_code;
                end if;
            when get_code => -- get the following scan code
                if scan_done_tick='1' then
                got_code_tick <='1';
                estado_prox <= wait_brk;
                end if;
        end case;
    end process;

end Behavioral;