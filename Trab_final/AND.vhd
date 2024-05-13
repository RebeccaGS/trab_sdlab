-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia
-- AND em uma ALU - VHDL


-- Entidade
entity AND is
  port (
    A, B: in STD_LOGIC_VECTOR (3 downto 0); -- 4 bits: A0 A1 A2 A3
    Z   : out STD_LOGIC_VECTOR (3 downto 0)
  ) ;
end AND;
  
-- Arquitetura
architecture behavioral_and of AND is
  begin
    z <= A and B;
end behavioral_and ;

  