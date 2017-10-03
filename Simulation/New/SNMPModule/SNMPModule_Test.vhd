--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:	11:02:10 05/12/2013
-- Design Name:	
-- Module Name:	E:/docs/univ/2012_2013_II/dipterv2/VHDL/ProtoLayer/Simulation/New/SNMPModule/SNMPModule_Test.vhd
-- Project Name:  SNMPModule
-- Target Device:  
-- Tool versions:  
-- Description:	
-- 
-- VHDL Test Bench Created by ISE for module: SNMPModule
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
USE IEEE.math_real.ALL;

use work.ProtoLayerTypesAndDefs.all;
use work.Simulation.all;
use work.SNMPModulePkg.SNMPModule;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY SNMPModule_Test IS
END SNMPModule_Test;
 
ARCHITECTURE behavior OF SNMPModule_Test IS 
 
	-- Component Declaration for the Unit Under Test (UUT)	

	--Inputs
	signal CLK : std_logic := '0';
	signal CE : std_logic := '0';
	signal CFG_CE : std_logic := '0';
	signal RST : std_logic := '0';
	signal DstIPAddr_In : std_logic_vector(31 downto 0) := (others => '0');
	signal SrcIPAddr_In : std_logic_vector(31 downto 0) := (others => '0');
	signal DstPort_In : std_logic_vector(15 downto 0) := (others => '0');
	signal SrcPort_In : std_logic_vector(15 downto 0) := (others => '0');
	signal Length_In : std_logic_vector(15 downto 0) := (others => '0');
	signal PDU_DIN : std_logic_vector(7 downto 0) := (others => '0');
	signal PDU_DINV : std_logic := '0';
	signal PDU_IN_SOP : std_logic := '0';
	signal PDU_IN_EOP : std_logic := '0';
	signal PDU_IN_INd : std_logic := '0';
	signal PDU_IN_ErrIN : std_logic := '0';
	signal PDU_OUT_Ack : std_logic := '0';
	signal PDU_OUT_ErrIN : std_logic := '0';
	signal WR_EN : std_logic := '0';
	signal RD_EN : std_logic := '0';
	signal ServerIP4_IN : std_logic_vector(31 downto 0) := (others => '0');
	signal TrapPort_IN : std_logic_vector(15 downto 0) := (others => '0');
	signal AgentPort_IN : std_logic_vector(15 downto 0) := (others => '0');
	signal BaseOID_IN : std_logic_vector(7 downto 0) := (others => '0');
	signal EventIN : std_logic_vector(31 downto 0) := (others => '0');
	signal LinkStatusIn : std_logic_vector(1 downto 0) := (others => '0');
	signal CFG_ADDR : STD_LOGIC_VECTOR( SNMPAddrWidth-1 DOWNTO 0) := (others => '0');
	signal DATA_IN : STD_LOGIC_VECTOR( SNMPDataWidth-1 DOWNTO 0) := (others => '0');


 	--Outputs
	signal DstIPAddr_Out : std_logic_vector(31 downto 0);
	signal SrcIPAddr_Out : std_logic_vector(31 downto 0);
	signal DstPort_Out : std_logic_vector(15 downto 0);
	signal SrcPort_Out : std_logic_vector(15 downto 0);
	signal Length_Out : std_logic_vector(15 downto 0);
	signal PDU_IN_ErrOUT : std_logic;
	signal PDU_IN_Ack : std_logic;
	signal PDU_DOUT : std_logic_vector(7 downto 0);
	signal PDU_DOUTV : std_logic;
	signal PDU_OUT_SOP : std_logic;
	signal PDU_OUT_EOP : std_logic;
	signal PDU_OUT_INd : std_logic;
	signal PDU_OUT_ErrOUT : std_logic;
	signal RD_DV : std_logic;
	signal ServerIP4_OUT : std_logic_vector(31 downto 0);
	signal TrapPort_OUT : std_logic_vector(15 downto 0);
	signal AgentPort_OUT : std_logic_vector(15 downto 0);
	signal BaseOID_OUT : std_logic_vector(7 downto 0);
	signal DATA_OUT : STD_LOGIC_VECTOR( SNMPDataWidth-1 DOWNTO 0);

	signal DummyAddr : std_logic_vector(7 downto 0);

	-- Clock period definitions
	constant CLK_period : time := 8 ns;
 
