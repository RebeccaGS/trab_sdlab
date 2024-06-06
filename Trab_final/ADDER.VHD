----------------------------------------------------------------------------------
-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia 
-- 
-- Module Name:    ADDER_1BIT - Behavioral 
-- Description: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ADDER_1BIT is
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           Cin : in  STD_LOGIC;
           Sum : out  STD_LOGIC;
           Cout : out  STD_LOGIC);
end ADDER_1BIT;

architecture Behavioral of ADDER_1BIT is

begin

    Sum <= A xor B xor Cin;
    Cout <= (A and B) or (Cin and (A xor B));

end Behavioral;

