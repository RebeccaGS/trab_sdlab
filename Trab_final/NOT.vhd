-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia
-- NOT em uma ALU


-- Entidade
entity NOT is
    port (
      A: in STD_LOGIC_VECTOR (3 downto 0);
      Z   : out STD_LOGIC_VECTOR (3 downto 0)
    ) ;
  end NOT;
    
-- Arquitetura
architecture behavioral_not of NOT is
    begin
      z <= (not A);
end behavioral_not ;
  
    