--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:34:33 11/30/2012
-- Design Name:   
-- Module Name:   E:/docs/univ/2012_2013_I/dipterv_1/VHDL/Simulation/EOP_test.vhd
-- Project Name:  EtherLayer
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: EOPGenerator
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_misc.ALL;
use IEEE.math_real.ALL;
use IEEE.numeric_std.ALL;
--USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

Library UNISIM;
use UNISIM.vcomponents.all;

library work;
use work.TypesAndDefinitonsPkg.all;

ENTITY EOP_test IS
END EOP_test;
 
ARCHITECTURE behavior OF EOP_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT EOPGenerator
    PORT(
         CLK : IN  std_logic;
         EN : IN  std_logic;
         RST : IN  std_logic;
         DIN : IN  std_logic_vector(7 downto 0);
         DV : IN  std_logic;
         SOP_IN : IN  std_logic;
         DOUT : OUT  std_logic_vector(7 downto 0);
         DV_OUT : OUT  std_logic;
         SOP_OUT : OUT  std_logic;
         EOP : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal EN : std_logic := '0';
   signal RST : std_logic := '0';
   signal DIN : std_logic_vector(7 downto 0) := (others => '0');
   signal DV : std_logic := '0';
   signal SOP_IN : std_logic := '0';

 	--Outputs
   signal DOUT : std_logic_vector(7 downto 0);
   signal DV_OUT : std_logic;
   signal SOP_OUT : std_logic;
   signal EOP : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: EOPGenerator PORT MAP (
          CLK => CLK,
          EN => EN,
          RST => RST,
          DIN => DIN,
          DV => DV,
          SOP_IN => SOP_IN,
          DOUT => DOUT,
          DV_OUT => DV_OUT,
          SOP_OUT => SOP_OUT,
          EOP => EOP
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;
	 
	RST<=HI;
	EN <= HI;
	wait for CLK_period;
	RST<=Lo;
	wait for CLK_period*10;
	
	DV <= Hi;
	SOP_IN <= Hi;
	DIN <= x"00";
	wait for CLK_period;  
	SOP_IN <= Lo;
	DIN <= x"01";
	wait for CLK_period;  
	DIN <= x"17";
	wait for CLK_period;  
	DIN <= x"F3";
	wait for CLK_period;  
	DIN <= x"F7";
	wait for CLK_period;  
	DIN <= x"86";
	wait for CLK_period;
	for i in 0 to 5 loop
	DIN <= x"12";
	wait for CLK_period;  
	end loop;
	DIN <= x"80";
	wait for CLK_period;
	DIN <= x"00";
	wait for CLK_period; 	
	for i in 0 to 63 loop
	DIN <= STD_LOGIC_VECTOR(TO_UNSIGNED(i,8));
	wait for CLK_period;
	end loop;
	DV <= Lo;
	wait for CLK_period * 10;

      -- insert stimulus here 

      wait;
   end process;

END;
