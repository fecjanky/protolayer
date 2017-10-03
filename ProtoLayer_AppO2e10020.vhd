--
-- AppO2E10000.VHD
-- ============
--
-- (C) Gabor Krodi, AITIA, 2005..2010
--
-- Gigabit Applications for GPLANAR1 PCI Express x4 adapter
-- with a Virtex-5 FPGA (xc5vlx50t-1-ff1136 )
-- SGA Monitor application
--
-- Created:  2010.05.01    - G.K. Ported from I1000102.VHD
--
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_UNSIGNED.all;
USE work.ProtoLayerTypesAndDefs.all;
-- --
--      ====
PACKAGE apps IS
--      ====
--        ========
COMPONENT O2E10020
--        ========
PORT (
	MacClk			: IN		STD_LOGIC;      -- mac clock
	TestO			: OUT	STD_LOGIC_VECTOR ( 31 DOWNTO 0 );
	----------------------------------------
	MAC_Reset			: OUT	STD_LOGIC;
	--	Ethernet "A" downstream
	MAC_0_SYNCH		: IN		STD_LOGIC; --Los of
	MAC_0_SOF			: IN		STD_LOGIC;
	MAC_0_EOF			: IN		STD_LOGIC;
	MAC_0_DAV			: IN		STD_LOGIC; --DV
	MAC_0_GOODF		: IN		STD_LOGIC; -- Opposite of badframe
	MAC_0_BADF		: IN		STD_LOGIC; --BAD CRC
	MAC_0_DROPF		: IN		STD_LOGIC; -- LOW
	MAC_0_LOS			: IN		STD_LOGIC; -- LOW
	MAC_0_DIN			: IN		STD_LOGIC_VECTOR(07 DOWNTO 0); --DATA IN
	MAC_0_LENGTH		: IN		STD_LOGIC_VECTOR(31 DOWNTO 0); -- others LOW
	MAC_0_Err			: In		STD_LOGIC;
	--	Ethernet "A" upstream
	MAC_0_DOUT		: OUT	STD_LOGIC_VECTOR(07 DOWNTO 0);
	MAC_0_DOUTV		: OUT	STD_LOGIC;
	--	Ethernet "B" downstream
	MAC_1_SYNCH		: IN		STD_LOGIC;
	MAC_1_SOF			: IN		STD_LOGIC;
	MAC_1_EOF			: IN		STD_LOGIC;
	MAC_1_DAV			: IN		STD_LOGIC;
	MAC_1_GOODF		: IN		STD_LOGIC;
	MAC_1_BADF		: IN		STD_LOGIC;
	MAC_1_DROPF		: IN		STD_LOGIC;
	MAC_1_LOS			: IN		STD_LOGIC;
	MAC_1_DIN			: IN		STD_LOGIC_VECTOR(07 DOWNTO 0);
	MAC_1_LENGTH		: IN		STD_LOGIC_VECTOR(31 DOWNTO 0);
	MAC_1_Err			: In		STD_LOGIC;
	--	Ethernet "B" upstream
	MAC_1_DOUT		: OUT	STD_LOGIC_VECTOR(07 DOWNTO 0);
	MAC_1_DOUTV		: OUT	STD_LOGIC;
	-- Debug
	DebugReg			: IN		STD_LOGIC_VECTOR(31 DOWNTO 0);
	TestVector		: OUT	STD_LOGIC_VECTOR ( 07 DOWNTO 0 )
);
END COMPONENT;
--
END PACKAGE apps;
--
-- ====================
PACKAGE BODY apps IS
-- ====================
--
--
END PACKAGE BODY apps;
--
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;
USE IEEE.numeric_std.ALL;
USE IEEE.MATH_REAL.ALL;

USE work.arch.all;
use work.EthernetLayerPkg.EthernetLayer;
use work.ARPModulePkg.ARPModule;
use work.IPLayerPkg.IPLayer;
USE work.ProtoLayerTypesAndDefs.all;
use work.css_pkg.csipszkop_vio;
use work.ProtoModulePkg.End_Arbitrator_2;
use work.ProtoModulePkg.EthLayer_Arbitrator_2;
use work.UDPLayerPkg.UDPLayer;
use work.SNMPModulePkg.SNMPModule;


--
--     ========
ENTITY O2E10020 IS
--     ========
PORT (
	MacClk			: IN		STD_LOGIC;      -- mac clock
	TestO			: OUT	STD_LOGIC_VECTOR ( 31 DOWNTO 0 );
	----------------------------------------
	MAC_Reset			: OUT	STD_LOGIC;
	--	Ethernet "A" downstream
	MAC_0_SYNCH		: IN		STD_LOGIC; --Los of
	MAC_0_SOF			: IN		STD_LOGIC;
	MAC_0_EOF			: IN		STD_LOGIC;
	MAC_0_DAV			: IN		STD_LOGIC; --DV
	MAC_0_GOODF		: IN		STD_LOGIC; -- Opposite of badframe
	MAC_0_BADF		: IN		STD_LOGIC; --BAD CRC
	MAC_0_DROPF		: IN		STD_LOGIC; -- LOW
	MAC_0_LOS			: IN		STD_LOGIC; -- LOW
	MAC_0_DIN			: IN		STD_LOGIC_VECTOR(07 DOWNTO 0); --DATA IN
	MAC_0_LENGTH		: IN		STD_LOGIC_VECTOR(31 DOWNTO 0); -- others LOW
	MAC_0_Err			: In		STD_LOGIC;
	--	Ethernet "A" upstream
	MAC_0_DOUT		: OUT	STD_LOGIC_VECTOR(07 DOWNTO 0);
	MAC_0_DOUTV		: OUT	STD_LOGIC;
	--	Ethernet "B" downstream
	MAC_1_SYNCH		: IN		STD_LOGIC;
	MAC_1_SOF			: IN		STD_LOGIC;
	MAC_1_EOF			: IN		STD_LOGIC;
	MAC_1_DAV			: IN		STD_LOGIC;
	MAC_1_GOODF		: IN		STD_LOGIC;
	MAC_1_BADF		: IN		STD_LOGIC;
	MAC_1_DROPF		: IN		STD_LOGIC;
	MAC_1_LOS			: IN		STD_LOGIC;
	MAC_1_DIN			: IN		STD_LOGIC_VECTOR(07 DOWNTO 0);
	MAC_1_LENGTH		: IN		STD_LOGIC_VECTOR(31 DOWNTO 0);
	MAC_1_Err			: In		STD_LOGIC;
	--	Ethernet "B" upstream
	MAC_1_DOUT		: OUT	STD_LOGIC_VECTOR(07 DOWNTO 0);
	MAC_1_DOUTV		: OUT	STD_LOGIC;
	-- Debug
	DebugReg			: IN		STD_LOGIC_VECTOR(31 DOWNTO 0);
	TestVector		: OUT	STD_LOGIC_VECTOR ( 07 DOWNTO 0 )
);
END O2E10020;
--
-- Buildig blocks
--
-- =====================================================================
ARCHITECTURE Application OF O2E10020 IS -- =============================
-- =====================================================================
-- DMA to host
	SIGNAL AppCSR				: STD_LOGIC_VECTOR( 31 DOWNTO 0);
	SIGNAL AppTEST				: STD_LOGIC_VECTOR( 31 DOWNTO 0);
