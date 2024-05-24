-- Sistemas digitais 2024.1 - UFRJ
-- Autor: Rebecca Gomes Simão e Mariana Garcia
-- Transformar clock da placa em 2segundos - VHDL


-- Entidade
entity CLK is
    port (
      clock_O   : in std_logic
      clock_f  : out std_logic
    ) ;
end CLK;
    
-- Arquitetura
architecture behavioral of CLK is
    signal count : INTEGER := 0;
    signal clk_div : STD_LOGIC := '0';
    constant COUNT_MAX : INTEGER := 100000000; -- 100 milhões de ciclos para 2 segundos
    begin
        process(clock_0)
    begin
        if rising_edge(clock_0) then
            if count = COUNT_MAX - 1 then
                count <= 0;
                clk_div <= not clk_div;
            else
                count <= count + 1;
            end if;
        end if;
    end process;
    clock_f <= clk_div;

end behavioral ;
  