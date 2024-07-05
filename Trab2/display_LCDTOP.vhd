library IEEE;
21 use IEEE.STD_LOGIC_1164.ALL;
22
23 -- Uncomment the following library declaration if using
24 -- arithmetic functions with Signed or Unsigned values
25 --use IEEE.NUMERIC_STD.ALL;
26
27 -- Uncomment the following library declaration if instantiating
28 -- any Xilinx primitives in this code.
29 --library UNISIM;
30 --use UNISIM.VComponents.all;
31
32 entity ConvAsciiToBCD is
33 Port ( number_code : in STD_LOGIC_VECTOR (7 downto 0);
34 BCD : out STD_LOGIC_VECTOR (3 downto 0));
35 end ConvAsciiToBCD;
36
APÊNDICE C. Código referêntes ao display LCD 56
37 architecture Behavioral of ConvAsciiToBCD is
38
39 with number_code select
40 BCD <=
41 "0000" when "00110000", -- 0
42 "0001" when "00110001", -- 1
43 "0010" when "00110010", -- 2
44 "0011" when "00110011", -- 3
45 "0100" when "00110100", -- 4
46 "0101" when "00110101", -- 5
47 "0110" when "00110110", -- 6
48 "0111" when "00110111", -- 7
49 "1000" when "00111000", -- 8
50 "1001" when "00111001", -- 9
51
52 begin
53
54
55 end Behavioral;