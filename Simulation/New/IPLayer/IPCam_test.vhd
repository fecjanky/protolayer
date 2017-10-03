--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:	14:35:21 04/25/2013
-- Design Name:	
-- Module Name:	D:/Users/fjanky/VHDL/code/ProtoLayer/Simulation/New/IPLayer/IPCam_test.vhd
-- Project Name:  IPLayer
-- Target Device:  
-- Tool versions:  
-- Description:	
-- 
-- VHDL Test Bench Created by ISE for module: IPCAM
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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;
USE IEEE.numeric_std.ALL;

use work.ProtoLayerTypesAndDefs.all;
use work.Simulation.all;
use work.IPLayerPkg.IPCAM;

ENTITY IPCam_test IS
END IPCam_test;
 
ARCHITECTURE behavior OF IPCam_test IS 
 
	 -- Component Declaration for the Unit Under Test (UUT)
 
	 

	--Inputs
	signal CLK : std_logic := '0';
	signal RST : std_logic := '0';
	signal CE : std_logic := '0';
	signal WR_EN : std_logic := '0';
	signal RD_EN : std_logic := '0';
	signal ValidAddrIn : std_logic := '0';
	signal IPAddrIN : std_logic_vector(31 downto 0) := (others => '0');
	signal NetMaskIN : std_logic_vector(31 downto 0) := (others => '0');
	signal ADDR_In : std_logic_vector(1 downto 0) := (others => '0');
	signal CAM_IPaddrIN : std_logic_vector(31 downto 0) := (others => '0');
	signal CAM_SRCH : std_logic := '0';

	--Outputs
	signal Match : std_logic;
	signal MatchV : std_logic;
	signal ValidAddrOut : std_logic;
	signal IPAddrOUT : std_logic_vector(31 downto 0);
	signal NetMaskOUT : std_logic_vector(31 downto 0);
	signal ADDR_Out : std_logic_vector(1 downto 0);
	signal DOUTV : std_logic;

	-- Clock period definitions
	constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
	uut: IPCAM 
	generic map(
	Elements			=>	4
	)
	PORT MAP (
		CLK => CLK,
		RST => RST,
		CE => CE,
		WR_EN => WR_EN,
		RD_EN => RD_EN,
		ValidAddrIn => ValidAddrIn,
		IPAddrIN => IPAddrIN,
		NetMaskIN => NetMaskIN,
		ADDR_In => ADDR_In,
		CAM_IPaddrIN => CAM_IPaddrIN,
		CAM_SRCH => CAM_SRCH,
		Match => Match,
		MatchV => MatchV,
		ValidAddrOut => ValidAddrOut,
		IPAddrOUT => IPAddrOUT,
		NetMaskOUT => NetMaskOUT,
		ADDR_Out => ADDR_Out,
		DOUTV => DOUTV
		);
	RSTer: Resetter
	port map(
		CLK	=>	CLK,
		RST	=>	RST,
		CE	=>	CE
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
	WAIT_CLK(CLK_period,20);
	ValidAddrIn	<=	Hi;
	IPAddrIN		<=	X"0a0a000b";
	NetMaskIN		<=	X"FF000000";
	WR_EN		<=	Hi;
	WAIT_CLK(CLK_period,1);
	WR_EN		<=	Lo;
	WAIT_CLK(CLK_period,1);
	ADDR_In		<=	"01";
	ValidAddrIn	<=	Hi;
	IPAddrIN		<=	X"0a0a000c";
	NetMaskIN		<=	X"FF000000";
	WR_EN		<=	Hi;
	WAIT_CLK(CLK_period,1);
	WR_EN		<=	Lo;
	CAM_IPaddrIN	<=	X"0a0a000b";
	CAM_SRCH		<=	Hi;
	WAIT_CLK(CLK_period,1);
	CAM_SRCH		<=	Lo;
	WAIT_CLK(CLK_period,10);
	ValidAddrIn	<=	Lo;
	WR_EN		<=	Hi;
	WAIT_CLK(CLK_period,1);
	WR_EN		<=	Lo;
	CAM_SRCH		<=	Hi;
	WAIT_CLK(CLK_period,1);
	CAM_SRCH		<=	Lo;
	WAIT_CLK(CLK_period,10);
	RD_EN	<=	Hi;
	WAIT_CLK(CLK_period,1);
	RD_EN	<=	Lo;
	 -- insert stimulus here 

	 wait;
	end process;

END;
