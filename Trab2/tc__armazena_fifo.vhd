----------------------------------------------------------------------------------
-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia 
-- 
-- Module Name:  armazena_fifo   
-- Description:  Este código VHDL implementa uma FIFO usando uma combinação de memória de registros e lógica de controle. 
-- Os ponteiros de leitura e escrita gerenciam as posições dos dados na FIFO, enquanto os sinais cheio e vazio indicam o 
-- estado da FIFO. O processo é controlado por um sinal de clock e reset, garantindo que as operações sejam sincronizadas 
-- e corretamente gerenciadas.
--
----------------------------------------------------------------------------------

-- BIBLIOTECAS
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ENTIDADE
entity armazena_fifo is
    Port ( 
        -- Como genericos, as variaveis: largura_dados (8 bits) e largura_endereco (4 bits)
        -- variáveis genéricas em um port map são usadas para parametrizar componentes,
        -- permitindo que diferentes instâncias de um componente possam ter diferentes
        -- características sem a necessidade de redefinir o componente em si.
        generic(
            largura_dados: natural:=8; -- number of bits
            largura_endereco: natural:=4 -- number of address bits
        );

        port(
        -- Entradas:
        -- dados_entrada, leitura, escrita, sinal do clock, sinal de reset
            dados_entrada: in std_logic_vector (largura_dados-1 downto 0);
            leitura, escrita: in std_logic;
            sinal_clock, sinal_reset: in std_logic;
        -- Saidas:
        -- fila_vazia, fila_cheia e dados_saida
            fila_vazia, fila_cheia: out std_logic;
            dados_saida: out std_logic_vector (largura_dados-1 downto 0)
        );
    );
end armazena_fifo;



-- ARQUITETURA - fifo utiliza de registradores e lógica de controle para armazenar
              -- temporariamente pacotes de dados enquanto eles estão sendo processados
architecture Behavioral of armazena_fifo is

    -- armazenamento da fifo
    type reg_file_type is array (2**largura_endereco-1 downto 0) of std_logic_vector(largura_dados-1 downto 0);
    -- sinal tipo reg_file_type, armazenando dados fifo
    signal array_reg: reg_file_type;
    -- Ponteiros de escrita atuais, próximos e sucessores.
    signal largura_endereco_ptr_reg, largura_endereco_ptr_next, largura_endereco_ptr_succ: std_logic_vector(largura_endereco-1 downto 0);
    -- Ponteiros de leitura atuais, próximos e sucessores.
    signal pont_leitura_0, pont_leitura_prox, pont_leitura_succ: std_logic_vector(largura_endereco-1 downto 0);
    -- Sinais para indicar se a FIFO está cheia ou vazia.
    signal fila_cheia_reg, fila_vazia_reg, fila_cheia_next, fila_vazia_next: std_logic;
    -- Indica a operação de leitura/escrita.
    signal escrita_op: std_logic_vector(1 downto 0);
    -- Habilita a escrita.
    signal escrita_on: std_logic; -- habilita escrita
    
    begin
        -- Cria processo de registro de dados - sensivel ao sinal do clock e do reset
        -- Se reset 1, todos registros zerados; se clk ocorrer e escrita_on tiver ativo,
        -- dados_entrada armazenados na fila na posição indicada por largura_endereco_ptr_reg
        process(sinal_clock,sinal_reset)
        begin
            -- se reset for apertado, entao zera tudo
            if (sinal_reset='1') then
                array_reg <= (others=>(others=>'0'));
            -- se clock for alterado para 1 entao dentro da nossa variavel sera escrita o conteudo de largura_endereco_ptr_reg
            elsif (sinal_clock'event and sinal_clock='1') then
                if escrita_on='1' then
                    array_reg(to_integer(unsigned(largura_endereco_ptr_reg))) <= dados_entrada;
                end if;
            end if;
        end process;



        -- dados_saida recebe o valor armazenado na posicao ponteiro_leitura_0
        dados_saida <= array_reg(to_integer(unsigned(pont_leitura_0)));
        -- escrita autorizada quando sinal de escrita tiver habilitado e fifo nao ta fila_cheia
        escrita_on <= escrita and (not fila_cheia_reg);
    

        
        -- cria processo de controle da fifo - sensivel ao sinal do clock e do reset
        -- atualiza ponteiros de leitura e escrita, além dos sinais fila_cheia_reg e fila_vazia_reg.
        process(sinal_clock,sinal_reset)
        begin
            -- se reset ativo, apaga tudo e coloca o fila_vazia como 1 (pra indicar que reg ta vazio)
            if (reset='1') then
                largura_endereco_ptr_reg <= (others=>'0');
                pont_leitura_0 <= (others=>'0');
                fila_cheia_reg <= '0';
                fila_vazia_reg <= '1';
            -- se clock alterado e igual a 1 entao estado de escrita, leitura, fila_cheia e fila_vazia alterado para proximo
            elsif (sinal_clock'event and sinal_clock='1') then
                largura_endereco_ptr_reg <= largura_endereco_ptr_next;
                pont_leitura_0 <= pont_leitura_prox;
                fila_cheia_reg <= fila_cheia_next;
                fila_vazia_reg <= fila_vazia_next;
            end if;
        end process;
    
        -- Calcula os valores sucessores dos ponteiros de leitura e escrita.
        largura_endereco_ptr_succ <= std_logic_vector(unsigned(largura_endereco_ptr_reg)+1);
        pont_leitura_succ <= std_logic_vector(unsigned(pont_leitura_0)+1);
    


        -- Lógica do Próximo Estado dos ponteiros e dos sinais fila_cheia_next e fila_vazia_next.
        -- escrita_op combina os sinais de leitura e escrita, que serãi usados nos cases.
        escrita_op <= escrita & leitura;
        process(largura_endereco_ptr_reg,largura_endereco_ptr_succ,pont_leitura_0,pont_leitura_succ,escrita_op,fila_vazia_reg,fila_cheia_reg)
        begin
        -- prox estado assume valor de atual
        largura_endereco_ptr_next <= largura_endereco_ptr_reg; 
        pont_leitura_prox <= pont_leitura_0;
        fila_cheia_next <= fila_cheia_reg;
        fila_vazia_next <= fila_vazia_reg;

        -- casos de escrita:
        -- se 00 nao rola operacao
        -- se 01, le
        -- se 10, escreve
        -- se 11, Leitura e escrita simultâneas
        case escrita_op is
            when "00" =>
            when "01" =>
                if (fila_vazia_reg /= '1') then -- not fila_vazia
                    pont_leitura_prox <= pont_leitura_succ;
                    fila_cheia_next <= '0';
                    if (pont_leitura_succ=largura_endereco_ptr_reg) then
                    fila_vazia_next <='1';
                    end if;
                end if;
            when "10" => 
                if (fila_cheia_reg /= '1') then -- not fila_cheia
                    largura_endereco_ptr_next <= largura_endereco_ptr_succ;
                    fila_vazia_next <= '0';
                    if (largura_endereco_ptr_succ=pont_leitura_0) then
                    fila_cheia_next <='1';
                    end if;
                end if;
            when others =>
                largura_endereco_ptr_next <= largura_endereco_ptr_succ;
                pont_leitura_prox <= pont_leitura_succ;
        end case;
        end process;
        -- saidas fila_cheia e fila_vazia recebem valores de fila_cheia_reg e fila_vazia_reg
        fila_cheia <= fila_cheia_reg;
        fila_vazia <= fila_vazia_reg;

end Behavioral;