--===========================
--	ProtoLayer signals
--===========================
--
--
--
signal	RESET_aggregate		:		std_logic_vector(31 DOWNTO 0);
signal	Enable_aggregate		:		std_logic_vector(31 DOWNTO 0);
signal	SDU_DCntr				:		std_logic_vector(31 DOWNTO 0);
signal	SDU_DCntr_sig			:		std_logic_vector(31 DOWNTO 0);
signal	RESET_ETHLayer_0		:		std_logic;
signal	RESET_ETHLayer_1		:		std_logic;
signal	En_ETHLayer_0			:		std_logic;
signal	En_ETHLayer_1			:		std_logic;
signal	RESET_PGen			:		std_logic;
signal	SDU_DIN				:		std_logic_vector(7 DOWNTO 0);
signal	SDU_DOUT				:		std_logic_vector(7 DOWNTO 0);
signal	MAC_0_DOUT_sig			:		std_logic_vector(7 DOWNTO 0);
signal	MAC_0_DOUTV_sig		:		std_logic;
signal	MAC_1_DOUT_sig			:		std_logic_vector(7 DOWNTO 0);
signal	MAC_1_DOUTV_sig		:		std_logic;
signal	MAC_RESET_sig			:		std_logic;
signal	SDU_Complete			:		std_logic;
signal	SDU_DINV				:		std_logic;
signal	SDU_DOUTV				:		std_logic;
signal	SDU_In_SOP			:		std_logic;
signal	SDU_Out_SOP			:		std_logic;
signal	SDU_In_EOP			:		std_logic;
signal	SDU_Out_EOP			:		std_logic;
signal	SDU_OUT_Ind			:		std_logic;
signal	SDU_OUT_Ack			:		std_logic;
signal	PDU_Out_Ind			:		std_logic;
signal	PDU_Out_Ack			:		std_logic;
signal	PDU_Out_SOP			:		std_logic;
signal	PDU_Out_EOP			:		std_logic;


signal	ETHLayer_0_EType_In		:	std_logic_vector(15 DOWNTO 0);
signal	ETHLayer_0_EType_Out	:	std_logic_vector(15 DOWNTO 0);
signal	ETHLayer_0_DstMacAddr_In	:	std_logic_vector(47 DOWNTO 0);
signal	ETHLayer_0_DstMacAddr_Out:	std_logic_vector(47 DOWNTO 0);
signal	ETHLayer_0_SrcMacAddr_In	:	std_logic_vector(47 DOWNTO 0);
signal	ETHLayer_0_SrcMacAddr_Out:	std_logic_vector(47 DOWNTO 0);

signal	ETHLayer_1_EType_In			:	std_logic_vector(15 DOWNTO 0);
signal	ETHLayer_1_EType_Out		:	std_logic_vector(15 DOWNTO 0);
signal	ETHLayer_1_DstMacAddr_In		:	std_logic_vector(47 DOWNTO 0);
signal	ETHLayer_1_DstMacAddr_Out	:	std_logic_vector(47 DOWNTO 0);
signal	ETHLayer_1_SrcMacAddr_In		:	std_logic_vector(47 DOWNTO 0);
signal	ETHLayer_1_SrcMacAddr_Out	:	std_logic_vector(47 DOWNTO 0);

signal	ETHLayer_0_PDU_DOUT			:	std_logic_vector(7 DOWNTO 0);
signal	ETHLayer_0_PDU_DOUTV		:	std_logic;
signal	ETHLayer_0_PDU_Out_SOP		:	std_logic;
signal	ETHLayer_0_PDU_Out_EOP		:	std_logic;
signal	ETHLayer_0_PDU_Out_Ind		:	std_logic;
signal	ETHLayer_0_PDU_Out_Ack		:	std_logic;
signal	ETHLayer_0_PDU_Out_ErrOut	:	std_logic;
signal	ETHLayer_0_PDU_DIN			:	std_logic_vector(7 DOWNTO 0);
signal	ETHLayer_0_PDU_DINV			:	std_logic;
signal	ETHLayer_0_PDU_In_SOP		:	std_logic;
signal	ETHLayer_0_PDU_In_EOP		:	std_logic;
signal	ETHLayer_0_PDU_In_ErrIn		:	std_logic;
signal	ETHLayer_0_SDU_DIN			:	std_logic_vector(7 DOWNTO 0);
signal	ETHLayer_0_SDU_DINV			:	std_logic;
signal	ETHLayer_0_SDU_In_SOP		:	std_logic;
signal	ETHLayer_0_SDU_In_EOP		:	std_logic;
signal	ETHLayer_0_SDU_In_Ind		:	std_logic;
signal	ETHLayer_0_SDU_In_Ack		:	std_logic;
signal	ETHLayer_0_SDU_In_ErrOut		:	std_logic;
signal	ETHLayer_0_SDU_In_ErrIn		:	std_logic;
signal	ETHLayer_0_SDU_DOUT			:	std_logic_vector(7 DOWNTO 0);
signal	ETHLayer_0_SDU_DOUTV		:	std_logic;
signal	ETHLayer_0_SDU_Out_SOP		:	std_logic;
signal	ETHLayer_0_SDU_Out_EOP		:	std_logic;
signal	ETHLayer_0_SDU_Out_Ind		:	std_logic;
signal	ETHLayer_0_SDU_Out_Ack		:	std_logic;
signal	ETHLayer_0_SDU_Out_ErrOut	:	std_logic;
signal	ETHLayer_0_SDU_Out_ErrIn		:	std_logic;

signal	ETHLayer_1_PDU_DOUT			:	std_logic_vector(7 DOWNTO 0);
signal	ETHLayer_1_PDU_DOUTV		:	std_logic;
signal	ETHLayer_1_PDU_Out_SOP		:	std_logic;
signal	ETHLayer_1_PDU_Out_EOP		:	std_logic;
signal	ETHLayer_1_PDU_Out_Ind		:	std_logic;
signal	ETHLayer_1_PDU_Out_Ack		:	std_logic;
signal	ETHLayer_1_PDU_Out_ErrOut	:	std_logic;
signal	ETHLayer_1_PDU_DIN			:	std_logic_vector(7 DOWNTO 0);
signal	ETHLayer_1_PDU_DINV			:	std_logic;
signal	ETHLayer_1_PDU_In_SOP		:	std_logic;
signal	ETHLayer_1_PDU_In_EOP		:	std_logic;
signal	ETHLayer_1_PDU_In_ErrIn		:	std_logic;
signal	ETHLayer_1_SDU_DIN			:	std_logic_vector(7 DOWNTO 0);
signal	ETHLayer_1_SDU_DINV			:	std_logic;
signal	ETHLayer_1_SDU_In_SOP		:	std_logic;
signal	ETHLayer_1_SDU_In_EOP		:	std_logic;
signal	ETHLayer_1_SDU_In_Ind		:	std_logic;
signal	ETHLayer_1_SDU_In_Ack		:	std_logic;
signal	ETHLayer_1_SDU_In_ErrOut		:	std_logic;
signal	ETHLayer_1_SDU_In_ErrIn		:	std_logic;
signal	ETHLayer_1_SDU_DOUT			:	std_logic_vector(7 DOWNTO 0);
signal	ETHLayer_1_SDU_DOUTV		:	std_logic;
signal	ETHLayer_1_SDU_Out_SOP		:	std_logic;
signal	ETHLayer_1_SDU_Out_EOP		:	std_logic;
signal	ETHLayer_1_SDU_Out_Ind		:	std_logic;
signal	ETHLayer_1_SDU_Out_Ack		:	std_logic;
signal	ETHLayer_1_SDU_Out_ErrOut	:	std_logic;
signal	ETHLayer_1_SDU_Out_ErrIn		:	std_logic;

