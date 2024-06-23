--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:22:06 11/29/2019
-- Design Name:   
-- Module Name:   /home/sd/MULT/TESTE_MOD3.vhd
-- Project Name:  MULT
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: meu_codigo
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TESTE_MOD3 IS
END TESTE_MOD3;
 
ARCHITECTURE behavior OF TESTE_MOD3 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT meu_codigo
    PORT(
         A : IN  std_logic_vector(3 downto 0);
         B : IN  std_logic_vector(3 downto 0);
         Z : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(3 downto 0) := (others => '0');
   signal B : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal Z : std_logic_vector(7 downto 0);
   -- No clocks detected in port list. Replace clock below with 
   -- appropriate port name 
 
   constant clock_period : time := 10 ns;
	signal clock: std_logic;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: meu_codigo PORT MAP (
          A => A,
          B => B,
          Z => Z
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		A<="1111";
		B<="0011";
		
      wait for 100 ns;	
		A<="1111";
		B<="1111";

      wait for clock_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
