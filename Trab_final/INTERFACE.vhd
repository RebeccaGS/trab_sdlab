-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia
-- Interface da ALU - VHDL


-- entidade interface
entity interface is
    port (
        -- ENTRADAS:
        -- Sw seleciona, outros, agregam valor. Exemplo: SW 1001; b_a agrega que isso corresponde a A
        -- Entrada Switch
        Sw                                 : in  STD_LOGIC_VECTOR(3 downto 0);
        -- Entradas de clock (clock da placa), botões: a, b e op para indicar que finalizou-se o processo de definir as variáveis e o botão reset.
        clock, B_A, B_B, B_OP, B_Reset     : in std_logic; -- B_op indica além de: bits correspondem a OP, que é pra iniciar operação.
        
        -- SAÍDAS
        -- LEDS MAIS A ESQUERDA: 1000 (A) --2seg--> 0100 (B) --2seg--> 0010 (Op) --2seg--> Resultado --2seg--> Repete mudando Op
        -- LEDS MAIS A DIREITA: A         --2seg--> B        --2seg--> Op        --2seg--> Resultado --2seg--> Repete mudando Op
        LEDS_left, LEDS_right              : out STD_LOGIC_VECTOR(3 downto 0)
    );
end interface;


architecture behavioral of full_adder is
    begin 
        component main is
            port (
                operation : in  std_logic_vector(2 downto 0); -- Controle da nossa ULA 
                A : in  std_logic_vector(3 downto 0);
                B : in  std_logic_vector(3 downto 0);
                OP: in  std_logic_vector(2 downto 0);
                Z : out std_logic_vector(3 downto 0)
            );
        end component;

        -- func clock pega clock da placa e aumenta para 2 segundos
        component CLK is
            port (
                clock_O   : in std_logic
                clock_f  : out std_logic
              ) ;
        end component;

        -- criando sinais auxiliares para guardar as entradas e saídas
        signal A,B,Op: std_logic_vector (3 downto 0);
        signal Z0,Z1,Z2,Z3,Z4,Z5,Z6,Z7 : std_logic_vector (3 downto 0);

        begin
            CLK port map (clock_O,clock_f);
            main port map(A,B,Z0,"000");
            main port map(A,B,Z1,"001");
            main port map(A,B,Z2,"010");
            main port map(A,B,Z3,"011");
            main port map(A,B,Z4,"100");
            main port map(A,B,Z5,"101");
            main port map(A,B,Z6,"110");
            main port map(A,B,Z7,"111");
            
        -- criar estadoAtual, estado e estadoInicial, estado1, estado2, 
        P_MaquinaEstados: process(B_A,B_B, B_OP,B_Reset,SW,estadoAtual)
        
        begin
            if (B_Reset = '1') then -- reseta tudo
                estadoAtual <= EstadoInicial;
                LEDS <= "0000";

            else
                
            

            end if;

end architecture behavioral;