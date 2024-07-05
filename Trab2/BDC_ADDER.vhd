library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity bcd_adder is
    Port ( A : in  STD_LOGIC_VECTOR (15 downto 0);
           B : in  STD_LOGIC_VECTOR (15 downto 0);
           SUM : out  STD_LOGIC_VECTOR (15 downto 0);
           CARRY_OUT : out  STD_LOGIC);
end bcd_adder;

architecture Behavioral of bcd_adder is

    signal digit0_sum, digit1_sum, digit2_sum, digit3_sum : STD_LOGIC_VECTOR(3 downto 0);
    signal carry0, carry1, carry2, carry3 : STD_LOGIC;

    component bcd_digit_adder
        Port (
            A : in  STD_LOGIC_VECTOR (3 downto 0);
            B : in  STD_LOGIC_VECTOR (3 downto 0);
            CIN : in STD_LOGIC;
            SUM : out  STD_LOGIC_VECTOR (3 downto 0);
            COUT : out STD_LOGIC
        );
    end component;

begin

    digit0_adder: bcd_digit_adder
        Port map (
            A => A(3 downto 0),
            B => B(3 downto 0),
            CIN => '0',
            SUM => digit0_sum,
            COUT => carry0
        );
		  
    digit1_adder: bcd_digit_adder
        Port map (
            A => A(7 downto 4),
            B => B(7 downto 4),
            CIN => carry0,
            SUM => digit1_sum,
            COUT => carry1
        );
		  
    digit2_adder: bcd_digit_adder
        Port map (
            A => A(11 downto 8),
            B => B(11 downto 8),
            CIN => carry1,
            SUM => digit2_sum,
            COUT => carry2
        );
		  
    digit3_adder: bcd_digit_adder
        Port map (
            A => A(15 downto 12),
            B => B(15 downto 12),
            CIN => carry2,
            SUM => digit3_sum,
            COUT => carry3
        );
		  

    SUM <= digit3_sum & digit2_sum & digit1_sum & digit0_sum;
    CARRY_OUT <= carry3;


end Behavioral;
