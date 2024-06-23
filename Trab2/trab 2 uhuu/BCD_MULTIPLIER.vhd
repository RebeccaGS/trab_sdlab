----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:36:24 06/21/2024 
-- Design Name: 
-- Module Name:    BCD_MULTIPLIER - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BCD_MULTIPLIER is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (7 downto 0);
           Z : out  STD_LOGIC_VECTOR (15 downto 0));
end BCD_MULTIPLIER;

architecture Behavioral of BCD_MULTIPLIER is
	
		signal multi0 :  STD_LOGIC_VECTOR (7 downto 0);
		signal multi1:  STD_LOGIC_VECTOR(7 downto 0);
		signal product: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');

begin
	process (A, B)
	begin
		product <= (others => '0');
		multi0 <= A;
		multi1 <= B;
		
		for i in 0 to 7 loop
			if multi1(0) = '1' then 
			product <= product + (multi0 & (others => '0')) sll i;
			end if;
			
			multi1 <= '0' &  multi1(7 downto 1);
		end loop;
		
		Z <= product;
		
	end process;
			
end Behavioral;

