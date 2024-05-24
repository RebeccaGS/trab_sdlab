-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia
-- Main da ULA - VHDL

-- criando entidade da ULA
entity ALU is
    port (
        operation : in  std_logic_vector(2 downto 0); -- Controle da nossa ULA 
        A : in  std_logic_vector(3 downto 0);
        B : in  std_logic_vector(3 downto 0);
        OP: in  std_logic_vector(2 downto 0);
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


    -- chamando os componentes das operações lógico-aritméticas
    component FULL_ADDER_4BITS is
        port (
            A, B : in  STD_LOGIC_VECTOR(3 downto 0);
            Cin : in STD_LOGIC;
            Sum : out STD_LOGIC_VECTOR(3 downto 0);
            Cout : out STD_LOGIC
        );
    end component;
    
    component complement_2 is
        port (
            A         : in  STD_LOGIC_VECTOR(3 downto 0); -- A0 A1 A2 A3
            Z         : out STD_LOGIC_VECTOR(3 downto 0);
        );
    end component;

    component subtrator is
        port (
            A, B      : in  STD_LOGIC_VECTOR(3 downto 0); -- A0 A1 A2 A3
            Z         : out STD_LOGIC_VECTOR(3 downto 0);
        );
    end component;

    component shifter_left is
        port (
            A         : in  STD_LOGIC_VECTOR(3 downto 0); -- A: entrada
            -- Q: quantidade de deslocamentos, quero até 3 deslocamentos para fazer o multiplicador 4 bits
            Q         : in  STD_LOGIC_VECTOR(1 downto 0); -- 2 bits de deslocamento (de (00: 0) a (11: 3) deslocamentos)
            Z         : out STD_LOGIC_VECTOR(3 downto 0); -- Z: saída
        );
    end component;
    
    component multiplier is
        port (
            A, B      : in  STD_LOGIC_VECTOR(3 downto 0); -- A e B: entradas
            Z         : out STD_LOGIC_VECTOR(7 downto 0); -- Z: saída com 8 casas
        );
    end component;
    


    
    -- Definindo sinais e criando variáveis de saída
    signal Z0,Z1,Z2,Z3,Z4,Z5,Z6,Z7: STD_LOGIC_VECTOR (3 downto 0);
    signal Cout, Bout: STD_LOGIC;


    -- designando operações com suas respectivas saídas
    begin
        module_AND: AND port map (A,B,Z0);
        module_OR: OR port map (A,B,Z1);
        module_NOT: NOT port map (A,Z2);
        module_FULL_ADDER_4BITS: FULL_ADDER_4BITS port map (A,B,'0',Z3,Cout);
        module_complement_2: complement_2 port map (A,Z4);
        module_subtrator: subtrator port map (A,B,Z5);
        module_shifter_left: shifter_left port map (A,B,Z6);
        module_multiplier: multiplier port map (A,B,Z7);


    -- Criando processo e designando entradas no controle da ULA com as saídas das respectivas operações
    P1: process(operation, A, B)
----------------------------------------------------------------------------------------
-- [ESSA OPERAÇÃO SEI Q PRECISA FAZER POR PRECISAR LIGAR A ENTRADA DE CONTROLE COM A RESPECTIVA
-- [DUVIDA: PRECISA DO PROCESSO? ENTRADAS DA ULA TEM OP, NE SO BOTAR IF OP = 000, SAIDA = Z?
-- SAÍDA TIPO 000 É Z0 PQ EU COLOQUEI Q É O AND, 001 É Z1 PQ COLOQUEI Q É O OR, MAS NAO SEI SE A SINTASE TA CERTA
    begin
        if (operation = "000") then -- AND
            Z <= Z0;
        elsif (operation = "001") then -- OR
            Z <= Z1;
        elsif (operation = "010") then -- NOT
            Z <= Z2;
        elsif (operation = "011") then -- soma
            Z <= Z3;
        elsif (operation = "001") then -- complemento de 2
            Z <= Z4;
        elsif (operation = "010") then -- subtrator
            Z <= Z5;
        elsif (operation = "011") then -- shifter left
            Z <= Z6;
        elsif (operation = "001") then -- multiplier
            Z <= Z7;

        end if;
    end process P1;    

    
end Behavioral;