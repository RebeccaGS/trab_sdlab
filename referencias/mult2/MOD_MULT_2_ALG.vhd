library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity meu_codigo is
    Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           Z : out  STD_LOGIC_VECTOR (7 downto 0));
end meu_codigo;


architecture Behavioral of meu_codigo is

signal aux: std_logic_vector (7 downto 0);
signal result:unsigned (7 downto 0):="00000000";

begin

		result <= unsigned(A)*unsigned(B);
		Z <= std_logic_vector(result);

end Behavioral;


