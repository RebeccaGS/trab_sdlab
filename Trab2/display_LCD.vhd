----------------------------------------------------------------------------------
-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia 
-- 
-- Module Name:    
-- Description: Este código VHDL implementa a inicialização e escrita de caracteres
-- em um display LCD, controlando estados e temporizações necessárias para garantir a operação correta do LCD.
----------------------------------------------------------------------------------


-- BIBLIOTECAS
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

-- ENTIDADE
entity display_lcd is
    Port ( NUMERO: in std_logic_vector(3 downto 0); --Entrada de 4 bits.
           BOTAO: in std_logic; --Botão de entrada
           sinal_reset: in std_logic; --Sinal de reset.
           sinal_clock: in std_logic; --Sinal de clock.
           
           LED: out std_logic; --Saída para controle de um LED.
           LCD_DB: out std_logic_vector(7 downto 0); --Dados de 8 bits para o display LCD.
           RS: out std_logic; --Sinal de registro de seleção do LCD.
           RW: out std_logic; --Sinal de leitura/escrita do LCD.
           OE: out std_logic; --Sinal de habilitação de saída.
           ok, okWr: out std_logic); --Sinais de controle de estado.
end display_lcd;

-- ARQUITETURA
architecture Behavioral of display_lcd is

-- Objetivo: Controlar um display de cristal líquido (LCD) através de um sistema digital.

-- 1- Inicialização do LCD:
-- O código inicia o LCD, configurando-o com comandos específicos para definir o modo de operação,
-- tamanho do caractere, entre outros parâmetros. Isso é feito através da máquina de estados estado_MaqEscrita.

-- 2- Escrita de Caracteres:
-- Uma vez inicializado, o código pode enviar caracteres para o LCD para serem exibidos. Isso é feito
-- na máquina de estados MaqE_escritaLCD, que controla o processo de escrita de dados no LCD.

-- 3- Temporização e Controle de Estado:
-- O código utiliza contadores e temporizadores (contador, delayOK, clkCount) para garantir que os comandos
-- e dados sejam enviados ao LCD nos momentos adequados, respeitando as especificações temporais do dispositivo.

-- 4- Interface com o Sistema Externo: 
-- Há portas de entrada (NUMERO, BOTAO, CLK, rst) e portas de saída (LED, LCD_DB, RS, RW, OE, ok, okWr)
-- que conectam o código VHDL ao sistema externo que controla ou utiliza o LCD.

