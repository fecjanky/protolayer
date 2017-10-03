--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:	15:14:10 04/03/2013
-- Design Name:	
-- Module Name:	C:/ferenc.janky/ISE/PDU_queue/PDUQ_Detect_test_2.vhd
-- Project Name:  PDU_queue
-- Target Device:  
-- Tool versions:  
-- Description:	
-- 
-- VHDL Test Bench Created by ISE for module: PDUQueue
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic AND
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

library work;
use work.ProtoLayerTypesAndDefs.all;
use work.ProtoModulePkg.PDUQueue;
use work.Simulation.all;

ENTITY PDUQ_test_3 IS
END PDUQ_test_3;
 
ARCHITECTURE behavior OF PDUQ_test_3 IS 
 
	 -- Component Declaration for the Unit Under Test (UUT)
	--Inputs
	signal CLK : std_logic := '0';
	signal CE_In : std_logic := '0';
	signal CE_Out : std_logic := '0';
	signal CE : std_logic := '0';
	signal RST : std_logic := '0';
	signal DIN : std_logic_vector(7 downto 0) := (others => '0');
	signal DINV : std_logic := '0';
	signal In_SOP : std_logic := '0';
	signal In_EOP : std_logic := '0';
	signal In_Ind : std_logic := '0';
	signal In_ErrIn : std_logic := '0';
	signal Out_Ack : std_logic := '0';
	signal Out_ErrIn : std_logic := '0';
	signal CTRL_Ack : std_logic := '0';
	signal CTRL_FWD : std_logic := '0';
	signal CTRL_Pause : std_logic := '0';
	signal CTRL_DROP_ERR : std_logic := '0';
	signal USER_IN : std_logic_vector(5 downto 0) := (others => '0');
 	--Outputs
	signal In_Ack : std_logic;
	signal In_ErrOut : std_logic;
	signal DOUT : std_logic_vector(7 downto 0);
	signal DOUTV : std_logic;
	signal Out_SOP : std_logic;
	signal Out_EOP : std_logic;
	signal Out_Ind : std_logic;
	signal Out_ErrOut : std_logic;
	signal CTRL_DOUT : std_logic_vector(7 downto 0);
	signal CTRL_DV : std_logic;
	signal CTRL_SOP : std_logic;
	signal CTRL_EOP : std_logic;
	signal CTRL_ErrOut : std_logic;
	signal CTRL_Ind : std_logic;
	signal USER_Out : std_logic_vector(5 downto 0) := (others => '0');
	signal USER_Out_CTRL : std_logic_vector(5 downto 0) := (others => '0');

	--simulation aux signals
	signal CTRL_FWD_SET		: std_logic := '0';
	signal CTRL_FWD_RST		: std_logic := '0';
	signal CTRL_FWD_delay		: integer := 8;
	signal CTRL_FWD_width		: integer := 1;
	
	signal CTRL_ACK_SET		: std_logic := '0';
	signal CTRL_ACK_RST		: std_logic := '0';
	signal CTRL_ACK_delay		: integer := 1;
	signal CTRL_ACK_width		: integer := 1;

	signal CTRL_DROP_SET		: std_logic := '0';
	signal CTRL_DROP_RST		: std_logic := '0';
	signal CTRL_DROP_delay	: integer := 1;
	signal CTRL_DROP_width		: integer := 1;

	signal OUTACK_SET		: std_logic := '0';
	signal OUTACK_RST		: std_logic := '0';
	signal OUTACK_delay		: integer := 1;
	signal OUTACK_width		: integer := 1;

	signal CTRL_PAUSE_SET		: std_logic := '0';
	signal CTRL_PAUSE_RST		: std_logic := '0';
	signal CTRL_PAUSE_delay	: integer := 4;
	signal CTRL_PAUSE_width		: integer := 6;

	signal CTRL_SOF			: std_logic := '0';


	-- Clock period definitions
	constant CLK_period : time := 10 ns;
 
