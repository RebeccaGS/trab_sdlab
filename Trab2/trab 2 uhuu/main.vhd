----------------------------------------------------------------------------------
-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia
--
-- Module Name:    main - Behavioral 
-- Description: Main da ULA - VHDL  
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main is
    Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           OP : in  STD_LOGIC_VECTOR (2 downto 0);
           Z : out  STD_LOGIC_VECTOR (3 downto 0));
end main;

architecture Behavioral of main is

	 -- chamando os componentes das portas logicas
    component LogicAND is
        port (
            A, B: in STD_LOGIC_VECTOR (3 downto 0);
            Z   : out STD_LOGIC_VECTOR (3 downto 0)
          ) ;
    end component;
	 
    component LogicOR is
        port (
            A, B: in STD_LOGIC_VECTOR (3 downto 0);
            Z   : out STD_LOGIC_VECTOR (3 downto 0)
          ) ;
    end component;

    component LogicNOT is
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

    component COMPLEMENT_2 is
        port (
            A         : in  STD_LOGIC_VECTOR(3 downto 0); -- A0 A1 A2 A3
            Z         : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;	

    component SUBTRACTOR is
        port (
            A, B      : in  STD_LOGIC_VECTOR(3 downto 0); -- A0 A1 A2 A3
            Z         : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;	 
	 
    component SHIFTER is
        port (
            A         : in  STD_LOGIC_VECTOR(3 downto 0); -- A: entrada
            -- Q: quantidade de deslocamentos, quero até 3 deslocamentos para fazer o multiplicador 4 bits
            Q         : in  STD_LOGIC_VECTOR(3 downto 0); -- 2 bits de deslocamento (de (00: 0) a (11: 3) deslocamentos)
            Z         : out STD_LOGIC_VECTOR(3 downto 0) -- Z: saída
        );
    end component;

   component MULTIPLIER is
       port (
           A, B      : in  STD_LOGIC_VECTOR(3 downto 0); -- A e B: entradas
            Z         : out STD_LOGIC_VECTOR(3 downto 0) -- Z: saída com 8 casas
       );
   end component;	

    -- Definindo sinais e criando variáveis de saída
    signal Z0,Z1,Z2,Z3,Z4,Z5,Z6,Z7: STD_LOGIC_VECTOR (3 downto 0);
	signal Cout: STD_LOGIC;


begin

    module_AND: LogicAND port map (A,B,Z0);
    module_OR: LogicOR port map (A,B,Z1);
    module_NOT: LogicNOT port map (A,Z2);
    module_FULL_ADDER_4BITS: FULL_ADDER_4BITS port map (A,B,'0',Z3,Cout);
    module_COMPLEMENT_2: COMPLEMENT_2 port map (A,Z4);
    module_SUBTRACTOR: SUBTRACTOR port map (A,B,Z5);
	 module_SHIFTER: SHIFTER port map (A,B,Z6);
    module_MULTIPLIER: MULTIPLIER port map (A,B,Z7);
	 
    process (OP)
    begin
        if (OP = "000") then -- AND
            Z <= Z0;
        elsif (OP = "001") then -- OR
            Z <= Z1;
        elsif (OP = "010") then -- NOT
            Z <= Z2;
        elsif (OP = "011") then -- ADDER 4 BITS
            Z <= Z3;
        elsif (OP = "100") then -- COMPLEMENT 2
            Z <= Z4;
        elsif (OP = "101") then -- SUBTRACTOR
            Z <= Z5;
        elsif (OP = "110") then -- SHIFTER
            Z <= Z6;
        elsif (OP = "111") then -- MULTIPLIER
            Z <= Z7;
        end if;
    end process;
	 
end Behavioral;