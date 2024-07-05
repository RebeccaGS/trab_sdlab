----------------------------------------------------------------------------------
-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia 
-- 
-- Module Name:    
-- Description: comunicar com o teclado anexado à FPGA e nos entregar os dados enviados por este periférico.
-- Pegamos essas informações em um sinal de saída chamado dados_saida, que é um vetor de 8 bits
--
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia 
-- 
-- Module Name:    
-- Description: comunicar com o teclado anexado à FPGA e nos entregar os dados enviados por este periférico.
-- Pegamos essas informações em um sinal de saída chamado dados_saida, que é um vetor de 8 bits
--
----------------------------------------------------------------------------------

-- BIBLIOTECAS
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- ENTIDADE
entity tc__pegar_dados is
   port (
      sinal_clock, sinal_reset: in  std_logic;
      dados_teclado, clock_teclado: in  std_logic;
      receptor_enable: in std_logic; -- habilita o receptor
      final_recebimento_byte: out  std_logic; -- indica quando um byte de dados foi completamente recebido.
      dados_saida: out std_logic_vector(7 downto 0)
   );
end tc__pegar_dados;



-- ARQUITETURA
architecture Behavioral of tc__pegar_dados is
    -- estados da máquina para gerenciar o processo de recepção de dados do teclado. FSM (máquina de estados finitos)
    -- idle: (Ocioso) - estado inicial e de espera da FSM - receptor está aguardando para detectar o início da transmissão de dados do teclado.
    -- dps: (Data Processing State) - Neste estado, os bits de dados estão sendo recebidos do teclado. dps processa os 8 bits de dados, 1 bit de paridade e 1 bit de parada.
    -- load: (Carregamento) - estado final em que o receptor confirma que um byte completo de dados foi recebido e está pronto para ser usado
    type statetype is (idle, dps, load);
    
    signal estado_atual, estado_prox: statetype; -- Registradores de estado atual e próximo estado.
    signal filtro_reg, filtro_prox: std_logic_vector(7 downto 0); -- Registradores de filtro para o sinal do clock do teclado.
    signal f_clock_teclado_reg,f_clock_teclado_prox: std_logic; -- sinal filtrado
    signal b_reg, b_next: std_logic_vector(10 downto 0); -- Registradores para os bits recebidos.
    signal n_reg,n_next: unsigned(3 downto 0); -- Contador para os bits recebidos.
    signal descida_clk: std_logic; --  Detecta a borda de descida do clock (falling edge)
    
    
    begin
    
    -- Filtragem do Sinal de Clock - sensível ao clock e ao reset
    -- busca suavizar ruídos e gerar um tick na borda de descida.



    process (sinal_clock, sinal_reset)
    begin
        if sinal_reset='1' then
            filtro_reg <= (others=>'0'); -- acumula o histórico do sinal de clk do teclado
            f_clock_teclado_reg <= '0';
        elsif (sinal_clock'event and sinal_clock='1') then
            filtro_reg <= filtro_prox; -- acumula o histórico do sinal de clk do teclado
            f_clock_teclado_reg <= f_clock_teclado_prox;
        end if;
    end process;

        -- registrador filtro_reg atua como um filtro de deslocamento, acumulando uma sequência dos últimos 8 valores do sinal do teclado.
    -- filtro_prox é o próximo valor de filtro_reg, obtido deslocando os bits para a direita e adicionando o valor atual do clk teclado na posição mais significativa.
    filtro_prox <= clock_teclado & filtro_reg(7 downto 1);
    f_clock_teclado_prox <= '1' when filtro_reg="11111111" -- será '1' se todos os bits forem '1', indicando que esteve consistentemente alto por 8 ciclos de clock.
        else '0' when filtro_reg="00000000" -- será '0' se todos os bits forem '0'
        else f_clock_teclado_reg; -- caso contrário mantém valor anterior, indicando que clk ainda está transitando ou não está estável.

    -- descida_clk será '1' se f_clock_teclado_reg é '1' (indicando que clk estava alto) e f_clock_teclado_prox é '0' (indicando que clk agora está baixo), detectando assim uma borda de descida.
    descida_clk <= f_clock_teclado_reg and (not f_clock_teclado_prox); -- a borda de descida é detectada comparando o valor atual e o próximo valor de f_clock_teclado_reg 

    
    
    
    
    -- Máquina de Estados para Extrair Dados
    -- Define os registradores para a máquina de estados e os sinais de controle.
    -- Em cada ciclo de clock, os registradores são atualizados com os próximos estados.
    process (sinal_clock, sinal_reset)
    begin
        if sinal_reset='1' then
            estado_atual <= idle; -- zera tudo
            n_reg  <= (others=>'0');
            b_reg <= (others=>'0');
        elsif (sinal_clock'event and sinal_clock='1') then
            estado_atual <= estado_prox;
            n_reg <= n_next;
            b_reg <= b_next;
        end if;
    end process;


    -- Lógica do Próximo Estado
    -- Lógica de transição de estados para a máquina de estados.
    -- No estado idle, se houver uma borda de descida (fall_edge) e rx_en estiver habilitado, começa a receber dados.
    -- No estado dps (recepção de dados), desloca os bits recebidos para b_reg e decrementa n_reg até que todos os bits sejam recebidos.
    -- No estado load, o dado recebido é considerado completo e rx_done_tick é ativado.
    process(estado_atual,n_reg,b_reg,descida_clk,receptor_enable,dados_teclado)
    begin
        final_recebimento_byte <='0';
        estado_prox <= estado_atual;
        n_next <= n_reg;
        b_next <= b_reg;
        case estado_atual is
            when idle =>
                if descida_clk='1' and receptor_enable='1' then
                -- shift in start bit
                b_next <= dados_teclado & b_reg(10 downto 1);
                n_next <= "1001";
                estado_prox <= dps;
                end if;
            when dps =>  -- 8 data + 1 pairty + 1 stop
                if descida_clk='1' then
                b_next <= dados_teclado & b_reg(10 downto 1);
                if n_reg = 0 then
                    estado_prox <=load;
                else
                    n_next <= n_reg - 1;
                end if;
                end if;
            when load =>
                -- 1 extra clock to complete the last shift
                estado_prox <= idle;
                final_recebimento_byte <='1';
        end case;
    end process;


    -- Saída de Dados
    -- Atribui os bits de dados recebidos (b_reg(8 downto 1)) à saída dout.
    dados_saida <= b_reg(8 downto 1); -- data bits
    
end Behavioral;