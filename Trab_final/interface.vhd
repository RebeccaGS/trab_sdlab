----------------------------------------------------------------------------------
-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia
--
-- Module Name:    main - Behavioral 
-- Description: Interface da ULA - VHDL  
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- definindo entidade
entity interface is
    Port ( switches    : in  STD_LOGIC_VECTOR(3 downto 0); -- Sw seleciona, outros, agregam valor. Exemplo: SW 1001; botão agrega esse valor a A, ou B, ou etc
            botao, reset, clock      : in  STD_LOGIC; -- agrega valor
            LEDS_RIGHT: out STD_LOGIC_VECTOR(3 downto 0);
		    LEDS_LEFT: out STD_LOGIC_VECTOR(7 downto 4) -- aparece para usuário
    );

end interface;

architecture Behavioral of interface is 
    -- definindo arquitetura: divido em:
    -- 1) chamar main e clk
    -- 2) criar signals e estados
    -- 3) chamar na main
    -- 4) definir reset e pegar A, B e OP
    -- 5) mostrar em loOPing A, B, Z
    -------------------------------------------------------------------------------------
    -- 1) chamar main e clk

    component main is
        port (
            A : in  STD_LOGIC_VECTOR(3 downto 0);
            B : in  STD_LOGIC_VECTOR(3 downto 0);
            OP: in  STD_LOGIC_VECTOR(2 downto 0);
            Z : out STD_LOGIC_VECTOR(3 downto 0)
        );
		  
    end component;
	 
	     -- func clock pega clock da placa e aumenta para 2 segundos
    component CLK is
        port (
            clock_O   : in STD_LOGIC;
            clock_f  : out STD_LOGIC
            );
    end component;

    -----------------------------------------------------------------------------------------------
    -- 2) criar signals e estados

    -- definindo meus ESTADOs: setando A, setando B, setando OP, aparecendo as respostas e A auxiliar, B auxiliar e OP auxiliar
    -- criando sinal ESTADO e proximo ESTADO, e definindo ambas como tipo_ESTADO (assumem algum ESTADO em tipo_ESTADO)
    type tipo_ESTADO is (Ai, Bi, OPi, Zo, Za, Zb, Zc, Zd, Ze, Zf, Zg, Zh, Ax, Bx, OPx);
    signal ESTADO: tipo_ESTADO := Ai;
	signal ESTADOx : tipo_ESTADO:= Zo;
	signal prox_operacaox: tipo_ESTADO := Zo;
	signal prox_operacao: tipo_ESTADO;
	 
    -- Definindo sinais e criando variáveis de saída
    signal Z0,Z1,Z2,Z3,Z4,Z5,Z6,Z7: STD_LOGIC_VECTOR (3 downto 0);
    signal A,B: STD_LOGIC_VECTOR (3 downto 0):= "0000";
    signal OP: STD_LOGIC_VECTOR (2 downto 0);
	signal clock_f: STD_LOGIC;
	signal LEDS_Laux : STD_LOGIC_VECTOR(3 downto 0) := "0000";
	signal LEDS_Raux: STD_LOGIC_VECTOR(3 downto 0) := "0000";
    
	 ----------------------------------------------------------------------------------------------------
    --
	 -- 3) mandar pra main e descobrir as saidas
    begin
	 
		LEDS_RIGHT <= LEDS_Raux;
		LEDS_LEFT <= LEDS_Laux;
        a1:CLK port map (clock,clock_f);
        a2:main port map(A,B,"000",Z0);
        a3:main port map(A,B,"001",Z1);
        a4:main port map(A,B,"010",Z2);
        a5:main port map(A,B,"011",Z3);
        a6:main port map(A,B,"100",Z4);
        a7:main port map(A,B,"101",Z5);
        a8:main port map(A,B,"110",Z6);
        a9:main port map(A,B,"111",Z7);
		
		  
    ----------------------------------------------------
    -- 4) definir reset e pegar A, B e OP 

        -- Criando processo que usa clock e reset
 
		  
		  process(botao, reset)
        begin
		  if reset = '1' then
                ESTADO <= Ai;
					 A <= "0000";
					 B <= "0000";
					 OP <="000";
					 
        elsif rising_edge(botao) then
            -- separa o que ocorre em cada ESTADO
            case ESTADO is
                when Ai =>
                        A <= switches;
                        ESTADO <= Bi;
						  
					
                when Bi =>
                        B <= switches;
                        ESTADO <= OPi;
						  
						  
					 when OPi =>
						ESTADO <= Zo;
                        OP <= switches(2 downto 0);
                        -- descobrir ESTADO inicial
                        if (OP = "000") then -- AND
                            prox_operacao <=  Za;  
                        elsif (OP = "001") then -- OR
                            prox_operacao <=  Zb;
                        elsif (OP = "010") then -- NOT
                            prox_operacao <=  Zc; 
                        elsif (OP = "011") then -- soma
                            prox_operacao <=  Zd; 
							   elsif (OP = "100") then -- complemento de 2
                            prox_operacao <=  Ze;
                        elsif (OP = "101") then -- subtrator
                            prox_operacao <= Zf;
                        elsif (OP = "110") then -- shifter left
                            prox_operacao <= Zg;
                        elsif (OP = "111") then -- multiplier
                            prox_operacao <= Zh;
                        end if;
						  
						 when others => 
                 end case;
			end if;
