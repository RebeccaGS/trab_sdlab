----------------------------------------------------------------------------------
-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia
-- 
-- Module Name:   BCD_ADDER  
-- Description: Somador completo de 4 bits em uma ALU - VHDL  
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BDC_ADDER is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (7 downto 0);
           Z : out  STD_LOGIC_VECTOR (7 downto 0));
end BDC_ADDER;

architecture Behavioral of BDC_ADDER is

begin 
	process (A, B)
	variable digit0_sum : STD_LOGIC_VECTOR (3 downto 0);
	variable digit1_sum :  STD_LOGIC_VECTOR (3 downto 0);
	variable digit0, digit1, digit2, digit3 :  STD_LOGIC_VECTOR(3 downto 0);
	variable carry0, carry1 : STD_LOGIC;

begin
	digit0 := A(3 downto 0);
	digit1 := A(7 downto 4);
	digit2 := B(3 downto 0);
	digit3 := B(7 downto 4);

		digit0_sum := digit0 + digit2;
		carry0 := '0';
		
		if digit0_sum > "1001" then
			digit0_sum := digit0_sum + "0110";
			carry0 := '1';
			
		end if;
		
		digit1_sum := digit1 + digit3 + carry0;
		carry1 := '0';
		
		if digit1_sum > "1001" then
			digit1_sum := digit0_sum + "0110";
			carry1 := '1';
			
		end if;
		
		Z <= digit1_sum & digit0_sum;
		
	end process;

end Behavioral;

