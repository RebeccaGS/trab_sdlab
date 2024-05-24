library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity user_interface is
    Port ( switches    : in  STD_LOGIC_VECTOR(3 downto 0);
           button      : in  STD_LOGIC;
           reset       : in  STD_LOGIC;
           leds_right  : out STD_LOGIC_VECTOR(3 downto 0);
           leds_left   : out STD_LOGIC_VECTOR(3 downto 0);
           clk         : in  STD_LOGIC);
end user_interface;

architecture Behavioral of user_interface is

    type state_type is (IDLE, SET_NUM1, SET_NUM2, SET_OP, DISPLAY);
    signal state, next_state : state_type;

    signal num1, num2 : INTEGER := 0;
    signal operation : INTEGER := 0;
    signal result : INTEGER := 0;

    signal op_cycle : INTEGER := 1;
    signal display_count : INTEGER := 0;
    signal clk_count : INTEGER := 0;
    constant CLK_MAX : INTEGER := 100000000; -- assuming a 100MHz clock

begin

    process(clk, reset)
    begin
        if reset = '1' then
            state <= IDLE;
            num1 <= 0;
            num2 <= 0;
            operation <= 0;
            result <= 0;
            op_cycle <= 1;
            display_count <= 0;
            clk_count <= 0;
        elsif rising_edge(clk) then
            if clk_count = CLK_MAX then
                clk_count <= 0;
                state <= next_state;
            else
                clk_count <= clk_count + 1;
            end if;
        end if;
    end process;

    process(state, button, switches)
    begin
        next_state <= state;
        leds_left <= "0000";
        case state is
            when IDLE =>
                leds_left <= "0000";
                if button = '1' then
                    next_state <= SET_NUM1;
                end if;

            when SET_NUM1 =>
                leds_left <= "1000";
                if button = '1' then
                    num1 <= to_integer(unsigned(switches));
                    next_state <= SET_NUM2;
                end if;

            when SET_NUM2 =>
                leds_left <= "0100";
                if button = '1' then
                    num2 <= to_integer(unsigned(switches));
                    next_state <= SET_OP;
                end if;

            when SET_OP =>
                leds_left <= "0010";
                if button = '1' then
                    operation <= to_integer(unsigned(switches));
                    next_state <= DISPLAY;
                end if;

            when DISPLAY =>
                leds_left <= "0001";
                if clk_count = CLK_MAX then
                    if display_count = 0 then
                        leds_right <= std_logic_vector(to_unsigned(num1, 4));
                    elsif display_count = 1 then
                        leds_right <= std_logic_vector(to_unsigned(num2, 4));
                    elsif display_count = 2 then
                        leds_right <= std_logic_vector(to_unsigned(op_cycle, 4));
                    elsif display_count = 3 then
                        case op_cycle is
                            -- CHAMA A MAIN
                            when 1 => result <= num1 + num2;
                            when 2 => result <= num1 - num2;
                            when 3 => result <= num1 * num2;
                            when 4 => if num2 /= 0 then result <= num1 / num2; else result <= 0; end if;
                            when others => result <= 0;
                        end case;
                        leds_right <= std_logic_vector(to_unsigned(result, 4));
                        op_cycle <= op_cycle + 1;
                        if op_cycle = 9 then
                            op_cycle <= 1;
                        end if;
                    end if;
                    display_count <= display_count + 1;
                    if display_count = 4 then
                        display_count <= 0;
                    end if;
                end if;
        end case;
    end process;

end Behavioral;
