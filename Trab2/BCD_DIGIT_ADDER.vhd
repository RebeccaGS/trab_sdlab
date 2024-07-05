library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bcd_digit_adder is
    Port (
        A : in  STD_LOGIC_VECTOR (3 downto 0); -- 1 dígito BCD
        B : in  STD_LOGIC_VECTOR (3 downto 0); -- 1 dígito BCD
        CIN : in STD_LOGIC;
        SUM : out  STD_LOGIC_VECTOR (3 downto 0);
        COUT : out STD_LOGIC
    );
end bcd_digit_adder;


architecture Behavioral of bcd_digit_adder is
begin
    process (A, B)
        variable temp_sum : STD_LOGIC_VECTOR(4 downto 0);
        variable adjusted_sum : STD_LOGIC_VECTOR(3 downto 0);
        variable carry : STD_LOGIC;
		  
   begin
        temp_sum := ("0" & A) + ("0" & B) + ("0000" & CIN);
        carry := '0';
        if temp_sum > "01001" then
            adjusted_sum := temp_sum(3 downto 0) + "0110";
            carry := '1';
				
        else
            adjusted_sum := temp_sum(3 downto 0);
        end if;
		  
        SUM <= adjusted_sum;
        COUT <= carry;

    end process;
end Behavioral;	  
