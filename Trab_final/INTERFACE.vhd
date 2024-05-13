-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia
-- Interface da ALU - VHDL


-- entidade interface
entity interface is
    port (
        clock     : in std_logic; -- 
        A, B      : in  STD_LOGIC_VECTOR(3 downto 0);
        Op        : out STD_LOGIC_VECTOR(2 downto 0);
    );
end interface;