BEGIN
	CE_In	<=	CE;
	CE_Out	<=	CE;
	-- Instantiate the Unit Under Test (UUT)
	uut: PDUQueue 
	
	generic map(
--		DataWidth					:		integer 	:= 	8;
		SYNC_IN					=>	TRUE,
		SYNC_OUT					=> 	TRUE,
		SYNC_CTRL					=>	TRUE
--		MINPDUSize				:		integer	:=	64;
--		MAXPDUSize				:		integer	:=	1500;
--		MaxPDUToQ					:		integer	:= 	30
	)
	
	PORT MAP (
			 CLK => CLK,
			 CE_In => CE_In,
			 CE_Out => CE_Out,
			 RST => RST,
			 DIN => DIN,
			 DINV => DINV,
			 In_SOP => In_SOP,
			 In_EOP => In_EOP,
			 In_Ind => In_Ind,
			 In_ErrIn => In_ErrIn,
			 In_Ack => In_Ack,
			 In_ErrOut => In_ErrOut,
			 DOUT => DOUT,
			 DOUTV => DOUTV,
			 Out_SOP => Out_SOP,
			 Out_EOP => Out_EOP,
			 Out_Ind => Out_Ind,
			 Out_ErrOut => Out_ErrOut,
			 Out_Ack => Out_Ack,
			 Out_ErrIn => Out_ErrIn,
			 CTRL_DOUT => CTRL_DOUT,
			 CTRL_DV => CTRL_DV,
			 CTRL_SOP => CTRL_SOP,
			 CTRL_EOP => CTRL_EOP,
			 CTRL_ErrOut => CTRL_ErrOut,
			 CTRL_Ind => CTRL_Ind,
			 CTRL_Ack => CTRL_Ack,
			 CTRL_FWD => CTRL_FWD,
			 CTRL_Pause => CTRL_Pause,
			 CTRL_DROP_ERR => CTRL_DROP_ERR,
		User_In => User_In,
		User_Out => User_Out,
		USER_Out_CTRL => USER_Out_CTRL
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
		INIT_Module(CLK_PERIOD,5,5,RST,CE);
		--normal op test (header removal)
		WAIT_CLK(CLK_PERIOD,10);
		CTRL_DROP_RST	<=	Hi;
		CTRL_FWD_delay <= 10;
		Emit_PDU_SYNC(CLK_PERIOD,64,1,In_Ack,In_Ind,DIN,DINV,In_SOP,In_EOP);
		WAIT_CLK(CLK_PERIOD,5);
		CTRL_FWD_RST	<= Hi;
		Emit_PDU_SYNC(CLK_PERIOD,64,1,In_Ack,In_Ind,DIN,DINV,In_SOP,In_EOP);
		CTRL_FWD_RST	<= Lo;
		WAIT_CLK(CLK_PERIOD,40);
		CTRL_FWD_SET	<=	Hi;
		Emit_PDU_SYNC(CLK_PERIOD,64,1,In_Ack,In_Ind,DIN,DINV,In_SOP,In_EOP);
		CTRL_FWD_RST	<=	Hi;
		CTRL_FWD_SET	<=	Lo;
		WAIT_CLK(CLK_PERIOD,5);
		CTRL_FWD_RST	<=	Lo;
		Emit_PDU_SYNC(CLK_PERIOD,64,1,In_Ack,In_Ind,DIN,DINV,In_SOP,In_EOP);
--		--just control test (no forwarding)
--		CTRL_FWD_rst <= Hi;
--		Emit_PDU(64,CLK_PERIOD,DIN,DINV,In_SOP,In_EOP);
--		--pass through test		
--		CTRL_FWD_rst <= Lo;
--		CTRL_FWD_set <= Hi;		
--		wait for CLK_period;
--		Emit_PDU(256,CLK_PERIOD,DIN,DINV,In_SOP,In_EOP);		
--		CTRL_FWD_set <= Lo;
--		--drop test
--		CTRL_FWD_rst <= Hi;
--		CTRL_DROP_rst <= Lo;
--		CTRL_DROP_delay <= 15;
--		Emit_PDU(64,CLK_PERIOD,DIN,DINV,In_SOP,In_EOP);
--		--normal op test (header removal) after drop
--		CTRL_DROP_rst  <= Hi;
--		CTRL_FWD_rst 	<= Lo;
--		CTRL_FWD_delay <= 20;
--		wait for CLK_period*10;	
--		Emit_PDU(64,CLK_PERIOD,DIN,DINV,In_SOP,In_EOP);
		wait;
	end process;
	
	
CTRL_FWD_Acker: Acker PORT MAP(
	clk => clk,
	set => CTRL_FWD_SET,
	rst => CTRL_FWD_RST,
	I => CTRL_SOP,
	delay => CTRL_FWD_delay,
	resp_width => CTRL_FWD_width,
	Q => CTRL_FWD
);

CTRL_Acker: Acker PORT MAP(
	clk => clk,
	set => CTRL_ACK_SET,
	rst => CTRL_ACK_RST,
	I => CTRL_Ind,
	delay => CTRL_ACK_delay,
	resp_width => CTRL_ACK_width,
	Q => CTRL_ACK
);

CTRL_SOF <= CTRL_SOP AND CTRL_DV;
CTRL_PAUSER: Acker  PORT MAP(
	clk => clk,
	set => CTRL_PAUSE_SET,
	rst => CTRL_PAUSE_RST,
	I => CTRL_SOF,
	delay => CTRL_PAUSE_delay,
	resp_width => CTRL_PAUSE_width,
	Q => CTRL_PAUSE
);



OUT_Acker: Acker PORT MAP(
	clk => clk,
	set => OUTACK_SET,
	rst => OUTACK_RST,
	I => Out_Ind,
	delay => OUTACK_delay,
	resp_width => OUTACK_width,
	Q => Out_Ack
);

CTRL_DROpper: Acker PORT MAP(
	clk => clk,
	set => CTRL_DROP_SET,
	rst => CTRL_DROP_RST,
	I => CTRL_SOP,
	delay => CTRL_DROP_delay,
	resp_width => CTRL_DROP_width,
	Q => CTRL_DROP_ERR
);

END;
