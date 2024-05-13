-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia
-- Somador completo em uma ALU


-- Entidade somador 1 bits
entity full_adder is
    port (
        A, B, Cin : in  std_logic;
        Sum, Cout : out std_logic
    );
end entity full_adder;

-- lógica do somador 1 bit
architecture behavioral of full_adder is
begin
    Sum <= A xor B xor Cin;
    Cout <= (A and B) or (Cin and (A xor B));
end architecture behavioral;


------
-- Entidade somador 4 bits
entity FULL_ADDER_4BITS is
    port (
        A, B : in  STD_LOGIC_VECTOR(3 downto 0);
        Cin : in STD_LOGIC;
        Sum : out STD_LOGIC_VECTOR(3 downto 0);
        Cout : out STD_LOGIC
    );
end entity FULL_ADDER_4BITS;

-- lógica do somador 4 bits - utiliza 4 somadores de 1 bit e vai passando os carrys para calcular soma
architecture behavioral_ADDER of full_adder_4bit is
    component full_adder --Chama full adder 1 bit
        port (
            A, B, Cin : in  std_logic;
            Sum, Cout : out std_logic
        );
    end component full_adder;

    signal carry : std_logic_vector(3 downto 0);

    begin
    -- Instanciando full adders para cada bit
    R0 : full_adder port map(A(0), B(0), Cin, Sum(0), carry(0)); -- usa 4 somadores de 1 bit para realizar a lógica da soma
    R1 : full_adder port map(A(1), B(1), carry(0), Sum(1), carry(1));
    R2 : full_adder port map(A(2), B(2), carry(1), Sum(2), carry(2));
    R3 : full_adder port map(A(3), B(3), carry(2), Sum(3), Cout);
    -- Resultado em SUM e carry final em cout
    -- não considerada possibilidade de overflow conforme direcionamento
end architecture behavioral_ADDER;
