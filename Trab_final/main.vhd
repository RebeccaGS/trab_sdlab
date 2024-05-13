-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia
-- Main da ULA - VHDL

-- criando entidade da ULA
entity ALU is
    port (
        operation : in  std_logic_vector(2 downto 0); -- Controle da nossa ULA 
        A : in  std_logic_vector(3 downto 0);
        B : in  std_logic_vector(3 downto 0);
        Z : out std_logic_vector(3 downto 0)
    );
end ALU;


-- Arquitetura da ULA
architecture Behavioral of ULA is
    
    -- chamando os componentes das portas
    component AND is
        port (
            A, B: in STD_LOGIC_VECTOR (3 downto 0);
            Z   : out STD_LOGIC_VECTOR (3 downto 0)
          ) ;
    end component;

    component OR is
        port (
            A, B: in STD_LOGIC_VECTOR (3 downto 0);
            Z   : out STD_LOGIC_VECTOR (3 downto 0)
          ) ;
    end component;
    
    component NOT is
        port (
            A: in STD_LOGIC_VECTOR (3 downto 0);
            Z   : out STD_LOGIC_VECTOR (3 downto 0)
          ) ;
    end component;

    component XNOR is
        port (
            A, B: in STD_LOGIC_VECTOR (3 downto 0);
            Z   : out STD_LOGIC_VECTOR (3 downto 0)
          ) ;
    end component;
    
    
    -- chamando os componentes das operações lógico-aritméticas


    
    -- Definindo sinais e criando variáveis de saída
    signal Z0,Z1,Z2,Z3,Z4,Z5,Z6,Z7: STD_LOGIC_VECTOR (3 downto 0);
    signal Cout, Bout: STD_LOGIC;


    -- designando operações com suas respectivas saídas
    begin
        my_AND: AND port map (A,B,Z0);
        my_OR: OR port map (A,B,Z1);
        my_NOT: NOT port map (A,Z2);
        my_XNOR: XNOR port map (A,B,Z3);


    -- Criando processo e designando entradas no controle da ULA com as saídas das respectivas operações
    P1: process(operation, A, B)
    begin
        if (operation = "000") then -- AND
            Z <= Z0;
        elsif (operation = "001") then -- OR
            Z <= Z1;
        elsif (operation = "010") then -- NOT
            Z <= Z2;
        elsif (operation = "011") then -- XNOR
            Z <= Z3;
  
        end if;
    end process P1;    

    
end Behavioral;