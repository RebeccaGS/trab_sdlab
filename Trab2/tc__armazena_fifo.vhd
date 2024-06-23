----------------------------------------------------------------------------------
-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia 
-- 
-- Module Name:  armazena_fifo   
-- Description:  armazena os dados
--
----------------------------------------------------------------------------------

-- BIBLIOTECAS
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ENTIDADE
entity armazena_fifo is
    Port ( 
        -- Como genericos, as variaveis: B (8 bits) e W (4 bits)
        generic(
            B: natural:=8; -- number of bits
            W: natural:=4 -- number of address bits
        );

        port(
        -- Entradas:
        -- escrever_dados, leitura, escrita, sinal do clock, sinal de reset
            escrever_dados: in std_logic_vector (B-1 downto 0);
            leitura, escrita: in std_logic;
            sinal_clock, sinal_reset: in std_logic;
        -- Saidas:
        -- vazio, cheio e ler_dados
            vazio, cheio: out std_logic;
            ler_dados: out std_logic_vector (B-1 downto 0)
        );
    );
end armazena_fifo;



-- ARQUITETURA
architecture Behavioral of armazena_fifo is

    type reg_file_type is array (2**W-1 downto 0) of std_logic_vector(B-1 downto 0);
    signal array_reg: reg_file_type;
    signal w_ptr_reg, w_ptr_next, w_ptr_succ:
    std_logic_vector(W-1 downto 0);
    signal r_ptr_reg, r_ptr_next, r_ptr_succ:
    std_logic_vector(W-1 downto 0);
    signal cheio_reg, vazio_reg, cheio_next, vazio_next:
    std_logic;
    signal escrita_op: std_logic_vector(1 downto 0);
    signal escrita_en: std_logic;
    
    begin
        -- cria processo sensivel ao sinal do clock e do reset
        process(sinal_clock,sinal_reset)
        begin
            -- se reset for apertado, entao zera tudo
            if (sinal_reset='1') then
                array_reg <= (others=>(others=>'0'));
            -- se clock for alterado para 1 entao dentro da nossa variavel sera escrita o conteudo de w_ptr_reg
            elsif (sinal_clock'event and sinal_clock='1') then
                if escrita_en='1' then
                    array_reg(to_integer(unsigned(w_ptr_reg))) <= escrever_dados;
                end if;
            end if;
        end process;



        -- ler dados recebe o valor armazenado
        ler_dados <= array_reg(to_integer(unsigned(r_ptr_reg)));
        -- escrita autorizada quando fifo nao ta cheio
        escrita_en <= escrita and (not cheio_reg);
    

        
        -- cria processo sensivel ao sinal do clock e do reset
        process(sinal_clock,sinal_reset)
        begin
            -- se reset ativo, apaga tudo e coloca o vazio como 1 (pra indicar que reg ta vazio)
            if (reset='1') then
                w_ptr_reg <= (others=>'0');
                r_ptr_reg <= (others=>'0');
                cheio_reg <= '0';
                vazio_reg <= '1';
            -- se clock alterado e igual a 1 entoo estado de escrita, leitura, cheio e vazio alterado para proximo
            elsif (sinal_clock'event and sinal_clock='1') then
                w_ptr_reg <= w_ptr_next;
                r_ptr_reg <= r_ptr_next;
                cheio_reg <= cheio_next;
                vazio_reg <= vazio_next;
            end if;
        end process;
    
        -- successive pointer values
        w_ptr_succ <= std_logic_vector(unsigned(w_ptr_reg)+1);
        r_ptr_succ <= std_logic_vector(unsigned(r_ptr_reg)+1);
    
        -- next-state logic for read and escritaite pointers
        escrita_op <= escrita & leitura;
        process(w_ptr_reg,w_ptr_succ,r_ptr_reg,r_ptr_succ,escrita_op,vazio_reg,cheio_reg)
        
        begin
        -- prox estado assume valor de atual
        w_ptr_next <= w_ptr_reg; 
        r_ptr_next <= r_ptr_reg;
        cheio_next <= cheio_reg;
        vazio_next <= vazio_reg;

        -- casos de escrita:
        -- se 00 nao rola operacao
        -- se 01, le
        -- se 10, escreve
        -- se 11, [COMPLETAR]-----------------------------------------------------------------------
        case escrita_op is
            when "00" =>
            when "01" =>
                if (vazio_reg /= '1') then -- not vazio
                    r_ptr_next <= r_ptr_succ;
                    cheio_next <= '0';
                    if (r_ptr_succ=w_ptr_reg) then
                    vazio_next <='1';
                    end if;
                end if;
            when "10" => 
                if (cheio_reg /= '1') then -- not cheio
                    w_ptr_next <= w_ptr_succ;
                    vazio_next <= '0';
                    if (w_ptr_succ=r_ptr_reg) then
                    cheio_next <='1';
                    end if;
                end if;
            when others =>
                w_ptr_next <= w_ptr_succ;
                r_ptr_next <= r_ptr_succ;
        end case;
        end process;
        -- saidas cheio e vazio recebem valores de cheio_reg e vazio_reg
        cheio <= cheio_reg;
        vazio <= vazio_reg;

end Behavioral;




