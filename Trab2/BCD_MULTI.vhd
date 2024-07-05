library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity bcd_multiplier is
    Port ( A : in  STD_LOGIC_VECTOR (15 downto 0);
           B : in  STD_LOGIC_VECTOR (15 downto 0);
           PRODUCT  : out  STD_LOGIC_VECTOR (31 downto 0));
end bcd_multiplier;

architecture Behavioral of bcd_multiplier is
	signal partial_product : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal multiplicand : STD_LOGIC_VECTOR(15 downto 0);
    signal multiplier : STD_LOGIC_VECTOR(15 downto 0);
	 
begin

process (A, B)
        variable result : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
        variable temp : STD_LOGIC_VECTOR(31 downto 0);
        variable extended_multiplicand : STD_LOGIC_VECTOR(31 downto 0);
        variable i : integer;	 


	    begin
        multiplicand <= A;
        multiplier <= B;
        partial_product <= (others => '0');
		  
		  extended_multiplicand := (others => '0');
        extended_multiplicand(15 downto 0) := multiplicand;
		  
        for i in 0 to 15 loop
            if multiplier(i) = '1' then
                temp := std_logic_vector(unsigned(extended_multiplicand) 2** i);
					 
	            result := result + temp;
            end if;
        end loop;
		  

        PRODUCT <= result;
    end process;
end Behavioral;				 