-- 5- Controle de Estado e Transições: 
-- A lógica de controle implementada garante que o sistema siga uma sequência de estados predefinidos 
-- (stFunctionSet, stDisplayCtrlSet, stDisplayClear, stInitDne, stActWr, stCharDelay, etc.) para realizar 
-- as operações necessárias de inicialização e escrita no LCD.

    
    type MaqE_controleLCD is ( -- maq de estados principal p/ controle do lcd - controla a sequência geral de inicialização e operações do LCD 
        -- Estados dessa maquina:
        stFunctionSet, -- Envia o comando de configuração da função do LCD. Isso define parâmetros como o comprimento dos dados (8 bits ou 4 bits), número de linhas (1 ou 2) e tipo de fonte (5x8 ou 5x11).
        stDisplayCtrlSet, -- Envia o comando de controle do display. Isso liga ou desliga o display, o cursor, e o piscar do cursor.
        stDisplayClear, -- Envia o comando para limpar o display, apagando todas as informações mostradas.
        stPowerOn_Delay, -- Introduz um atraso após ligar o LCD para garantir que ele tenha tempo suficiente para se inicializar corretamente.
        stFunctionSet_Delay, -- Introduz um atraso após enviar o comando stFunctionSet.
        stDisplayCtrlSet_Delay, -- Introduz um atraso após enviar o comando stDisplayCtrlSet.
        stDisplayClear_Delay, -- Introduz um atraso após enviar o comando stDisplayClear.
        stInitDne, -- Indica que a inicialização do LCD está concluída e o sistema está pronto para operações normais.
        stActWr, -- Estado ativo de escrita, onde caracteres são escritos no LCD.
        stCharDelay -- Introduz um atraso entre escritas consecutivas de caracteres para garantir que cada comando tenha tempo de ser processado pelo LCD.
    );


    type MaqE_escritaLCD is ( -- lida controle de escrita.
        -- Estados dessa maquina:
        stRW, -- Configura os sinais de RS e RW para preparar o LCD para receber dados.
        stEnable, -- Configura o sinal de habilitação (enable) para escrever os dados no LCD. Este estado garante que os dados no barramento estão estáveis antes de ativar o sinal de escrita.
        stIdle -- Estado de espera. A máquina de estados permanece neste estado até receber um comando para escrever novos dados no LCD.
    );


    -- declarando sinais    
    signal contador_Clock: std_logic_vector(5 downto 0);
    signal ativaMaqE_Escrita: std_logic := '0';
    signal contador: std_logic_vector (16 downto 0) := "00000000000000000"; 
    signal gerar_clock_1micro: std_logic; -- utilizado para temporização precisa dentro do circuito.
    signal estado_MaqEscrita: MaqE_controleLCD := stPowerOn_Delay; -- armazena estados atuais das máq de estados MaqE_controleLCD 
    signal proxEstado_MaqControle: MaqE_controleLCD; 
    signal estado_MaqControle: MaqE_escritaLCD := stIdle; -- armazena estados atuais da máq de estados MaqE_escritaLCD
    signal proxEstado_MaqEscrita: MaqE_escritaLCD;
    signal writeDone: std_logic := '0'; -- qnd writedone = 1 significa que op de escrita foi finalizada
    signal delayOK: std_logic := '0'; -- delayOK é usado para indicar quando um atraso específico foi completado. Quando delayOK é '1', isso significa que o atraso foi alcançado.

    -- LCD Commands
    -- Define uma matriz de comandos para o LCD, onde cada comando é 
    -- um vetor de 10 bits (2 bits de controle e 8 bits de dados).
   
    type LCD_CMDS_T is array(23 downto 0) of std_logic_vector(9 downto 0);
    signal LCD_CMDS: LCD_CMDS_T := (
        0 => "00" & X"3C",
        1 => "00" & X"0C",
        2 => "00" & X"01",
        3 => "00" & X"02",
        4 => "10" & X"30",
        5 => "10" & X"65",
        6 => "10" & X"6C",
        7 => "10" & X"6C",
        8 => "10" & X"6F",
        9 => "10" & X"20",
        10 => "10" & X"46",
        11 => "10" & X"72",
        12 => "10" & X"6F",
        13 => "10" & X"6D",
        14 => "10" & X"20",
        15 => "10" & X"44",
        16 => "10" & X"69",
        17 => "10" & X"67",
        18 => "10" & X"69",
        19 => "10" & X"6C",
        20 => "10" & X"65",
        21 => "10" & X"6E",
        22 => "10" & X"74",
        23 => "00" & X"02"
    );

    -- Define um ponteiro para os comandos do LCD e um sinal de trava (TRAVA).
    signal lcd_cmd_ptr: integer range 0 to LCD_CMDS'HIGH + 1 := 0;
    signal TRAVA: std_logic := '1';

