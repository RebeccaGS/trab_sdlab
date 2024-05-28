library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
-- DUVIDA
    
-- juntar com clk
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------



-- definindo entidade
entity interface is
    Port ( switches    : in  STD_LOGIC_VECTOR(3 downto 0); -- Sw seleciona, outros, agregam valor. Exemplo: SW 1001; botão agrega esse valor a A, ou B, ou etc
           botao, reset, clk      : in  STD_LOGIC; -- agrega valor
           leds_right, leds_left  : out STD_LOGIC_VECTOR(3 downto 0); -- aparece para usuário
    );
end interface;




architecture Behavioral of interface is 
    -- definindo arquitetura: divido em:
    -- 1) chamar main e clk
    -- 2) criar signals
    -- 3) chamar na main
    -- 4) definir reset e pegar A, B e OP
    -- 5) mostrar em looping A, B, Z
    -------------------------------------------------------------------------------------
    -- 1) chamar main e clk
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


    -----------------------------------------------------------------------------------------------
    -- 2) criar signals

    -- definindo meus estados: setando A, setando B, setando OP e aparecendo as respostas
    type tipo_estado is (1_A, 2_B, 3_OP, 5_Z0, 6_Z1, 7_Z2, 8_Z3, 9_Z4, 10_Z5, 11_Z6, 12_Z7);
    -- criando sinal estado e proximo estado, e definindo ambas como tipo_estado (assumem algum estado em tipo_estado)
    signal ESTADO, prox_estado : tipo_estado;
    -- Definindo sinais e criando variáveis de saída
    signal Z0,Z1,Z2,Z3,Z4,Z5,Z6,Z7: STD_LOGIC_VECTOR (3 downto 0);
    signal A,B: STD_LOGIC_VECTOR (3 downto 0);
    signal OP: STD_LOGIC_VECTOR (2 downto 0);

    ----------------------------------------------------------------------------------------------------
    -- 3) mandar pra main e descobrir as saidas
    begin
        CLK port map (clock_O,clock_f);
        main port map(A,B,"000",Z0);
        main port map(A,B,"001",Z1);
        main port map(A,B,"010",Z2);
        main port map(A,B,"011",Z3);
        main port map(A,B,"100",Z4);
        main port map(A,B,"101",Z5);
        main port map(A,B,"110",Z6);
        main port map(A,B,"111",Z7);

    
    ----------------------------------------------------
    -- 4) definir reset e pegar A, B e OP 
    begin
        -- Criando processo que usa clock e reset
        process(clk, reset) -- process avalia comandos sequencialmente, em vhdl, fora de process, avalia paralelamente
        -- cada comando pode atribuir valores a sinais (signal A <=0;) ou variáveis (varia)
        begin
            -- caso reset for ativo, resetando tudo e estado = estado inicial
            if reset = '1' then
                ESTADO <= 1_A;
                leds_right <= '0000';
                leds_left <= '1000';
                A  <= 0000;
                B  <= 0000;
                OP <= 000;
                Z  <= 0000;
            end if;
        end process;

        -- VER COMO CHAMAR ESTADO INICIAL DE 1_A
        -- outro processo chamando estado, botao e switche
        process(ESTADO:1_A, botao, switches)
        begin
            prox_estado <= ESTADO;
            -- separa o que ocorre em cada estado
            case prox_estado is
                when 1_A =>
                    leds_left <= "1000";
                    if botao = '1' then
                        A <= switches;
                        prox_estado <= 2_B;
                    end if;


                when 2_B =>
                    leds_left <= "0100";
                    if botao = '1' then
                        B <= switches;
                        prox_estado <= 3_OP;
                    end if;

                when 3_OP =>
                    leds_left <= "0010";
                    if botao = '1' then
                        op <= switch;
                        -- descobrir estado inicial
                        if (OP = "000") then -- AND
                            prox_estado <=  5_Z0;  
                        elsif (OP = "001") then -- OR
                            prox_estado <=  6_Z1; 
                        elsif (OP = "010") then -- NOT
                            prox_estado <=  7_Z2; 
                        elsif (OP = "011") then -- soma
                            prox_estado <=  8_Z3; 
                        elsif (OP = "100") then -- complemento de 2
                            prox_estado <=  9_Z4;
                        elsif (OP = "101") then -- subtrator
                            prox_estado <= 10_Z5;
                        elsif (OP = "110") then -- shifter left
                            prox_estado <= 11_Z6;
                        elsif (OP = "111") then -- multiplier
                            prox_estado <= 12_Z7;
                        end if;
                    end if;
                                    

    ------------------------------------------------------------------------------
    -- 5) emostrar em looping A, B, Z
                while reset = 0 loop
                    leds_left <= "1000"; --coloco leds adequado
                    leds_right <= A;
                    clock -- ESCREVER CERTO ESSA PORRA 
                    leds_left <= "0100"; --coloco leds adequado
                    leds_right <= B;
                    clock -- ESCREVER CERTO ESSA PORRA 
                    leds_left <= "0010"; --coloco leds adequado
                    leds_right <= OP;
                    clock -- ESCREVER CERTO ESSA PORRA 
                    leds_left <= "0001";
                    
                    case prox_estado
                        if 5_Z0 then
                            leds_right <= Z0
                            prox_estado <= 6_Z1;
                        elsif 6_Z1 then
                            leds_right <= Z1
                            prox_estado <= 7_Z2;
                        elsif 7_Z2 then
                            leds_right <= Z2
                            prox_estado <= 8_Z3;
                        elsif 8_Z3 then
                            leds_right <= Z3
                            prox_estado <= 9_Z4;
                        elsif 9_Z4 then
                            leds_right <= Z4
                            prox_estado <= 10_Z5;
                        elsif 10_Z5 then
                            leds_right <= Z5
                            prox_estado <= 11_Z6;
                        elsif 11_Z6 then
                            leds_right <= Z6
                            prox_estado <= 12_Z7;
                        elsif 12_Z7 then
                            leds_right <= Z7
                            prox_estado <= 5_Z0;
                        end if;
                    end case;
                end loop;
                end case;
            end case;
        end process;
end Behavioral;
