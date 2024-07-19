----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:41:05 06/07/2024 
-- Design Name: 
-- Module Name:    main - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main is -- declarando a máquina de estados
    Port (
        sinal_clock : in std_logic; -- clock
        dados_teclado, clock_teclado: in std_logic; -- sinais do teclado
        LCD_DB: out std_logic_vector(7 downto 0); -- sinais para o display
        RS, RW, OE: out std_logic; -- sinais de controle para o display
        BOTAOA, BOTAOB, BOTAOC, BOTAO_RST: in std_logic; -- botões e switches
        SW : in std_logic; -- switch
        LEDS: out std_logic_vector(3 downto 0); -- leds
        LEDA, LEDB: out std_logic -- leds individuais
    );
end main;

architecture Behavioral of main is

    -- definição dos estados
    type state is (state0, stateA3, stateA2, stateA1, stateA0, stateB3, stateB2, stateB1, stateB0, stateS, stateZ3, stateZ2, stateZ1, stateZ0);
    signal estadoAtual, estadoAux: state := state0; -- sinais para o estado atual e auxiliar

	 component tc_codigo_teclado is
	    -- generic(W_SIZE: integer := 1); -- 2^W_SIZE words in FIFO
    port (
        sinal_clock, sinal_reset: in  std_logic;
        dados_teclado, clock_teclado: in  std_logic;
        receptor_enable: in std_logic;
        final_recebimento_byte: out  std_logic;
        dados_saida: out std_logic_vector(7 downto 0)
    );
	end component;
	
	component display_lcd is
		 Port ( NUMERO: in std_logic_vector(3 downto 0); --Entrada de 4 bits.
				  BOTAO: in std_logic; --Botão de entrada
				  sinal_reset: in std_logic; --Sinal de reset.
				  sinal_clock: in std_logic; --Sinal de clock.
				  
				  LED: out std_logic; --Saída para controle de um LED.
				  LCD_DB: out std_logic_vector(7 downto 0); --Dados de 8 bits para o display LCD.
				  -- Register Select - Bit 9 - Se rs: 1 -> registrador de dados (DR), p/ ops de leitura e escrita de dados; rs: 0 -> registrador de instrução (IR), usado para comandos.
				  RS: out std_logic; --Sinal de registro de seleção do LCD.
				  RW: out std_logic; -- Read/Write      - Bit 8 - Se rw: 1 -> leitura; rw: 0 -> escrita   
				  OE: out std_logic; --Sinal de habilitação de saída.
				  ok, okWr: out std_logic); --Sinais de controle de estado.
	end component;
	 
	 
	 component display_traduz_BCD is
		  Port ( ascii : in STD_LOGIC_VECTOR (7 downto 0);
				  BCD : out STD_LOGIC_VECTOR (3 downto 0));
	 end component;
	 
	 
	component bcd_multiplier is
		 Port ( A : in  STD_LOGIC_VECTOR (15 downto 0);  -- 4 dígitos BCD
				  B : in  STD_LOGIC_VECTOR (15 downto 0);  -- 4 dígitos BCD
				  Z : out  STD_LOGIC_VECTOR (15 downto 0)); -- Resultado em BCD (8 dígitos)
	end component;
	
	 
	component bcd_adder is
		 Port ( A : in  STD_LOGIC_VECTOR (15 downto 0);
				  B : in  STD_LOGIC_VECTOR (15 downto 0);
				  SUM : out  STD_LOGIC_VECTOR (15 downto 0);
				  CARRY_OUT : out  STD_LOGIC);
	end component;
	 
    -- sinais para o kbcode
    signal dados_saida : std_logic_vector(7 downto 0);
    signal final_recebimento_byte, receptor_enable: std_logic;

    -- vetor BCD para a conversão
    signal BCD : std_logic_vector(3 downto 0);

    -- sinais para o display
    signal numDisplay : std_logic_vector(3 downto 0); -- número a ser mostrado no display
    signal led, ok, okWr : std_logic;
    signal read_tecla : std_logic := '0';

    -- sinais para as operações
    signal A, B, ZMultiplicacao, ZSoma : std_logic_vector(15 downto 0) := "0000000000000000"; -- vetores para operações
    signal S: std_logic; -- para guardar a seleção

