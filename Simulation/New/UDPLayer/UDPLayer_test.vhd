--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:	13:02:02 05/05/2013
-- Design Name:	
-- Module Name:	D:/Users/fjanky/VHDL/code/ProtoLayer/Simulation/New/UDPLayer/UDPLayer_test.vhd
-- Project Name:  UDPLayer
-- Target Device:  
-- Tool versions:  
-- Description:	
-- 
-- VHDL Test Bench Created by ISE for module: UDPLayer
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
-- LIBRARY UNISIM;
-- USE UNISIM.VCOMPONENTS.ALL;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

use work.ProtoLayerTypesAndDefs.all;
use work.Simulation.all;
use work.UDPLayerPkg.UDPLayer;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY UDPLayer_test IS
END UDPLayer_test;
 
ARCHITECTURE behavior OF UDPLayer_test IS 

	constant NumOfUDPPorts	:	integer	:=	8;
	constant UDP_AddrWidth	:	integer	:=	integer(ceil(log2(real(NumOfUDPPorts))));

	 -- Component Declaration for the Unit Under Test (UUT)
	--Inputs
	signal CLK : std_logic := '0';
	signal RST : std_logic := '0';
	signal CE : std_logic := '0';
	signal CFG_CE : std_logic := '0';
	signal WR_EN : std_logic := '0';
	signal RD_EN : std_logic := '0';
	signal ADDR : std_logic_vector(UDP_AddrWidth-1 downto 0) := (others => '0');
	signal DATA_IN : std_logic_vector(16 downto 0) := (others => '0');
	signal IP_DstIPAddr_In : std_logic_vector(31 downto 0) := (others => '0');
	signal IP_SrcIPAddr_In : std_logic_vector(31 downto 0) := (others => '0');
	signal IP_Proto_In : std_logic_vector(7 downto 0) := (others => '0');
	signal IP_Length_In : std_logic_vector(15 downto 0) := (others => '0');
	signal DstIPAddr_In : std_logic_vector(31 downto 0) := (others => '0');
	signal SrcIPAddr_In : std_logic_vector(31 downto 0) := (others => '0');
	signal DstPort_In : std_logic_vector(15 downto 0) := (others => '0');
	signal SrcPort_In : std_logic_vector(15 downto 0) := (others => '0');
	signal Length_In : std_logic_vector(15 downto 0) := (others => '0');
	signal SDU_DIN : std_logic_vector(7 downto 0) := (others => '0');
	signal SDU_DINV : std_logic := '0';
	signal SDU_IN_SOP : std_logic := '0';
	signal SDU_IN_EOP : std_logic := '0';
	signal SDU_IN_Ind : std_logic := '0';
	signal SDU_IN_ErrIn : std_logic := '0';
	signal SDU_IN_USER_In : std_logic_vector(5 downto 0) := (others => '0');
	signal PDU_Out_Ack : std_logic := '0';
	signal PDU_Out_ErrIn : std_logic := '0';
	signal PDU_DIN : std_logic_vector(7 downto 0) := (others => '0');
	signal PDU_DINV : std_logic := '0';
	signal PDU_IN_SOP : std_logic := '0';
	signal PDU_IN_EOP : std_logic := '0';
	signal PDU_IN_Ind : std_logic := '0';
	signal PDU_IN_USER_In : std_logic_vector(5 downto 0) := (others => '0');
	signal PDU_IN_ErrIn : std_logic := '0';
	signal SDU_OUT_ErrIn : std_logic := '0';
	signal SDU_OUT_Ack : std_logic := '0';

 	--Outputs
	signal DATA_OUT : std_logic_vector(16 downto 0);
	signal DOUTV : std_logic;
	signal IP_DstIPAddr_Out : std_logic_vector(31 downto 0);
	signal IP_SrcIPAddr_Out : std_logic_vector(31 downto 0);
	signal IP_Proto_Out : std_logic_vector(7 downto 0);
	signal IP_Length_Out : std_logic_vector(15 downto 0);
	signal DstIPAddr_Out : std_logic_vector(31 downto 0);
	signal SrcIPAddr_Out : std_logic_vector(31 downto 0);
	signal DstPort_Out : std_logic_vector(15 downto 0);
	signal SrcPort_Out : std_logic_vector(15 downto 0);
	signal Length_Out : std_logic_vector(15 downto 0);
	signal SDU_IN_Ack : std_logic;
	signal SDU_IN_ErrOut : std_logic;
	signal PDU_DOUT : std_logic_vector(7 downto 0);
	signal PDU_DOUTV : std_logic;
	signal PDU_Out_SOP : std_logic;
	signal PDU_Out_EOP : std_logic;
	signal PDU_Out_Ind : std_logic;
	signal PDU_Out_ErrOut : std_logic;
	signal PDU_Out_USER_Out : std_logic_vector(5 downto 0);
	signal PDU_IN_ErrOut : std_logic;
	signal PDU_IN_Ack : std_logic;
	signal SDU_DOUT : std_logic_vector(7 downto 0);
	signal SDU_DOUTV : std_logic;
	signal SDU_Out_SOP : std_logic;
	signal SDU_OUT_EOP : std_logic;
	signal SDU_OUT_Ind : std_logic;
	signal SDU_OUT_USER_Out : std_logic_vector(5 downto 0);
	signal SDU_OUT_ErrOut : std_logic;
	signal Status : std_logic_vector(7 downto 0);

	-- Clock period definitions
	constant CLK_period : time := 10 ns;
	
	signal MGMT_Port_In	:	std_logic_vector(16 downto 0);
	signal Valid_Port	:	std_logic	:=	'0';
	signal Port_sig	:	std_logic_vector(15 downto 0)	:=	(OTHERS => Lo);
