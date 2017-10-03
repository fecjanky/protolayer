--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:31:31 04/15/2013
-- Design Name:   
-- Module Name:   D:/Users/fjanky/VHDL/code/Simulation/New/EthernetModule/CAM_test.vhd
-- Project Name:  EthernetModule
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MiniCAM
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
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;
USE IEEE.numeric_std.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

use work.Simulation.all;
use work.ProtoLayerTypesAndDefs.all;
use work.ProtoModulePkg.MiniCAM;

ENTITY CAM_test IS
END CAM_test;
 
ARCHITECTURE behavior OF CAM_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal CE : std_logic := '0';
   signal WR_EN : std_logic := '0';
   signal RD_EN : std_logic := '0';
   signal DIN : std_logic_vector(MacAddrSize-1 downto 0) := (others => '0');
   signal ADDR_In : std_logic_vector(0 downto 0) := (others => '0');
   signal CAM_DIN : std_logic_vector(MacAddrSize-1 downto 0) := (others => '0');
   signal CAM_SRCH : std_logic := '0';


 	--Outputs
   signal Match : std_logic;
   signal MatchV : std_logic;
   signal DOUT : std_logic_vector(MacAddrSize-1 downto 0) := (others => '0');
   signal DOUTV : std_logic := '0';

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MiniCAM 
   generic map(
		DataWidth			=>	MacAddrSize,
		Elements			=>	2
	)
	PORT MAP(
			CLK => CLK,
			RST => RST,
			CE => CE,
			WR_EN => WR_EN,
			RD_EN => RD_EN,
			DIN => DIN,
			ADDR_In => ADDR_In,
			CAM_DIN => CAM_DIN,
			CAM_SRCH => CAM_SRCH,
			Match => Match,
			MatchV => MatchV,
			DOUT => DOUT,
			DOUTV => DOUTV
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
	Init_Module(CLK_period,5,5,RST,CE);
	WR_CAM(CLK_period,0,X"001122334455",WR_EN,ADDR_In,DIN);
	WAIT_CLK(CLK_period,5);
	-- DIN	<= X"001122334455";
	DIN	<= X"FFFFFFFFFFFF";
	RD_EN	<=	Hi;
	WAIT_CLK(CLK_period,1);
	RD_EN	<=	Lo;
      -- insert stimulus here 
	WAIT_CLK(CLK_period,5);
	DIN	<= X"001122334455";
	-- DIN	<= X"FFFFFFFFFFFF";
	RD_EN	<=	Hi;
	WAIT_CLK(CLK_period,1);
	RD_EN	<=	Lo;
	
	WAIT_CLK(CLK_period,5);
	DIN	<= X"001122334456";
	-- DIN	<= X"FFFFFFFFFFFF";
	RD_EN	<=	Hi;
	WAIT_CLK(CLK_period,1);
	RD_EN	<=	Lo;
      wait;
   end process;

END;