begin

    -- Incrementa o contador contador_Clock em cada ciclo de clock e
    -- define gerar_clock_1micro como um sinal derivado do contador.
    LED <= TRAVA;
    okWr <= ativaMaqE_Escrita;

    process (sinal_clock, gerar_clock_1micro)
    begin
        if (sinal_clock = '1' and sinal_clock'event) then
            contador_Clock <= contador_Clock + 1;
        end if;
    end process;

    gerar_clock_1micro <= contador_Clock(5);

    -- Implementa um contador de delay que é resetado quando delayOK é '1'.
    process (gerar_clock_1micro, delayOK)
    begin
        if (gerar_clock_1micro = '1' and gerar_clock_1micro'event) then
            if delayOK = '1' then
                contador <= "00000000000000000";
            else
                contador <= contador + 1;
            end if;
        end if;
    end process;


    -- Define writeDone como '1' quando todos os comandos do LCD foram executados.
    writeDone <= '1' when (lcd_cmd_ptr = LCD_CMDS'HIGH) else '0';

    -- Este processo gerencia o ponteiro de comandos do LCD e a lógica de controle de TRAVA e BOTAO.
    process (lcd_cmd_ptr, gerar_clock_1micro, BOTAO)
    begin
        if (gerar_clock_1micro = '1' and gerar_clock_1micro'event) then
            if ((proxEstado_MaqControle = stInitDne or proxEstado_MaqControle = stDisplayCtrlSet or proxEstado_MaqControle = stDisplayClear) and writeDone = '0') then
                lcd_cmd_ptr <= lcd_cmd_ptr + 1;

                if (lcd_cmd_ptr <= 3) then
                    TRAVA <= '0';
                elsif (BOTAO = '1') then
                    TRAVA <= '0';
                    LCD_CMDS(lcd_cmd_ptr)(7 downto 0) <= "0011" & NUMERO;
                else
                    TRAVA <= '1';
                end if;

            elsif estado_MaqEscrita = stPowerOn_Delay or proxEstado_MaqControle = stPowerOn_Delay then
                lcd_cmd_ptr <= 0;
                TRAVA <= '0';
            else
                lcd_cmd_ptr <= lcd_cmd_ptr;

                if (lcd_cmd_ptr <= 3) then
                    TRAVA <= '0';
                elsif (BOTAO = '1') then
                    TRAVA <= '0';
                    LCD_CMDS(lcd_cmd_ptr)(7 downto 0) <= "0011" & NUMERO;
                else
                    TRAVA <= '1';
                end if;
            end if;
        end if;
    end process;

    -- Define delayOK com base no estado atual e no valor do contador contador.
    delayOK <= '1' when (
        (estado_MaqEscrita = stPowerOn_Delay and contador = "00100111001010010") or
        (estado_MaqEscrita = stFunctionSet_Delay and contador = "00000000000110010") or
        (estado_MaqEscrita = stDisplayCtrlSet_Delay and contador = "00000000000110010") or
        (estado_MaqEscrita = stDisplayClear_Delay and contador = "00000011001000000") or
        (estado_MaqEscrita = stCharDelay and contador = "11111111111111111")
    ) else '0';


    -- Implementa a máquina de estados principal para controlar a inicialização do LCD e a escrita de caracteres.
    process (gerar_clock_1micro, sinal_reset)
    begin
        if gerar_clock_1micro = '1' and gerar_clock_1micro'Event then
            if sinal_reset = '1' then
                estado_MaqEscrita <= stPowerOn_Delay;
            else
                estado_MaqEscrita <= proxEstado_MaqControle;
            end if;
        end if;
    end process;

    -- Controla a sequência de escrita no LCD (RW, Enable).
    process (estado_MaqEscrita, delayOK, writeDone, lcd_cmd_ptr, TRAVA)
    begin
        case estado_MaqEscrita is
            when stPowerOn_Delay =>
                ok <= '0';
                if delayOK = '1' then
                    proxEstado_MaqControle <= stFunctionSet;
                else
                    proxEstado_MaqControle <= stPowerOn_Delay;
                end if;
                RS <= LCD_CMDS(lcd_cmd_ptr)(9);
                RW <= LCD_CMDS(lcd_cmd_ptr)(8);
                LCD_DB <= LCD_CMDS(lcd_cmd_ptr)(7 downto 0);
                ativaMaqE_Escrita <= '0';

            when stFunctionSet =>
                RS <= LCD_CMDS(lcd_cmd_ptr)(9);
                RW <= LCD_CMDS(lcd_cmd_ptr)(8);
                LCD_DB <= LCD_CMDS(lcd_cmd_ptr)(7 downto 0);
                ativaMaqE_Escrita <= '1';
                proxEstado_MaqControle <= stFunctionSet_Delay;

            when stFunctionSet_Delay =>
                RS <= LCD_CMDS(lcd_cmd_ptr)(9);
                RW <= LCD_CMDS(lcd_cmd_ptr)(8);
                LCD_DB <= LCD_CMDS(lcd_cmd_ptr)(7 downto 0);
                ativaMaqE_Escrita <= '0';
                if delayOK = '1' then
                    proxEstado_MaqControle <= stDisplayCtrlSet;
                else
                    proxEstado_MaqControle <= stFunctionSet_Delay;
                end if;

            when stDisplayCtrlSet =>
                RS <= LCD_CMDS(lcd_cmd_ptr)(9);
                RW <= LCD_CMDS(lcd_cmd_ptr)(8);
                LCD_DB <= LCD_CMDS(lcd_cmd_ptr)(7 downto 0);
                ativaMaqE_Escrita <= '1';
                proxEstado_MaqControle <= stDisplayCtrlSet_Delay;

            when stDisplayCtrlSet_Delay =>
                RS <= LCD_CMDS(lcd_cmd_ptr)(9);
                RW <= LCD_CMDS(lcd_cmd_ptr)(8);
                LCD_DB <= LCD_CMDS(lcd_cmd_ptr)(7 downto 0);
                ativaMaqE_Escrita <= '0';
                if delayOK = '1' then
                    proxEstado_MaqControle <= stDisplayClear;
                else
                    proxEstado_MaqControle <= stDisplayCtrlSet_Delay;
                end if;

            when stDisplayClear =>
                RS <= LCD_CMDS(lcd_cmd_ptr)(9);
                RW <= LCD_CMDS(lcd_cmd_ptr)(8);
                LCD_DB <= LCD_CMDS(lcd_cmd_ptr)(7 downto 0);
                ativaMaqE_Escrita <= '1';
                proxEstado_MaqControle <= stDisplayClear_Delay;

            when stDisplayClear_Delay =>
                RS <= LCD_CMDS(lcd_cmd_ptr)(9);
                RW <= LCD_CMDS(lcd_cmd_ptr)(8);
                LCD_DB <= LCD_CMDS(lcd_cmd_ptr)(7 downto 0);
                ativaMaqE_Escrita <= '0';
                if delayOK = '1' then
                    proxEstado_MaqControle <= stInitDne;
                else
                    proxEstado_MaqControle <= stDisplayClear_Delay;
                end if;

            when stInitDne =>
                ok <= '1';
                if (BOTAO = '1' and TRAVA = '0') then
                    proxEstado_MaqControle <= stActWr;
                else
                    proxEstado_MaqControle <= stInitDne;
                end if;

            when stActWr =>
                RS <= LCD_CMDS(lcd_cmd_ptr)(9);
                RW <= LCD_CMDS(lcd_cmd_ptr)(8);
                LCD_DB <= LCD_CMDS(lcd_cmd_ptr)(7 downto 0);
                ativaMaqE_Escrita <= '1';
                proxEstado_MaqControle <= stCharDelay;

            when stCharDelay =>
                RS <= LCD_CMDS(lcd_cmd_ptr)(9);
                RW <= LCD_CMDS(lcd_cmd_ptr)(8);
                LCD_DB <= LCD_CMDS(lcd_cmd_ptr)(7 downto 0);
                ativaMaqE_Escrita <= '0';
                if delayOK = '1' then
                    proxEstado_MaqControle <= stInitDne;
                else
                    proxEstado_MaqControle <= stCharDelay;
                end if;

            when others =>
                proxEstado_MaqControle <= stPowerOn_Delay;
        end case;
    end process;

    process (ativaMaqE_Escrita, sinal_clock, gerar_clock_1micro)
    begin
        case estado_MaqControle is
            when stIdle =>
                if ativaMaqE_Escrita = '1' then
                    proxEstado_MaqEscrita <= stRW;
                else
                    proxEstado_MaqEscrita <= stIdle;
                end if;
                OE <= '0';

            when stRW =>
                OE <= '0';
                proxEstado_MaqEscrita <= stEnable;

            when stEnable =>
                OE <= '1';
                proxEstado_MaqEscrita <= stIdle;

            when others =>
                proxEstado_MaqEscrita <= stIdle;
        end case;
    end process;

    -- Atualiza o estado atual da máquina de estados de escrita (estado_MaqControle) com base no próximo estado (proxEstado_MaqEscrita) ou reseta se sinal_reset for '1'.
    process (gerar_clock_1micro, sinal_reset)
    begin
        if gerar_clock_1micro = '1' and gerar_clock_1micro'Event then
            if sinal_reset = '1' then
                estado_MaqControle <= stIdle;
            else
                estado_MaqControle <= proxEstado_MaqEscrita;
            end if;
        end if;
    end process;

end Behavioral;
