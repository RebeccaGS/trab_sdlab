----------------------------------------------------------------------------------
-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia 


-- Description:

-- Ele recebe o sinal do teclado, processa os dados recebidos e gera a saída correspondente ao scan code.

-- Quando pressionamos uma tecla no teclado:
-- 1. Controlador do teclado recebe um sinal elétrico que avisa que houve uma ação;
-- 2. Um “Scan_code”  - código de varredura - específico para cada tecla pressionada é gerado e enviado para o SO (Sistema Operacional) da placa;
-- 3. Scan_code é traduzido no SO para código em ASCII
-- 4. Código Ascii é traduzido para o que é pertinente de ser utilizado.

----------------------------------------------------------------------------------

-- BIBLIOTECAS
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- ENTIDADE
entity tc_pegar_dados is
   port (
      sinal_clock, sinal_reset: in  std_logic; -- info placa
      dados_teclado, clock_teclado: in  std_logic; -- info teclado
      receptor_on: in std_logic;
      final_recebimento: out  std_logic; -- indica quando um byte de dados foi completamente recebido.
      dados_saida: out std_logic_vector(7 downto 0) -- scanCode
   );
end tc_pegar_dados;



-- ARQUITETURA
architecture Behavioral of tc_pegar_dados is
    -----------------------------------------------------------------------------------------------------------------
    -- 1) Inicializando o código definindo seus 3 estados

    -- estados da máquina para gerenciar o processo de recepção de 1 byte de dados do teclado.
    -- idle: (Ocioso) - nada detectado;
    -- dps: (Data Processing State) - Neste estado, os bits de dados estão sendo recebidos do teclado. Processa os 8 bits de dados, 1 bit de paridade e 1 bit de parada.
    -- load: (Carregamento) - receptor confirma que um byte completo de dados foi recebido e está pronto para ser usado
    type statetype is (idle, dps, load); 
    
    signal estado_atual, estado_prox: statetype; -- Registradores de estado atual e próximo estado.
    signal filtro_reg, filtro_prox: std_logic_vector(7 downto 0); -- Registradores de filtro para o sinal do clock do teclado.
    signal f_clock_teclado_reg,f_clock_teclado_prox: std_logic; -- sinal filtrado de clock
    signal b_reg, b_next: std_logic_vector(10 downto 0); -- Registradores para os bits recebidos.
    signal n_reg,n_next: unsigned(3 downto 0); -- Contador para os bits que faltam receber.
    signal descida_clk: std_logic; --  Detecta a borda de descida do clock (falling edge)

    
    

    begin    
    ------------------------------------------------------------------------------------------------------------------
    -- 2) Filtragem do clock: suavizar ruidos para que estado so mude de "idle" (ocioso) em mudanças estaveis do clock

    process (sinal_clock, sinal_reset)
    begin
        if sinal_reset='1' then -- Reseta o histórico do sinal de clock do teclado.
            filtro_reg <= (others=>'0'); 
            f_clock_teclado_reg <= '0';
        elsif (sinal_clock'event and sinal_clock='1') then -- Atualiza o histórico do sinal de clock do teclado.
            filtro_reg <= filtro_prox;   
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


    -------------------------------------------------------------------------------------------------------------------
    -- 3) Em cada ciclo de clock, os registradores são atualizados com os próximos estados.
    process (sinal_clock, sinal_reset)
    begin
        if sinal_reset='1' then
            estado_atual <= idle; -- zera tudo
            n_reg  <= (others=>'0'); -- num de bits 0
            b_reg <= (others=>'0'); -- bits 0
        elsif (sinal_clock'event and sinal_clock='1') then -- se teve clock
            estado_atual <= estado_prox; -- estado atual vira estado_prox
            n_reg <= n_next;
            b_reg <= b_next;
        end if;
    end process;

    --------------------------------------------------------------------------------------------------------------------
    -- 4) Lógica de transição dos Estados Idle, dps e load
    process(estado_atual,n_reg,b_reg,descida_clk,receptor_on,dados_teclado)
    begin
        final_recebimento <='0';
        estado_prox <= estado_atual;
        n_next <= n_reg; 
        b_next <= b_reg;
        case estado_atual is
            when idle => -- No estado idle, se houver uma borda de descida (fall_edge) e receptor estiver habilitado, começa a receber dados.
                if descida_clk='1' and receptor_on='1' then
                    b_next <= dados_teclado & b_reg(10 downto 1);
                    n_next <= "1001";
                    estado_prox <= dps;
                end if;
            when dps => -- No estado dps (recepção de dados), desloca os bits recebidos para b_reg e decrementa n_reg até que todos os bits sejam recebidos.
                if descida_clk='1' then
                    b_next <= dados_teclado & b_reg(10 downto 1); -- desloca bits recebidos b_reg 
                if n_reg = 0 then -- quando n bits (que faltam a ser lidos) for 0, passa pra load
                    estado_prox <=load;
                else
                    n_next <= n_reg - 1; -- decrementa num de bits ate n bits for 0
                    end if;
                end if;
            when load => -- No estado load, o dado recebido é considerado completo.
                estado_prox <= idle;
                final_recebimento <='1';
        end case;
    end process;

    -------------------------------------------------------------------------------------------------------------------------
    -- 5) saida scanCode
    dados_saida <= b_reg(8 downto 1); -- 1 byte
    
end Behavioral;