signal	RESET_Arbitrator			:	std_logic;


signal	ARP_PDU_DOUT			:	std_logic_vector(7 DOWNTO 0);
signal	ARP_PDU_DOUTV			:	std_logic;
signal	ARP_PDU_DIN			:	std_logic_vector(7 DOWNTO 0);
signal	ARP_PDU_DINV			:	std_logic;
signal	ARP_PDU_In_SOP			:	std_logic;
signal	ARP_PDU_Out_SOP		:	std_logic;
signal	ARP_PDU_In_EOP			:	std_logic;
signal	ARP_PDU_Out_EOP		:	std_logic;
signal	ARP_PDU_Out_Ind		:	std_logic;
signal	ARP_PDU_Out_Ack		:	std_logic;
signal	ARP_PDU_In_Ind			:	std_logic;
signal	ARP_PDU_In_Ack			:	std_logic;
signal	ARP_PDU_Out_ErrOut		:	std_logic;
signal	ARP_PDU_Out_ErrIn		:	std_logic;
signal	ARP_PDU_In_ErrOut		:	std_logic;
signal	ARP_PDU_In_ErrIn		:	std_logic;
signal	ARP_DST_MacAddr_Out		:	std_logic_vector(47 DOWNTO 0);
signal	ARP_SRC_MacAddr_Out		:	std_logic_vector(47 DOWNTO 0);
signal	ARP_EType_Out			:	std_logic_vector(15 DOWNTO 0);
signal	ARP_DST_MacAddr_In		:	std_logic_vector(47 DOWNTO 0);
signal	ARP_SRC_MacAddr_In		:	std_logic_vector(47 DOWNTO 0);
signal	ARP_EType_In			:	std_logic_vector(15 DOWNTO 0);

signal	RESET_ARP				:	std_logic;
signal	EN_ARP				:	std_logic;
signal	ARP_ReqUest			:	std_logic;
signal	ARP_DST_IP_addr		:	std_logic_vector(31 DOWNTO 0);
signal	ARP_DST_MAC_addr		:	std_logic_vector(47 DOWNTO 0);
signal	ARP_RESPONSEV			:	std_logic;
signal	ARP_RESPONSE_ERR		:	std_logic;
signal	ARP_IPADDR_WR_EN		:	std_logic;
signal	ARP_MACADDR_WR_EN		:	std_logic;
signal	ARP_IPADDR_RD_EN		:	std_logic;
signal	ARP_MACADDR_RD_EN		:	std_logic;
signal	ARP_ADDR				:	std_logic_vector(1 DOWNTO 0);
signal	ARP_ADDR_DATA_IN		:	std_logic_vector(47 DOWNTO 0);
signal	ARP_IPADDR_DATA_OUT		:	std_logic_vector(31 DOWNTO 0);
signal	ARP_IPADDR_DATA_OUT_reg	:	std_logic_vector(31 DOWNTO 0);
signal	ARP_MACADDR_DATA_OUT	:	std_logic_vector(47 DOWNTO 0);
signal	ARP_MACADDR_DATA_OUT_reg	:	std_logic_vector(47 DOWNTO 0);
signal	ARP_MACADDR_DOUT_reg_Hi	:	std_logic_vector(31 DOWNTO 0);
signal	ARP_MACADDR_DOUT_reg_Lo	:	std_logic_vector(31 DOWNTO 0);
signal	ARP_IPADDR_DV			:	std_logic;
signal	ARP_MACADDR_DV			:	std_logic;

signal	Address				:	std_logic_vector(31 DOWNTO 0);
signal	Data_Lo				:	std_logic_vector(31 DOWNTO 0);
signal	Data_Hi				:	std_logic_vector(31 DOWNTO 0);
signal	Data_Misc				:	std_logic_vector(31 DOWNTO 0);
signal	Write_aggregate		:	std_logic_vector(31 DOWNTO 0);
signal	Read_aggregate			:	std_logic_vector(31 DOWNTO 0);
signal	Control_aggregate		:	std_logic_vector(31 DOWNTO 0);


signal	ETH_WR_En				:	std_logic;
signal	ETH_RD_En				:	std_logic;
signal	ETH_Addr				:	std_logic_vector(1 DOWNTO 0);
signal	ETH_ADDR_DV			:	std_logic;
signal	ETH_ADDR_DATA_IN		:	std_logic_vector(47 DOWNTO 0);
signal	ETH_ADDR_DATA_OUT		:	std_logic_vector(47 DOWNTO 0);
signal	ETH_ADDR_DATA_OUT_reg	:	std_logic_vector(47 DOWNTO 0);
signal	ETH_ADDR_DATA_OUT_reg_Hi	:	std_logic_vector(31 DOWNTO 0);
signal	ETH_ADDR_DATA_OUT_reg_Lo	:	std_logic_vector(31 DOWNTO 0);

signal	EN_Arbitrator			:	std_logic;
--------
--IPLayer jelek
-------
signal	RESET_IPLayer			:	std_logic;
signal	EN_IPLayer			:	std_logic;
signal	EN_IPLayerCFG			:	std_logic;
signal	IP_WREN				:	std_logic;
signal	IP_RDEN				:	std_logic;
signal	IP_CFGAWREN			:	std_logic;
signal	IP_CFG_ADDR			:	std_logic_vector(3 DOWNTO 0);
signal	IP_Addr				:	std_logic_vector(2 DOWNTO 0);
signal	IP_Data_In			:	std_logic_vector(31 DOWNTO 0);
signal	IP_Data_Out			:	std_logic_vector(31 DOWNTO 0);
signal	IP_Data_Out_reg		:	std_logic_vector(31 DOWNTO 0);
signal	IP_DoutV				:	std_logic;
signal	IP_ARP_Request			:	std_logic;
signal	IP_ARP_DSTIPAddr		:	std_logic_vector(31 DOWNTO 0);
signal	IP_ARP_ResponseV		:	std_logic;
signal	IP_ARP_ResponseErr		:	std_logic;
signal	IP_ARP_DstMacAddr		:	std_logic_vector(47 DOWNTO 0);
signal	IP_DstIPAddr_In		:	std_logic_vector(31 DOWNTO 0);
signal	IP_SrcIPAddr_In		:	std_logic_vector(31 DOWNTO 0);
signal	IP_Prot_In			:	std_logic_vector(7 DOWNTO 0);
signal	IP_Length_In			:	std_logic_vector(15 DOWNTO 0);
signal	IP_DstIPAddr_Out		:	std_logic_vector(31 DOWNTO 0);
signal	IP_SrcIPAddr_Out		:	std_logic_vector(31 DOWNTO 0);
signal	IP_Prot_Out			:	std_logic_vector(7 DOWNTO 0);
signal	IP_Length_Out			:	std_logic_vector(15 DOWNTO 0);
signal	IP_DstMacAddr_In		:	std_logic_vector(47 DOWNTO 0);
signal	IP_SrcMacAddr_In		:	std_logic_vector(47 DOWNTO 0);
signal	IP_EthType_In			:	std_logic_vector(15 DOWNTO 0);
signal	IP_DstMacAddr_Out		:	std_logic_vector(47 DOWNTO 0);
signal	IP_SrcMacAddr_Out		:	std_logic_vector(47 DOWNTO 0);
signal	IP_EthType_Out			:	std_logic_vector(15 DOWNTO 0);
signal	IP_SDU_DIN			:	std_logic_vector(7 DOWNTO 0);
signal	IP_SDU_DINV			:	std_logic;
signal	IP_SDU_IN_SOP			:	std_logic;
signal	IP_SDU_IN_EOP			:	std_logic;
signal	IP_SDU_IN_Ind			:	std_logic;
signal	IP_SDU_IN_ErrIn		:	std_logic;
signal	IP_SDU_IN_Ack			:	std_logic;
signal	IP_SDU_IN_ErrOut		:	std_logic;
signal	IP_PDU_DOUT			:	std_logic_vector(7 DOWNTO 0);
signal	IP_PDU_DOUTV			:	std_logic;
signal	IP_PDU_Out_SOP			:	std_logic;
signal	IP_PDU_Out_EOP			:	std_logic;
signal	IP_PDU_Out_Ind			:	std_logic;
signal	IP_PDU_Out_ErrOut		:	std_logic;
-- signal	IP_PDU_Out_USER_Out		:	std_logic;
signal	IP_PDU_Out_Ack			:	std_logic;
signal	IP_PDU_Out_ErrIn		:	std_logic;
signal	IP_PDU_DIN			:	std_logic_vector(7 DOWNTO 0);
signal	IP_PDU_DINV			:	std_logic;
signal	IP_PDU_IN_SOP			:	std_logic;
signal	IP_PDU_IN_EOP			:	std_logic;
signal	IP_PDU_IN_Ind			:	std_logic;
signal	IP_PDU_IN_ErrIn		:	std_logic;
signal	IP_PDU_IN_ErrOut		:	std_logic;
signal	IP_PDU_IN_Ack			:	std_logic;
signal	IP_SDU_DOUT			:	std_logic_vector(7 DOWNTO 0);
signal	IP_SDU_DOUTV			:	std_logic;
signal	IP_SDU_Out_SOP			:	std_logic;
signal	IP_SDU_OUT_EOP			:	std_logic;
signal	IP_SDU_OUT_Ind			:	std_logic;
signal	IP_SDU_OUT_ErrOut		:	std_logic;
signal	IP_SDU_OUT_ErrIn		:	std_logic;
signal	IP_SDU_OUT_Ack			:	std_logic;