end process;

---------------------------------------------------------------------------
    -- 5) emostrar em loOPing A, B, Z
	 PROCESS(clock_f,ESTADO,reset)
	 begin
	 if (reset = '1') then
	             LEDS_Raux <= "0000";
                LEDS_Laux <= "1000";
                ESTADOx <= Zo;
					 prox_operacaox <= Zo;
		
	elsif(rising_edge(clock_f)) then
				if(ESTADO = OPi) then
					prox_operacaox <= prox_operacao;
					ESTADOx <= Ax;
				
				elsif (ESTADO = Zo)then
							  
							  case ESTADOx is
							  
								when Ax  =>
									LEDS_Laux <= "1000"; --coloco leds adequado
									LEDS_Raux <= A;
									ESTADOx <=Bx;
								when Bx  =>
									LEDS_Laux <= "0100"; --coloco leds adequado
								   LEDS_Raux <= B;
								   ESTADOx <= OPx;
								when OPx  =>
									LEDS_Raux (2 downto 0) <= OP (2 downto 0);
								   LEDS_Laux <= "0001";
									ESTADOx <= prox_operacaox;
								 
								 when Za =>
										 LEDS_Raux <= Z0;
										 prox_operacaox <= Zb;
										 ESTADOx <= Ax;
									when Zb =>
										 LEDS_Raux <= Z1;
										 prox_operacaox <= Zc;
										 ESTADOx <= Ax;
									when Zc =>
										 LEDS_Raux <= Z2;
										 prox_operacaox <= Zd;
										 ESTADOx <= Ax;
									when Zd =>
										 LEDS_Raux <= Z3;
										 prox_operacaox <= Ze;
										 ESTADOx <= Ax;
									when Ze =>
										 LEDS_Raux <= Z4;
										 prox_operacaox <= Zf;
										 ESTADOx <= Ax;
									when Zf =>
										 LEDS_Raux <= Z5;
										 prox_operacaox <= Zg;
										 ESTADOx <= Ax;
									when Zg =>
										 LEDS_Raux <= Z6;
										 prox_operacaox <= Zh;
										 ESTADOx <= Ax;
									when Zh =>
										 LEDS_Raux <= Z7;
										 prox_operacaox <= Za;
										 ESTADOx <= Ax;
									when others =>
							end case;
					end if;
			end if;
 end process;
		  
end Behavioral;					  
