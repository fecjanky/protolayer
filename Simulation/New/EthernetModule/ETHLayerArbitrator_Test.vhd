--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:	15:50:10 05/03/2013
-- Design Name:	
-- Module Name:	D:/Users/fjanky/VHDL/code/ProtoLayer/Simulation/New/EthernetModule/ETHLayerArbitrator_Test.vhd
-- Project Name:  GPlanar_test
-- Target Device:  
-- Tool versions:  
-- Description:	
-- 
-- VHDL Test Bench Created by ISE for module: EthLayer_Arbitrator_2
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
use work.ProtoModulePkg.EthLayer_Arbitrator_2;
use work.EthernetLayerPkg.EthernetLayer;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ETHLayerArbitrator_Test IS
END ETHLayerArbitrator_Test;
 
ARCHITECTURE behavior OF ETHLayerArbitrator_Test IS 
 
	-- Component Declaration for the Unit Under Test (UUT) 

	--Inputs
	signal CLK : std_logic := '0';
	signal RST : std_logic := '0';
	signal CE : std_logic := '0';
	signal DstMacAddr_In_0 : std_logic_vector(47 downto 0) := (others => '0');
	signal SrcMacAddr_In_0 : std_logic_vector(47 downto 0) := (others => '0');
	signal EthType_In_0 : std_logic_vector(15 downto 0) := (others => '0');
	signal In_0_Data : std_logic_vector(7 downto 0) := (others => '0');
	signal In_0_DataV : std_logic := '0';
	signal In_0_SOP : std_logic := '0';
	signal In_0_EOP : std_logic := '0';
	signal In_0_ErrIn : std_logic := '0';
	signal In_0_Ind : std_logic := '0';
	signal DstMacAddr_In_1 : std_logic_vector(47 downto 0) := (others => '0');
	signal SrcMacAddr_In_1 : std_logic_vector(47 downto 0) := (others => '0');
	signal EthType_In_1 : std_logic_vector(15 downto 0) := (others => '0');
	signal In_1_Data : std_logic_vector(7 downto 0) := (others => '0');
	signal In_1_DataV : std_logic := '0';
	signal In_1_SOP : std_logic := '0';
	signal In_1_EOP : std_logic := '0';
	signal In_1_ErrIn : std_logic := '0';
	signal In_1_Ind : std_logic := '0';
	signal Out_ErrIn : std_logic := '0';
	signal DstMacAddr_In : std_logic_vector(47 downto 0) := (others => '0');
	signal SrcMacAddr_In : std_logic_vector(47 downto 0) := (others => '0');
	signal EthType_In : std_logic_vector(15 downto 0) := (others => '0');
	signal In_Data : std_logic_vector(7 downto 0) := (others => '0');
	signal In_DataV : std_logic := '0';
	signal In_SOP : std_logic := '0';
	signal In_EOP : std_logic := '0';
	signal In_ErrIn : std_logic := '0';

 	--Outputs
	signal In_0_Ack : std_logic;
	signal In_0_ErrOut : std_logic;
	signal DstMacAddr_Out_0 : std_logic_vector(47 downto 0);
	signal SrcMacAddr_Out_0 : std_logic_vector(47 downto 0);
	signal EthType_Out_0 : std_logic_vector(15 downto 0);
	signal Out_0_Data : std_logic_vector(7 downto 0);
	signal Out_0_DataV : std_logic;
	signal Out_0_SOP : std_logic;
	signal Out_0_EOP : std_logic;
	signal Out_0_ErrOut : std_logic;
	signal In_1_Ack : std_logic;
	signal In_1_ErrOut : std_logic;
	signal Out_1_Data : std_logic_vector(7 downto 0);
	signal Out_1_DataV : std_logic;
	signal Out_1_SOP : std_logic;
	signal Out_1_EOP : std_logic;
	signal Out_1_ErrOut : std_logic;
	signal DstMacAddr_Out_1 : std_logic_vector(47 downto 0);
	signal SrcMacAddr_Out_1 : std_logic_vector(47 downto 0);
	signal EthType_Out_1 : std_logic_vector(15 downto 0);
	signal DstMacAddr_Out : std_logic_vector(47 downto 0);
	signal SrcMacAddr_Out : std_logic_vector(47 downto 0);
	signal EthType_Out : std_logic_vector(15 downto 0);
	signal Out_Data : std_logic_vector(7 downto 0);
	signal Out_DataV : std_logic;
	signal Out_SOP : std_logic;
	signal OUT_EOP : std_logic;
	signal Out_ErrOut : std_logic;
	signal In_ErrOut : std_logic;
	signal Status : std_logic_vector(3 downto 0);

	-- Clock period definitions
	constant CLK_period : time := 10 ns;
 
 
 signal	ETHLayer_0_EType_In			:	std_logic_vector(15 downto 0):=(others => Lo);
