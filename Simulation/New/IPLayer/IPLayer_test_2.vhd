--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:	13:47:39 04/29/2013
-- Design Name:	
-- Module Name:	D:/Users/fjanky/VHDL/code/ProtoLayer/Simulation/New/IPLayer/IPLayer_test.vhd
-- Project Name:  IPLayer
-- Target Device:  
-- Tool versions:  
-- Description:	
-- 
-- VHDL Test Bench Created by ISE for module: IPLayer
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
USE IEEE.MATH_REAL.ALL;
use work.ProtoLayerTypesAndDefs.all;
use work.Simulation.all;
use work.IPLayerPkg.IPLayer;
USE work.arch.all;
use work.EthernetLayerPkg.EthernetLayer;
use work.ARPModulePkg.ARPModule;
-- use work.IPLayerPkg.IPLayer;
-- USE work.ProtoLayerTypesAndDefs.all;
-- use work.css_pkg.csipszkop_vio;
use work.ProtoModulePkg.End_Arbitrator_2;
use work.ProtoModulePkg.EthLayer_Arbitrator_2;
USE WORK.UDPLayerPkg.UDPLayer;
USE WORK.SNMPModulePkg.SNMPModule;

ENTITY IPLayer_test_2 IS
END IPLayer_test_2;

ARCHITECTURE behavior OF IPLayer_test_2 IS 
 
	 -- Component Declaration for the Unit Under Test (UUT)
 

	--Inputs
	signal CLK				:	std_logic := '0';
	signal RST				:	std_logic := '0';
	signal CE					:	std_logic := '0';
	signal CFG_CE				:	std_logic := '0';
	
 	--Outputs	
	signal DATA_OUT			:	std_logic_vector(31 downto 0)		:=	(others => Lo);
	signal DOUTV				:	std_logic;
	signal ARP_Request			:	std_logic;
	signal ARP_DSTIPAddr		:	std_logic_vector(31 downto 0)		:=	(others => Lo);
	signal DstIPAddr_Out		:	std_logic_vector(31 downto 0)		:=	(others => Lo);
	signal SrcIPAddr_Out		:	std_logic_vector(31 downto 0)		:=	(others => Lo);
	signal Prot_Out			:	std_logic_vector(7 downto 0)		:=	(others => Lo);
	signal Length_Out			:	std_logic_vector( 15 downto 0)	:= (others => '0');
	signal DstMacAddr_Out		:	std_logic_vector(47 downto 0)		:=	(others => Lo);
	signal SrcMacAddr_Out		:	std_logic_vector(47 downto 0)		:=	(others => Lo);
	signal EthType_Out			:	std_logic_vector(15 downto 0)		:=	(others => Lo);
	signal SDU_IN_Ack			:	std_logic;
	signal SDU_IN_ErrOut		:	std_logic;
	signal PDU_DOUT			:	std_logic_vector(7 downto 0)		:=	(others => Lo);
	signal Status				:	std_logic_vector(7 downto 0)		:=	(others => Lo);
	signal PDU_DOUTV			:	std_logic;
	signal PDU_Out_SOP			:	std_logic;
	signal PDU_Out_EOP			:	std_logic;
	signal PDU_Out_Ind			:	std_logic;
	signal PDU_Out_ErrOut		:	std_logic;
	signal PDU_Out_USER_Out		:	std_logic_vector(5 downto 0)		:=	(others => Lo);
	signal PDU_IN_ErrOut		:	std_logic;
	signal PDU_IN_Ack			:	std_logic;
	signal SDU_DOUT			:	std_logic_vector(7 downto 0)		:=	(others => Lo);
	signal SDU_DOUTV			:	std_logic;
	signal SDU_Out_SOP			:	std_logic;
	signal SDU_OUT_EOP			:	std_logic;
	signal SDU_OUT_Ind			:	std_logic;
	signal SDU_OUT_USER_Out		:	std_logic_vector(5 downto 0)		:=	(others => Lo);
	signal SDU_OUT_ErrOut		:	std_logic;

	signal OUTACK_SET			:	std_logic	:= '0';
	signal OUTACK_RST			:	std_logic	:= '0';
	signal OUTACK_delay			:	integer	:= 1;
	signal OUTACK_width			:	integer	:= 1;

	-- Clock period definitions
	constant CLK_period			:	time	:=	8 ns;
	signal Options				:	std_logic_vector( 44*8-1 downto 0)	:=	(others => Lo);

signal	ETHLayer_0_EType_In		:	std_logic_vector(15 downto 0)	:=	(others => Lo);
signal	ETHLayer_0_EType_Out	:	std_logic_vector(15 downto 0)	:=	(others => Lo);
signal	ETHLayer_0_DstMacAddr_In	:	std_logic_vector(47 downto 0)	:=	(others => Lo);
signal	ETHLayer_0_DstMacAddr_Out:	std_logic_vector(47 downto 0)	:=	(others => Lo);
signal	ETHLayer_0_SrcMacAddr_In	:	std_logic_vector(47 downto 0)	:=	(others => Lo);
signal	ETHLayer_0_SrcMacAddr_Out:	std_logic_vector(47 downto 0)	:=	(others => Lo);
		
signal	ETHLayer_1_EType_In		:	std_logic_vector(15 downto 0)	:=	(others => Lo);
signal	ETHLayer_1_EType_Out	:	std_logic_vector(15 downto 0)	:=	(others => Lo);
signal	ETHLayer_1_DstMacAddr_In	:	std_logic_vector(47 downto 0)	:=	(others => Lo);
signal	ETHLayer_1_DstMacAddr_Out:	std_logic_vector(47 downto 0)	:=	(others => Lo);
signal	ETHLayer_1_SrcMacAddr_In	:	std_logic_vector(47 downto 0)	:=	(others => Lo);
signal	ETHLayer_1_SrcMacAddr_Out:	std_logic_vector(47 downto 0)	:=	(others => Lo);

signal	ETHLayer_0_PDU_DOUT		:	std_logic_vector(7 downto 0)	:=	(others => Lo);
signal	ETHLayer_0_PDU_DOUTV	:	std_logic	:=	'0';
signal	ETHLayer_0_PDU_Out_SOP	:	std_logic	:=	'0';
signal	ETHLayer_0_PDU_Out_EOP	:	std_logic	:=	'0';
signal	ETHLayer_0_PDU_Out_Ind	:	std_logic	:=	'0';
signal	ETHLayer_0_PDU_Out_Ack	:	std_logic	:=	'0';
signal	ETHLayer_0_PDU_Out_ErrOut:	std_logic	:=	'0';
signal	ETHLayer_0_PDU_DIN		:	std_logic_vector(7 downto 0)	:=	(others => Lo);
signal	ETHLayer_0_PDU_DINV		:	std_logic	:=	'0';
signal	ETHLayer_0_PDU_In_SOP	:	std_logic	:=	'0';
signal	ETHLayer_0_PDU_In_EOP	:	std_logic	:=	'0';
signal	ETHLayer_0_PDU_In_ErrIn	:	std_logic	:=	'0';
signal	ETHLayer_0_SDU_DIN		:	std_logic_vector(7 downto 0)	:=	(others => Lo);
signal	ETHLayer_0_SDU_DINV		:	std_logic;
signal	ETHLayer_0_SDU_In_SOP	:	std_logic;
signal	ETHLayer_0_SDU_In_EOP	:	std_logic;
signal	ETHLayer_0_SDU_In_Ind	:	std_logic;
signal	ETHLayer_0_SDU_In_Ack	:	std_logic;
signal	ETHLayer_0_SDU_In_ErrOut	:	std_logic;
signal	ETHLayer_0_SDU_In_ErrIn	:	std_logic;
signal	ETHLayer_0_SDU_DOUT		:	std_logic_vector(7 downto 0)	:=	(others => Lo);
signal	ETHLayer_0_SDU_DOUTV	:	std_logic;
signal	ETHLayer_0_SDU_Out_SOP	:	std_logic;
signal	ETHLayer_0_SDU_Out_EOP	:	std_logic;
signal	ETHLayer_0_SDU_Out_Ind	:	std_logic;
signal	ETHLayer_0_SDU_Out_Ack	:	std_logic;
signal	ETHLayer_0_SDU_Out_ErrOut:	std_logic;
signal	ETHLayer_0_SDU_Out_ErrIn	:	std_logic;

signal	ETHLayer_1_PDU_DOUT		:	std_logic_vector(7 downto 0):=(others => Lo);
signal	ETHLayer_1_PDU_DOUTV	:	std_logic	:=	'0';
signal	ETHLayer_1_PDU_Out_SOP	:	std_logic	:=	'0';
signal	ETHLayer_1_PDU_Out_EOP	:	std_logic	:=	'0';
signal	ETHLayer_1_PDU_Out_Ind	:	std_logic	:=	'0';
signal	ETHLayer_1_PDU_Out_Ack	:	std_logic	:=	'0';
signal	ETHLayer_1_PDU_Out_ErrOut:	std_logic	:=	'0';
signal	ETHLayer_1_PDU_DIN		:	std_logic_vector(7 downto 0):=(others => Lo);
signal	ETHLayer_1_PDU_DINV		:	std_logic:='0';
signal	ETHLayer_1_PDU_In_SOP	:	std_logic:='0';
signal	ETHLayer_1_PDU_In_EOP	:	std_logic:='0';
signal	ETHLayer_1_PDU_In_ErrIn	:	std_logic:='0';
signal	ETHLayer_1_SDU_DIN		:	std_logic_vector(7 downto 0):=(others => Lo);
signal	ETHLayer_1_SDU_DINV		:	std_logic:='0';
signal	ETHLayer_1_SDU_In_SOP	:	std_logic:='0';
signal	ETHLayer_1_SDU_In_EOP	:	std_logic:='0';
signal	ETHLayer_1_SDU_In_Ind	:	std_logic:='0';
signal	ETHLayer_1_SDU_In_Ack	:	std_logic:='0';
signal	ETHLayer_1_SDU_In_ErrOut	:	std_logic:='0';
signal	ETHLayer_1_SDU_In_ErrIn	:	std_logic:='0';
signal	ETHLayer_1_SDU_DOUT		:	std_logic_vector(7 downto 0):=(others => Lo);
signal	ETHLayer_1_SDU_DOUTV	:	std_logic:='0';
signal	ETHLayer_1_SDU_Out_SOP	:	std_logic:='0';
signal	ETHLayer_1_SDU_Out_EOP	:	std_logic:='0';
signal	ETHLayer_1_SDU_Out_Ind	:	std_logic:='0';
signal	ETHLayer_1_SDU_Out_Ack	:	std_logic:='0';
signal	ETHLayer_1_SDU_Out_ErrOut:	std_logic:='0';
signal	ETHLayer_1_SDU_Out_ErrIn	:	std_logic:='0';

signal	RESET_ETHLayer_0		:		std_logic:='0';
signal	RESET_ETHLayer_1		:		std_logic:='0';
signal	En_ETHLayer_0			:		std_logic:='0';
signal	En_ETHLayer_1			:		std_logic:='0';

signal	RESET_Arbitrator		:	std_logic:='0';


