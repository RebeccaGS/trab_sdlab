-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia
-- Complemento de 2 em uma ALU - VHDL


-- entidade complemento de 2
entity complement_2 is
    port (
        A         : in  STD_LOGIC_VECTOR(3 downto 0); -- A0 A1 A2 A3
        Z         : out STD_LOGIC_VECTOR(3 downto 0);
    );
end entity complement_2;



-- lógica do complemento de 2 utilizando not e o modulo somador
architecture behavioral of complement_2 is
    component full_adder is
        Port (
            A, B, cin : in std_logic;
            sum, cout : out std_logic
        );
    end component;

    signal carry : std_logic_vector(3 downto 0); -- criando carry para ser usado nas somas

    begin -- soma: not(A3) + 0  ;  not(A2) + 0   ; not(A1) + 0    ; not(A0) + 1;
            -- port map: soma(A , B , carry in) sai (soma, cout)
    R0: full_adder port map(not(A(0)), '1', '0', Sum(0), carry(0));
    R1: full_adder port map(not(A(1)), '0', carry(0), Sum(1), carry(1));
    R2: full_adder port map(not(A(2)), '0', carry(1), Sum(2), carry(2));
    R3: full_adder port map(not(A(3)), '0', carry(2), Sum(3), cout);

    -- Saída do complemento de dois
    Z <= Sum;

end architecture behavioral;


