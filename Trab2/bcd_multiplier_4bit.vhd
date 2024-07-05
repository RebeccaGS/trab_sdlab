
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bcd_digit_multiplier is
    Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           Z : out  STD_LOGIC_VECTOR (7 downto 0));
end bcd_digit_multiplier;

architecture Behavioral of bcd_digit_multiplier is

	signal product: UNSIGNED (7 downto 0);
	signal unit: UNSIGNED (3 downto 0);
	signal dez: UNSIGNED (3 downto 0);
	

begin
	
	process(A, B)
		begin
	
			product <= unsigned(A)*unsigned(B);
			
		unit <= product(3 downto 0);
		dez <= product(7 downto 4);
			
			if unit > 9 then
				 unit <= unit + 6;
				 
				end if;
	
	
	Z <= STD_LOGIC_VECTOR(dez & unit);
	
	end process;


end Behavioral;