BEGIN
	RSTer: Resetter PORT MAP(CLK,RST,CE);
	CFG_CE	<=	CE;
	-- Instantiate the Unit Under Test (UUT)
	uut: SNMPModule
	GENERIC MAP(
		DataWidth		=>	8,
		CLK_freq		=>	125.0,
		TX_SYNC		=>	false,
		NumOfEvents	=>	32, --max 255, transferred in specific trap
		NumOfLinks	=>	2 --max 255
	)
	PORT MAP (
			CLK => CLK,
			CE => CE,
			CFG_CE => CFG_CE,
			RST => RST,
			DstIPAddr_In => DstIPAddr_In,
			SrcIPAddr_In => SrcIPAddr_In,
			DstPort_In => DstPort_In,
			SrcPort_In => SrcPort_In,
			Length_In => Length_In,
			DstIPAddr_Out => DstIPAddr_Out,
			SrcIPAddr_Out => SrcIPAddr_Out,
			DstPort_Out => DstPort_Out,
			SrcPort_Out => SrcPort_Out,
			Length_Out => Length_Out,
			PDU_DIN => PDU_DIN,
			PDU_DINV => PDU_DINV,
			PDU_IN_SOP => PDU_IN_SOP,
			PDU_IN_EOP => PDU_IN_EOP,
			PDU_IN_INd => PDU_IN_INd,
			PDU_IN_ErrOUT => PDU_IN_ErrOUT,
			PDU_IN_Ack => PDU_IN_Ack,
			PDU_IN_ErrIN => PDU_IN_ErrIN,
			PDU_DOUT => PDU_DOUT,
			PDU_DOUTV => PDU_DOUTV,
			PDU_OUT_SOP => PDU_OUT_SOP,
			PDU_OUT_EOP => PDU_OUT_EOP,
			PDU_OUT_INd => PDU_OUT_INd,
			PDU_OUT_ErrOUT => PDU_OUT_ErrOUT,
			PDU_OUT_Ack => PDU_OUT_Ack,
			PDU_OUT_ErrIN => PDU_OUT_ErrIN,
			WR_EN => WR_EN,
			RD_EN => RD_EN,
			CFG_ADDR => CFG_ADDR,
			DATA_IN => DATA_IN,
			RD_DV => RD_DV,
			DATA_OUT => DATA_OUT,
			EventIN => EventIN,
			LinkStatusIn => LinkStatusIn
		 );

	-- Clock process definitions
	CLK_process :process
	begin
		CLK <= '1';
		wait for CLK_period/2;
		CLK <= '0';
		wait for CLK_period/2;
	end process;
 

	-- Stimulus process
	stim_proc: process
	begin		
		-- hold reset state for 100 ns.
		WAIT_CLK(CLK_period,20);
		
		CFG_WRITE(CLK_period,0,0,X"0a0a000a",CFG_ADDR,WR_EN,DummyAddr,DATA_IN,WR_EN);
		CFG_WRITE(CLK_period,1,1,X"0a0a000b",CFG_ADDR,WR_EN,DummyAddr,DATA_IN,WR_EN);
		CFG_WRITE(CLK_period,2,2,X"000000a2",CFG_ADDR,WR_EN,DummyAddr,DATA_IN,WR_EN);
		CFG_WRITE(CLK_period,3,3,X"00001988",CFG_ADDR,WR_EN,DummyAddr,DATA_IN,WR_EN);
		WAIT_CLK(CLK_period,2);
		CFG_ADDR	<=	"001";
		RD_EN	<=	Hi;
		WAIT_CLK(CLK_period,1);
		RD_EN	<=	Lo;
		WAIT_CLK(CLK_period,1);
		CFG_ADDR	<=	"010";
		RD_EN	<=	Hi;
		WAIT_CLK(CLK_period,1);
		RD_EN	<=	Lo;
		LinkStatusIn(0)	<=	Hi;
		WAIT_CLK(CLK_period,20);
		LinkStatusIn(0)	<=	Lo;
		WAIT_CLK(CLK_period,20);
		LinkStatusIn(1)	<=	Hi;
		WAIT_CLK(CLK_period,20);
		LinkStatusIn(1)	<=	Lo;
		WAIT_CLK(CLK_period,200);
		LinkStatusIn(0)	<=	Hi;
		LinkStatusIn(1)	<=	Hi;
		WAIT_CLK(CLK_period,20);
		LinkStatusIn(0)	<=	Lo;
		LinkStatusIn(1)	<=	Lo;
		WAIT_CLK(CLK_period,200);
		-- insert stimulus here 

		wait;
	end process;

END;