BEGIN
	MGMT_Port_In	<=	Valid_Port & Port_sig;
	-- Instantiate the Unit Under Test (UUT)
	uut: UDPLayer 
	Generic Map(
		DataWidth			=>		8,
		RX_SYNC_IN		=>		true,
		RX_SYNC_OUT		=>		false,
		-- TX_SYNC_IN		=>		false, Just in Sync mode
		TX_SYNC_OUT		=>		true,
		NumOfUDPPorts		=>		NumOfUDPPorts,
		PDUToQueue		=>		DefPDUToQ
	)
	PORT MAP (
			 CLK => CLK,
			 RST => RST,
			 CE => CE,
			 CFG_CE => CFG_CE,
			 WR_EN => WR_EN,
			 RD_EN => RD_EN,
			 ADDR => ADDR,
			 DATA_IN => DATA_IN,
			 DATA_OUT => DATA_OUT,
			 DOUTV => DOUTV,
			 IP_DstIPAddr_In => IP_DstIPAddr_In,
			 IP_SrcIPAddr_In => IP_SrcIPAddr_In,
			 IP_Proto_In => IP_Proto_In,
			 IP_Length_In => IP_Length_In,
			 IP_DstIPAddr_Out => IP_DstIPAddr_Out,
			 IP_SrcIPAddr_Out => IP_SrcIPAddr_Out,
			 IP_Proto_Out => IP_Proto_Out,
			 IP_Length_Out => IP_Length_Out,
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
			 SDU_DIN => SDU_DIN,
			 SDU_DINV => SDU_DINV,
			 SDU_IN_SOP => SDU_IN_SOP,
			 SDU_IN_EOP => SDU_IN_EOP,
			 SDU_IN_Ind => SDU_IN_Ind,
			 SDU_IN_ErrIn => SDU_IN_ErrIn,
			 SDU_IN_USER_In => SDU_IN_USER_In,
			 SDU_IN_Ack => SDU_IN_Ack,
			 SDU_IN_ErrOut => SDU_IN_ErrOut,
			 PDU_DOUT => PDU_DOUT,
			 PDU_DOUTV => PDU_DOUTV,
			 PDU_Out_SOP => PDU_Out_SOP,
			 PDU_Out_EOP => PDU_Out_EOP,
			 PDU_Out_Ind => PDU_Out_Ind,
			 PDU_Out_ErrOut => PDU_Out_ErrOut,
			 PDU_Out_USER_Out => PDU_Out_USER_Out,
			 PDU_Out_Ack => PDU_Out_Ack,
			 PDU_Out_ErrIn => PDU_Out_ErrIn,
			 PDU_DIN => PDU_DIN,
			 PDU_DINV => PDU_DINV,
			 PDU_IN_SOP => PDU_IN_SOP,
			 PDU_IN_EOP => PDU_IN_EOP,
			 PDU_IN_Ind => PDU_IN_Ind,
			 PDU_IN_USER_In => PDU_IN_USER_In,
			 PDU_IN_ErrIn => PDU_IN_ErrIn,
			 PDU_IN_ErrOut => PDU_IN_ErrOut,
			 PDU_IN_Ack => PDU_IN_Ack,
			 SDU_DOUT => SDU_DOUT,
			 SDU_DOUTV => SDU_DOUTV,
			 SDU_Out_SOP => SDU_Out_SOP,
			 SDU_OUT_EOP => SDU_OUT_EOP,
			 SDU_OUT_Ind => SDU_OUT_Ind,
			 SDU_OUT_USER_Out => SDU_OUT_USER_Out,
			 SDU_OUT_ErrOut => SDU_OUT_ErrOut,
			 SDU_OUT_ErrIn => SDU_OUT_ErrIn,
			 SDU_OUT_Ack => SDU_OUT_Ack,
			 Status => Status
		  );
	IP_DstIPAddr_In	<=	IP_DstIPAddr_Out;
	IP_SrcIPAddr_In	<=	IP_SrcIPAddr_Out;
	IP_Proto_In		<=	IP_Proto_Out;
	IP_Length_In		<=	IP_Length_Out;
	PDU_DIN			<=	PDU_DOUT;
	PDU_DINV			<=	PDU_DOUTV;
	PDU_In_SOP		<=	PDU_Out_SOP;
	PDU_In_EOP		<=	PDU_Out_EOP;
	PDU_In_ErrIn		<=	PDU_Out_ErrOut;
	PDU_Out_ErrIn		<=	PDU_In_ErrOut;
	PDU_In_Ind		<=	PDU_Out_Ind;
	PDU_Out_Ack		<=	PDU_In_Ack;
	
	
	-- Clock process definitions
	CLK_process :process
	begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
	end process;
 
