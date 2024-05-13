-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia
-- Subtrator em uma ALU - VHDL


-- entidade Subtrator
entity subtrator is
    port (
        A, B      : in  STD_LOGIC_VECTOR(3 downto 0); -- A0 A1 A2 A3
        Z         : out STD_LOGIC_VECTOR(3 downto 0);
    );
end entity subtrator;



-- lógica do subtrator utilizando complemento de 2 e o modulo somador
architecture behavioral of subtrator is -- lógica: Z = A + (B em complemento de 2)
    component complement_2 is
        port (
            B         : in  STD_LOGIC_VECTOR(3 downto 0); -- A0 A1 A2 A3
            Z         : out STD_LOGIC_VECTOR(3 downto 0);
        );
    end component complement_2;

------------------------------------------------------------------------------------------------------
------- [VER SE VAI FUNCIONAR, SE NAO: VER SE É PRA COMPLEMENTAR UM A UM complement_2 port map(B(0));
------- [SE AINDA NAO FUNCIONAR PODE SER A CHAMADA DA FUNÇÃO Q TA ERRADA] 
    B2: complement_2 port map(B);

    component full_adder is
        Port (
            A, B, cin : in std_logic;
            sum, cout : out std_logic
        );
    end component;

    signal carry : std_logic_vector(3 downto 0); -- criando carry para ser usado nas somas

    begin -- soma: 
    R0: full_adder port map(A(0), B2(0), '0', Sum(0), carry(0));
    R1: full_adder port map(A(1), B2(1), carry(0), Sum(1), carry(1));
    R2: full_adder port map(A(2), B2(2), carry(1), Sum(2), carry(2));
    R3: full_adder port map(A(3), B2(3), carry(2), Sum(3), cout);

    -- Saída do complemento de dois
    Z <= Sum;

end architecture behavioral;


