-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia
-- XNOR em uma ALU


-- Entidade
entity XNOR is
    port (
      A, B: in STD_LOGIC_VECTOR (3 downto 0);
      Z   : out STD_LOGIC_VECTOR (3 downto 0)
    ) ;
  end XNOR;
  
  -- Arquitetura
architecture behavioral_xnor of XNOR is -- main of XNOR is
    signal X, Y: std_logic;
    begin
    x <= A and B;
    Y <= (not A) and (not B);
    Z <= X or Y;
  end behavioral_xnor ;

  -- A   B   X   Y   Z
  -- 0   0   0   1   1
  -- 0   1   0   0   0
  -- 1   0   0   0   0
  -- 1   1   1   0   1