signal	ETHLayer_0_EType_Out		:	std_logic_vector(15 downto 0):=(others => Lo);
signal	ETHLayer_0_DstMacAddr_In		:	std_logic_vector(47 downto 0):=(others => Lo);
signal	ETHLayer_0_DstMacAddr_Out	:	std_logic_vector(47 downto 0):=(others => Lo);
signal	ETHLayer_0_SrcMacAddr_In		:	std_logic_vector(47 downto 0):=(others => Lo);
signal	ETHLayer_0_SrcMacAddr_Out	:	std_logic_vector(47 downto 0):=(others => Lo);

signal	ETHLayer_1_EType_In			:	std_logic_vector(15 downto 0):=(others => Lo);
signal	ETHLayer_1_EType_Out		:	std_logic_vector(15 downto 0):=(others => Lo);
signal	ETHLayer_1_DstMacAddr_In		:	std_logic_vector(47 downto 0):=(others => Lo);
signal	ETHLayer_1_DstMacAddr_Out	:	std_logic_vector(47 downto 0):=(others => Lo);
signal	ETHLayer_1_SrcMacAddr_In		:	std_logic_vector(47 downto 0):=(others => Lo);
signal	ETHLayer_1_SrcMacAddr_Out	:	std_logic_vector(47 downto 0):=(others => Lo);

signal	ETHLayer_0_PDU_DOUT			:	std_logic_vector(7 downto 0):=(others => Lo);
signal	ETHLayer_0_PDU_DOUTV		:	std_logic:='0';
signal	ETHLayer_0_PDU_Out_SOP		:	std_logic:='0';
signal	ETHLayer_0_PDU_Out_EOP		:	std_logic:='0';
signal	ETHLayer_0_PDU_Out_Ind		:	std_logic:='0';
signal	ETHLayer_0_PDU_Out_Ack		:	std_logic:='0';
signal	ETHLayer_0_PDU_Out_ErrOut	:	std_logic:='0';
signal	ETHLayer_0_PDU_DIN			:	std_logic_vector(7 downto 0):=(others => Lo);
signal	ETHLayer_0_PDU_DINV			:	std_logic:='0';
signal	ETHLayer_0_PDU_In_SOP		:	std_logic:='0';
signal	ETHLayer_0_PDU_In_EOP		:	std_logic:='0';
signal	ETHLayer_0_PDU_In_ErrIn		:	std_logic:='0';
signal	ETHLayer_0_SDU_DIN			:	std_logic_vector(7 downto 0):=(others => Lo);
signal	ETHLayer_0_SDU_DINV			:	std_logic:='0';
signal	ETHLayer_0_SDU_In_SOP		:	std_logic:='0';
signal	ETHLayer_0_SDU_In_EOP		:	std_logic:='0';
signal	ETHLayer_0_SDU_In_Ind		:	std_logic:='0';
signal	ETHLayer_0_SDU_In_Ack		:	std_logic:='0';
signal	ETHLayer_0_SDU_In_ErrOut		:	std_logic:='0';
signal	ETHLayer_0_SDU_In_ErrIn		:	std_logic:='0';
signal	ETHLayer_0_SDU_DOUT			:	std_logic_vector(7 downto 0):=(others => Lo);
signal	ETHLayer_0_SDU_DOUTV		:	std_logic:='0';
signal	ETHLayer_0_SDU_Out_SOP		:	std_logic:='0';
signal	ETHLayer_0_SDU_Out_EOP		:	std_logic:='0';
signal	ETHLayer_0_SDU_Out_Ind		:	std_logic:='0';
signal	ETHLayer_0_SDU_Out_Ack		:	std_logic:='0';
signal	ETHLayer_0_SDU_Out_ErrOut	:	std_logic:='0';
signal	ETHLayer_0_SDU_Out_ErrIn		:	std_logic:='0';


signal	RESET_ETHLayer_0		:		std_logic:='0';
signal	RESET_ETHLayer_1		:		std_logic:='0';
signal	En_ETHLayer_0			:		std_logic:='0';
signal	En_ETHLayer_1			:		std_logic:='0';