RSTer: Resetter PORT MAP(CLK,RST,CE);
CFG_CE	<=	CE;

	-- Stimulus process
	stim_proc: process
	begin		
		-- hold reset state for 100 ns.
		WAIT_CLK(CLK_period,20);
		Port_sig		<=	X"1122";
		Valid_Port	<=	Hi;
		WAIT_CLK(CLK_period,1);
		WR_CAM(CLK_period,0,MGMT_Port_In,WR_EN,ADDR,DATA_IN);
		WAIT_CLK(CLK_period,1);
		Port_sig		<=	X"6677";
		WAIT_CLK(CLK_period,1);
		WR_CAM(CLK_period,1,MGMT_Port_In,WR_EN,ADDR,DATA_IN);
		WAIT_CLK(CLK_period,1);
		
		DstIPAddr_In	<=	X"0a0a000a";
		SrcIPAddr_In	<=	X"0a0a000b";
		DstPort_In	<=	X"1122";
		SrcPort_In	<=	X"3344";
		Length_In		<=	X"0008";
		Emit_PDU_SYNC(CLK_PERIOD,8,1,SDU_In_Ack,SDU_In_Ind,SDU_DIN,SDU_DINV,SDU_In_SOP,SDU_In_EOP);
		-- Emit_UDP_PDU_SYNC(CLK_period,X"0a0a000a",X"0a0a000b",X"1988",X"0521",21,IP_SrcIPAddr_In,IP_DstIPAddr_In,IP_Proto_In,IP_Length_In,PDU_DIN,PDU_DINV,PDU_In_SOP,PDU_In_EOP,PDU_In_Ind,PDU_In_Ack);
		WAIT_CLK(CLK_period,10);
		DstIPAddr_In	<=	X"0a0af00b";
		SrcIPAddr_In	<=	X"0a0ad00f";
		DstPort_In	<=	X"6677";
		SrcPort_In	<=	X"2222";
		Length_In		<=	X"000a";
		Emit_PDU_SYNC(CLK_PERIOD,10,1,SDU_In_Ack,SDU_In_Ind,SDU_DIN,SDU_DINV,SDU_In_SOP,SDU_In_EOP);
		-- Emit_UDP_PDU_SYNC(CLK_period,X"0a0a000a",X"0a0a000b",X"1988",X"0521",21,IP_SrcIPAddr_In,IP_DstIPAddr_In,IP_Proto_In,IP_Length_In,PDU_DIN,PDU_DINV,PDU_In_SOP,PDU_In_EOP,PDU_In_Ind,PDU_In_Ack);
		WAIT_CLK(CLK_period,10);
		DstIPAddr_In	<=	X"0a0a000a";
		SrcIPAddr_In	<=	X"0a0a000b";
		DstPort_In	<=	X"4444";
		SrcPort_In	<=	X"6666";
		Length_In		<=	X"000b";
		Emit_PDU_SYNC(CLK_PERIOD,11,1,SDU_In_Ack,SDU_In_Ind,SDU_DIN,SDU_DINV,SDU_In_SOP,SDU_In_EOP);
		WAIT_CLK(CLK_period,10);
		DstIPAddr_In	<=	X"0c0af00b";
		SrcIPAddr_In	<=	X"0d0ad00f";
		DstPort_In	<=	X"6677";
		SrcPort_In	<=	X"9898";
		Length_In		<=	X"0043";
		Emit_PDU_SYNC(CLK_PERIOD,67,1,SDU_In_Ack,SDU_In_Ind,SDU_DIN,SDU_DINV,SDU_In_SOP,SDU_In_EOP);
		-- Emit_UDP_PDU_SYNC(CLK_period,X"0a0a000a",X"0a0a000b",X"1988",X"0521",21,IP_SrcIPAddr_In,IP_DstIPAddr_In,IP_Proto_In,IP_Length_In,PDU_DIN,PDU_DINV,PDU_In_SOP,PDU_In_EOP,PDU_In_Ind,PDU_In_Ack);

		-- insert stimulus here 

		wait;
	end process;

END;
