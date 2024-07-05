library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- use IEEE.NUMERIC_STD.ALL;

entity bcd_adder is
    Port (
        A : in  STD_LOGIC_VECTOR (15 downto 0); -- 4 dígitos BCD
        B : in  STD_LOGIC_VECTOR (15 downto 0); -- 4 dígitos BCD
        SUM : out  STD_LOGIC_VECTOR (15 downto 0); -- 4 dígitos BCD
        CARRY_OUT : out STD_LOGIC -- Carry out final
    );
end bcd_adder;


architecture Behavioral of bcd_adder is
begin
    process (A, B)
        variable digit0_sum, digit1_sum, digit2_sum, digit3_sum : STD_LOGIC_VECTOR(3 downto 0);
        variable digit0, digit1, digit2, digit3 : STD_LOGIC_VECTOR(3 downto 0);
        variable digit4, digit5, digit6, digit7 : STD_LOGIC_VECTOR(3 downto 0);
        variable carry0, carry1, carry2, carry3 : STD_LOGIC;
		  
   begin
        digit0 := A(3 downto 0);
        digit1 := A(7 downto 4);
        digit2 := A(11 downto 8);
        digit3 := A(15 downto 12);

        digit4 := B(3 downto 0);
        digit5 := B(7 downto 4);
        digit6 := B(11 downto 8);
        digit7 := B(15 downto 12);

        digit0_sum := digit0 + digit4;
        carry0 := '0';
        if digit0_sum > "1001" then
            digit0_sum := digit0_sum + "0110";
            carry0 := '1';
        end if;
		  
       digit1_sum := digit1 + digit5 + carry0;
        carry1 := '0';
        if digit1_sum > "1001" then
            digit1_sum := digit1_sum + "0110";
            carry1 := '1';
        end if;

        digit2_sum := digit2 + digit6 + carry1;
        carry2 := '0';
        if digit2_sum > "1001" then
            digit2_sum := digit2_sum + "0110";
            carry2 := '1';
        end if;
		  
	        digit3_sum := digit3 + digit7 + carry2;
        carry3 := '0';
        if digit3_sum > "1001" then
            digit3_sum := digit3_sum + "0110";
            carry3 := '1';
        end if;

        SUM <= digit3_sum & digit2_sum & digit1_sum & digit0_sum;
        CARRY_OUT <= carry3;
    end process;
end Behavioral;	