signal	MAC_0_SOF				:		STD_LOGIC:='0';
signal	MAC_0_EOF				:		STD_LOGIC:='0';
signal	MAC_0_DAV				:		STD_LOGIC:='0'; --DV
signal	MAC_0_GOODF			:		STD_LOGIC:='0'; -- Opposite of badframe
signal	MAC_0_BADF			:		STD_LOGIC:='0'; --BAD CRC
signal	MAC_0_DROPF			:		STD_LOGIC:='0'; -- LOW
signal	MAC_0_LOS				:		STD_LOGIC:='0'; -- LOW
signal	MAC_1_LOS				:		STD_LOGIC:='0'; -- LOW
signal	MAC_0_DIN				:		STD_LOGIC_VECTOR(07 downto 0):=(others => Lo); --DATA IN
signal	MAC_0_LENGTH			:		STD_LOGIC_VECTOR(31 downto 0):=(others => Lo); -- others LOW
signal	MAC_0_Err				:		STD_LOGIC:='0';

signal	MAC_0_SOF_sig			:		STD_LOGIC:='0';
signal	MAC_0_SOF_dummy		:		STD_LOGIC:='0';
signal	MAC_0_EOF_sig			:		STD_LOGIC:='0';
signal	MAC_0_DAV_sig			:		STD_LOGIC:='0'; --DV
signal	MAC_0_DIN_sig			:		STD_LOGIC_VECTOR(07 downto 0):=(others => Lo); --DATA IN
signal	MAC_0_Err_sig			:		STD_LOGIC:='0';


signal	LoopBackSel			:		STD_LOGIC:='0';


	--	Ethernet "A" upstream
signal	MAC_0_DOUT			:		STD_LOGIC_VECTOR(07 downto 0):=(others => Lo);
signal	MAC_0_DOUTV			:		STD_LOGIC:='0';
signal	MAC_0_Out_SOP			:		STD_LOGIC:='0';
signal	MAC_0_Out_EOP			:		STD_LOGIC:='0';
signal	MAC_0_Out_ErrOut		:		STD_LOGIC:='0';

signal	MAC_1_SOF				:		STD_LOGIC:='0';
signal	MAC_1_EOF				:		STD_LOGIC:='0';
signal	MAC_1_DAV				:		STD_LOGIC:='0'; --DV
signal	MAC_1_GOODF			:		STD_LOGIC:='0'; -- Opposite of badframe
signal	MAC_1_BADF			:		STD_LOGIC:='0'; --BAD CRC
signal	MAC_1_DROPF			:		STD_LOGIC:='0'; -- LOW
signal	MAC_1_DIN				:		STD_LOGIC_VECTOR(07 downto 0):=(others => Lo); --DATA IN
signal	MAC_1_LENGTH			:		STD_LOGIC_VECTOR(31 downto 0):=(others => Lo); -- others LOW
signal	MAC_1_Err				:		STD_LOGIC:='0';
	--	Ethernet "A" upstream
signal	MAC_1_DOUT			:		STD_LOGIC_VECTOR(07 downto 0):=(others => Lo);
signal	MAC_1_DOUTV			:		STD_LOGIC:='0';

signal	ARP_PDU_DOUT			:	std_logic_vector(7 downto 0):=(others => Lo);
signal	ARP_PDU_DOUTV			:	std_logic:='0';
signal	ARP_PDU_DIN			:	std_logic_vector(7 downto 0):=(others => Lo);
signal	ARP_PDU_DINV			:	std_logic:='0';
signal	ARP_PDU_In_SOP			:	std_logic:='0';
signal	ARP_PDU_Out_SOP		:	std_logic:='0';
signal	ARP_PDU_In_EOP			:	std_logic:='0';
signal	ARP_PDU_Out_EOP		:	std_logic:='0';
signal	ARP_PDU_Out_Ind		:	std_logic:='0';
signal	ARP_PDU_Out_Ack		:	std_logic:='0';
signal	ARP_PDU_In_Ind			:	std_logic:='0';
signal	ARP_PDU_In_Ack			:	std_logic:='0';
signal	ARP_PDU_Out_ErrOut		:	std_logic:='0';
signal	ARP_PDU_Out_ErrIn		:	std_logic:='0';
signal	ARP_PDU_In_ErrOut		:	std_logic:='0';
signal	ARP_PDU_In_ErrIn		:	std_logic:='0';
signal	ARP_DST_MacAddr_Out		:	std_logic_vector(47 downto 0)	:=	(others => Lo);
signal	ARP_SRC_MacAddr_Out		:	std_logic_vector(47 downto 0)	:=	(others => Lo);
signal	ARP_EType_Out			:	std_logic_vector(15 downto 0)	:=	(others => Lo);
signal	ARP_DST_MacAddr_In		:	std_logic_vector(47 downto 0)	:=	(others => Lo);
signal	ARP_SRC_MacAddr_In		:	std_logic_vector(47 downto 0)	:=	(others => Lo);
signal	ARP_EType_In			:	std_logic_vector(15 downto 0)	:=	(others => Lo);

signal	RESET_ARP				:	std_logic:='0';
signal	EN_ARP				:	std_logic:='0';
-- signal	ARP_ReqUest			:	std_logic:='0';
signal	ARP_DST_IP_addr		:	std_logic_vector(31 downto 0):=(others => Lo);
signal	ARP_DST_MAC_addr		:	std_logic_vector(47 downto 0):=(others => Lo);
signal	ARP_DST_MAC_addr_sig	:	std_logic_vector(47 downto 0):=(others => Lo);
signal	ARP_RESPONSEV			:	std_logic:='0';
signal	ARP_RESPONSEV_sig		:	std_logic:='0';
signal	ARP_RESPONSE_ERR		:	std_logic:='0';
signal	ARP_RESPONSE_ERR_sig	:	std_logic:='0';
signal	ManualARPSelect		:	std_logic:='0';
signal	ARP_IPADDR_WR_EN		:	std_logic:='0';
signal	ARP_MACADDR_WR_EN		:	std_logic:='0';
signal	ARP_IPADDR_RD_EN		:	std_logic:='0';
signal	ARP_MACADDR_RD_EN		:	std_logic:='0';
signal	ARP_ADDR				:	std_logic_vector(1 downto 0):=(others => Lo);
signal	ARP_ADDR_DATA_IN		:	std_logic_vector(47 downto 0):=(others => Lo);
signal	ARP_IPADDR_DATA_OUT		:	std_logic_vector(31 downto 0):=(others => Lo);
signal	ARP_IPADDR_DATA_OUT_reg	:	std_logic_vector(31 downto 0):=(others => Lo);
signal	ARP_MACADDR_DATA_OUT	:	std_logic_vector(47 downto 0):=(others => Lo);
signal	ARP_MACADDR_DATA_OUT_reg	:	std_logic_vector(47 downto 0):=(others => Lo);
signal	ARP_MACADDR_DOUT_reg_Hi	:	std_logic_vector(31 downto 0):=(others => Lo);
signal	ARP_MACADDR_DOUT_reg_Lo	:	std_logic_vector(31 downto 0):=(others => Lo);
signal	ARP_IPADDR_DV			:	std_logic:='0';
signal	ARP_MACADDR_DV			:	std_logic:='0';
	
signal	Address				:	std_logic_vector(31 downto 0):=(others => Lo);
signal	Data_Lo				:	std_logic_vector(31 downto 0):=(others => Lo);
signal	Data_Hi				:	std_logic_vector(31 downto 0):=(others => Lo);
signal	Data_Misc				:	std_logic_vector(31 downto 0):=(others => Lo);
signal	Write_aggregate		:	std_logic_vector(31 downto 0):=(others => Lo);
signal	Read_aggregate			:	std_logic_vector(31 downto 0):=(others => Lo);
signal	Control_aggregate		:	std_logic_vector(31 downto 0):=(others => Lo);
	
	
signal	ETH_WR_En				:	std_logic:='0';
signal	ETH_RD_En				:	std_logic:='0';
signal	ETH_Addr				:	std_logic_vector(1 downto 0):=(others => Lo);
signal	ETH_ADDR_DV			:	std_logic:='0';
signal	ETH_ADDR_DATA_IN		:	std_logic_vector(47 downto 0):=(others => Lo);
signal	ETH_ADDR_DATA_OUT		:	std_logic_vector(47 downto 0):=(others => Lo);
signal	ETH_ADDR_DATA_OUT_reg	:	std_logic_vector(47 downto 0):=(others => Lo);
signal	ETH_ADDR_DATA_OUT_reg_Hi	:	std_logic_vector(31 downto 0):=(others => Lo);
signal	ETH_ADDR_DATA_OUT_reg_Lo	:	std_logic_vector(31 downto 0):=(others => Lo);
	
signal	EN_Arbitrator			:	std_logic:='0';
--------	
--IPLayer jelek	
-------	
signal	RESET_IPLayer			:	std_logic:='0';
signal	EN_IPLayer			:	std_logic:='0';
signal	EN_IPLayerCFG			:	std_logic:='0';
signal	IP_WREN				:	std_logic:='0';
signal	IP_RDEN				:	std_logic:='0';
signal	IP_CFGAWREN			:	std_logic:='0';
signal	IP_CFG_ADDR			:	std_logic_vector(3 downto 0):=(others => Lo);
signal	IP_Addr				:	std_logic_vector(2 downto 0):=(others => Lo);
signal	IP_Data_In			:	std_logic_vector(31 downto 0):=(others => Lo);
signal	IP_Data_Out			:	std_logic_vector(31 downto 0):=(others => Lo);
signal	IP_Data_Out_reg		:	std_logic_vector(31 downto 0):=(others => Lo);
signal	IP_DoutV				:	std_logic:='0';
signal	IP_ARP_Request			:	std_logic:='0';
signal	IP_ARP_DSTIPAddr		:	std_logic_vector(31 downto 0):=(others => Lo);
signal	IP_ARP_ResponseV		:	std_logic:='0';
signal	IP_ARP_ResponseV_sig	:	std_logic:='0';
signal	IP_ARP_ResponseErr		:	std_logic:='0';
signal	IP_ARP_ResponseErr_sig	:	std_logic:='0';
signal	IP_ARP_DstMacAddr		:	std_logic_vector(47 downto 0):=(others => Lo);
signal	IP_ARP_DstMacAddr_sig	:	std_logic_vector(47 downto 0):=(others => Lo);
signal	IP_DstIPAddr_In		:	std_logic_vector(31 downto 0):=(others => Lo);
signal	IP_SrcIPAddr_In		:	std_logic_vector(31 downto 0):=(others => Lo);
signal	IP_Prot_In			:	std_logic_vector(7 downto 0):=(others => Lo);
signal	IP_Length_In			:	std_logic_vector(15 downto 0):=(others => Lo);
signal	IP_DstIPAddr_Out		:	std_logic_vector(31 downto 0):=(others => Lo);
signal	IP_SrcIPAddr_Out		:	std_logic_vector(31 downto 0):=(others => Lo);
signal	IP_Prot_Out			:	std_logic_vector(7 downto 0):=(others => Lo);
signal	IP_Length_Out			:	std_logic_vector(15 downto 0):=(others => Lo);
signal	IP_DstMacAddr_In		:	std_logic_vector(47 downto 0):=(others => Lo);
signal	IP_SrcMacAddr_In		:	std_logic_vector(47 downto 0):=(others => Lo);
signal	IP_EthType_In			:	std_logic_vector(15 downto 0):=(others => Lo);
signal	IP_DstMacAddr_Out		:	std_logic_vector(47 downto 0):=(others => Lo);
signal	IP_SrcMacAddr_Out		:	std_logic_vector(47 downto 0):=(others => Lo);
signal	IP_EthType_Out			:	std_logic_vector(15 downto 0):=(others => Lo);
signal	IP_SDU_DIN			:	std_logic_vector(7 downto 0):=(others => Lo);
signal	IP_SDU_DINV			:	std_logic:='0';
signal	IP_SDU_IN_SOP			:	std_logic:='0';
signal	IP_SDU_IN_EOP			:	std_logic:='0';
signal	IP_SDU_IN_Ind			:	std_logic:='0';
signal	IP_SDU_IN_ErrIn		:	std_logic:='0';
signal	IP_SDU_IN_Ack			:	std_logic:='0';
signal	IP_SDU_IN_ErrOut		:	std_logic:='0';
signal	IP_PDU_DOUT			:	std_logic_vector(7 downto 0):=(others => Lo);
signal	IP_PDU_DOUTV			:	std_logic:='0';
signal	IP_PDU_Out_SOP			:	std_logic:='0';
signal	IP_PDU_Out_EOP			:	std_logic:='0';
signal	IP_PDU_Out_Ind			:	std_logic:='0';
signal	IP_PDU_Out_ErrOut		:	std_logic:='0';
-- signal	IP_PDU_Out_USER_Out		:	std_logic:='0';
signal	IP_PDU_Out_Ack			:	std_logic:='0';
signal	IP_PDU_Out_ErrIn		:	std_logic:='0';
signal	IP_PDU_DIN			:	std_logic_vector(7 downto 0):=(others => Lo);
signal	IP_PDU_DINV			:	std_logic:='0';
signal	IP_PDU_IN_SOP			:	std_logic:='0';
signal	IP_PDU_IN_EOP			:	std_logic:='0';
signal	IP_PDU_IN_Ind			:	std_logic:='0';
signal	IP_PDU_IN_ErrIn		:	std_logic:='0';
signal	IP_PDU_IN_ErrOut		:	std_logic:='0';
signal	IP_PDU_IN_Ack			:	std_logic:='0';
signal	IP_SDU_DOUT			:	std_logic_vector(7 downto 0):=(others => Lo);
signal	IP_SDU_DOUTV			:	std_logic:='0';
signal	IP_SDU_Out_SOP			:	std_logic:='0';
signal	IP_SDU_OUT_EOP			:	std_logic:='0';
signal	IP_SDU_OUT_Ind			:	std_logic:='0';
signal	IP_SDU_OUT_ErrOut		:	std_logic:='0';
signal	IP_SDU_OUT_ErrIn		:	std_logic:='0';
signal	IP_SDU_OUT_Ack			:	std_logic:='0';
	
