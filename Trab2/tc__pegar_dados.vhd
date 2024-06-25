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
entity pegar_dados is
   port (
      sinal_clock, sinal_reset: in  std_logic;
      dados_teclado, clock_teclado: in  std_logic;  -- key data, key clock
      receptor_on: in std_logic; -- habilita o receptor
      final_recebimento: out  std_logic; -- indica quando um byte de dados foi completamente recebido.
      dados_saida: out std_logic_vector(7 downto 0)
   );
end pegar_dados;



-- ARQUITETURA
architecture Behavioral of pegar_dados is
   type statetype is (idle, dps, load); -- statetype: Tipo enumerado que define os estados da máquina de estados (idle, dps, load).
   signal estado_atual, estado_prox: statetype; -- Registradores de estado atual e próximo estado.
   signal filter_reg, filter_next: std_logic_vector(7 downto 0);
   signal f_clock_teclado_reg,f_clock_teclado_next: std_logic;
   signal b_reg, b_next: std_logic_vector(10 downto 0);
   signal n_reg,n_next: unsigned(3 downto 0);
   signal fall_edge: std_logic;
begin
   --=================================================
   -- filter and falling edge tick generation for clock_teclado
   --=================================================
   process (sinal_clock, sinal_reset)
   begin
      if sinal_reset='1' then
         filter_reg <= (others=>'0');
         f_clock_teclado_reg <= '0';
      elsif (sinal_clock'event and sinal_clock='1') then
         filter_reg <= filter_next;
         f_clock_teclado_reg <= f_clock_teclado_next;
      end if;
   end process;

   filter_next <= clock_teclado & filter_reg(7 downto 1);
   f_clock_teclado_next <= '1' when filter_reg="11111111" else
                  '0' when filter_reg="00000000" else
                  f_clock_teclado_reg;
   fall_edge <= f_clock_teclado_reg and (not f_clock_teclado_next);

   --=================================================
   -- fsmd to extract the 8-bit data
   --=================================================
   -- registers
   process (sinal_clock, sinal_reset)
   begin
      if sinal_reset='1' then
         estado_atual <= idle;
         n_reg  <= (others=>'0');
         b_reg <= (others=>'0');
      elsif (sinal_clock'event and sinal_clock='1') then
         estado_atual <= estado_prox;
         n_reg <= n_next;
         b_reg <= b_next;
      end if;
   end process;
   -- next-state logic
   process(estado_atual,n_reg,b_reg,fall_edge,receptor_on,dados_teclado)
   begin
      final_recebimento <='0';
      estado_prox <= estado_atual;
      n_next <= n_reg;
      b_next <= b_reg;
      case estado_atual is
         when idle =>
            if fall_edge='1' and receptor_on='1' then
               -- shift in start bit
               b_next <= dados_teclado & b_reg(10 downto 1);
               n_next <= "1001";
               estado_prox <= dps;
            end if;
         when dps =>  -- 8 data + 1 pairty + 1 stop
            if fall_edge='1' then
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
            final_recebimento <='1';
      end case;
   end process;
   -- output
   dados_saida <= b_reg(8 downto 1); -- data bits
end Behavioral;