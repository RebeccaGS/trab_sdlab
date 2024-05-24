D.2 REDUTOR DE CLOCK
30 library IEEE;
31 use IEEE.STD_LOGIC_1164.ALL;
32
33 entity redutorClock is
34 port (
35 clk_in : in std_logic;
36 clk_out : out std_logic
37 );
38 end redutorClock;
39
40 architecture arcRedutorClock of redutorClock is
41 signal aux : integer;
42 begin
43 process(clk_in)
44 begin

APÊNDICE D. Código interface com usuário 47
45 if(clk_in'event and clk_in = '1') then
46 -- o clock interno da placa possui freq de 50MHz.
47 --Vamos multiplicar seu periodo por
48 -- 100 milhoes para ter um periodo de 2 segundos
49 if(aux = 100000000 ) then -- variavel auxiliar vai de

,→ zero ate

50 --100 milhoes e volta
51 aux<=0;
52 else
53 aux <= aux + 1;
54 end if;
55
56 if(aux >= 50000000) then -- metado do tempo ela ta em

,→ high,

57 -- metade em low
58 clk_out <='1';
59 else
60 clk_out <='0';
61 end if;
62 end if;
63 end process;
64 end architecture;