signal	IP_Status				:	std_logic_vector(7 downto 0):=(others => Lo);
	
SIGNAL	ARP_Status			:	STD_LOGIC_VECTOR(32-1 downto 0)	:=	(others => Lo);
SIGNAL	Arbitrator_Status		:	STD_LOGIC_VECTOR(3 downto 0)	:=	(others => Lo);
SIGNAL	ETHLArb_Status			:	STD_LOGIC_VECTOR(3 downto 0)	:=	(others => Lo);
	
signal	User_ARP_ReqUest		:	std_logic:='0';
signal	User_ARP_DST_IP_addr	:	std_logic_vector(31 downto 0):=(others => Lo);
signal	User_IP_ARP_Select		:	std_logic:='0';
signal	User_ARP_RESPONSEV		:	std_logic:='0';
signal	User_ARP_RESPONSE_ERR	:	std_logic:='0';
signal	User_ARP_DST_MAC_addr	:	std_logic_vector(47 downto 0)	:=	(others => Lo);

type IPPDUgenFSM_StateType is
(
	INIT,
	IDLE,
	WFOR_ACK,
	EmitIPPDU
);
ATTRIBUTE	ENUM_ENCODING			:	STRING;
	
signal	IPPDUgenFSM_State		:	IPPDUgenFSM_StateType;
SIGNAL	IPPDUGenStart			:	STD_LOGIC;
SIGNAL	IPPDUGen_DSTIPaddrOut	:	STD_LOGIC_VECTOR(32-1 downto 0)	:=	(others => Lo);
SIGNAL	IPPDUGen_SRCIPaddrOut	:	STD_LOGIC_VECTOR(32-1 downto 0)	:=	(others => Lo);
SIGNAL	IPPDUGen_ProtoOut		:	STD_LOGIC_VECTOR(8-1 downto 0)	:=	(others => Lo);
SIGNAL	IPPDUGen_LenOut		:	STD_LOGIC_VECTOR(16-1 downto 0)	:=	(others => Lo);
signal	IPPDUGen_DOUT			:	std_logic_vector(7 downto 0)	:=	(others => Lo);
signal	IPPDUGen_DOUTV			:	std_logic	:=	'0';
signal	IPPDUGen_Out_SOP		:	std_logic	:=	'0';
signal	IPPDUGen_Out_EOP		:	std_logic	:=	'0';
signal	IPPDUGen_Out_Ind		:	std_logic	:=	'0';
signal	IPPDUGen_Out_ErrIn		:	std_logic	:=	'0';
signal	IPPDUGen_Out_ErrOut		:	std_logic	:=	'0';
signal	IPPDUGen_Out_Ack		:	std_logic	:=	'0';
signal	EN_IPPDUGen			:	std_logic	:=	'0';
signal	RST_IPPDUGen			:	std_logic	:=	'0';
signal	IPPDUGen_IPGR			:	std_logic	:=	'0';
SIGNAL	IPPDUGen_LenCntr		:	STD_LOGIC_VECTOR(16-1 downto 0)	:=	(others => Lo);
SIGNAL	IPPDUGen_Status		:	STD_LOGIC_VECTOR(1 downto 0)	:=	(others => Lo);

