--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:	13:58:16 05/07/2013
-- Design Name:	
-- Module Name:	D:/Users/fjanky/VHDL/code/ProtoLayer/Simulation/New/EthernetModule/ETHPadder_test.vhd
-- Project Name:  EthernetModule
-- Target Device:  
-- Tool versions:  
-- Description:	
-- 
-- VHDL Test Bench Created by ISE for module: EthernetPadder
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
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;

USE WORK.ProtoLayerTypesAndDefs.ALL;
USE WORK.Simulation.ALL;
USE WORK.EthernetLayerPkg.EthernetPadder;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ETHPadder_test IS
END ETHPadder_test;
 
ARCHITECTURE behavior OF ETHPadder_test IS 
 
	 -- Component Declaration for the Unit Under Test (UUT)
	 --Inputs
	signal CLK : std_logic := '0';
	signal CE : std_logic := '0';
	signal RST : std_logic := '0';
	signal PDU_DIN : std_logic_vector(7 downto 0) := (others => '0');
	signal PDU_DINV : std_logic := '0';
	signal PDU_IN_SOP : std_logic := '0';
	signal PDU_IN_EOP : std_logic := '0';
	signal PDU_IN_ErrIn : std_logic := '0';
	signal PDU_IN_Ind : std_logic := '0';
	signal PDU_OUT_Ack : std_logic := '0';
	signal PDU_OUT_ErrIn : std_logic := '0';

 	--Outputs
	signal PDU_IN_Ack : std_logic;
	signal PDU_IN_ErrOut : std_logic;
	signal PDU_DOUT : std_logic_vector(7 downto 0);
	signal PDU_DOUTV : std_logic;
	signal PDU_Out_SOP : std_logic;
	signal PDU_OUT_EOP : std_logic;
	signal PDU_OUT_ErrOut : std_logic;
	signal PDU_OUT_Ind : std_logic;

	-- Clock period definitions
	constant CLK_period : time := 8 ns;

	signal OUTACK_SET		: std_logic := '0';
	signal OUTACK_RST		: std_logic := '0';
	signal OUTACK_delay		: integer := 1;
	signal OUTACK_width		: integer := 1;
	

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
	uut: EthernetPadder 
	GENERIC MAP(
		DataWidth		=>	DefDataWidth,
		SYNC_OUT		=>	TRUE --JUST SYNC Input!!!
	)
	PORT MAP (
			 CLK => CLK,
			 CE => CE,
			 RST => RST,
			 PDU_DIN => PDU_DIN,
			 PDU_DINV => PDU_DINV,
			 PDU_IN_SOP => PDU_IN_SOP,
			 PDU_IN_EOP => PDU_IN_EOP,
			 PDU_IN_ErrIn => PDU_IN_ErrIn,
			 PDU_IN_Ind => PDU_IN_Ind,
			 PDU_IN_Ack => PDU_IN_Ack,
			 PDU_IN_ErrOut => PDU_IN_ErrOut,
			 PDU_DOUT => PDU_DOUT,
			 PDU_DOUTV => PDU_DOUTV,
			 PDU_Out_SOP => PDU_Out_SOP,
			 PDU_OUT_EOP => PDU_OUT_EOP,
			 PDU_OUT_ErrOut => PDU_OUT_ErrOut,
			 PDU_OUT_Ind => PDU_OUT_Ind,
			 PDU_OUT_Ack => PDU_OUT_Ack,
			 PDU_OUT_ErrIn => PDU_OUT_ErrIn
		);

	-- Clock process definitions
	CLK_process :process
	begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
	end process;
	RSTer	: Resetter PORT MAP(CLK,RST,CE);
	OUT_Acker	: Acker 
	PORT MAP(
		clk			=>	clk,
		set			=>	OUTACK_SET,
		rst			=>	OUTACK_RST,
		I			=>	PDU_OUT_Ind,
		delay		=>	OUTACK_delay,
		resp_width	=>	OUTACK_width,
		Q			=>	PDU_OUT_Ack
	);
	-- Stimulus process
	stim_proc: process
	begin		
		-- hold reset state for 100 ns.
		WAIT_CLK(CLK_period,10);
		-- insert stimulus here 
		Emit_PDU_SYNC(CLK_PERIOD,10,1,PDU_IN_Ack,PDU_IN_Ind,PDU_DIN,PDU_DINV,PDU_IN_SOP,PDU_IN_EOP);
		WAIT_CLK(CLK_period,10);
		Emit_PDU_SYNC(CLK_PERIOD,20,1,PDU_IN_Ack,PDU_IN_Ind,PDU_DIN,PDU_DINV,PDU_IN_SOP,PDU_IN_EOP);
		WAIT_CLK(CLK_period,10);
		Emit_PDU_SYNC(CLK_PERIOD,64,1,PDU_IN_Ack,PDU_IN_Ind,PDU_DIN,PDU_DINV,PDU_IN_SOP,PDU_IN_EOP);
		WAIT_CLK(CLK_period,10);
		Emit_PDU_SYNC(CLK_PERIOD,65,1,PDU_IN_Ack,PDU_IN_Ind,PDU_DIN,PDU_DINV,PDU_IN_SOP,PDU_IN_EOP);
		WAIT_CLK(CLK_period,10);
		Emit_PDU_SYNC(CLK_PERIOD,20,1,PDU_IN_Ack,PDU_IN_Ind,PDU_DIN,PDU_DINV,PDU_IN_SOP,PDU_IN_EOP);
		WAIT_CLK(CLK_period,10);
		Emit_PDU_SYNC(CLK_PERIOD,128,1,PDU_IN_Ack,PDU_IN_Ind,PDU_DIN,PDU_DINV,PDU_IN_SOP,PDU_IN_EOP);

		wait;
	end process;

END;