signal	IP_Status				:	std_logic_vector(7 DOWNTO 0);

signal	User_ARP_ReqUest		:	std_logic;
signal	User_ARP_DST_IP_addr	:	std_logic_vector(31 DOWNTO 0);
signal	User_IP_ARP_Select		:	std_logic;
signal	User_ARP_RESPONSEV		:	std_logic;
signal	User_ARP_RESPONSE_ERR	:	std_logic;

signal	User_ARP_DST_MAC_addr	:	std_logic_vector(47 DOWNTO 0);
signal	User_ARP_DST_MAC_addr_reg	:	std_logic_vector(47 DOWNTO 0);
signal	User_ARP_DST_MAC_addr_reg_Hi	:	std_logic_vector(31 DOWNTO 0);
signal	User_ARP_DST_MAC_addr_reg_Lo	:	std_logic_vector(31 DOWNTO 0);

--------
--UDPLayer jelek
-------
CONSTANT	NumOfUDPPorts			:	integer	:=	8;
CONSTANT	UDP_AddrWidth			:	integer	:=	INTEGER(CEIL(LOG2(REAL(NumOfUDPPorts))));
CONSTANT	UDP_DataWidth			:	integer	:=	UDPPortSize + 1;
SIGNAL	UDP_RST				:	STD_LOGIC;
SIGNAL	UDP_CE				:	STD_LOGIC;
SIGNAL	UDP_CFG_CE			:	STD_LOGIC;
SIGNAL	UDP_WR_EN				:	STD_LOGIC;
SIGNAL	UDP_RD_EN				:	STD_LOGIC;
SIGNAL	UDP_ADDR				:	STD_LOGIC_VECTOR( UDP_AddrWidth-1 DOWNTO 0);
SIGNAL	UDP_DATA_IN			:	STD_LOGIC_VECTOR( UDP_DataWidth-1 DOWNTO 0);
SIGNAL	UDP_DATA_OUT			:	STD_LOGIC_VECTOR( UDP_DataWidth-1 DOWNTO 0);
SIGNAL	UDP_DATA_OUT_reg		:	STD_LOGIC_VECTOR( UDP_DataWidth-1 DOWNTO 0);
SIGNAL	UDP_DOUTV				:	STD_LOGIC;
SIGNAL	UDP_IP_DstIPAddr_In		:	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
SIGNAL	UDP_IP_SrcIPAddr_In		:	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
SIGNAL	UDP_IP_Proto_In		:	STD_LOGIC_VECTOR( IP_ProtSize-1 DOWNTO 0);
SIGNAL	UDP_IP_Length_In		:	STD_LOGIC_VECTOR( IPLengthSize-1 DOWNTO 0);
SIGNAL	UDP_IP_DstIPAddr_Out	:	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
SIGNAL	UDP_IP_SrcIPAddr_Out	:	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
SIGNAL	UDP_IP_Proto_Out		:	STD_LOGIC_VECTOR( IP_ProtSize-1 DOWNTO 0);
SIGNAL	UDP_IP_Length_Out		:	STD_LOGIC_VECTOR( IPLengthSize-1 DOWNTO 0);
SIGNAL	UDP_DstIPAddr_In		:	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
SIGNAL	UDP_SrcIPAddr_In		:	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
SIGNAL	UDP_DstPort_In			:	STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
SIGNAL	UDP_SrcPort_In			:	STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
SIGNAL	UDP_Length_In			:	STD_LOGIC_VECTOR( UDPLengthSize-1 DOWNTO 0);
SIGNAL	UDP_DstIPAddr_Out		:	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
SIGNAL	UDP_SrcIPAddr_Out		:	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
SIGNAL	UDP_DstPort_Out		:	STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
SIGNAL	UDP_SrcPort_Out		:	STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
SIGNAL	UDP_Length_Out			:	STD_LOGIC_VECTOR( UDPLengthSize-1 DOWNTO 0);
SIGNAL	UDP_SDU_DIN			:	STD_LOGIC_VECTOR( 8-1 DOWNTO 0);
SIGNAL	UDP_SDU_DINV			:	STD_LOGIC;
SIGNAL	UDP_SDU_IN_SOP			:	STD_LOGIC;
SIGNAL	UDP_SDU_IN_EOP			:	STD_LOGIC;
SIGNAL	UDP_SDU_IN_Ind			:	STD_LOGIC;
SIGNAL	UDP_SDU_IN_ErrIn		:	STD_LOGIC;
SIGNAL	UDP_SDU_IN_USER_In		:	STD_LOGIC_VECTOR( USER_width-1 DOWNTO 0);
SIGNAL	UDP_SDU_IN_Ack			:	STD_LOGIC;
SIGNAL	UDP_SDU_IN_ErrOut		:	STD_LOGIC;
SIGNAL	UDP_PDU_DOUT			:	STD_LOGIC_VECTOR( 8-1 DOWNTO 0);
SIGNAL	UDP_PDU_DOUTV			:	STD_LOGIC;
SIGNAL	UDP_PDU_Out_SOP		:	STD_LOGIC;
SIGNAL	UDP_PDU_Out_EOP		:	STD_LOGIC;
SIGNAL	UDP_PDU_Out_Ind		:	STD_LOGIC;
SIGNAL	UDP_PDU_Out_ErrOut		:	STD_LOGIC;
SIGNAL	UDP_PDU_Out_USER_Out	:	STD_LOGIC_VECTOR( USER_width-1 DOWNTO 0);
SIGNAL	UDP_PDU_Out_Ack		:	STD_LOGIC;
SIGNAL	UDP_PDU_Out_ErrIn		:	STD_LOGIC;
SIGNAL	UDP_PDU_DIN			:	STD_LOGIC_VECTOR( 8-1 DOWNTO 0);
SIGNAL	UDP_PDU_DINV			:	STD_LOGIC;
SIGNAL	UDP_PDU_IN_SOP			:	STD_LOGIC;
SIGNAL	UDP_PDU_IN_EOP			:	STD_LOGIC;
SIGNAL	UDP_PDU_IN_Ind			:	STD_LOGIC;
SIGNAL	UDP_PDU_IN_USER_In		:	STD_LOGIC_VECTOR( USER_width-1 DOWNTO 0);
SIGNAL	UDP_PDU_IN_ErrIn		:	STD_LOGIC;
SIGNAL	UDP_PDU_IN_ErrOut		:	STD_LOGIC;
SIGNAL	UDP_PDU_IN_Ack			:	STD_LOGIC;
SIGNAL	UDP_SDU_DOUT			:	STD_LOGIC_VECTOR( 8-1 DOWNTO 0);
SIGNAL	UDP_SDU_DOUTV			:	STD_LOGIC;
SIGNAL	UDP_SDU_Out_SOP		:	STD_LOGIC;
SIGNAL	UDP_SDU_OUT_EOP		:	STD_LOGIC;
SIGNAL	UDP_SDU_OUT_Ind		:	STD_LOGIC;
SIGNAL	UDP_SDU_OUT_USER_Out	:	STD_LOGIC_VECTOR( USER_width-1 DOWNTO 0);
SIGNAL	UDP_SDU_OUT_ErrOut		:	STD_LOGIC;
SIGNAL	UDP_SDU_OUT_ErrIn		:	STD_LOGIC;
SIGNAL	UDP_SDU_OUT_Ack		:	STD_LOGIC;
SIGNAL	UDP_Status			:	STD_LOGIC_VECTOR( 8-1 DOWNTO 0);