--------
--UDP PDU generator jelek
-------
SIGNAL	UDPPDUGenStart			:	STD_LOGIC	:=	'0';
SIGNAL	UDPPDUGen_DSTIPaddrOut	:	STD_LOGIC_VECTOR(32-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDPPDUGen_SRCIPaddrOut	:	STD_LOGIC_VECTOR(32-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDPPDUGen_DstPort_Out	:	STD_LOGIC_VECTOR(16-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDPPDUGen_SrcPort_Out	:	STD_LOGIC_VECTOR(16-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDPPDUGen_LenOut		:	STD_LOGIC_VECTOR(16-1 DOWNTO 0)	:=	(others => Lo);
signal	UDPPDUGen_DOUT			:	std_logic_vector(08-1 DOWNTO 0)	:=	(others => Lo);
signal	UDPPDUGen_DOUTV		:	std_logic	:=	'0';
signal	UDPPDUGen_Out_SOP		:	std_logic	:=	'0';
signal	UDPPDUGen_Out_EOP		:	std_logic	:=	'0';
signal	UDPPDUGen_Out_Ind		:	std_logic	:=	'0';
signal	UDPPDUGen_Out_ErrIn		:	std_logic	:=	'0';
signal	UDPPDUGen_Out_ErrOut	:	std_logic	:=	'0';
signal	UDPPDUGen_Out_Ack		:	std_logic	:=	'0';
signal	EN_UDPPDUGen			:	std_logic	:=	'0';
signal	RST_UDPPDUGen			:	std_logic	:=	'0';
signal	UDPPDUGen_IPGR			:	std_logic	:=	'0';
SIGNAL	UDPPDUGen_LenCntr		:	STD_LOGIC_VECTOR(16-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDPPDUGen_Status		:	STD_LOGIC_VECTOR(1 DOWNTO 0)	:=	(others => Lo);

type UDPPDUgenFSM_StateType is
(
	INIT,
	IDLE,
	WFOR_ACK,
	EmitUDPPDU
);
-- ATTRIBUTE	ENUM_ENCODING		:STRING;

signal	UDPPDUgenFSM_State	:	UDPPDUgenFSM_StateType;

--------
--UDPLayer jelek
-------
CONSTANT	NumOfUDPPorts			:	integer	:=	8;
CONSTANT	UDP_AddrWidth			:	integer	:=	 INTEGER(CEIL(LOG2(REAL(NumOfUDPPorts))));
CONSTANT	UDP_DataWidth			:	integer	:=	 UDPPortSize + 1;
SIGNAL	UDP_RST				:	STD_LOGIC	:=	'0';
SIGNAL	UDP_CE				:	STD_LOGIC	:=	'0';
SIGNAL	UDP_CFG_CE			:	STD_LOGIC	:=	'0';
SIGNAL	UDP_WR_EN				:	STD_LOGIC	:=	'0';
SIGNAL	UDP_RD_EN				:	STD_LOGIC	:=	'0';
SIGNAL	UDP_ADDR				:	STD_LOGIC_VECTOR( UDP_AddrWidth-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_DATA_IN			:	STD_LOGIC_VECTOR( UDP_DataWidth-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_DATA_IN_sig		:	STD_LOGIC_VECTOR( UDP_DataWidth-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_WR_ValidPort		:	STD_LOGIC	:=	'0';
SIGNAL	UDP_WR_Port			:	STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_DATA_OUT			:	STD_LOGIC_VECTOR( UDP_DataWidth-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_DATA_OUT_reg		:	STD_LOGIC_VECTOR( UDP_DataWidth-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_DOUTV				:	STD_LOGIC	:=	'0';
SIGNAL	UDP_IP_DstIPAddr_In		:	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_IP_SrcIPAddr_In		:	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_IP_Proto_In		:	STD_LOGIC_VECTOR( IP_ProtSize-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_IP_Length_In		:	STD_LOGIC_VECTOR( IPLengthSize-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_IP_DstIPAddr_Out	:	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_IP_SrcIPAddr_Out	:	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_IP_Proto_Out		:	STD_LOGIC_VECTOR( IP_ProtSize-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_IP_Length_Out		:	STD_LOGIC_VECTOR( IPLengthSize-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_DstIPAddr_In		:	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_SrcIPAddr_In		:	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_DstPort_In			:	STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_SrcPort_In			:	STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_Length_In			:	STD_LOGIC_VECTOR( UDPLengthSize-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_DstIPAddr_Out		:	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_SrcIPAddr_Out		:	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_DstPort_Out		:	STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_SrcPort_Out		:	STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_Length_Out			:	STD_LOGIC_VECTOR( UDPLengthSize-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_SDU_DIN			:	STD_LOGIC_VECTOR( 8-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_SDU_DINV			:	STD_LOGIC	:=	'0';
SIGNAL	UDP_SDU_IN_SOP			:	STD_LOGIC	:=	'0';
SIGNAL	UDP_SDU_IN_EOP			:	STD_LOGIC	:=	'0';
SIGNAL	UDP_SDU_IN_Ind			:	STD_LOGIC	:=	'0';
SIGNAL	UDP_SDU_IN_ErrIn		:	STD_LOGIC	:=	'0';
SIGNAL	UDP_SDU_IN_USER_In		:	STD_LOGIC_VECTOR( USER_width-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_SDU_IN_Ack			:	STD_LOGIC	:=	'0';
SIGNAL	UDP_SDU_IN_ErrOut		:	STD_LOGIC	:=	'0';
SIGNAL	UDP_PDU_DOUT			:	STD_LOGIC_VECTOR( 8-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_PDU_DOUTV			:	STD_LOGIC	:=	'0';
SIGNAL	UDP_PDU_Out_SOP		:	STD_LOGIC	:=	'0';
SIGNAL	UDP_PDU_Out_EOP		:	STD_LOGIC	:=	'0';
SIGNAL	UDP_PDU_Out_Ind		:	STD_LOGIC	:=	'0';
SIGNAL	UDP_PDU_Out_ErrOut		:	STD_LOGIC	:=	'0';
SIGNAL	UDP_PDU_Out_USER_Out	:	STD_LOGIC_VECTOR( USER_width-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_PDU_Out_Ack		:	STD_LOGIC	:=	'0';
SIGNAL	UDP_PDU_Out_ErrIn		:	STD_LOGIC	:=	'0';
SIGNAL	UDP_PDU_DIN			:	STD_LOGIC_VECTOR( 8-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_PDU_DINV			:	STD_LOGIC	:=	'0';
SIGNAL	UDP_PDU_IN_SOP			:	STD_LOGIC	:=	'0';
SIGNAL	UDP_PDU_IN_EOP			:	STD_LOGIC	:=	'0';
SIGNAL	UDP_PDU_IN_Ind			:	STD_LOGIC	:=	'0';
SIGNAL	UDP_PDU_IN_USER_In		:	STD_LOGIC_VECTOR( USER_width-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_PDU_IN_ErrIn		:	STD_LOGIC	:=	'0';
SIGNAL	UDP_PDU_IN_ErrOut		:	STD_LOGIC	:=	'0';
SIGNAL	UDP_PDU_IN_Ack			:	STD_LOGIC	:=	'0';
SIGNAL	UDP_SDU_DOUT			:	STD_LOGIC_VECTOR( 8-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_SDU_DOUTV			:	STD_LOGIC	:=	'0';
SIGNAL	UDP_SDU_Out_SOP		:	STD_LOGIC	:=	'0';
SIGNAL	UDP_SDU_OUT_EOP		:	STD_LOGIC	:=	'0';
SIGNAL	UDP_SDU_OUT_Ind		:	STD_LOGIC	:=	'0';
SIGNAL	UDP_SDU_OUT_USER_Out	:	STD_LOGIC_VECTOR( USER_width-1 DOWNTO 0)	:=	(others => Lo);
SIGNAL	UDP_SDU_OUT_ErrOut		:	STD_LOGIC	:=	'0';
SIGNAL	UDP_SDU_OUT_ErrIn		:	STD_LOGIC	:=	'0';
SIGNAL	UDP_SDU_OUT_Ack		:	STD_LOGIC	:=	'0';
SIGNAL	UDP_Status			:	STD_LOGIC_VECTOR( 8-1 DOWNTO 0)	:=	(others => Lo);

CONSTANT	NumOfSNMPEvents		:	INTEGER	:=	32;
CONSTANT	NumOfLinks			:	INTEGER	:=	2;
	
SIGNAL	SNMP_CE				:	STD_LOGIC;
SIGNAL	SNMP_CFG_CE			:	STD_LOGIC;
SIGNAL	SNMP_RST				:	STD_LOGIC;
SIGNAL	SNMP_DstIPAddr_In		:	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
SIGNAL	SNMP_SrcIPAddr_In		:	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
SIGNAL	SNMP_DstPort_In		:	STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
SIGNAL	SNMP_SrcPort_In		:	STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
SIGNAL	SNMP_Length_In			:	STD_LOGIC_VECTOR( UDPLengthSize-1 DOWNTO 0);
SIGNAL	SNMP_DstIPAddr_Out		:	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
SIGNAL	SNMP_SrcIPAddr_Out		:	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
SIGNAL	SNMP_DstPort_Out		:	STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
SIGNAL	SNMP_SrcPort_Out		:	STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
SIGNAL	SNMP_Length_Out		:	STD_LOGIC_VECTOR( UDPLengthSize-1 DOWNTO 0);
SIGNAL	SNMP_PDU_DIN			:	STD_LOGIC_VECTOR( 8 - 1 DOWNTO 0);
SIGNAL	SNMP_PDU_DINV			:	STD_LOGIC;
SIGNAL	SNMP_PDU_IN_SOP		:	STD_LOGIC;
SIGNAL	SNMP_PDU_IN_EOP		:	STD_LOGIC;
SIGNAL	SNMP_PDU_IN_INd		:	STD_LOGIC;
SIGNAL	SNMP_PDU_IN_ErrOUT		:	STD_LOGIC;
SIGNAL	SNMP_PDU_IN_Ack		:	STD_LOGIC;
SIGNAL	SNMP_PDU_IN_ErrIN		:	STD_LOGIC;
SIGNAL	SNMP_PDU_DOUT			:	STD_LOGIC_VECTOR( 8 - 1 DOWNTO 0);
SIGNAL	SNMP_PDU_DOUTV			:	STD_LOGIC;
SIGNAL	SNMP_PDU_OUT_SOP		:	STD_LOGIC;
SIGNAL	SNMP_PDU_OUT_EOP		:	STD_LOGIC;
SIGNAL	SNMP_PDU_OUT_INd		:	STD_LOGIC;
SIGNAL	SNMP_PDU_OUT_ErrOUT		:	STD_LOGIC;
SIGNAL	SNMP_PDU_OUT_Ack		:	STD_LOGIC;
SIGNAL	SNMP_PDU_OUT_ErrIN		:	STD_LOGIC;
SIGNAL	SNMP_WR_EN			:	STD_LOGIC;
SIGNAL	SNMP_RD_EN			:	STD_LOGIC;
SIGNAL	SNMP_CFG_ADDR			:	STD_LOGIC_VECTOR( SNMPAddrWidth - 1 DOWNTO 0);
SIGNAL	SNMP_DATA_IN			:	STD_LOGIC_VECTOR( SNMPDataWidth - 1 DOWNTO 0);
SIGNAL	SNMP_RD_DV			:	STD_LOGIC;
SIGNAL	SNMP_DATA_OUT			:	STD_LOGIC_VECTOR( SNMPDataWidth - 1 DOWNTO 0);
SIGNAL	SNMP_DATA_OUT_reg		:	STD_LOGIC_VECTOR( SNMPDataWidth - 1 DOWNTO 0);
SIGNAL	SNMP_EventIN			:	STD_LOGIC_VECTOR( NumOfSNMPEvents - 1 DOWNTO 0);
SIGNAL	SNMP_LinkStatusIn		:	STD_LOGIC_VECTOR( NumOfLinks - 1 DOWNTO 0);
	
	
SIGNAL	DummyAddr				:	STD_LOGIC_VECTOR(7 downto 0);

BEGIN
 
	-------------------------------------------------------------

	User_IP_ARPMUX:process(CLK,User_IP_ARP_Select)
	begin
		if(rising_edge(CLK))then
			if(User_IP_ARP_Select = Lo)then
				ARP_ReqUest			<=	User_ARP_ReqUest;
				ARP_DST_IP_addr		<=	User_ARP_DST_IP_addr;
				User_ARP_Dst_Mac_Addr	<=	ARP_DST_MAC_addr;
				User_ARP_ResponseV		<=	ARP_ResponseV;
				User_ARP_RESPONSE_ERR	<=	ARP_RESPONSE_ERR;
				IP_ARP_DstMacAddr		<=	(others => Lo);
				IP_ARP_ResponseV		<=	Lo;
				IP_ARP_ResponseErr		<=	Lo;
			else
				ARP_ReqUest			<=	IP_ARP_Request;
				ARP_DST_IP_addr		<=	IP_ARP_DSTIPAddr;
				User_ARP_Dst_Mac_Addr	<=	(others => Lo);
				User_ARP_ResponseV		<=	Lo;
				User_ARP_RESPONSE_ERR	<=	Lo;
				IP_ARP_DstMacAddr		<=	ARP_DST_MAC_addr;
				IP_ARP_ResponseV		<=	ARP_ResponseV;
				IP_ARP_ResponseErr		<=	ARP_RESPONSE_ERR;

			end if;
		end if;
	end process User_IP_ARPMUX;
	-------------------------------------------------------------
	EN_ARP			<=	CE;
	RESET_ARP			<=	RST;
	
	Inst_ARPModule: ARPModule --RX_SYNC_IN !!
	GENERIC MAP(
		DataWidth			=>		8,
		TX_SYNC_OUT		=>		true,	--must be true in case of abitration
		RX_SYNC_IN		=>		false,	--must be false in case of abitration
		NumOfAddresses		=>		4, --Maximum 16, for each IP a MAC addr must be defined and vice-versa
		CLK_freq			=>		125.0, --Clock frequency in MHz
		TimeOUT			=>		0.02, --timeout in ms
		RetryCnt			=>		1	--retry count
	)
	PORT MAP(
		CLK				=>	Clk,
		RST				=>	RESET_ARP,
		CE				=>	EN_ARP,
		CFG_CE			=>	EN_ARP,
		DST_MacAddr_Out	=>	ARP_DST_MacAddr_Out,
		SRC_MacAddr_Out	=>	ARP_SRC_MacAddr_Out,
		EType_Out			=>	ARP_EType_Out,
		PDU_DOUT			=>	ARP_PDU_DOUT,
		PDU_DOUTV			=>	ARP_PDU_DOUTV,
		PDU_Out_SOP		=>	ARP_PDU_Out_SOP,
		PDU_Out_EOP		=>	ARP_PDU_Out_EOP,
		PDU_Out_Ind		=>	ARP_PDU_Out_Ind,
		PDU_Out_ErrOut		=>	ARP_PDU_Out_ErrOut,
		PDU_Out_Ack		=>	ARP_PDU_Out_Ack,
		PDU_Out_ErrIn		=>	ARP_PDU_Out_ErrIn,
		DST_MacAddr_In		=>	ARP_DST_MacAddr_In,
		SRC_MacAddr_In		=>	ARP_SRC_MacAddr_In,
		EType_In			=>	ARP_EType_In,
		PDU_DIN			=>	ARP_PDU_DIN,
		PDU_DINV			=>	ARP_PDU_DINV,
		PDU_In_SOP		=>	ARP_PDU_In_SOP,
		PDU_In_EOP		=>	ARP_PDU_In_EOP,
		PDU_In_Ind		=>	ARP_PDU_In_Ind,
		PDU_In_ErrIn		=>	ARP_PDU_In_ErrIn,
		PDU_In_Ack		=>	ARP_PDU_In_Ack,
		PDU_In_ErrOut		=>	ARP_PDU_In_ErrOut,
		ARP_ReqUest		=>	ARP_ReqUest,
		ARP_DST_IP_addr	=>	ARP_DST_IP_addr,
		ARP_DST_MAC_addr	=>	ARP_DST_MAC_addr,
		ARP_RESPONSEV		=>	ARP_RESPONSEV,
		ARP_RESPONSE_ERR	=>	ARP_RESPONSE_ERR,
		IPADDR_WR_EN		=>	ARP_IPADDR_WR_EN,
		MACADDR_WR_EN		=>	ARP_MACADDR_WR_EN,
		IPADDR_RD_EN		=>	ARP_IPADDR_RD_EN,
		MACADDR_RD_EN		=>	ARP_MACADDR_RD_EN,
		ADDR				=>	ARP_ADDR,
		ADDR_DATA_IN		=>	ARP_ADDR_DATA_IN,
		IPADDR_DATA_OUT	=>	ARP_IPADDR_DATA_OUT,
		MACADDR_DATA_OUT	=>	ARP_MACADDR_DATA_OUT,
		IPADDR_DV			=>	ARP_IPADDR_DV,
		MACADDR_DV		=>	ARP_MACADDR_DV,
		StatusVec			=>	ARP_Status
	);
	
	RESET_Arbitrator	<=	RST;
	EN_Arbitrator		<=	CE;
	
	
	Inst_EthLayer_Arbitrator_2: EthLayer_Arbitrator_2 PORT MAP(
		CLK				=>	Clk,
		RST				=>	RESET_Arbitrator,
		CE				=>	EN_Arbitrator,
		DstMacAddr_In_0	=>	ARP_DST_MacAddr_Out,
		SrcMacAddr_In_0	=>	ARP_SRC_MacAddr_Out,
		EthType_In_0		=>	ARP_EType_Out,
		In_0_Data			=>	ARP_PDU_DOUT,
		In_0_DataV		=>	ARP_PDU_DOUTV,
		In_0_SOP			=>	ARP_PDU_Out_SOP,
		In_0_EOP			=>	ARP_PDU_Out_EOP,
		In_0_ErrIn		=>	ARP_PDU_Out_ErrOut,
		In_0_Ind			=>	ARP_PDU_Out_Ind,
		In_0_Ack			=>	ARP_PDU_Out_Ack,
		In_0_ErrOut		=>	ARP_PDU_Out_ErrIn,
		DstMacAddr_Out_0	=>	ARP_DST_MacAddr_In,
		SrcMacAddr_Out_0	=>	ARP_SRC_MacAddr_In,
		EthType_Out_0		=>	ARP_EType_In,
		Out_0_Data		=>	ARP_PDU_DIN,
		Out_0_DataV		=>	ARP_PDU_DINV,
		Out_0_SOP			=>	ARP_PDU_In_SOP,
		Out_0_EOP			=>	ARP_PDU_In_EOP,
		Out_0_ErrOut		=>	ARP_PDU_In_ErrIn,
		DstMacAddr_In_1	=>	IP_DstMacAddr_Out,
		SrcMacAddr_In_1	=>	IP_SrcMacAddr_Out,
		EthType_In_1		=>	IP_EthType_Out,
		In_1_Data			=>	IP_PDU_DOUT,
		In_1_DataV		=>	IP_PDU_DOUTV,
		In_1_SOP			=>	IP_PDU_Out_SOP,
		In_1_EOP			=>	IP_PDU_Out_EOP,
		In_1_ErrIn		=>	IP_PDU_Out_ErrOut,
		In_1_Ind			=>	IP_PDU_Out_Ind,
		In_1_Ack			=>	IP_PDU_Out_Ack,
		In_1_ErrOut		=>	IP_PDU_Out_ErrIn,
		Out_1_Data		=>	IP_PDU_DIN,
		Out_1_DataV		=>	IP_PDU_DINV,
		Out_1_SOP			=>	IP_PDU_In_SOP,
		Out_1_EOP			=>	IP_PDU_In_EOP,
		Out_1_ErrOut		=>	IP_PDU_In_ErrIn,
		DstMacAddr_Out_1	=>	IP_DstMacAddr_In,
		SrcMacAddr_Out_1	=>	IP_SrcMacAddr_In,
		EthType_Out_1		=>	IP_EthType_In,
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
		Status			=>	ETHLArb_Status
	);

	EArbit: End_Arbitrator_2
	GENERIC MAP(
		DataWidth		=>	8
		)
	PORT MAP (
		CLK			=>	Clk,
		RST			=>	RESET_Arbitrator,
		CE			=>	EN_Arbitrator,
		In_0_Data		=>	ETHLayer_0_PDU_DOUT,
		In_0_DataV	=>	ETHLayer_0_PDU_DOUTV,
		In_0_SOP		=>	ETHLayer_0_PDU_Out_SOP,
		In_0_EOP		=>	ETHLayer_0_PDU_Out_EOP,
		In_0_ErrIn	=>	ETHLayer_0_PDU_Out_ErrOut,
		In_0_Ind		=>	ETHLayer_0_PDU_Out_Ind,
		In_0_Ack		=>	ETHLayer_0_PDU_Out_Ack,
		Out_0_Data	=>	ETHLayer_0_PDU_DIN,
		Out_0_DataV	=>	ETHLayer_0_PDU_DINV,
		Out_0_SOP		=>	ETHLayer_0_PDU_In_SOP,
		Out_0_EOP		=>	ETHLayer_0_PDU_In_EOP,
		Out_0_ErrOut	=>	ETHLayer_0_PDU_In_ErrIn,
		-- In_1_Data		=>	ETHLayer_1_PDU_DOUT,
		-- In_1_DataV	=>	ETHLayer_1_PDU_DOUTV,
		-- In_1_SOP		=>	ETHLayer_1_PDU_Out_SOP,
		-- In_1_EOP		=>	ETHLayer_1_PDU_Out_EOP,
		-- In_1_ErrIn	=>	ETHLayer_1_PDU_Out_ErrOut,
		-- In_1_Ind		=>	ETHLayer_1_PDU_Out_Ind,
		-- In_1_Ack		=>	ETHLayer_1_PDU_Out_Ack,
		-- Out_1_Data	=>	ETHLayer_1_PDU_DIN,
		-- Out_1_DataV	=>	ETHLayer_1_PDU_DINV,
		-- Out_1_SOP		=>	ETHLayer_1_PDU_In_SOP,
		-- Out_1_EOP		=>	ETHLayer_1_PDU_In_EOP,
		-- Out_1_ErrOut	=>	ETHLayer_1_PDU_In_ErrIn,
		In_1_Data		=>	X"00",
		In_1_DataV	=>	Lo,
		In_1_SOP		=>	Lo,
		In_1_EOP		=>	Lo,
		In_1_ErrIn	=>	Lo,
		In_1_Ind		=>	Lo,
		In_1_Ack		=>	OPEN,
		Out_1_Data	=>	OPEN,
		Out_1_DataV	=>	OPEN,
		Out_1_SOP		=>	OPEN,
		Out_1_EOP		=>	OPEN,
		Out_1_ErrOut	=>	OPEN,
		Out_Data		=>	MAC_0_DOUT,
		Out_DataV		=>	MAC_0_DOUTV,
		Out_SOP		=>	MAC_0_Out_SOP,
		Out_EOP		=>	MAC_0_Out_EOP,
		Out_ErrOut	=>	MAC_0_Out_ErrOut,
		In_Data		=>	MAC_0_DIN,
		In_DataV		=>	MAC_0_DAV,
		In_SOP		=>	MAC_0_SOF,
		In_EOP		=>	MAC_0_EOF,
		In_ErrIn		=>	MAC_0_Err,
		Status		=>	Arbitrator_Status
	);
	
	
	Inst_EthernetLayer_0: EthernetLayer 
	generic map(
		DataWidth			=>		8,
		RX_SYNC_IN		=>		false, --Due to MAC
		RX_SYNC_OUT		=>		false, --Due to arbitration
		TX_SYNC_IN		=>		false, --Due to arbitration
		TX_SYNC_OUT		=>		true, --Due to arbitration (IFGap)
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
	
	-- IP_DstIPAddr_In	<=	IPPDUGen_DSTIPaddrOut;
	-- IP_SrcIPAddr_In	<=	IPPDUGen_SRCIPaddrOut;
	-- IP_Prot_In		<=	IPPDUGen_ProtoOut;
	-- IP_Length_In		<=	IPPDUGen_LenOut;
	-- IP_SDU_DIN		<=	IPPDUGen_DOUT;
	-- IP_SDU_DINV		<=	IPPDUGen_DOUTV;
	-- IP_SDU_IN_SOP		<=	IPPDUGen_Out_SOP;
	-- IP_SDU_IN_EOP		<=	IPPDUGen_Out_EOP;
	-- IP_SDU_IN_Ind		<=	IPPDUGen_Out_Ind;
	-- IP_SDU_IN_ErrIn	<=	Lo;
	
	IP_DstIPAddr_In	<=	UDP_IP_DstIPAddr_Out;
	IP_SrcIPAddr_In	<=	UDP_IP_SrcIPAddr_Out;
	IP_Prot_In		<=	UDP_IP_Proto_Out;
	IP_Length_In		<=	UDP_IP_Length_Out;
	IP_SDU_DIN		<=	UDP_PDU_DOUT;
	IP_SDU_DINV		<=	UDP_PDU_DOUTV;
	IP_SDU_IN_SOP		<=	UDP_PDU_Out_SOP;
	IP_SDU_IN_EOP		<=	UDP_PDU_Out_EOP;
	IP_SDU_IN_Ind		<=	UDP_PDU_Out_Ind;
	IP_SDU_IN_ErrIn	<=	UDP_PDU_Out_ErrOut;
	UDP_PDU_Out_Ack	<=	IP_SDU_IN_Ack;
	UDP_PDU_Out_ErrIn	<=	IP_SDU_IN_ErrOut;
	
	Inst_IPLayer: IPLayer  --TX_SYNC_IN !!!
	generic MAP(
		DataWidth			=>		DefDataWidth,
		RX_SYNC_IN		=>		false, --freely choosen
		RX_SYNC_OUT		=>		false, --freely choosen
		TX_SYNC_OUT		=>		true, --freely choosen
		NumOfIPAddresses	=>		4,
		PacketToQueue		=>		DefPDUToQ,
		TTL				=>		DefTTL,
		MTU				=>		IPDefMTU
	)
	PORT MAP (
		CLK				=>	CLK,
		RST				=>	RST,
		CE				=>	CE,
		CFG_CE			=>	CE,
		WR_EN			=>	IP_WREN,
		RD_EN			=>	IP_RDEN,
		CFG_ADDR_WR		=>	IP_CFGAWREN,
		CFG_ADDR			=>	IP_CFG_ADDR,
		ADDR				=>	IP_Addr,
		DATA_IN			=>	IP_Data_In,
		DATA_OUT			=>	IP_Data_Out,
		DOUTV			=>	IP_DoutV,
		ARP_Request		=>	IP_ARP_Request,
		ARP_DSTIPAddr		=>	IP_ARP_DSTIPAddr,
		ARP_ResponseV		=>	IP_ARP_ResponseV_sig,
		ARP_ResponseErr	=>	IP_ARP_ResponseErr_sig,
		ARP_DstMacAddr		=>	IP_ARP_DstMacAddr_sig,
		DstIPAddr_In		=>	IP_DstIPAddr_In,
		SrcIPAddr_In		=>	IP_SrcIPAddr_In,
		Prot_In			=>	IP_Prot_In,
		Length_In			=>	IP_Length_In,
		DstIPAddr_Out		=>	IP_DstIPAddr_Out,
		SrcIPAddr_Out		=>	IP_SrcIPAddr_Out,
		Prot_Out			=>	IP_Prot_Out,
		Length_Out		=>	IP_Length_Out,
		DstMacAddr_In		=>	IP_DstMacAddr_In,
		SrcMacAddr_In		=>	IP_SrcMacAddr_In,
		EthType_In		=>	IP_EthType_In,
		DstMacAddr_Out		=>	IP_DstMacAddr_Out,
		SrcMacAddr_Out		=>	IP_SrcMacAddr_Out,
		EthType_Out		=>	IP_EthType_Out,
		SDU_DIN			=>	IP_SDU_DIN,
		SDU_DINV			=>	IP_SDU_DINV,
		SDU_IN_SOP		=>	IP_SDU_IN_SOP,
		SDU_IN_EOP		=>	IP_SDU_IN_EOP,
		SDU_IN_Ind		=>	IP_SDU_IN_Ind,
		SDU_IN_ErrIn		=>	IP_SDU_IN_ErrIn,
		SDU_IN_USER_In		=>	"000000",
		SDU_IN_Ack		=>	IP_SDU_IN_Ack,
		SDU_IN_ErrOut		=>	IP_SDU_IN_ErrOut,
		PDU_DOUT			=>	IP_PDU_DOUT,
		PDU_DOUTV			=>	IP_PDU_DOUTV,
		PDU_Out_SOP		=>	IP_PDU_Out_SOP,
		PDU_Out_EOP		=>	IP_PDU_Out_EOP,
		PDU_Out_Ind		=>	IP_PDU_Out_Ind,
		PDU_Out_ErrOut		=>	IP_PDU_Out_ErrOut,
		PDU_Out_USER_Out	=>	OPEN,
		PDU_Out_Ack		=>	IP_PDU_Out_Ack,
		PDU_Out_ErrIn		=>	IP_PDU_Out_ErrIn,
		PDU_DIN			=>	IP_PDU_DIN,
		PDU_DINV			=>	IP_PDU_DINV,
		PDU_IN_SOP		=>	IP_PDU_IN_SOP,
		PDU_IN_EOP		=>	IP_PDU_IN_EOP,
		PDU_IN_Ind		=>	IP_PDU_IN_Ind,
		PDU_IN_USER_In		=>	"000000",
		PDU_IN_ErrIn		=>	IP_PDU_IN_ErrIn,
		PDU_IN_ErrOut		=>	IP_PDU_IN_ErrOut,
		PDU_IN_Ack		=>	IP_PDU_IN_Ack,
		SDU_DOUT			=>	IP_SDU_DOUT,
		SDU_DOUTV			=>	IP_SDU_DOUTV,
		SDU_Out_SOP		=>	IP_SDU_Out_SOP,
		SDU_OUT_EOP		=>	IP_SDU_OUT_EOP,
		SDU_OUT_Ind		=>	IP_SDU_OUT_Ind,
		SDU_OUT_USER_Out	=>	OPEN,
		SDU_OUT_ErrOut		=>	IP_SDU_OUT_ErrOut,
		SDU_OUT_ErrIn		=>	IP_SDU_OUT_ErrIn,
		SDU_OUT_Ack		=>	IP_SDU_OUT_Ack,
		Status			=>	IP_Status
		);

IPPDU_RSTer: Resetter PORT MAP(CLK,RST_IPPDUGen,EN_IPPDUGen);
IPPDUgenFSM_proc:process(	CLK,
						RST_IPPDUGen,
						EN_IPPDUGen,
						IPPDUgenFSM_State)
begin
	if(rising_edge(CLK))then
		if(RST_IPPDUGen = Hi) then
			IPPDUgenFSM_State	<=	INIT;
		elsif(RST_IPPDUGen = Lo and EN_IPPDUGen = Hi) then
			case IPPDUgenFSM_State is
				when IDLE =>
					IPPDUGen_Status		<=	"01";
					IPPDUGen_Out_ErrOut		<=	Lo;
					IPPDUGen_Out_Ind		<=	Lo;
					IPPDUGen_Out_EOP		<=	Lo;
					IPPDUGen_Out_SOP		<=	Lo;
					IPPDUGen_DOUTV			<=	Lo;
					IPPDUGen_DOUT			<=	(others => Lo);
					IPPDUGen_LenCntr		<=	X"0002";
					if(IPPDUGenStart = Hi) then
						IPPDUGen_DSTIPaddrOut	<=	Address;
						IPPDUGen_SRCIPaddrOut	<=	Data_Hi;
						IPPDUGen_ProtoOut		<=	Data_Lo(7 downto 0);
						IPPDUGen_LenOut		<=	Data_Lo(23 downto 8);
						IPPDUGen_IPGR			<=	Hi;
						IPPDUgenFSM_State		<=	WFOR_ACK;
					else
						IPPDUgenFSM_State		<=	IDLE;
					end if;
				when WFOR_ACK =>
					IPPDUGen_Status		<=	"10";
					IPPDUGen_Out_Ind		<=	Hi;
					if(IP_SDU_IN_Ack = Hi and IP_SDU_IN_ErrOut = Lo)then
						IPPDUGen_DOUTV		<=	Hi;
						IPPDUGen_Out_SOP	<=	Hi;
						IPPDUgenFSM_State	<=	EmitIPPDU;
					elsif(IP_SDU_IN_ErrOut = Hi) then
						IPPDUgenFSM_State	<=	IDLE;
					else
						IPPDUgenFSM_State	<=	WFOR_ACK;
					end if;
				when EmitIPPDU =>
					IPPDUGen_Status		<=	"11";
					IPPDUGen_Out_SOP	<=	Lo;
					IPPDUGen_DOUT		<=	IPPDUGen_LenCntr(7 downto 0);
					if(IPPDUGen_LenCntr = IPPDUGen_LenOut) then
						IPPDUGen_Out_EOP	<=	Hi;
						IPPDUgenFSM_State	<=	IDLE;
					else
						IPPDUGen_LenCntr	<=	IPPDUGen_LenCntr + 1;
						IPPDUgenFSM_State	<=	EmitIPPDU;
					end if;
				when others => --INIT
				-- when INIT =>
					IPPDUGen_Status		<=	"00";
					IPPDUGen_DSTIPaddrOut	<=	Address;
					IPPDUGen_SRCIPaddrOut	<=	Data_Hi;
					IPPDUGen_ProtoOut		<=	Data_Lo(7 downto 0);
					IPPDUGen_LenOut		<=	Data_Lo(23 downto 8);
					IPPDUGen_Out_ErrOut		<=	Lo;
					IPPDUGen_Out_Ind		<=	Lo;
					IPPDUGen_Out_EOP		<=	Lo;
					IPPDUGen_Out_SOP		<=	Lo;
					IPPDUGen_DOUTV			<=	Lo;
					IPPDUGen_IPGR			<=	Lo;
					IPPDUGen_DOUT			<=	(others => Lo);
					IPPDUGen_LenCntr		<=	X"0002";
					IPPDUgenFSM_State		<=	IDLE;
			end case;
		end if;
	end if;
end process IPPDUgenFSM_proc;

UDPPDU_RSTer: Resetter PORT MAP(CLK,RST_UDPPDUGen,EN_UDPPDUGen);

UDPPDUgenFSM_proc:process(	CLK,
						RST_UDPPDUGen,
						EN_UDPPDUGen,
						UDPPDUgenFSM_State,UDP_SDU_IN_Ack,UDP_SDU_IN_ErrOut,UDPPDUGen_LenCntr)
begin
	if(rising_edge(CLK))then
		if(RST_UDPPDUGen = Hi) then
			UDPPDUgenFSM_State	<=	INIT;
		elsif(RST_UDPPDUGen = Lo and EN_UDPPDUGen = Hi) then
			case UDPPDUgenFSM_State is
				when IDLE =>
					UDPPDUGen_Status		<=	"01";
					UDPPDUGen_Out_ErrOut	<=	Lo;
					UDPPDUGen_Out_Ind		<=	Lo;
					UDPPDUGen_Out_EOP		<=	Lo;
					UDPPDUGen_Out_SOP		<=	Lo;
					UDPPDUGen_DOUTV		<=	Lo;
					UDPPDUGen_DOUT			<=	(others => Lo);
					UDPPDUGen_LenCntr		<=	X"0002";
					if(UDPPDUGenStart = Hi) then
						UDPPDUGen_SRCIPaddrOut	<=	Address;
						UDPPDUGen_DSTIPaddrOut	<=	Data_Hi;
						UDPPDUGen_SrcPort_Out	<=	Data_Lo(31 DOWNTO 16);
						UDPPDUGen_DstPort_Out	<=	Data_Lo(15 DOWNTO 0);
						UDPPDUGen_LenOut		<=	Data_Misc(15 DOWNTO 0);
						UDPPDUGen_IPGR			<=	Hi;
						UDPPDUgenFSM_State		<=	WFOR_ACK;
					else
						UDPPDUgenFSM_State		<=	IDLE;
					end if;
				when WFOR_ACK =>
					UDPPDUGen_Status		<=	"10";
					UDPPDUGen_Out_Ind		<=	Hi;
					UDPPDUGen_Out_EOP		<=	Lo;
					UDPPDUGen_DOUTV		<=	Lo;
					UDPPDUGen_DOUT			<=	(others => Lo);
					if(UDP_SDU_IN_Ack = Hi and UDP_SDU_IN_ErrOut = Lo)then
						UDPPDUGen_DOUTV	<=	Hi;
						UDPPDUGen_Out_SOP	<=	Hi;
						UDPPDUgenFSM_State	<=	EmitUDPPDU;
					elsif(UDP_SDU_IN_ErrOut = Hi) then
						UDPPDUgenFSM_State	<=	IDLE;
					else
						UDPPDUgenFSM_State	<=	WFOR_ACK;
					end if;
				when EmitUDPPDU =>
					UDPPDUGen_Status	<=	"11";
					UDPPDUGen_Out_SOP	<=	Lo;
					UDPPDUGen_Out_Ind	<=	Lo;
					UDPPDUGen_DOUT		<=	UDPPDUGen_LenCntr(7 DOWNTO 0);
					if(UDPPDUGen_LenCntr = UDPPDUGen_LenOut) then
						UDPPDUGen_Out_EOP	<=	Hi;
						IF(UDPPDUGenStart = Hi)THEN
							UDPPDUGen_SRCIPaddrOut	<=	Address;
							UDPPDUGen_DSTIPaddrOut	<=	Data_Hi;
							UDPPDUGen_SrcPort_Out	<=	Data_Lo(31 DOWNTO 16);
							UDPPDUGen_DstPort_Out	<=	Data_Lo(15 DOWNTO 0);
							UDPPDUGen_LenOut		<=	Data_Misc(15 DOWNTO 0);
							UDPPDUGen_IPGR			<=	Hi;
							UDPPDUGen_LenCntr		<=	X"0002";
							UDPPDUgenFSM_State		<=	WFOR_ACK;
						ELSE
							UDPPDUgenFSM_State	<=	IDLE;
						END IF;
					else
						UDPPDUGen_LenCntr	<=	UDPPDUGen_LenCntr + 1;
						UDPPDUgenFSM_State	<=	EmitUDPPDU;
					end if;
				when others => --INIT
				-- when INIT =>
					UDPPDUGen_Status		<=	"00";
					UDPPDUGen_SRCIPaddrOut	<=	Address;
					UDPPDUGen_DSTIPaddrOut	<=	Data_Hi;
					UDPPDUGen_SrcPort_Out	<=	Data_Lo(31 DOWNTO 16);
					UDPPDUGen_DstPort_Out	<=	Data_Lo(15 DOWNTO 0);
					UDPPDUGen_LenOut		<=	Data_Misc(15 DOWNTO 0);
					UDPPDUGen_Out_ErrOut	<=	Lo;
					UDPPDUGen_Out_Ind		<=	Lo;
					UDPPDUGen_Out_EOP		<=	Lo;
					UDPPDUGen_Out_SOP		<=	Lo;
					UDPPDUGen_DOUTV		<=	Lo;
					UDPPDUGen_IPGR			<=	Lo;
					UDPPDUGen_DOUT			<=	(others => Lo);
					UDPPDUGen_LenCntr		<=	X"0002";
					UDPPDUgenFSM_State		<=	IDLE;
			end case;
		end if;
	end if;
end process UDPPDUgenFSM_proc;

	UDP_RST		<=	RST;
	UDP_CE		<=	CE;
	UDP_CFG_CE	<=	CE;
	-- UDP_WR_EN		<=	Write_aggregate(CFGAddr_UDPLayer)	:=	(others => Lo);
	-- UDP_RD_EN		<=	Read_aggregate(CFGAddr_UDPLayer)	:=	(others => Lo);
	-- UDP_ADDR		<=	Address(UDP_AddrWidth-1 DOWNTO 0);
	-- UDP_DATA_IN	<=	Data_Lo(UDP_DataWidth-1 DOWNTO 0);
	
	-- UDP_DstIPAddr_In	<=	UDPPDUGen_DSTIPaddrOut;
	-- UDP_SrcIPAddr_In	<=	UDPPDUGen_SRCIPaddrOut;
	-- UDP_DstPort_In		<=	UDPPDUGen_DstPort_Out;
	-- UDP_SrcPort_In		<=	UDPPDUGen_SrcPort_Out;
	-- UDP_Length_In		<=	UDPPDUGen_LenOut;
	-- UDP_SDU_DIN		<=	UDPPDUGen_DOUT;
	-- UDP_SDU_DINV		<=	UDPPDUGen_DOUTV;
	-- UDP_SDU_IN_SOP		<=	UDPPDUGen_Out_SOP;
	-- UDP_SDU_IN_EOP		<=	UDPPDUGen_Out_EOP;
	-- UDP_SDU_IN_Ind		<=	UDPPDUGen_Out_Ind;
	-- UDP_SDU_IN_ErrIn	<=	Lo;
	
	UDP_DstIPAddr_In	<=	SNMP_DstIPAddr_Out;
	UDP_SrcIPAddr_In	<=	SNMP_SrcIPAddr_Out;
	UDP_SrcPort_In		<=	SNMP_SrcPort_Out;
	UDP_DstPort_In		<=	SNMP_DstPort_Out;
	UDP_Length_In		<=	SNMP_Length_Out;
	UDP_SDU_DIN		<=	SNMP_PDU_DOUT;
	UDP_SDU_DINV		<=	SNMP_PDU_DOUTV;
	UDP_SDU_IN_SOP		<=	SNMP_PDU_OUT_SOP;
	UDP_SDU_IN_EOP		<=	SNMP_PDU_OUT_EOP;
	UDP_SDU_IN_Ind		<=	SNMP_PDU_OUT_INd;
	UDP_SDU_IN_ErrIn	<=	SNMP_PDU_OUT_ErrOUT;
	SNMP_PDU_OUT_Ack	<=	UDP_SDU_IN_Ack;
	SNMP_PDU_OUT_ErrIN	<=	UDP_SDU_IN_ErrOut;

	UDP_IP_DstIPAddr_In	<=	IP_DstIPAddr_Out;
	UDP_IP_SrcIPAddr_In	<=	IP_SrcIPAddr_Out;
	UDP_IP_Proto_In	<=	IP_Prot_Out;
	UDP_IP_Length_In	<=	IP_Length_Out;
	UDP_PDU_DIN		<=	IP_SDU_DOUT;
	UDP_PDU_DINV		<=	IP_SDU_DOUTV;
	UDP_PDU_IN_SOP		<=	IP_SDU_Out_SOP;
	UDP_PDU_IN_EOP		<=	IP_SDU_Out_EOP;
	UDP_PDU_IN_Ind		<=	IP_SDU_OUT_Ind;
	UDP_PDU_IN_ErrIn	<=	IP_SDU_OUT_ErrOut;
	IP_SDU_OUT_Ack		<=	UDP_PDU_IN_Ack;
	IP_SDU_OUT_ErrIn	<=	UDP_PDU_IN_ErrOut;

	UDPDO_reg	:	aRegister	generic map(Size =>	UDP_DataWidth)	port map(D=>UDP_DATA_OUT,C=>CLK,CE=>UDP_DOUTV,Q=>UDP_DATA_OUT_reg);
	
	UDP_DATA_IN_sig	<=	UDP_WR_ValidPort & UDP_WR_Port;
	
	UDPLayer_inst: UDPLayer 
	Generic Map(
		DataWidth			=>		8,
		RX_SYNC_IN		=>		false,
		RX_SYNC_OUT		=>		false,
		-- TX_SYNC_IN		=>		true, Just in Sync mode
		TX_SYNC_OUT		=>		true, --must be true due to IPLayer
		NumOfUDPPorts		=>		NumOfUDPPorts,
		PDUToQueue		=>		DefPDUToQ
	)
	PORT MAP (
			CLK				=>	CLK,
			RST				=>	UDP_RST,
			CE				=>	UDP_CE,
			CFG_CE			=>	UDP_CFG_CE,
			-------------------------------------
			WR_EN			=>	UDP_WR_EN,
			RD_EN			=>	UDP_RD_EN,
			ADDR				=>	UDP_ADDR,
			DATA_IN			=>	UDP_DATA_IN,
			DATA_OUT			=>	UDP_DATA_OUT,
			DOUTV			=>	UDP_DOUTV,
			-------------------------------------
			IP_DstIPAddr_In	=>	UDP_IP_DstIPAddr_In,
			IP_SrcIPAddr_In	=>	UDP_IP_SrcIPAddr_In,
			IP_Proto_In		=>	UDP_IP_Proto_In,
			IP_Length_In		=>	UDP_IP_Length_In,
			-------------------------------------
			IP_DstIPAddr_Out	=>	UDP_IP_DstIPAddr_Out,
			IP_SrcIPAddr_Out	=>	UDP_IP_SrcIPAddr_Out,
			IP_Proto_Out		=>	UDP_IP_Proto_Out,
			IP_Length_Out		=>	UDP_IP_Length_Out,
			-------------------------------------
			DstIPAddr_In		=>	UDP_DstIPAddr_In,
			SrcIPAddr_In		=>	UDP_SrcIPAddr_In,
			DstPort_In		=>	UDP_DstPort_In,
			SrcPort_In		=>	UDP_SrcPort_In,
			Length_In			=>	UDP_Length_In,
			DstIPAddr_Out		=>	UDP_DstIPAddr_Out,
			SrcIPAddr_Out		=>	UDP_SrcIPAddr_Out,
			DstPort_Out		=>	UDP_DstPort_Out,
			SrcPort_Out		=>	UDP_SrcPort_Out,
			Length_Out		=>	UDP_Length_Out,
			-------------------------------------
			SDU_DIN			=>	UDP_SDU_DIN,
			SDU_DINV			=>	UDP_SDU_DINV,
			SDU_IN_SOP		=>	UDP_SDU_IN_SOP,
			SDU_IN_EOP		=>	UDP_SDU_IN_EOP,
			SDU_IN_Ind		=>	UDP_SDU_IN_Ind,
			SDU_IN_ErrIn		=>	UDP_SDU_IN_ErrIn,
			SDU_IN_USER_In		=>	UDP_SDU_IN_USER_In,
			SDU_IN_Ack		=>	UDP_SDU_IN_Ack,
			SDU_IN_ErrOut		=>	UDP_SDU_IN_ErrOut,
			PDU_DOUT			=>	UDP_PDU_DOUT,
			-------------------------------------
			PDU_DOUTV			=>	UDP_PDU_DOUTV,
			PDU_Out_SOP		=>	UDP_PDU_Out_SOP,
			PDU_Out_EOP		=>	UDP_PDU_Out_EOP,
			PDU_Out_Ind		=>	UDP_PDU_Out_Ind,
			PDU_Out_ErrOut		=>	UDP_PDU_Out_ErrOut,
			PDU_Out_USER_Out	=>	UDP_PDU_Out_USER_Out,
			PDU_Out_Ack		=>	UDP_PDU_Out_Ack,
			PDU_Out_ErrIn		=>	UDP_PDU_Out_ErrIn,
			-------------------------------------
			PDU_DIN			=>	UDP_PDU_DIN,
			PDU_DINV			=>	UDP_PDU_DINV,
			PDU_IN_SOP		=>	UDP_PDU_IN_SOP,
			PDU_IN_EOP		=>	UDP_PDU_IN_EOP,
			PDU_IN_Ind		=>	UDP_PDU_IN_Ind,
			PDU_IN_USER_In		=>	UDP_PDU_IN_USER_In,
			PDU_IN_ErrIn		=>	UDP_PDU_IN_ErrIn,
			PDU_IN_ErrOut		=>	UDP_PDU_IN_ErrOut,
			PDU_IN_Ack		=>	UDP_PDU_IN_Ack,
			-------------------------------------
			SDU_DOUT			=>	UDP_SDU_DOUT,
			SDU_DOUTV			=>	UDP_SDU_DOUTV,
			SDU_Out_SOP		=>	UDP_SDU_Out_SOP,
			SDU_OUT_EOP		=>	UDP_SDU_OUT_EOP,
			SDU_OUT_Ind		=>	UDP_SDU_OUT_Ind,
			SDU_OUT_USER_Out	=>	UDP_SDU_OUT_USER_Out,
			SDU_OUT_ErrOut		=>	UDP_SDU_OUT_ErrOut,
			SDU_OUT_ErrIn		=>	UDP_SDU_OUT_ErrIn,
			SDU_OUT_Ack		=>	UDP_SDU_OUT_Ack,
			Status			=>	UDP_Status
		 );
	
	-- SNMP_CE				<=	CE;
	SNMP_CFG_CE			<=	CE;
	SNMP_RST				<=	RST;
	SNMP_LinkStatusIn(0)	<=	MAC_0_LOS;
	SNMP_LinkStatusIn(1)	<=	MAC_1_LOS;

	SNMPModule_inst: SNMPModule
	GENERIC MAP(
		DataWidth		=>	8,
		CLK_freq		=>	125.0,
		TX_SYNC		=>	true,
		NumOfEvents	=>	NumOfSNMPEvents, --max 255, transferred in specific trap
		NumOfLinks	=>	NumOfLinks --max 255
	)
	PORT MAP (
			CLK			=>	CLK,
			CE			=>	SNMP_CE,
			CFG_CE		=>	SNMP_CFG_CE,
			RST			=>	SNMP_RST,
			DstIPAddr_In	=>	SNMP_DstIPAddr_In,
			SrcIPAddr_In	=>	SNMP_SrcIPAddr_In,
			DstPort_In	=>	SNMP_DstPort_In,
			SrcPort_In	=>	SNMP_SrcPort_In,
			Length_In		=>	SNMP_Length_In,
			DstIPAddr_Out	=>	SNMP_DstIPAddr_Out,
			SrcIPAddr_Out	=>	SNMP_SrcIPAddr_Out,
			DstPort_Out	=>	SNMP_DstPort_Out,
			SrcPort_Out	=>	SNMP_SrcPort_Out,
			Length_Out	=>	SNMP_Length_Out,
			PDU_DIN		=>	SNMP_PDU_DIN,
			PDU_DINV		=>	SNMP_PDU_DINV,
			PDU_IN_SOP	=>	SNMP_PDU_IN_SOP,
			PDU_IN_EOP	=>	SNMP_PDU_IN_EOP,
			PDU_IN_INd	=>	SNMP_PDU_IN_INd,
			PDU_IN_ErrOUT	=>	SNMP_PDU_IN_ErrOUT,
			PDU_IN_Ack	=>	SNMP_PDU_IN_Ack,
			PDU_IN_ErrIN	=>	SNMP_PDU_IN_ErrIN,
			PDU_DOUT		=>	SNMP_PDU_DOUT,
			PDU_DOUTV		=>	SNMP_PDU_DOUTV,
			PDU_OUT_SOP	=>	SNMP_PDU_OUT_SOP,
			PDU_OUT_EOP	=>	SNMP_PDU_OUT_EOP,
			PDU_OUT_INd	=>	SNMP_PDU_OUT_INd,
			PDU_OUT_ErrOUT	=>	SNMP_PDU_OUT_ErrOUT,
			PDU_OUT_Ack	=>	SNMP_PDU_OUT_Ack,
			PDU_OUT_ErrIN	=>	SNMP_PDU_OUT_ErrIN,
			WR_EN		=>	SNMP_WR_EN,
			RD_EN		=>	SNMP_RD_EN,
			CFG_ADDR		=>	SNMP_CFG_ADDR,
			DATA_IN		=>	SNMP_DATA_IN,
			RD_DV		=>	SNMP_RD_DV,
			DATA_OUT		=>	SNMP_DATA_OUT,
			EventIN		=>	SNMP_EventIN,
			LinkStatusIn	=>	SNMP_LinkStatusIn
		);

		-- MAC_0_DIN	<=	MAC_0_DOUT;
		-- MAC_0_DAV	<=	MAC_0_DOUTV;
		-- MAC_0_SOF	<=	MAC_0_Out_SOP;
		-- MAC_0_EOF	<=	MAC_0_Out_EOP;
		-- MAC_0_Err	<=	MAC_0_Out_ErrOut;
		
		WITH LoopBackSel SELECT MAC_0_DIN	<=	MAC_0_DIN_sig WHEN Lo, MAC_0_DOUT		WHEN OTHERS;
		WITH LoopBackSel SELECT MAC_0_DAV	<=	MAC_0_DAV_sig WHEN Lo, MAC_0_DOUTV		WHEN OTHERS;
		WITH LoopBackSel SELECT MAC_0_SOF	<=	MAC_0_SOF_sig WHEN Lo, MAC_0_Out_SOP	WHEN OTHERS;
		WITH LoopBackSel SELECT MAC_0_EOF	<=	MAC_0_EOF_sig WHEN Lo, MAC_0_Out_EOP	WHEN OTHERS;
		WITH LoopBackSel SELECT MAC_0_Err	<=	MAC_0_Err_sig WHEN Lo, MAC_0_Out_ErrOut	WHEN OTHERS;
		
		WITH ManualARPSelect SELECT IP_ARP_DstMacAddr_sig		<=	IP_ARP_DstMacAddr	WHEN Lo, ARP_DST_MAC_addr_sig	WHEN OTHERS;
		WITH ManualARPSelect SELECT IP_ARP_ResponseErr_sig	<=	IP_ARP_ResponseErr	WHEN Lo, ARP_RESPONSE_ERR_sig	WHEN OTHERS;
		WITH ManualARPSelect SELECT IP_ARP_ResponseV_sig		<=	IP_ARP_ResponseV	WHEN Lo, ARP_RESPONSEV_sig	WHEN OTHERS;
		  
	-- Clock process definitions
	CLK_process :process
	begin
		CLK <= '1';
		wait for CLK_period/2;
		CLK <= '0';
		wait for CLK_period/2;
	end process;
 
	CFG_CE	<=	CE;
	-- Stimulus process
	stim_proc: process
	BEGIN
		WAIT_CLK(CLK_period,20);

		CFG_WRITE(CLK_period,0,0,X"0a0a000b",IP_CFG_ADDR,IP_CFGAWREN,IP_ADDR,IP_DATA_IN,IP_WREN);
		CFG_WRITE(CLK_period,1,0,X"FF000000",IP_CFG_ADDR,IP_CFGAWREN,IP_ADDR,IP_DATA_IN,IP_WREN);
		CFG_WRITE(CLK_period,9,0,X"00000001",IP_CFG_ADDR,IP_CFGAWREN,IP_ADDR,IP_DATA_IN,IP_WREN);
		CFG_WRITE(CLK_period,2,0,X"0a0a000b" or X"00FFFFFF",IP_CFG_ADDR,IP_CFGAWREN,IP_ADDR,IP_DATA_IN,IP_WREN);
		CFG_WRITE(CLK_period,7,0,X"0aFFFFFE",IP_CFG_ADDR,IP_CFGAWREN,IP_ADDR,IP_DATA_IN,IP_WREN);
		CFG_WRITE(CLK_period,0,4,X"0a0a000b" or X"00FFFFFF",IP_CFG_ADDR,IP_CFGAWREN,IP_ADDR,IP_DATA_IN,IP_WREN);
		CFG_WRITE(CLK_period,11,4,X"0a0a000b" or X"00FFFFFF",IP_CFG_ADDR,IP_CFGAWREN,IP_ADDR,IP_DATA_IN,IP_WREN);
		CFG_WRITE(CLK_period,12,0,X"00000011",IP_CFG_ADDR,IP_CFGAWREN,IP_ADDR,IP_DATA_IN,IP_WREN);
		CFG_WRITE(CLK_period,13,0,X"22334455",IP_CFG_ADDR,IP_CFGAWREN,IP_ADDR,IP_DATA_IN,IP_WREN);
		CFG_WRITE(CLK_period,14,0,X"22334455",IP_CFG_ADDR,IP_CFGAWREN,IP_ADDR,IP_DATA_IN,IP_WREN);
		CFG_WRITE(CLK_period, 8,0,X"00000040",IP_CFG_ADDR,IP_CFGAWREN,IP_ADDR,IP_DATA_IN,IP_WREN);
		-- WR_CAM(CLK_period,0,X"AC100002",ARP_IPADDR_WR_EN,ARP_ADDR,ARP_ADDR_DATA_IN(IpAddrSize-1 downto 0));
		WR_CAM(CLK_period,0,X"0a0a000b",ARP_IPADDR_WR_EN,ARP_ADDR,ARP_ADDR_DATA_IN(IpAddrSize-1 downto 0));
		WAIT_CLK(CLK_period,2);
		WR_CAM(CLK_period,0,X"001122334455",ARP_MACADDR_WR_EN,ARP_ADDR,ARP_ADDR_DATA_IN);
		WR_CAM(CLK_period,0,X"001122334455",ETH_WR_EN,ETH_ADDR,ETH_ADDR_DATA_IN);
		----
		-- UDP_DATA_IN_sig	<=	UDP_WR_ValidPort & UDP_WR_Port;
		UDP_WR_ValidPort	<=	Hi;
		UDP_WR_Port		<=	X"1988";
		WAIT_CLK(CLK_period,1);
		WR_CAM(CLK_period,0,UDP_DATA_IN_sig,UDP_WR_EN,UDP_ADDR,UDP_DATA_IN);
		UDP_WR_Port		<=	X"0521";
		WAIT_CLK(CLK_period,1);
		WR_CAM(CLK_period,1,UDP_DATA_IN_sig,UDP_WR_EN,UDP_ADDR,UDP_DATA_IN);
		UDP_WR_Port		<=	X"2222";
		WAIT_CLK(CLK_period,1);
		WR_CAM(CLK_period,2,UDP_DATA_IN_sig,UDP_WR_EN,UDP_ADDR,UDP_DATA_IN);
		UDP_WR_Port		<=	X"2222";
		WAIT_CLK(CLK_period,1);
		WR_CAM(CLK_period,2,UDP_DATA_IN_sig,UDP_WR_EN,UDP_ADDR,UDP_DATA_IN);
		
		CFG_WRITE(CLK_period,0,0,X"0a0a000b",SNMP_CFG_ADDR,SNMP_WR_EN,DummyAddr,SNMP_DATA_IN,SNMP_WR_EN);
		CFG_WRITE(CLK_period,1,1,X"0a0a000b",SNMP_CFG_ADDR,SNMP_WR_EN,DummyAddr,SNMP_DATA_IN,SNMP_WR_EN);
		CFG_WRITE(CLK_period,2,2,X"000000a2",SNMP_CFG_ADDR,SNMP_WR_EN,DummyAddr,SNMP_DATA_IN,SNMP_WR_EN);
		CFG_WRITE(CLK_period,3,3,X"00001988",SNMP_CFG_ADDR,SNMP_WR_EN,DummyAddr,SNMP_DATA_IN,SNMP_WR_EN);

		-----
		SNMP_CE			<=	Hi;
		User_IP_ARP_Select	<=	Hi;
		LoopBackSel		<=	Hi;
		ManualARPSelect	<=	Lo;
		ARP_DST_MAC_addr_sig	<=	X"001122334455";
		ARP_RESPONSE_ERR_sig	<=	Lo;
		ARP_RESPONSEV_sig		<=	Hi;
		SNMP_EventIN	<=	(OTHERS => Lo);
		WAIT_CLK(CLK_period,10);
		MAC_0_LOS		<=	Hi;
		MAC_1_LOS		<=	Hi;
		-- SNMP_EventIN	<=	(OTHERS => Hi);
		WAIT_CLK(CLK_period,10);
		MAC_0_LOS		<=	Lo;
		MAC_1_LOS		<=	Lo;
		WAIT_CLK(CLK_period,100);
		SNMP_EventIN	<=	X"00000003";
		WAIT_CLK(CLK_period,10);
		SNMP_EventIN	<=	(OTHERS => Lo);
		MAC_0_LOS		<=	Hi;
		MAC_1_LOS		<=	Hi;
		-- SNMP_EventIN	<=	(OTHERS => Hi);
		WAIT_CLK(CLK_period,10);
		MAC_0_LOS		<=	Lo;
		MAC_1_LOS		<=	Lo;
		WAIT_CLK(CLK_period,100);
		SNMP_EventIN	<=	X"0000000c";

		-- WAIT_CLK(CLK_period,10);
		-- Address	<=	X"0a0a000b";
		-- Data_Hi	<=	X"0a0a000b";
		-- Data_Lo	<=	X"11112222";
		-- Data_Misc	<=	X"000005c0";
		-- UDPPDUGenStart	<=	Hi;
		-- WAIT_CLK(CLK_period,1);
		-- -- UDPPDUGenStart	<=	Lo;
		-- WAIT_CLK(CLK_period,100);
		-- -- Emit_ETH_ARP_PDU(CLK_period ,X"001122334455",X"665544332211",ares_op_REP,X"0a0a000a",X"0a0a000b",MAC_0_DIN_sig,MAC_0_DAV_sig,MAC_0_SOF_sig,MAC_0_EOF_sig);
		-- Emit_ETH_ARP_PDU(CLK_period ,X"001122334455",X"001122334455",ares_op_REP,X"0a0a000b",X"0a0a000b",MAC_0_DIN_sig,MAC_0_DAV_sig,MAC_0_SOF_sig,MAC_0_EOF_sig);
		-- WAIT_CLK(CLK_period,10);
				-- ManualARPSelect	<=	Hi;
		-- -- ARP_DST_MAC_addr_sig	<=	X"001122334455";
		-- ARP_RESPONSE_ERR_sig	<=	Hi;
		-- -- ARP_RESPONSEV_sig		<=	Hi;
		-- LoopBackSel	<=	Hi;

		wait;
	end process;

RSTer: Resetter PORT MAP(CLK,RST,CE);
END;