begin

    -- Mapeamento do componente tc_codigo_teclado
    TECLADO: tc_codigo_teclado port map (
        sinal_clock => sinal_clock,
        sinal_reset => BOTAO_RST,
        dados_teclado => dados_teclado,
        clock_teclado => clock_teclado,
        receptor_enable => receptor_enable,
        dados_saida => dados_saida,
        final_recebimento_byte => final_recebimento_byte
    );
    receptor_enable <= NOT final_recebimento_byte;
    read_tecla <= BOTAOC;


    -- Mapeamento do componente lcd
    DISPLAY: display_lcd port map (
        NUMERO => numDisplay,
        BOTAO => read_tecla,
        LED => led,
        LCD_DB => LCD_DB,
        RS => RS,
        RW => RW,
        sinal_clock => sinal_clock,
        OE => OE,
        sinal_reset => BOTAO_RST,
        ok => ok,
        okWr => okWr
    );
	 
	 
    -- Mapeamento do componente ConvAsciiToBCD
    CONVERSAO: display_traduz_BCD port map (
        ascii => dados_saida,
        BCD => BCD
    );

    -- Mapeamento do componente bcd_multiplier
    MULTIPLICACAO: bcd_multiplier port map ( A, B, ZMultiplicacao);

    -- Mapeamento do componente bcd_adder
    SOMA: bcd_adder port map ( B, A, ZSoma);

    -- Processo para alterar o estado atual no clock
    process(sinal_clock, estadoAux)
    begin
        if(sinal_clock'event and sinal_clock = '1') then
            estadoAtual <= estadoAux; -- alteramos o estado no clock
        end if;
    end process;


    -- Processo principal da máquina de estados
    process
    begin
        
if (BOTAO_RST = '1') then -- caso tenhamos RST, voltamos para o primeiro estado
    estadoAux <= stateA3;
else
    case estadoAtual is
        when state0 =>
            if (ok = '1' ) then
                estadoAux <= stateA3;
            else
                estadoAux <= state0;
            end if;
        when stateA3 => -- primeiro digito de A
            LEDA <= '1';
            LEDB <= '0';
            LEDS <= BCD;
            numDisplay <= BCD;
				if (BOTAOA = '1') then
                A(15 downto 12) <= BCD;
                estadoAux <= stateA2;
            else
                estadoAux <= stateA3;
            end if;

        when stateA2 => -- segundo digito de A
            LEDA <= '0';
            LEDB <= '1';
            LEDS <= BCD;
            numDisplay <= BCD;
				
				if (BOTAOB = '1') then
                A(11 downto 8) <= BCD;
                estadoAux <= stateA1;
            else
                estadoAux <= stateA2;
            end if;

        when stateA1 => -- terceiro digito de A
            LEDA <= '1';
            LEDB <= '0';
            LEDS <= BCD;
            numDisplay <= BCD;
				if (BOTAOA = '1') then
                A(7 downto 4) <= BCD;
                estadoAux <= stateA0;
            else
                estadoAux <= stateA1;
            end if;

        when stateA0 => -- ultimo digito de A
            LEDA <= '0';
            LEDB <= '1';
            LEDS <= BCD;
            numDisplay <= BCD;
				
				if (BOTAOB = '1') then
                A(3 downto 0) <= BCD;
                estadoAux <= stateB3;
            else
                estadoAux <= stateA0;
            end if;

        when stateB3 => -- primeiro digito de B
            LEDA <= '1';
            LEDB <= '0';
            LEDS <= BCD;
            numDisplay <= BCD;
				
				if (BOTAOA = '1') then
                B(15 downto 12) <= BCD;
                estadoAux <= stateB2;
            else
                estadoAux <= stateB3;
            end if;

        when stateB2 => -- segundo digito de B
            LEDA <= '0';
            LEDB <= '1';
            LEDS <= BCD;
            numDisplay <= BCD;
				
				if (BOTAOB = '1') then
                B(11 downto 8) <= BCD;
                estadoAux <= stateB1;
            else
                estadoAux <= stateB2;
            end if;

        when stateB1 => -- terceiro digito de B
            LEDA <= '1';
            LEDB <= '0';
            LEDS <= BCD;
            numDisplay <= BCD;
				if (BOTAOA = '1') then
                B(7 downto 4) <= BCD;
                estadoAux <= stateB0;
            else
                estadoAux <= stateB1;
            end if;

        when stateB0 => -- quarto bit de B
            LEDA <= '0';
            LEDB <= '1';
            LEDS <= BCD;
            numDisplay <= BCD;
				
				if (BOTAOB = '1') then
                B(3 downto 0) <= BCD;
                estadoAux <= stateS;
            else
                estadoAux <= stateB0;
            end if;

        when stateS =>
            LEDA <= '1';
            LEDB <= '1';

            if (BOTAOA = '1') then
                S <= SW;
                estadoAux <= stateZ3;
            else
                estadoAux <= stateS;
            end if;
				
				when stateZ3 =>
            LEDA <= '0';
            LEDB <= '0';

            if (S = '1' ) then
                LEDS <= ZSoma(15 downto 12);
                numDisplay <= ZSoma(15 downto 12);
            else
                LEDS <= ZMultiplicacao(15 downto 12);
                numDisplay <= ZMultiplicacao(15 downto 12);
            end if;
				
				if (BOTAOB = '1') then
                estadoAux <= stateZ2;
            else
                estadoAux <= stateZ3;
            end if;

        when stateZ2 =>
            LEDA <= '0';
            LEDB <= '0';

            if (S = '1' ) then
                LEDS <= ZSoma(11 downto 8);
                numDisplay <= ZSoma(11 downto 8);
            else
                LEDS <= ZMultiplicacao(11 downto 8);
                numDisplay <= ZMultiplicacao(11 downto 8);
            end if;
				
				if (BOTAOA = '1') then
                estadoAux <= stateZ1;
            else
                estadoAux <= stateZ2;
            end if;

        when stateZ1 =>
            LEDA <= '0';
            LEDB <= '0';

            if (S = '1' ) then
                LEDS <= ZSoma(7 downto 4);
                numDisplay <= ZSoma(7 downto 4);
					 
				 else
				 LEDS <= ZMultiplicacao(7 downto 4);
				 numDisplay <= ZMultiplicacao(7 downto 4);
            end if;

            if (BOTAOB = '1') then
                estadoAux <= stateZ0;
            else
                estadoAux <= stateZ1;
            end if;

        when stateZ0 =>
            LEDA <= '0';
            LEDB <= '0';
				
		
            if (S = '1' ) then
                LEDS <= ZSoma(3 downto 0);
                numDisplay <= ZSoma(3 downto 0);
            else
                LEDS <= ZMultiplicacao(3 downto 0);
                numDisplay <= ZMultiplicacao(3 downto 0);
            end if;

            if (BOTAOA = '1') then
                estadoAux <= stateA3;
            else
                estadoAux <= stateZ0;
            end if;
    end case;
end if;
end process;
end Behavioral;