--------
--ChipScope jelek
-------
type		cs_data_bus			is array(0 to 15) of std_logic_vector(31 DOWNTO 0);
SIGNAL	aCs_Din				:	STD_LOGIC_VECTOR(16*32-1 DOWNTO 0);
SIGNAL	Cs_Din				:	cs_data_bus;
SIGNAL	Cs_Dout				:	STD_LOGIC_VECTOR(32-1 DOWNTO 0);
SIGNAL	Cs_RegRe				:	STD_LOGIC_VECTOR(16-1 DOWNTO 0);
SIGNAL	Cs_RegWe				:	STD_LOGIC_VECTOR(16-1 DOWNTO 0); 

SIGNAL	ARP_Status			:	STD_LOGIC_VECTOR(32-1 DOWNTO 0);
SIGNAL	Arbitrator_Status		:	STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	ETHLArb_Status			:	STD_LOGIC_VECTOR(3 DOWNTO 0);
--------
--IPPDU generator jelek
-------
SIGNAL	IPPDUGenStart			:	STD_LOGIC;
SIGNAL	IPPDUGen_DSTIPaddrOut	:	STD_LOGIC_VECTOR(32-1 DOWNTO 0);
SIGNAL	IPPDUGen_SRCIPaddrOut	:	STD_LOGIC_VECTOR(32-1 DOWNTO 0);
SIGNAL	IPPDUGen_ProtoOut		:	STD_LOGIC_VECTOR(8-1 DOWNTO 0);
SIGNAL	IPPDUGen_LenOut		:	STD_LOGIC_VECTOR(16-1 DOWNTO 0);
signal	IPPDUGen_DOUT			:	std_logic_vector(7 DOWNTO 0);
signal	IPPDUGen_DOUTV			:	std_logic;
signal	IPPDUGen_Out_SOP		:	std_logic;
signal	IPPDUGen_Out_EOP		:	std_logic;
signal	IPPDUGen_Out_Ind		:	std_logic;
signal	IPPDUGen_Out_ErrIn		:	std_logic;
signal	IPPDUGen_Out_ErrOut		:	std_logic;
signal	IPPDUGen_Out_Ack		:	std_logic;
signal	EN_IPPDUGen			:	std_logic;
signal	RST_IPPDUGen			:	std_logic;
signal	IPPDUGen_IPGR			:	std_logic;
SIGNAL	IPPDUGen_LenCntr		:	STD_LOGIC_VECTOR(16-1 DOWNTO 0);
SIGNAL	IPPDUGen_Status		:	STD_LOGIC_VECTOR(1 DOWNTO 0);
type IPPDUgenFSM_StateType is
(
	INIT,
	IDLE,
	WFOR_ACK,
	EmitIPPDU
);
ATTRIBUTE	ENUM_ENCODING		:	STRING;

signal	IPPDUgenFSM_State	:	IPPDUgenFSM_StateType;

--------
--UDP PDU generator jelek
-------
SIGNAL	UDPPDUGenStart			:	STD_LOGIC;
SIGNAL	UDPPDUGen_DSTIPaddrOut	:	STD_LOGIC_VECTOR(32-1 DOWNTO 0);
SIGNAL	UDPPDUGen_SRCIPaddrOut	:	STD_LOGIC_VECTOR(32-1 DOWNTO 0);
SIGNAL	UDPPDUGen_DstPort_Out	:	STD_LOGIC_VECTOR(16-1 DOWNTO 0);
SIGNAL	UDPPDUGen_SrcPort_Out	:	STD_LOGIC_VECTOR(16-1 DOWNTO 0);
SIGNAL	UDPPDUGen_LenOut		:	STD_LOGIC_VECTOR(16-1 DOWNTO 0);
signal	UDPPDUGen_DOUT			:	std_logic_vector(08-1 DOWNTO 0);
signal	UDPPDUGen_DOUTV		:	std_logic;
signal	UDPPDUGen_Out_SOP		:	std_logic;
signal	UDPPDUGen_Out_EOP		:	std_logic;
signal	UDPPDUGen_Out_Ind		:	std_logic;
signal	UDPPDUGen_Out_ErrIn		:	std_logic;
signal	UDPPDUGen_Out_ErrOut	:	std_logic;
signal	UDPPDUGen_Out_Ack		:	std_logic;
signal	EN_UDPPDUGen			:	std_logic;
signal	RST_UDPPDUGen			:	std_logic;
signal	UDPPDUGen_IPGR			:	std_logic;
SIGNAL	UDPPDUGen_LenCntr		:	STD_LOGIC_VECTOR(16-1 DOWNTO 0);
SIGNAL	UDPPDUGen_Status		:	STD_LOGIC_VECTOR(1 DOWNTO 0);
type UDPPDUgenFSM_StateType is
(
	INIT,
	IDLE,
	WFOR_ACK,
	EmitUDPPDU
);
-- ATTRIBUTE	ENUM_ENCODING		:	STRING;