signal	ETH_WR_En				:	std_logic:='0';
signal	ETH_RD_En				:	std_logic:='0';
signal	ETH_Addr				:	std_logic_vector(1 downto 0):=(others => Lo);
signal	ETH_ADDR_DV			:	std_logic:='0';
signal	ETH_ADDR_DATA_IN		:	std_logic_vector(47 downto 0):=(others => Lo);
signal	ETH_ADDR_DATA_OUT		:	std_logic_vector(47 downto 0):=(others => Lo);

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
	uut: EthLayer_Arbitrator_2 PORT MAP (
			CLK => CLK,
			RST => RST,
			CE => CE,
			DstMacAddr_In_0 => DstMacAddr_In_0,
			SrcMacAddr_In_0 => SrcMacAddr_In_0,
			EthType_In_0 => EthType_In_0,
			In_0_Data => In_0_Data,
			In_0_DataV => In_0_DataV,
			In_0_SOP => In_0_SOP,
			In_0_EOP => In_0_EOP,
			In_0_ErrIn => In_0_ErrIn,
			In_0_Ind => In_0_Ind,
			In_0_Ack => In_0_Ack,
			In_0_ErrOut => In_0_ErrOut,
			DstMacAddr_Out_0 => DstMacAddr_Out_0,
			SrcMacAddr_Out_0 => SrcMacAddr_Out_0,
			EthType_Out_0 => EthType_Out_0,
			Out_0_Data => Out_0_Data,
			Out_0_DataV => Out_0_DataV,
			Out_0_SOP => Out_0_SOP,
			Out_0_EOP => Out_0_EOP,
			Out_0_ErrOut => Out_0_ErrOut,
			DstMacAddr_In_1 => DstMacAddr_In_1,
			SrcMacAddr_In_1 => SrcMacAddr_In_1,
			EthType_In_1 => EthType_In_1,
			In_1_Data => In_1_Data,
			In_1_DataV => In_1_DataV,
			In_1_SOP => In_1_SOP,
			In_1_EOP => In_1_EOP,
			In_1_ErrIn => In_1_ErrIn,
			In_1_Ind => In_1_Ind,
			In_1_Ack => In_1_Ack,
			In_1_ErrOut => In_1_ErrOut,
			Out_1_Data => Out_1_Data,
			Out_1_DataV => Out_1_DataV,
			Out_1_SOP => Out_1_SOP,
			Out_1_EOP => Out_1_EOP,
			Out_1_ErrOut => Out_1_ErrOut,
			DstMacAddr_Out_1 => DstMacAddr_Out_1,
			SrcMacAddr_Out_1 => SrcMacAddr_Out_1,
			EthType_Out_1 => EthType_Out_1,
			DstMacAddr_Out		=>	ETHLayer_0_DSTMacAddr_In,
			SrcMacAddr_Out		=>	ETHLayer_0_SrcMacAddr_In,
			EthType_Out		=>	ETHLayer_0_EType_In,
			Out_Data			=>	ETHLayer_0_SDU_DIN,
			Out_DataV			=>	ETHLayer_0_SDU_DINV,
			Out_SOP			=>	ETHLayer_0_SDU_IN_SOP,
			OUT_EOP			=>	ETHLayer_0_SDU_IN_EOP,
			Out_ErrOut		=>	ETHLayer_0_SDU_IN_ErrIn,
			Out_ErrIn			=>	ETHLayer_0_SDU_IN_ErrOut,
			DstMacAddr_In		=>	ETHLayer_0_DSTMacAddr_Out,
			SrcMacAddr_In		=>	ETHLayer_0_SrcMacAddr_Out,
			EthType_In		=>	ETHLayer_0_EType_Out,
			In_Data			=>	ETHLayer_0_SDU_DOUT,
			In_DataV			=>	ETHLayer_0_SDU_DOUTV,
			In_SOP			=>	ETHLayer_0_SDU_Out_SOP,
			In_EOP			=>	ETHLayer_0_SDU_OUT_EOP,
			In_ErrIn			=>	ETHLayer_0_SDU_OUT_ErrOut,
			In_ErrOut			=>	ETHLayer_0_SDU_OUT_ErrIn,
			Status			=>	Status
		 );
	Inst_EthernetLayer_0: EthernetLayer 
	generic map(
		DataWidth			=>		8,
		RX_SYNC_IN		=>		false, --Due to MAC
		RX_SYNC_OUT		=>		false, --Due to arbitration
		TX_SYNC_IN		=>		false, --Due to arbitration
		TX_SYNC_OUT		=>		false, --Due to arbitration (IFGap)
		MINSDUSize		=>		64,
		MAXSDUSize		=>		1500,
		MaxSDUToQ			=>		30,
		MINPCISize		=>		14,
		MAXPCISize		=>		14,
		MaxPCIToQ			=>		30,
		NumOfMacAddresses	=>		4
	)
	PORT MAP(
		CLK				=>	Clk,
		CE				=>	CE,
		RST				=>	RST,
		WR_EN			=>	ETH_WR_En,
		RD_EN			=>	ETH_RD_En,
		ADDR				=>	ETH_Addr,
		ADDR_DATA_IN		=>	ETH_ADDR_DATA_IN,
		ADDR_DATA_OUT		=>	ETH_ADDR_DATA_OUT,
		ADDR_DV			=>	ETH_ADDR_DV,
		DstMacAddr_In		=>	ETHLayer_0_DSTMacAddr_In,
		SrcMacAddr_In		=>	ETHLayer_0_SrcMacAddr_In,
		EthType_In		=>	ETHLayer_0_EType_In,
		DstMacAddr_Out		=>	ETHLayer_0_DSTMacAddr_Out,
		SrcMacAddr_Out		=>	ETHLayer_0_SrcMacAddr_Out,
		EthType_Out		=>	ETHLayer_0_EType_Out,
		SDU_DIN			=>	ETHLayer_0_SDU_DIN,
		SDU_DINV			=>	ETHLayer_0_SDU_DINV,
		SDU_IN_SOP		=>	ETHLayer_0_SDU_IN_SOP,
		SDU_IN_EOP		=>	ETHLayer_0_SDU_IN_EOP,
		SDU_IN_Ind		=>	Lo,
		SDU_IN_ErrIn		=>	ETHLayer_0_SDU_IN_ErrIn,
		SDU_IN_USER_In		=>	"000000",
		SDU_IN_Ack		=>	OPEN,
		SDU_IN_ErrOut		=>	ETHLayer_0_SDU_IN_ErrOut,
		PDU_DOUT			=>	ETHLayer_0_PDU_DOUT,
		PDU_DOUTV			=>	ETHLayer_0_PDU_DOUTV,
		PDU_Out_SOP		=>	ETHLayer_0_PDU_Out_SOP,
		PDU_Out_EOP		=>	ETHLayer_0_PDU_Out_EOP,
		PDU_Out_Ind		=>	ETHLayer_0_PDU_Out_Ind,
		PDU_Out_ErrOut		=>	ETHLayer_0_PDU_Out_ErrOut,
		PDU_Out_USER_Out	=>	OPEN,
		PDU_Out_Ack		=>	ETHLayer_0_PDU_Out_Ack,
		PDU_Out_ErrIn		=>	Lo,
		PDU_DIN			=>	ETHLayer_0_PDU_DIN,
		PDU_DINV			=>	ETHLayer_0_PDU_DINV,
		PDU_IN_SOP		=>	ETHLayer_0_PDU_In_SOP ,
		PDU_IN_EOP		=>	ETHLayer_0_PDU_In_EOP,
		PDU_IN_Ind		=>	Lo,
		PDU_IN_USER_In		=>	"000000",
		PDU_IN_ErrIn		=>	ETHLayer_0_PDU_In_ErrIn,
		PDU_IN_ErrOut		=>	OPEN,
		PDU_IN_Ack		=>	OPEN,
		SDU_DOUT			=>	ETHLayer_0_SDU_DOUT,
		SDU_DOUTV			=>	ETHLayer_0_SDU_DOUTV,
		SDU_Out_SOP		=>	ETHLayer_0_SDU_Out_SOP,
		SDU_OUT_EOP		=>	ETHLayer_0_SDU_OUT_EOP,
		SDU_OUT_Ind		=>	ETHLayer_0_SDU_OUT_Ind,
		SDU_OUT_USER_Out	=>	OPEN,
		SDU_OUT_ErrOut		=>	ETHLayer_0_SDU_OUT_ErrOut,
		SDU_OUT_ErrIn		=>	ETHLayer_0_SDU_OUT_ErrIn,
		SDU_OUT_Ack		=>	ETHLayer_0_SDU_OUT_Ack
	);

	-- Clock process definitions
	CLK_process :process
	begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
	end process;
 
 
	RSTer:Resetter Port Map(CLK => CLK, RST => RST, CE => CE);
	-- Stimulus process
	stim_proc: process
	begin		
		-- hold reset state for 100 ns.
		
		WAIT_CLK(CLK_period,20);
		DstMacAddr_In_0	<=	X"FFFFFFFFFFFF";
		SrcMacAddr_In_0	<=	X"001122334455";
		EthType_In_0		<=	X"0800";
		DstMacAddr_In_1	<=	X"665544332211";
		SrcMacAddr_In_1	<=	X"998877665544";
		EthType_In_1		<=	X"0806";
		Emit_PDU_SYNC(CLK_PERIOD,64,1,In_0_Ack,In_0_Ind,In_0_Data,In_0_DataV,In_0_SOP,In_0_EOP);
		Emit_PDU_SYNC(CLK_PERIOD,64,1,In_0_Ack,In_0_Ind,In_0_Data,In_0_DataV,In_0_SOP,In_0_EOP);
		Emit_PDU_SYNC(CLK_PERIOD,64,1,In_0_Ack,In_0_Ind,In_0_Data,In_0_DataV,In_0_SOP,In_0_EOP);
		Emit_PDU_SYNC(CLK_PERIOD,64,1,In_1_Ack,In_1_Ind,In_1_Data,In_1_DataV,In_1_SOP,In_1_EOP);
		Emit_PDU(CLK_PERIOD,64,In_Data,In_DataV,In_SOP,In_EOP);
		-- insert stimulus here 

		wait;
	end process;

END;
