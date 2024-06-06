----------------------------------------------------------------------------------
-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia
-- 
-- Module Name:    LogicOR - Behavioral 
-- Description: Funçãp lógica OR em uma ALU - VHDL  
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LogicOR is
    Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           Z : out  STD_LOGIC_VECTOR (3 downto 0));
end LogicOR;

architecture Behavioral of LogicOR is

begin

	Z <= A or B;

end Behavioral;