signal	UDPPDUgenFSM_State	:	UDPPDUgenFSM_StateType;

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
--------
--Adress Mapping
-------
CONSTANT	CFGAddr_Etherlayer_0		:	integer	:=	0;
CONSTANT	CFGAddr_Etherlayer_1		:	integer	:=	1;
CONSTANT	CFGAddr_Arbiter			:	integer	:=	2;
CONSTANT	CFGAddr_ARPModule			:	integer	:=	3;
CONSTANT	CFGAddr_ARPModule_MAC		:	integer	:=	4;
CONSTANT	CFGAddr_MAC				:	integer	:=	5;
CONSTANT	CFGAddr_IPLayer			:	integer	:=	6;
CONSTANT	CFGAddr_IPLayerCFG			:	integer	:=	7;
CONSTANT	CFGAddr_USERIPMux			:	integer	:=	8;
CONSTANT	CFGAddr_IPPDUGen			:	integer	:=	9;
CONSTANT	CFGAddr_UDPPDUGen			:	integer	:=	10;
CONSTANT	CFGAddr_UDPLayer			:	integer	:=	11;
CONSTANT	CFGAddr_SNMP				:	integer	:=	12;
CONSTANT	CFGAddr_SNMP_CFG			:	integer	:=	13;

CONSTANT	CFGAddr_RXFIFO				:	integer	:=	15;
--------
--RX FIFO Mapping
-------
signal	RXFIFO_ALMOSTEMPTY		:	std_logic;
signal	RXFIFO_ALMOSTFULL		:	std_logic;
signal	RXFIFO_DO				:	std_logic_vector(31 DOWNTO 0);
signal	RXFIFO_DO_delayed		:	std_logic_vector(31 DOWNTO 0);
signal	RXFIFO_DOP			:	std_logic_vector(3 DOWNTO 0);
signal	RXFIFO_EMPTY			:	std_logic;
signal	RXFIFO_FULL			:	std_logic;
signal	RXFIFO_RDERR			:	std_logic;
signal	RXFIFO_WRERR			:	std_logic;
signal	RXFIFO_DI				:	std_logic_vector(31 DOWNTO 0);
signal	RXFIFO_DIP			:	std_logic_vector(3 DOWNTO 0);
signal	RXFIFO_RDEN			:	std_logic;
signal	RXFIFO_WREN			:	std_logic;
signal	RXFIFO_RST			:	std_logic;

