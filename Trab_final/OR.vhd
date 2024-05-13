-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia
-- OR em uma ALU


-- Entidade
entity OR is
    port (
      A, B: in STD_LOGIC_VECTOR (3 downto 0);
      Z   : out STD_LOGIC_VECTOR (3 downto 0)
    ) ;
end OR;
    
-- Arquitetura
architecture behavioral_OR of OR is
    begin
      z <= A or B;
end behavioral_OR ;
  
    