BEGIN


	MAC_RESET			<=	MAC_RESET_sig;
	MAC_RESET_sig		<=	RESET_aggregate(CFGAddr_MAC);
	-------------------------------------------------------------
	User_IP_ARP_Select	<=	Control_aggregate(CFGAddr_USERIPMux);
	User_ARP_ReqUest	<=	Control_aggregate(CFGAddr_ARPModule);
	User_ARP_DST_IP_addr<=	Data_Lo;
	User_IP_ARPMUX:process(MacClk,User_IP_ARP_Select)
	begin
		if(rising_edge(MacClk))then
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
				---------------------------------
				--!!!!!!!!!!!TEST!!!!!!!!!!!!!!!!
				---------------------------------
				-- ARP_ReqUest			<=	Lo;
				-- ARP_DST_IP_addr		<=	(others => Lo);
				-- User_ARP_Dst_Mac_Addr	<=	(others => Lo);
				-- User_ARP_ResponseV		<=	Lo;
				-- User_ARP_RESPONSE_ERR	<=	Lo;
				-- IP_ARP_DstMacAddr		<=	X"b888e3e20139";
				-- IP_ARP_ResponseV		<=	Hi;
				-- IP_ARP_ResponseErr		<=	Lo;
				---------------------------------
				--!!!!!!!!!!!TEST!!!!!!!!!!!!!!!!
				---------------------------------
			end if;
		end if;
	end process User_IP_ARPMUX;
	-------------------------------------------------------------
	EN_ARP			<=	Enable_Aggregate(CFGAddr_ARPModule);
	RESET_ARP			<=	RESET_aggregate(CFGAddr_ARPModule);
	ARP_ADDR			<=	Address(1 DOWNTO 0);
	-- ARP_ReqUest		<=	
	-- ARP_DST_IP_addr	<=	
	ARP_IPADDR_WR_EN	<=	Write_aggregate(CFGAddr_ARPModule);
	ARP_MACADDR_WR_EN	<=	Write_aggregate(CFGAddr_ARPModule_MAC);
	ARP_IPADDR_RD_EN	<=	Read_aggregate(CFGAddr_ARPModule);
	ARP_MACADDR_RD_EN	<=	Read_aggregate(CFGAddr_ARPModule_MAC);
	ARP_ADDR_DATA_IN	<=	Data_Hi(15 DOWNTO 0) & Data_Lo;
	
	ARPIPADO_reg	:	aRegister	generic map(Size =>	32)	port map(D=>ARP_IPADDR_DATA_OUT,C=>MacClk,CE=>ARP_IPADDR_DV,Q=>ARP_IPADDR_DATA_OUT_reg);
	ARPDSTMACA_reg	:	aRegister	generic map(Size =>	48)	port map(D=>ARP_DST_MAC_addr,C=>MacClk,CE=>ARP_RESPONSEV,Q=>User_ARP_DST_MAC_addr_reg);
	
	ARP_MACADDR_DOUT_reg_Hi	<=	X"0000" & ARP_MACADDR_DATA_OUT(47 DOWNTO 32);
	ARP_MACADDR_DOUT_reg_Lo	<=	ARP_MACADDR_DATA_OUT(31 DOWNTO 0);
	
	User_ARP_DST_MAC_addr_reg_Hi	<=	X"0000" & User_ARP_DST_MAC_addr_reg(47 DOWNTO 32);
	User_ARP_DST_MAC_addr_reg_Lo	<=	User_ARP_DST_MAC_addr_reg(31 DOWNTO 0);
	
	Inst_ARPModule: ARPModule --RX_SYNC_IN !!
	GENERIC MAP(
		DataWidth			=>		8,
		TX_SYNC_OUT		=>		true,	--must be true in case of abitration
		RX_SYNC_IN		=>		false,	--must be false in case of abitration
		NumOfAddresses		=>		4, --Maximum 16, for each IP a MAC addr must be defined and vice-versa
		CLK_freq			=>		125.0, --Clock frequency in MHz
		TimeOUT			=>		250.0, --timeout in ms
		RetryCnt			=>		3	--retry count
	)
	PORT MAP(
		CLK				=>	MacClk,
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
	
	RESET_Arbitrator	<=	RESET_aggregate(CFGAddr_Arbiter);
	EN_Arbitrator		<=	Enable_Aggregate(CFGAddr_Arbiter);

	Inst_EthLayer_Arbitrator_2: EthLayer_Arbitrator_2 PORT MAP(
		CLK				=>	MacClk,
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
		CLK			=>	MacClk,
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
		Out_SOP		=>	OPEN,
		Out_EOP		=>	OPEN,
		Out_ErrOut	=>	OPEN,
		In_Data		=>	MAC_0_DIN,
		In_DataV		=>	MAC_0_DAV,
		In_SOP		=>	MAC_0_SOF,
		In_EOP		=>	MAC_0_EOF,
		In_ErrIn		=>	MAC_0_Err,
		Status		=>	Arbitrator_Status
	);
	
	
	En_ETHLayer_0		<=	Enable_Aggregate(CFGAddr_Etherlayer_0);
	RESET_ETHLayer_0	<=	RESET_aggregate(CFGAddr_Etherlayer_0);
	ETH_WR_En			<=	Write_aggregate(CFGAddr_Etherlayer_0);
	ETH_RD_En			<=	Read_aggregate(CFGAddr_Etherlayer_0);
	ETH_Addr			<=	Address(1 DOWNTO 0);
	ETH_ADDR_DATA_IN	<=	Data_Hi(15 DOWNTO 0) & Data_Lo;
	
	ETHADO_reg		:	aRegister	generic map(Size =>	48)	port map(D=>ETH_ADDR_DATA_OUT,C=>MacClk,CE=>ETH_ADDR_DV,Q=>ETH_ADDR_DATA_OUT_reg);
	
	ETH_ADDR_DATA_OUT_reg_Hi	<=	X"0000" & ETH_ADDR_DATA_OUT_reg(47 DOWNTO 32);
	ETH_ADDR_DATA_OUT_reg_Lo	<=	ETH_ADDR_DATA_OUT_reg(31 DOWNTO 0);

	
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
		CLK				=>	MacClk,
		CE				=>	En_ETHLayer_0,
		RST				=>	RESET_ETHLayer_0,
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
		SDU_IN_Ind		=>	ETHLayer_0_SDU_IN_Ind,
		SDU_IN_ErrIn		=>	ETHLayer_0_SDU_IN_ErrIn,
		SDU_IN_USER_In		=>	"000000",
		SDU_IN_Ack		=>	ETHLayer_0_SDU_IN_Ack,
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
	
	En_ETHLayer_1		<=	Enable_Aggregate(CFGAddr_Etherlayer_1);
	RESET_ETHLayer_1	<=	RESET_aggregate(CFGAddr_Etherlayer_1);
	
	RESET_IPLayer	<=	RESET_aggregate(CFGAddr_IPLayer);
	EN_IPLayer	<=	Enable_Aggregate(CFGAddr_IPLayer);
	EN_IPLayerCFG	<=	Enable_Aggregate(CFGAddr_IPLayerCFG);
	IP_WREN		<=	Write_aggregate(CFGAddr_IPLayer);
	IP_RDEN		<=	Read_aggregate(CFGAddr_IPLayer);
	IP_CFGAWREN	<=	Write_aggregate(CFGAddr_IPLayerCFG);
	IP_CFG_ADDR	<=	Address(3 DOWNTO 0);
	IP_Addr		<=	Address(2 DOWNTO 0);
	IP_Data_In	<=	Data_Lo;

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
		TX_SYNC_OUT		=>		true, --due to arbitration
		NumOfIPAddresses	=>		4,
		PacketToQueue		=>		DefPDUToQ,
		TTL				=>		DefTTL,
		MTU				=>		IPDefMTU
	)
	PORT MAP (
		CLK				=>	MacClk,
		RST				=>	RESET_IPLayer,
		CE				=>	EN_IPLayer,
		CFG_CE			=>	EN_IPLayerCFG,
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
		ARP_ResponseV		=>	IP_ARP_ResponseV,
		ARP_ResponseErr	=>	IP_ARP_ResponseErr,
		ARP_DstMacAddr		=>	IP_ARP_DstMacAddr,
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

-- IPSTR_inst	:	aRise	port map (I => Control_aggregate(CFGAddr_IPPDUGen), C => MacClk, Q => IPPDUGenStart);
IPPDUGenStart	<=	Control_aggregate(CFGAddr_IPPDUGen);
EN_IPPDUGen	<=	Enable_Aggregate(CFGAddr_IPPDUGen);
RST_IPPDUGen	<=	RESET_aggregate(CFGAddr_IPPDUGen);


IPPDUgenFSM_proc:process(	MacClk,
						RST_IPPDUGen,
						EN_IPPDUGen,
						IPPDUgenFSM_State)
begin
	if(rising_edge(MacClk))then
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
						IPPDUGen_ProtoOut		<=	Data_Lo(7 DOWNTO 0);
						IPPDUGen_LenOut		<=	Data_Lo(23 DOWNTO 8);
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
					IPPDUGen_DOUT		<=	IPPDUGen_LenCntr(7 DOWNTO 0);
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
					IPPDUGen_ProtoOut		<=	Data_Lo(7 DOWNTO 0);
					IPPDUGen_LenOut		<=	Data_Lo(23 DOWNTO 8);
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

-- UDPSTR_inst	:	aRise	port map (I => Control_aggregate(CFGAddr_UDPPDUGen), C => MacClk, Q => UDPPDUGenStart);
UDPPDUGenStart	<=	Control_aggregate(CFGAddr_UDPPDUGen);

EN_UDPPDUGen	<=	Enable_Aggregate(CFGAddr_UDPPDUGen);
RST_UDPPDUGen	<=	RESET_aggregate(CFGAddr_UDPPDUGen);


UDPPDUgenFSM_proc:process(	MacClk,
						RST_UDPPDUGen,
						EN_UDPPDUGen,
						UDPPDUgenFSM_State)
begin
	if(rising_edge(MacClk))then
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
					if(UDP_SDU_IN_Ack = Hi and UDP_SDU_IN_ErrOut = Lo)then
						UDPPDUGen_DOUTV		<=	Hi;
						UDPPDUGen_Out_SOP	<=	Hi;
						UDPPDUgenFSM_State	<=	EmitUDPPDU;
					elsif(UDP_SDU_IN_ErrOut = Hi) then
						UDPPDUgenFSM_State	<=	IDLE;
					else
						UDPPDUgenFSM_State	<=	WFOR_ACK;
					end if;
				when EmitUDPPDU =>
					UDPPDUGen_Status		<=	"11";
					UDPPDUGen_Out_SOP	<=	Lo;
					UDPPDUGen_DOUT		<=	UDPPDUGen_LenCntr(7 DOWNTO 0);
					if(UDPPDUGen_LenCntr = UDPPDUGen_LenOut) then
						UDPPDUGen_Out_EOP	<=	Hi;
						UDPPDUgenFSM_State	<=	IDLE;
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


	UDP_RST		<=	RESET_aggregate(CFGAddr_UDPLayer);
	UDP_CE		<=	Enable_Aggregate(CFGAddr_UDPLayer);
	UDP_CFG_CE	<=	Enable_Aggregate(CFGAddr_UDPLayer);
	UDP_WR_EN		<=	Write_aggregate(CFGAddr_UDPLayer);
	UDP_RD_EN		<=	Read_aggregate(CFGAddr_UDPLayer);
	UDP_ADDR		<=	Address(UDP_AddrWidth-1 DOWNTO 0);
	UDP_DATA_IN	<=	Data_Lo(UDP_DataWidth-1 DOWNTO 0);
	
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

	UDPDO_reg	:	aRegister	generic map(Size =>	UDP_DataWidth)	port map(D=>UDP_DATA_OUT,C=>MacClk,CE=>UDP_DOUTV,Q=>UDP_DATA_OUT_reg);

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
			CLK				=>	MacClk,
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

	SNMP_CE			<=	Enable_Aggregate(CFGAddr_SNMP);
	SNMP_CFG_CE		<=	Enable_Aggregate(CFGAddr_SNMP_CFG);
	SNMP_RST			<=	RESET_aggregate(CFGAddr_SNMP);
	SNMP_WR_EN		<=	Write_aggregate(CFGAddr_SNMP_CFG);
	SNMP_RD_EN		<=	Read_aggregate(CFGAddr_SNMP_CFG);
	SNMP_CFG_ADDR		<=	Address(SNMPAddrWidth-1 DOWNTO 0);
	SNMP_DATA_IN		<=	Data_Lo;

	SNMPDO_reg	:	aRegister	generic map(Size =>	SNMPDataWidth)	port map(D=>SNMP_DATA_OUT,C=>MacClk,CE=>SNMP_RD_DV,Q=>SNMP_DATA_OUT_reg);
	
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
			CLK			=>	MacClk,
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
		
		
RXFIFO_DI		<=	X"0000"&"00"& RXFIFO_EMPTY & RXFIFO_FULL& IP_PDU_Out_Ind & IP_PDU_DOUTV & IP_PDU_Out_SOP & IP_PDU_Out_EOP  & IP_PDU_DOUT;
RXFIFO_DIP	<=	(others => Lo);
RXFIFO_WREN	<=	IP_PDU_DOUTV;
RXFIFO_RST	<=	RESET_aggregate(CFGAddr_RXFIFO);
RXFRD_inst	:	aRise	port map (I => Cs_RegRe(14), C => MacClk, Q => RXFIFO_RDEN);

RX_FIFO : FIFO36
generic map 
(
	ALMOST_FULL_OFFSET		=>	X"080",-- Sets the almost empty threshold
	ALMOST_EMPTY_OFFSET		=>	X"080",-- Sets the almost empty threshold
	DATA_WIDTH			=>	18,-- Sets data width to 4,9,or 18
	DO_REG				=>	1,-- Enable output register ( 0 or 1)
	-- Must be 1 if the EN_SYN = FALSE
	EN_SYN				=>	FALSE,-- Specified FIFO as Asynchronous (FALSE) or
	-- Synchronous (TRUE)
	FIRST_WORD_FALL_THROUGH	=>	TRUE,-- Sets the FIFO FWFT to TRUE or FALSE
	SIM_MODE				=>	"FAST"
)    -- Simulation: "SAFE" vs "FAST",see "Synthesis and Simulation
	-- Design Guide" for details
port map 
(
	ALMOSTEMPTY	=>	RXFIFO_ALMOSTEMPTY,-- 1-bit almost empty output flag
	ALMOSTFULL	=>	RXFIFO_ALMOSTFULL,-- 1-bit almost full output flag
	DO			=>	RXFIFO_DO,-- 32-bit data output
	DOP			=>	RXFIFO_DOP,-- 2-bit parity data output
	EMPTY		=>	RXFIFO_EMPTY,-- 1-bit empty output flag
	FULL			=>	RXFIFO_FULL,-- 1-bit full output flag
	RDCOUNT		=>	OPEN,-- 12-bit read count output
	RDERR		=>	RXFIFO_RDERR,-- 1-bit read error output
	WRCOUNT		=>	OPEN,-- 12-bit write count output
	WRERR		=>	RXFIFO_WRERR,-- 1-bit write error
	DI			=>	RXFIFO_DI,-- 16-bit data input
	DIP			=>	RXFIFO_DIP,-- 2-bit parity input
	RDCLK		=>	MacClk,-- 1-bit read clock input
	RDEN			=>	RXFIFO_RDEN,-- 1-bit read enable input
	RST			=>	RXFIFO_RST,-- 1-bit reset input
	WRCLK		=>	MacClk,-- 1-bit write clock input
	WREN			=>	RXFIFO_WREN -- 1-bit write enable input
);

-- 0. Csipszkop VIO tester:
csss: csipszkop_vio PORT MAP -- _dual
(
	Clock		=> MacClk,
--	data			=> adata,
--	trigger		=> atrigger,
	-- VIO
	Cs_Din		=> aCs_Din,
	Cs_Dout		=> Cs_Dout,
	Cs_RegRe		=> Cs_RegRe,
	Cs_RegWe		=> Cs_RegWe
);

aCs_Din	<= 
	Cs_Din(15) &
	Cs_Din(14) &
	Cs_Din(13) &
	Cs_Din(12) &
	Cs_Din(11) &
	Cs_Din(10) &
	Cs_Din(9) &
	Cs_Din(8) &
	Cs_Din(7) &
	Cs_Din(6) &
	Cs_Din(5) &
	Cs_Din(4) &
	Cs_Din(3) &
	Cs_Din(2) &
	Cs_Din(1) &
	Cs_Din(0); 

PROCESS(MacClk)
BEGIN
IF (MacClk'event AND MacClk='1') THEN
	Cs_Din(0)		<= AppCSR;
	Cs_Din(1)		<= AppTEST;
	Cs_Din(2)		<= Enable_Aggregate;
	Cs_Din(3)		<= RESET_aggregate;
	Cs_Din(4)		<= ARP_IPADDR_DATA_OUT_reg;
	Cs_Din(5)		<= ARP_MACADDR_DOUT_reg_Hi;
	Cs_Din(6)		<= ARP_MACADDR_DOUT_reg_Lo;
	CS_Din(7)		<= IP_Data_Out;
	Cs_Din(8)		<= User_ARP_DST_MAC_addr_reg_Hi;
	Cs_Din(9)		<= User_ARP_DST_MAC_addr_reg_Lo;
	Cs_Din(10)	<= ETH_ADDR_DATA_OUT_reg_Hi;
	Cs_Din(11)	<= ETH_ADDR_DATA_OUT_reg_Lo;
	Cs_Din(12)	<= ARP_Status;
	Cs_Din(13)	<= X"00"& IP_Status & "00" & IPPDUGen_Status & Arbitrator_Status & "00"& ETHLayer_1_PDU_Out_ErrOut & ETHLayer_0_PDU_Out_ErrOut & ETHLayer_1_PDU_Out_Ind & ETHLayer_0_PDU_Out_Ind & MAC_1_Err & MAC_0_Err;
	Cs_Din(14)	<= UDP_Status & "0000000" & UDP_DATA_OUT_reg;
	Cs_Din(15)	<= SNMP_DATA_OUT_reg; -- 15
	-- Cs_Din(CFGAddr_RXFIFO)	<= RXFIFO_DO; -- 15
	-- Cs_Din(15)	<= ;
END IF;
END PROCESS;

U0:  PROCESS( MacClk, AppCSR )
BEGIN
IF( MacClk'event AND MacClk='1' ) THEN
	IF (Cs_RegWe(0) = '1') THEN
		AppCSR <= Cs_Dout;
	END IF;
	IF (Cs_RegWe(1) = '1') THEN
		AppTEST <= NOT Cs_Dout;
	END IF;
	IF (Cs_RegWe(2) = '1') THEN
		Enable_Aggregate <= Cs_Dout;
	END IF;
	IF (Cs_RegWe(3)='1') THEN
		RESET_aggregate <= Cs_Dout;
	END IF;
	IF (Cs_RegWe(4)='1') THEN
		Address <= Cs_Dout;
	END IF;
	IF (Cs_RegWe(5)='1') THEN
		Data_Hi <= Cs_Dout;
	END IF;
	IF (Cs_RegWe(6)='1') THEN
		Data_Lo <= Cs_Dout;
	END IF;
	IF (Cs_RegWe(7)='1') THEN
		Data_Misc <= Cs_Dout;
	END IF;
	IF (Cs_RegWe(8)='1') THEN
		Write_aggregate <= Cs_Dout;
	END IF;
	IF (Cs_RegWe(9)='1') THEN
		Read_aggregate <= Cs_Dout;
	END IF;
	IF (Cs_RegWe(10)='1') THEN
		Control_aggregate <= Cs_Dout;
	END IF;
	IF (Cs_RegWe(11)='1') THEN
		SNMP_EventIN <= Cs_Dout;
	END IF;
	--11
	--12
	--13
	--14
	--15
END IF;
END PROCESS;

END Application;
--  End of O23E0102.VHD