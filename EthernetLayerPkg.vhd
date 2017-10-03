--
-- EthernetLayerPkg.vhd
-- ============
--
-- (C) Ferenc Janky, BME TMIT
--   file name:	EthernetLayerPkg.vhd
--   PACKAGE:		EthernetLayerPkg
--

LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;

USE IEEE.std_logic_misc.ALL;
USE IEEE.math_real.ALL;

USE work.ProtoLayerTypesAndDefs.ALL;


-- ====================================================================
PACKAGE EthernetLayerPkg IS
-- ====================================================================
--
	COMPONENT EthernetLayer IS
	generic(
		DataWidth			:		INTEGER	:=	DefDataWidth;
		RX_SYNC_IN		:		BOOLEAN	:=	false;
		RX_SYNC_OUT		:		BOOLEAN	:=	false;
		TX_SYNC_IN		:		BOOLEAN	:=	false;
		TX_SYNC_OUT		:		BOOLEAN	:=	false;
		MINSDUSize		:		INTEGER	:=	DefMinSDUSize;
		MAXSDUSize		:		INTEGER	:=	DefMaxSDUSize;
		MaxSDUToQ			:		INTEGER	:=	DefPDUToQ;
		MINPCISize		:		INTEGER	:=	DefPCISize;
		MAXPCISize		:		INTEGER	:=	DefPCISize;
		MaxPCIToQ			:		INTEGER	:=	DefPDUToQ;
		NumOfMacAddresses	:		INTEGER	:=	DefNumOfMacAddr
	);
	PORT(
		CLK				: IN		STD_LOGIC;
		CE				: IN		STD_LOGIC;
		RST				: IN		STD_LOGIC;
		------------------------------------------------------------
		WR_EN			: IN		STD_LOGIC;
		RD_EN			: IN		STD_LOGIC;
		ADDR				: IN		STD_LOGIC_VECTOR(INTEGER(CEIL(LOG2(REAL(NumOfMacAddresses))))-1 DOWNTO 0);
		ADDR_DATA_IN		: IN		STD_LOGIC_VECTOR( MacAddrSize-1 DOWNTO 0);
		ADDR_DATA_OUT		: OUT	STD_LOGIC_VECTOR( MacAddrSize-1 DOWNTO 0);
		ADDR_DV			: OUT	STD_LOGIC;
		------------------------------------------------------------
		DstMacAddr_In		: IN		STD_LOGIC_VECTOR( MacAddrSize-1 DOWNTO 0);
		SrcMacAddr_In		: IN		STD_LOGIC_VECTOR( MacAddrSize-1 DOWNTO 0);
		EthType_In		: IN		STD_LOGIC_VECTOR( EtherTypeSize-1 DOWNTO 0);
		-------------------------------------------------------------
		DstMacAddr_Out		: OUT	STD_LOGIC_VECTOR( MacAddrSize-1 DOWNTO 0);
		SrcMacAddr_Out		: OUT	STD_LOGIC_VECTOR( MacAddrSize-1 DOWNTO 0);
		EthType_Out		: OUT	STD_LOGIC_VECTOR( EtherTypeSize-1 DOWNTO 0);
		-------------------------------------------------------------
		SDU_DIN			: IN		STD_LOGIC_VECTOR(DataWidth-1 DOWNTO 0);
		SDU_DINV			: IN		STD_LOGIC;
		SDU_IN_SOP		: IN		STD_LOGIC;
		SDU_IN_EOP		: IN		STD_LOGIC;
		SDU_IN_Ind		: IN		STD_LOGIC;
		SDU_IN_ErrIn		: IN		STD_LOGIC;
		SDU_IN_USER_In		: IN		STD_LOGIC_VECTOR(USER_width-1 DOWNTO 0);
		SDU_IN_Ack		: OUT	STD_LOGIC;
		SDU_IN_ErrOut		: OUT	STD_LOGIC;
		-------------------------------------------------------------
		PDU_DOUT			: OUT	STD_LOGIC_VECTOR(DataWidth-1 DOWNTO 0);
		PDU_DOUTV			: OUT	STD_LOGIC;
		PDU_Out_SOP		: OUT	STD_LOGIC;
		PDU_Out_EOP		: OUT	STD_LOGIC;
		PDU_Out_Ind		: OUT	STD_LOGIC;
		PDU_Out_ErrOut		: OUT	STD_LOGIC;
		PDU_Out_USER_Out	: OUT	STD_LOGIC_VECTOR(USER_width-1 DOWNTO 0);
		PDU_Out_Ack		: IN		STD_LOGIC;
		PDU_Out_ErrIn		: IN		STD_LOGIC;
		-------------------------------------------------------------
		PDU_DIN			: IN		STD_LOGIC_VECTOR(DataWidth-1 DOWNTO 0);
		PDU_DINV			: IN		STD_LOGIC;
		PDU_IN_SOP		: IN		STD_LOGIC;
		PDU_IN_EOP		: IN		STD_LOGIC;
		PDU_IN_Ind		: IN		STD_LOGIC;
		PDU_IN_USER_In		: IN		STD_LOGIC_VECTOR(USER_width-1 DOWNTO 0);
		PDU_IN_ErrIn		: IN		STD_LOGIC;
		PDU_IN_ErrOut		: OUT	STD_LOGIC;
		PDU_IN_Ack		: OUT	STD_LOGIC;
		-------------------------------------------------------------
		SDU_DOUT			: OUT	STD_LOGIC_VECTOR(DataWidth-1 DOWNTO 0);
		SDU_DOUTV			: OUT	STD_LOGIC;
		SDU_Out_SOP		: OUT	STD_LOGIC;
		SDU_OUT_EOP		: OUT	STD_LOGIC;
		SDU_OUT_Ind		: OUT	STD_LOGIC;
		SDU_OUT_USER_Out	: OUT	STD_LOGIC_VECTOR(USER_width-1 DOWNTO 0);
		SDU_OUT_ErrOut		: OUT	STD_LOGIC;
		SDU_OUT_ErrIn		: IN		STD_LOGIC;
		SDU_OUT_Ack		: IN		STD_LOGIC--;
		--====================--
		-- RX_AUX_In			: IN		STD_LOGIC_VECTOR(2*MacAddrSize-1 DOWNTO 0)
	);
	END COMPONENT EthernetLayer;
	
	COMPONENT EthernetPadder IS
	GENERIC(
		DataWidth			:		INTEGER	:=	DefDataWidth;
		SYNC_OUT			:		BOOLEAN	:=	false --JUST SYNC Input!!!
	);
	PORT(
		CLK				: IN		STD_LOGIC;
		CE				: IN		STD_LOGIC;
		RST				: IN		STD_LOGIC;
		------------------------------------------------------------
		PDU_DIN			: IN		STD_LOGIC_VECTOR( DataWidth-1 DOWNTO 0);
		PDU_DINV			: IN		STD_LOGIC;
		PDU_IN_SOP		: IN		STD_LOGIC;
		PDU_IN_EOP		: IN		STD_LOGIC;
		PDU_IN_ErrIn		: IN		STD_LOGIC;
		PDU_IN_Ind		: IN		STD_LOGIC;
		PDU_IN_Ack		: OUT	STD_LOGIC;
		PDU_IN_ErrOut		: OUT	STD_LOGIC;
		------------------------------------------------------------
		PDU_DOUT			: OUT	STD_LOGIC_VECTOR( DataWidth-1 DOWNTO 0);
		PDU_DOUTV			: OUT	STD_LOGIC;
		PDU_Out_SOP		: OUT	STD_LOGIC;
		PDU_OUT_EOP		: OUT	STD_LOGIC;
		PDU_OUT_ErrOut		: OUT	STD_LOGIC;
		PDU_OUT_Ind		: OUT	STD_LOGIC;
		PDU_OUT_Ack		: IN		STD_LOGIC;
		PDU_OUT_ErrIn		: IN		STD_LOGIC
	);
	END COMPONENT EthernetPadder;



END PACKAGE EthernetLayerPkg;

-- ============================
PACKAGE BODY EthernetLayerPkg IS
-- ============================

END PACKAGE BODY EthernetLayerPkg;

--
-- EthernetLayer.vhd
-- ============
--
-- (C) Ferenc Janky, BME TMIT
--   file name:	EthernetLayer.vhd
--   PACKAGE:		EthernetLayerPkg
--

LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;

USE IEEE.std_logic_misc.ALL;
USE IEEE.math_real.ALL;

USE work.ProtoLayerTypesAndDefs.ALL;
USE work.ProtoModulePkg.ProtoLayer;
USE work.arch.aRegister;
USE work.ProtoModulePkg.Serializer;
USE work.ProtoModulePkg.DeSerializer;
USE work.ProtoModulePkg.MiniCAM;
USE work.EthernetLayerPkg.EthernetPadder;

ENTITY EthernetLayer IS
generic(
	DataWidth			:		INTEGER	:=	DefDataWidth;
	RX_SYNC_IN		:		BOOLEAN	:=	false;
	RX_SYNC_OUT		:		BOOLEAN	:=	false;
	TX_SYNC_IN		:		BOOLEAN	:=	false;
	TX_SYNC_OUT		:		BOOLEAN	:=	false;
	MINSDUSize		:		INTEGER	:=	DefMinSDUSize;
	MAXSDUSize		:		INTEGER	:=	DefMaxSDUSize;
	MaxSDUToQ			:		INTEGER	:=	DefPDUToQ;
	MINPCISize		:		INTEGER	:=	DefPCISize;
	MAXPCISize		:		INTEGER	:=	DefPCISize;
	MaxPCIToQ			:		INTEGER	:=	DefPDUToQ;
	NumOfMacAddresses	:		INTEGER	:=	DefNumOfMacAddr
);
PORT(
	CLK				: IN		STD_LOGIC;
	CE				: IN		STD_LOGIC;
	RST				: IN		STD_LOGIC;
	------------------------------------------------------------
	WR_EN			: IN		STD_LOGIC;
	RD_EN			: IN		STD_LOGIC;
	ADDR				: IN		STD_LOGIC_VECTOR(INTEGER(CEIL(LOG2(REAL(NumOfMacAddresses))))-1 DOWNTO 0);
	ADDR_DATA_IN		: IN		STD_LOGIC_VECTOR( MacAddrSize-1 DOWNTO 0);
	ADDR_DATA_OUT		: OUT	STD_LOGIC_VECTOR( MacAddrSize-1 DOWNTO 0);
	ADDR_DV			: OUT	STD_LOGIC;
	------------------------------------------------------------
	DstMacAddr_In		: IN		STD_LOGIC_VECTOR( MacAddrSize-1 DOWNTO 0);
	SrcMacAddr_In		: IN		STD_LOGIC_VECTOR( MacAddrSize-1 DOWNTO 0);
	EthType_In		: IN		STD_LOGIC_VECTOR( EtherTypeSize-1 DOWNTO 0);
	-------------------------------------------------------------
	DstMacAddr_Out		: OUT	STD_LOGIC_VECTOR( MacAddrSize-1 DOWNTO 0);
	SrcMacAddr_Out		: OUT	STD_LOGIC_VECTOR( MacAddrSize-1 DOWNTO 0);
	EthType_Out		: OUT	STD_LOGIC_VECTOR( EtherTypeSize-1 DOWNTO 0);
	-------------------------------------------------------------
	SDU_DIN			: IN		STD_LOGIC_VECTOR(DataWidth-1 DOWNTO 0);
	SDU_DINV			: IN		STD_LOGIC;
	SDU_IN_SOP		: IN		STD_LOGIC;
	SDU_IN_EOP		: IN		STD_LOGIC;
	SDU_IN_Ind		: IN		STD_LOGIC;
	SDU_IN_ErrIn		: IN		STD_LOGIC;
	SDU_IN_USER_In		: IN		STD_LOGIC_VECTOR(USER_width-1 DOWNTO 0);
	SDU_IN_Ack		: OUT	STD_LOGIC;
	SDU_IN_ErrOut		: OUT	STD_LOGIC;
	-------------------------------------------------------------
	PDU_DOUT			: OUT	STD_LOGIC_VECTOR(DataWidth-1 DOWNTO 0);
	PDU_DOUTV			: OUT	STD_LOGIC;
	PDU_Out_SOP		: OUT	STD_LOGIC;
	PDU_Out_EOP		: OUT	STD_LOGIC;
	PDU_Out_Ind		: OUT	STD_LOGIC;
	PDU_Out_ErrOut		: OUT	STD_LOGIC;
	PDU_Out_USER_Out	: OUT	STD_LOGIC_VECTOR(USER_width-1 DOWNTO 0);
	PDU_Out_Ack		: IN		STD_LOGIC;
	PDU_Out_ErrIn		: IN		STD_LOGIC;
	-------------------------------------------------------------
	PDU_DIN			: IN		STD_LOGIC_VECTOR(DataWidth-1 DOWNTO 0);
	PDU_DINV			: IN		STD_LOGIC;
	PDU_IN_SOP		: IN		STD_LOGIC;
	PDU_IN_EOP		: IN		STD_LOGIC;
	PDU_IN_Ind		: IN		STD_LOGIC;
	PDU_IN_USER_In		: IN		STD_LOGIC_VECTOR(USER_width-1 DOWNTO 0);
	PDU_IN_ErrIn		: IN		STD_LOGIC;
	PDU_IN_ErrOut		: OUT	STD_LOGIC;
	PDU_IN_Ack		: OUT	STD_LOGIC;
	-------------------------------------------------------------
	SDU_DOUT			: OUT	STD_LOGIC_VECTOR(DataWidth-1 DOWNTO 0);
	SDU_DOUTV			: OUT	STD_LOGIC;
	SDU_Out_SOP		: OUT	STD_LOGIC;
	SDU_OUT_EOP		: OUT	STD_LOGIC;
	SDU_OUT_Ind		: OUT	STD_LOGIC;
	SDU_OUT_USER_Out	: OUT	STD_LOGIC_VECTOR(USER_width-1 DOWNTO 0);
	SDU_OUT_ErrOut		: OUT	STD_LOGIC;
	SDU_OUT_ErrIn		: IN		STD_LOGIC;
	SDU_OUT_Ack		: IN		STD_LOGIC--;
	--====================--
	-- RX_AUX_In			: IN		STD_LOGIC_VECTOR(2*MacAddrSize-1 DOWNTO 0)
);
END  EthernetLayer;

ARCHITECTURE Arch_EthernetLayer_Behavioral OF EthernetLayer IS

TYPE Ethernet_TX_Type IS
(
	INIT,
	IDLE,
	WFOR_ACK,
	Start_SERIALIZE_DSTMac,
	SERIALIZE_DSTMac
);

TYPE Ethernet_RX_Type IS
(
	INIT,
	IDLE,
	SendAck,
	Extract_IPGR,
	Extract_IPGR_GENEOP,
	PAUSE_EXTR,
	CAM_SRCH,
	FWD_PACKET,
	DROP_FRAME,
	ERR_HANDLE

);

ATTRIBUTE ENUM_ENCODING : STRING;

CONSTANT PCI_Size				:	INTEGER	:=	MacAddrSize+MacAddrSize+EtherTypeSize;
CONSTANT AddrHigh				:	INTEGER	:=	(MacAddrSize+MacAddrSize+EtherTypeSize)/DataWidth;

CONSTANT MacPCIDWLength			:	INTEGER	:=	MacPCILength/DataWidth;
-----------
--==========
--Input aux signals
--==========
-----------
SIGNAL	StartOfSDUIn			:	STD_LOGIC;
SIGNAL	MACPCI_In_sig			:	STD_LOGIC_VECTOR(MacPCILength-1 DOWNTO 0);
SIGNAL	PCI_In_ser_Start		:	STD_LOGIC;
SIGNAL	PCI_Ser_Complete		:	STD_LOGIC;
SIGNAL	PCI_Ser_Start			:	STD_LOGIC;
SIGNAL	PCI_Ser_DOUTV			:	STD_LOGIC;
SIGNAL	PCI_Ser_DOUT			:	STD_LOGIC_VECTOR(DataWidth-1 DOWNTO 0);
-----------
----------------
----------------
--Ethernet_TX part  signals
----------------
--FSM signals
SIGNAL	Ethernet_TX_State		:	Ethernet_TX_Type;
----------------
-- INPUT signals
----------------
-- OUTPUT signals


CONSTANT MacPCILengthDW		:		INTEGER	:=	(2*MacAddrSize+EtherTypeSize)/DataWidth;
----------------
----------------
-- Ethernet_RX part  signals
----------------
--FSM signals
SIGNAL	Ethernet_RX_State		:	Ethernet_RX_Type;
SIGNAL	PCI_RX_CNTR			:	STD_LOGIC_VECTOR(MacPCILengthDW-1 DOWNTO 0);

----------------
-- INPUT signals
----------------
-- OUTPUT signals
----------------
-- Suppl signals


SIGNAL	PCI_RX_register	:	STD_LOGIC_VECTOR(MacPCILength-1 DOWNTO 0);
SIGNAL	PCI_POut			:	STD_LOGIC_VECTOR(MacPCILength-1 DOWNTO 0);
SIGNAL	PCI_POutV			:	STD_LOGIC;

SIGNAL	CTRL_DOUT			:	STD_LOGIC_VECTOR(DataWidth-1 DOWNTO 0);
SIGNAL	CTLR_USER_Out		:	STD_LOGIC_VECTOR(USER_width-1 DOWNTO 0);
SIGNAL	CTRL_DV			:	STD_LOGIC;
SIGNAL	CTRL_SOP			:	STD_LOGIC;
SIGNAL	CTRL_EOP			:	STD_LOGIC;
SIGNAL	CTRL_EOP_OVR		:	STD_LOGIC;
SIGNAL	CTRL_EOP_sig		:	STD_LOGIC;
SIGNAL	CTRL_ErrOut		:	STD_LOGIC;
SIGNAL	CTRL_Ind			:	STD_LOGIC;
SIGNAL	CTRL_Ack			:	STD_LOGIC;
SIGNAL	CTRL_FWD			:	STD_LOGIC;
SIGNAL	CTRL_Pause		:	STD_LOGIC;
SIGNAL	CTRL_DROP_ERR		:	STD_LOGIC;

SIGNAL	PCI_DIN			:	STD_LOGIC_VECTOR(DataWidth-1 DOWNTO 0);
SIGNAL	PCI_IN_USER_In		:	STD_LOGIC_VECTOR(USER_width-1 DOWNTO 0);
SIGNAL	PCI_DINV			:	STD_LOGIC;
SIGNAL	PCI_IN_SOP		:	STD_LOGIC;
SIGNAL	PCI_IN_EOP		:	STD_LOGIC;
SIGNAL	PCI_IN_Ind		:	STD_LOGIC;
SIGNAL	PCI_IN_ErrIn		:	STD_LOGIC;
SIGNAL	PCI_IN_Ack		:	STD_LOGIC;
SIGNAL	PCI_IN_ErrOut		:	STD_LOGIC;

SIGNAL	PDU_DOUT_ToPad		:	STD_LOGIC_VECTOR(DataWidth-1 DOWNTO 0);
SIGNAL	PDU_DOUTV_ToPad	:	STD_LOGIC;
SIGNAL	PDU_Out_SOP_ToPad	:	STD_LOGIC;
SIGNAL	PDU_Out_EOP_ToPad	:	STD_LOGIC;
SIGNAL	PDU_Out_Ind_ToPad	:	STD_LOGIC;
SIGNAL	PDU_Out_ErrOut_ToPad:	STD_LOGIC;
SIGNAL	PDU_Out_Ack_ToPad	:	STD_LOGIC;
SIGNAL	PDU_Out_ErrIn_ToPad	:	STD_LOGIC;
-----------
--==========
--Macaddress management signals
--==========
SIGNAL	MACCAM_DIN		:	STD_LOGIC_VECTOR(MacAddrSize-1 DOWNTO 0);
SIGNAL	MACCAM_ADDR_In		:	STD_LOGIC_VECTOR(INTEGER(CEIL(LOG2(REAL(NumOfMacAddresses))))-1 DOWNTO 0);
SIGNAL	MACCAM_RD_EN		:	STD_LOGIC;
SIGNAL	MACCAM_WR_EN		:	STD_LOGIC;
SIGNAL	MACCAM_CAM_DIN		:	STD_LOGIC_VECTOR(MacAddrSize-1 DOWNTO 0);
SIGNAL	MACCAM_CAM_SRCH	:	STD_LOGIC;
SIGNAL	MACCAM_Match		:	STD_LOGIC;
SIGNAL	MACCAM_MatchV		:	STD_LOGIC;
SIGNAL	MACCAM_DOUT		:	STD_LOGIC_VECTOR(MacAddrSize-1 DOWNTO 0);
SIGNAL	MACCAM_DOUTV		:	STD_LOGIC;
-----------
--==========
--==========
-----------
----------------
--============--
--TEST Signals--
--============--
----------------
SIGNAL	TX_AUX_Out		:	STD_LOGIC_VECTOR(2*MacAddrSize-1 DOWNTO 0);
SIGNAL	TX_AUX_in			:	STD_LOGIC_VECTOR(2*MacAddrSize-1 DOWNTO 0);
SIGNAL	TX_AUX_OutV		:	STD_LOGIC;
SIGNAL	RX_AUX_Out		:	STD_LOGIC_VECTOR(2*MacAddrSize-1 DOWNTO 0);
SIGNAL	RX_AUX_OutV		:	STD_LOGIC;


BEGIN

MacAddrCAM: MiniCAM 
GENERIC MAP(
	DataWidth	=>	MacAddrSize,
	Elements	=>	NumOfMacAddresses
)
PORT MAP(
	CLK		=>	CLK,
	RST		=>	RST,
	CE		=>	CE,
	CFG_CE	=>	CE,
	WR_EN	=>	MACCAM_WR_EN,
	RD_EN	=>	MACCAM_RD_EN,
	DIN		=>	MACCAM_DIN,
	ADDR_In	=>	MACCAM_ADDR_In,
	CAM_DIN	=>	MACCAM_CAM_DIN,
	CAM_SRCH	=>	MACCAM_CAM_SRCH,
	Match	=>	MACCAM_Match,
	MatchV	=>	MACCAM_MatchV,
	DOUT		=>	MACCAM_DOUT,
	DOUTV	=>	MACCAM_DOUTV
);

MACCAM_WR_EN	<=	WR_EN;
MACCAM_RD_EN	<=	RD_EN;
MACCAM_DIN	<=	ADDR_DATA_IN;
MACCAM_ADDR_In	<=	ADDR;
ADDR_DATA_OUT	<=	MACCAM_DOUT;
ADDR_DV		<=	MACCAM_DOUTV;

StartOfSDUIn	<=	SDU_DINV AND SDU_IN_SOP;

MACPCI_In_sig	<=	DstMacAddr_In & SrcMacAddr_In & EthType_In;

PCI_In_ser: Serializer
GENERIC MAP(
	DataWidth	=>	DataWidth,
	ToSer	=>	MacPCIDWLength
)
PORT MAP(
	CLK		=>	CLK,
	RST		=>	RST,
	CE		=>	CE,
	Start	=>	PCI_In_ser_Start,
	Ser_Start	=>	PCI_Ser_Start,
	Complete	=>	PCI_Ser_Complete,
	--------------------------------------------
	PIn		=>	MACPCI_In_sig,
	SOut		=>	PCI_Ser_DOUT,
	OuTV		=>	PCI_Ser_DOUTV
);

PCI_DIN		<=	PCI_Ser_DOUT;
PCI_DINV		<=	PCI_Ser_DOUTV;
PCI_IN_SOP	<=	PCI_Ser_Start;
PCI_IN_EOP	<=	PCI_Ser_Complete;


ETH_TXFSM:PROCESS(	clk,
				rst,
				CE,
				Ethernet_TX_State,
				StartOfSDUIn,
				SDU_IN_ErrIn,
				PCI_IN_Ack,
				PCI_IN_ErrOut,
				PCI_Ser_Start,
				PCI_Ser_DOUTV,
				PCI_Ser_Complete
				)
BEGIN
	IF(RISING_EDGE(clk)) THEN
		IF(rst = Hi)THEN
			PCI_IN_USER_In		<=	(OTHERS => Lo);
			PCI_IN_Ind		<=	Lo;
			PCI_IN_ErrIn		<=	Lo;
			PCI_In_ser_Start	<=	Lo;
			Ethernet_TX_State	<=	INIT;
		ELSE
			IF(CE = Hi) THEN
				CASE Ethernet_TX_State IS
					WHEN IDLE=>
						PCI_IN_Ind	<=	Lo;
						IF(StartOfSDUIn = Hi AND SDU_IN_ErrIn = Lo) THEN
							IF(TX_SYNC_IN) THEN
								Ethernet_TX_State	<=	WFOR_ACK;
							ELSE
								Ethernet_TX_State	<=	Start_SERIALIZE_DSTMac;
							END IF;
						ELSE
							Ethernet_TX_State	<=	IDLE;
						END IF;
					WHEN WFOR_ACK =>
						PCI_IN_Ind	<=	Hi;
						IF(PCI_IN_Ack = Hi AND  PCI_IN_ErrOut = Lo) THEN
							PCI_In_ser_Start	<=	Hi;
							Ethernet_TX_State	<=	Start_SERIALIZE_DSTMac;
						-- ELSIF(PCI_IN_ErrOut = Hi or SDU_IN_ErrIn = Hi) THEN
						ELSIF(PCI_IN_ErrOut = Hi) THEN --Az SDU errora azért nem kell abbahagyni , mivel akkor nem lesz bent PCI
							Ethernet_TX_State	<=	IDLE;
						ELSE
							Ethernet_TX_State	<=	WFOR_ACK;
						END IF;
					WHEN Start_SERIALIZE_DSTMac =>
						PCI_In_ser_Start	<=	Hi;
						IF(PCI_Ser_Start = Hi AND PCI_Ser_DOUTV = Hi)THEN
							Ethernet_TX_State	<=	SERIALIZE_DSTMac;
						ELSE
							Ethernet_TX_State	<=	Start_SERIALIZE_DSTMac;
						END IF;
					WHEN SERIALIZE_DSTMac =>
						PCI_IN_Ind		<=	Lo;
						PCI_In_ser_Start	<=	Lo;
						IF(PCI_Ser_DOUTV = Hi AND PCI_Ser_Complete = Hi) THEN
							Ethernet_TX_State	<=	IDLE;
						ELSE
							Ethernet_TX_State	<=	SERIALIZE_DSTMac;
						END IF;
					-- WHEN OTHERS => --INIT
					WHEN INIT => --INIT
						IF(PCI_IN_ErrOut = Lo AND SDU_IN_ErrIn = Lo) THEN
							Ethernet_TX_State	<=	IDLE;
						ELSE
							Ethernet_TX_State	<=	INIT;
						END IF;
				END CASE;
			END IF;
		END IF;
	END IF;
END PROCESS ETH_TXFSM;


PDU_In_DeSer: DeSerializer 
GENERIC MAP(
	DataWidth	=>	DataWidth,
	ToDeSer	=>	MacPCIDWLength
)
PORT MAP(
	CLK		=>	CLK,
	RST		=>	RST,
	CE		=>	CE,
	SIn		=>	CTRL_DOUT,
	Ser_DV	=>	CTRL_DV,
	Ser_SOP	=>	CTRL_SOP,
	Ser_EOP	=>	CTRL_EOP_sig,
	Ser_ErrIn	=>	CTRL_ErrOut,
	POut		=>	PCI_POut,
	POuTV	=>	PCI_POuTV
   );
CTRL_EOP_sig	<=	CTRL_EOP or CTRL_EOP_OVR;


PCI_RXR	:	aRegister GENERIC MAP(Size => MacPCILength)	PORT MAP(D => PCI_POut,C => CLK,CE => PCI_POuTV,Q => PCI_RX_register);

MACCAM_CAM_DIN	<=	PCI_RX_register(PCI_Size -1 DOWNTO PCI_Size - MacAddrSize); --lookup dst address IN CAM

ETH_RX_FSM:PROCESS(	clk,
				RST,
				CE,
				CTRL_Ind,
				CTRL_ErrOut,
				CTRL_DV,
				CTRL_SOP,
				PCI_RX_CNTR,
				Ethernet_RX_State,
				MACCAM_Match,
				MACCAM_MatchV
				)
BEGIN
	IF(RISING_EDGE(clk)) THEN
		IF(RST = Hi) THEN
			CTRL_Ack			<=	Lo;
			CTRL_FWD			<=	Lo;
			CTRL_Pause		<=	Lo;
			CTRL_DROP_ERR		<=	Lo;
			CTRL_EOP_OVR		<=	Lo;
			MACCAM_CAM_SRCH	<=	Lo;
			PCI_RX_CNTR		<=	(OTHERS => Lo);
			Ethernet_RX_State	<=	INIT;
		ELSIF(CE = Hi) THEN
			CASE Ethernet_RX_State IS
				WHEN IDLE =>
					CTRL_Pause	<=	Lo;
					CTRL_Ack		<=	Lo;
					CTRL_FWD		<=	Lo;
					CTRL_DROP_ERR	<=	Lo;
					IF(CTRL_Ind = Hi AND CTRL_ErrOut = Lo) THEN
						Ethernet_RX_State	<=	SendAck;
					ELSE
						Ethernet_RX_State	<=	IDLE;
					END IF;
				WHEN SendAck =>
					CTRL_Ack	<=	Hi;
					IF(CTRL_ErrOut = Hi) THEN
						Ethernet_RX_State	<=	ERR_HANDLE;
					ELSE
						IF(CTRL_DV = Hi AND CTRL_SOP = Hi) THEN
							PCI_RX_CNTR		<=	(OTHERS => Lo);
							Ethernet_RX_State	<=	Extract_IPGR;
						ELSIF(CTRL_Ind = Hi AND CTRL_DV = Lo)THEN
							Ethernet_RX_State	<=	SendAck;
						ELSE
							Ethernet_RX_State	<=	IDLE;
						END IF;
					END IF;
				WHEN Extract_IPGR =>
					CTRL_Ack	<=	Lo;
					IF(CTRL_ErrOut = Hi) THEN
						Ethernet_RX_State	<=	ERR_HANDLE;
					ELSE
						IF(CTRL_DV = Hi) THEN
							PCI_RX_CNTR	<=	PCI_RX_CNTR + 1;
						END IF;
						IF(PCI_RX_CNTR = STD_LOGIC_VECTOR(to_unsigned(MacPCIDWLength-1-2,PCI_RX_CNTR'Length))) THEN
							CTRL_EOP_OVR		<=	Hi;
							Ethernet_RX_State	<=	Extract_IPGR_GENEOP;
						ELSE
							Ethernet_RX_State	<=	Extract_IPGR;
						END IF;
					END IF;
				WHEN Extract_IPGR_GENEOP =>
					CTRL_EOP_OVR		<=	Lo;
					IF(CTRL_DV = Hi) THEN
						Ethernet_RX_State	<=	pause_extr;
					ELSE
						Ethernet_RX_State	<=	Extract_IPGR_GENEOP;
					END IF;
				WHEN pause_extr =>
					MACCAM_CAM_SRCH	<=	Hi;
					CTRL_Pause		<=	Hi;
					IF(PCI_POuTV = Hi) THEN
						Ethernet_RX_State	<=	CAM_SRCH;
					ELSE
						Ethernet_RX_State	<=	pause_extr;
					END IF;
				WHEN CAM_SRCH =>
					MACCAM_CAM_SRCH	<=	Lo;
					IF(MACCAM_Match = Hi AND MACCAM_MatchV = Hi) THEN
						Ethernet_RX_State	<=	fwd_packet;
					ELSIF(MACCAM_Match = Lo AND MACCAM_MatchV = Hi) THEN
						Ethernet_RX_State	<=	drop_frame;
					ELSE
						Ethernet_RX_State	<=	CAM_SRCH;
					END IF;
				WHEN fwd_packet=>
					CTRL_FWD			<=	Hi;
					Ethernet_RX_State	<= IDLE;
				WHEN drop_frame=>
					CTRL_DROP_ERR		<=	Hi;
					Ethernet_RX_State	<= IDLE;
				WHEN ERR_HANDLE =>
					CTRL_Ack	<=	Lo;
					IF(CTRL_ErrOut = Hi) THEN
						Ethernet_RX_State	<=	ERR_HANDLE;
					ELSE
						Ethernet_RX_State	<=	IDLE;
					END IF;
				-- WHEN OTHERS => --INIT
				WHEN INIT => --INIT
					IF(CTRL_DV = Lo AND CTRL_ErrOut = Lo)THEN
						Ethernet_RX_State	<=	IDLE;
					ELSE
						Ethernet_RX_State	<=	DROP_FRAME;
					END IF;
			END CASE;
		END IF;
	END IF;
END PROCESS ETH_RX_FSM;


DstMacAddr_Out		<=	PCI_RX_register(PCI_Size -1				DOWNTO PCI_Size - MacAddrSize);
SrcMacAddr_Out		<=	PCI_RX_register(PCI_Size -1 - MacAddrSize	DOWNTO PCI_Size - 2*MacAddrSize);
EthType_Out		<=	PCI_RX_register(PCI_Size -1 - 2*MacAddrSize	DOWNTO 0);

Eth_ProtoLayer: ProtoLayer
GENERIC MAP(
	DataWidth				=>	DataWidth,
	RX_SYNC_IN			=>	RX_SYNC_IN,
	RX_SYNC_OUT			=>	RX_SYNC_OUT,
	RX_CTRL_SYNC			=>	true,
	TX_CTRL_SYNC			=>	TX_SYNC_IN,
	TX_SYNC_IN			=>	TX_SYNC_IN,
	TX_SYNC_OUT			=>	true, --Due to Padding
	TX_AUX_Q				=>	false,
	TX_AUX_widthDW			=>	1,
	RX_AUX_Q				=>	false,
	RX_AUX_widthDW			=>	1,
	MINSDUSize			=>	MINSDUSize,
	MAXSDUSize			=>	MAXSDUSize,
	MaxSDUToQ				=>	MaxSDUToQ,
	MINPCISize			=>	MINPCISize,
	MAXPCISize			=>	MAXPCISize,
	MaxPCIToQ				=>	MaxPCIToQ
)
PORT MAP(
	CLK					=>	CLK,
	CE					=>	CE,
	RST					=>	RST,
	------------------------------------------------------------
	PCI_DIN				=>	PCI_DIN,
	PCI_DINV				=>	PCI_DINV,
	PCI_IN_SOP			=>	PCI_IN_SOP,
	PCI_IN_EOP			=>	PCI_IN_EOP,
	PCI_IN_Ind			=>	PCI_IN_Ind,
	PCI_IN_ErrIn			=>	PCI_IN_ErrIn,
	PCI_IN_USER_In			=>	PCI_IN_USER_In,
	PCI_IN_Ack			=>	PCI_IN_Ack,
	PCI_IN_ErrOut			=>	PCI_IN_ErrOut,
	-------------------------------------------------------------
	SDU_DIN				=>	SDU_DIN,
	SDU_DINV				=>	SDU_DINV,
	SDU_IN_SOP			=>	SDU_IN_SOP,
	SDU_IN_EOP			=>	SDU_IN_EOP,
	SDU_IN_Ind			=>	SDU_IN_Ind,
	SDU_IN_ErrIn			=>	SDU_IN_ErrIn,
	SDU_IN_USER_In			=>	SDU_IN_USER_In,
	SDU_IN_Ack			=>	SDU_IN_Ack,
	SDU_IN_ErrOut			=>	SDU_IN_ErrOut,
	-------------------------------------------------------------
	PDU_DOUT				=>	PDU_DOUT_ToPad,
	PDU_DOUTV				=>	PDU_DOUTV_ToPad,
	PDU_Out_SOP			=>	PDU_Out_SOP_ToPad,
	PDU_Out_EOP			=>	PDU_Out_EOP_ToPad,
	PDU_Out_Ind			=>	PDU_Out_Ind_ToPad,
	PDU_Out_ErrOut			=>	PDU_Out_ErrOut_ToPad,
	PDU_Out_USER_Out		=>	PDU_Out_USER_Out,
	PDU_Out_Ack			=>	PDU_Out_Ack_ToPad,
	PDU_Out_ErrIn			=>	PDU_Out_ErrIn_ToPad,
	-------------------------------------------------------------
	PDU_DIN				=>	PDU_DIN,
	PDU_DINV				=>	PDU_DINV,
	PDU_IN_SOP			=>	PDU_IN_SOP,
	PDU_IN_EOP			=>	PDU_IN_EOP,
	PDU_IN_Ind			=>	PDU_IN_Ind,
	PDU_IN_USER_In			=>	PDU_IN_USER_In,
	PDU_IN_ErrIn			=>	PDU_IN_ErrIn,
	PDU_IN_ErrOut			=>	PDU_IN_ErrOut,
	PDU_IN_Ack			=>	PDU_IN_Ack,
	-------------------------------------------------------------
	CTRL_DOUT				=>	CTRL_DOUT,
	CTRL_DV				=>	CTRL_DV,
	CTRL_SOP				=>	CTRL_SOP,
	CTRL_EOP				=>	CTRL_EOP,
	CTRL_ErrOut			=>	CTRL_ErrOut,
	CTRL_Ind				=>	CTRL_Ind,
	CTLR_USER_Out			=>	CTLR_USER_Out,
	CTRL_Ack				=>	CTRL_Ack,
	CTRL_FWD				=>	CTRL_FWD,
	CTRL_Pause			=>	CTRL_Pause,
	CTRL_DROP_ERR			=>	CTRL_DROP_ERR,
	-------------------------------------------------------------
	SDU_DOUT				=>	SDU_DOUT,
	SDU_DOUTV				=>	SDU_DOUTV,
	SDU_Out_SOP			=>	SDU_Out_SOP,
	SDU_OUT_EOP			=>	SDU_OUT_EOP,
	SDU_OUT_Ind			=>	SDU_OUT_Ind,
	SDU_OUT_USER_Out		=>	SDU_OUT_USER_Out,
	SDU_OUT_ErrOut			=>	SDU_OUT_ErrOut,
	SDU_OUT_ErrIn			=>	SDU_OUT_ErrIn,
	SDU_OUT_Ack			=>	SDU_OUT_Ack,
	-------------------------------------------------------------
	TX_AUX_Out			=>	OPEN,
	TX_AUX_outV			=>	OPEN,
	TX_AUX_in				=>	X"00",
	RX_AUX_Out			=>	OPEN,
	RX_AUX_OutV			=>	OPEN,
	RX_AUX_in				=>	X"00"
);

	EthernetPadder_inst: EthernetPadder 
	GENERIC MAP(
		DataWidth		=>	DefDataWidth,
		SYNC_OUT		=>	TX_SYNC_OUT --JUST SYNC Input!!!
	)
	PORT MAP (
			 CLK				=>	CLK,
			 CE				=>	CE,
			 RST				=>	RST,
			 --------------------------------------------
			 PDU_DIN			=>	PDU_DOUT_ToPad,
			 PDU_DINV			=>	PDU_DOUTV_ToPad,
			 PDU_IN_SOP		=>	PDU_Out_SOP_ToPad,
			 PDU_IN_EOP		=>	PDU_Out_EOP_ToPad,
			 PDU_IN_ErrIn		=>	PDU_Out_ErrOut_ToPad,
			 PDU_IN_Ind		=>	PDU_Out_Ind_ToPad,
			 PDU_IN_Ack		=>	PDU_Out_Ack_ToPad,
			 PDU_IN_ErrOut		=>	PDU_Out_ErrIn_ToPad,
			 --------------------------------------------
			 PDU_DOUT			=>	PDU_DOUT,
			 PDU_DOUTV		=>	PDU_DOUTV,
			 PDU_Out_SOP		=>	PDU_Out_SOP,
			 PDU_OUT_EOP		=>	PDU_OUT_EOP,
			 PDU_OUT_ErrOut	=>	PDU_OUT_ErrOut,
			 PDU_OUT_Ind		=>	PDU_OUT_Ind,
			 PDU_OUT_Ack		=>	PDU_OUT_Ack,
			 PDU_OUT_ErrIn		=>	PDU_OUT_ErrIn
		);

END Arch_EthernetLayer_Behavioral;

LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;

USE IEEE.math_real.ALL;

USE work.ProtoLayerTypesAndDefs.ALL;
USE work.arch.aPipe;
USE work.arch.aDelay;


ENTITY EthernetPadder IS
GENERIC(
	DataWidth			:		INTEGER	:=	DefDataWidth;
	SYNC_OUT			:		BOOLEAN	:=	false --JUST SYNC Input!!!
);
PORT(
	CLK				: IN		STD_LOGIC;
	CE				: IN		STD_LOGIC;
	RST				: IN		STD_LOGIC;
	------------------------------------------------------------
	PDU_DIN			: IN		STD_LOGIC_VECTOR( DataWidth-1 DOWNTO 0);
	PDU_DINV			: IN		STD_LOGIC;
	PDU_IN_SOP		: IN		STD_LOGIC;
	PDU_IN_EOP		: IN		STD_LOGIC;
	PDU_IN_ErrIn		: IN		STD_LOGIC;
	PDU_IN_Ind		: IN		STD_LOGIC;
	PDU_IN_Ack		: OUT	STD_LOGIC;
	PDU_IN_ErrOut		: OUT	STD_LOGIC;
	------------------------------------------------------------
	PDU_DOUT			: OUT	STD_LOGIC_VECTOR( DataWidth-1 DOWNTO 0);
	PDU_DOUTV			: OUT	STD_LOGIC;
	PDU_Out_SOP		: OUT	STD_LOGIC;
	PDU_OUT_EOP		: OUT	STD_LOGIC;
	PDU_OUT_ErrOut		: OUT	STD_LOGIC;
	PDU_OUT_Ind		: OUT	STD_LOGIC;
	PDU_OUT_Ack		: IN		STD_LOGIC;
	PDU_OUT_ErrIn		: IN		STD_LOGIC
);
END EthernetPadder;

ARCHITECTURE ArchEthernetPadderBehav OF EthernetPadder IS

CONSTANT	MinPDUSWidth	:		INTEGER								:=	INTEGER(CEIL(LOG2(REAL(EThMinPDUSize+1))));
CONSTANT	ETHMindPDU_vec	:		STD_LOGIC_VECTOR( MinPDUSWidth-1 DOWNTO 0)	:=	STD_LOGIC_VECTOR(to_unsigned(EThMinPDUSize-1,MinPDUSWidth));
CONSTANT	NULL_vec		:		STD_LOGIC_VECTOR( MinPDUSWidth-1 DOWNTO 0)	:=	STD_LOGIC_VECTOR(to_unsigned(0,MinPDUSWidth));
CONSTANT	TWO_vec		:		STD_LOGIC_VECTOR( MinPDUSWidth-1 DOWNTO 0)	:=	STD_LOGIC_VECTOR(to_unsigned(2,MinPDUSWidth));
CONSTANT	TH_delay		:		INTEGER								:=	2;

TYPE RXFSM_StateType IS
(
	INIT,
	IDLE,
	WFOR_ACK,
	SendAck,
	IPGR,
	PaddingNeeded,
	PutEOP
);
ATTRIBUTE	ENUM_ENCODING	:	STRING;

SIGNAL	RXFSM_State	:	RXFSM_StateType;

SIGNAL	RX_CNTR		:		STD_LOGIC_VECTOR( MinPDUSWidth-1 DOWNTO 0);
SIGNAL	DOUTV_OVR		:		STD_LOGIC;
SIGNAL	Out_EOP_OVRN	:		STD_LOGIC;
SIGNAL	OuT_EOP_OVR	:		STD_LOGIC;
SIGNAL	PDU_OUT_Ind_sig:		STD_LOGIC;
SIGNAL	PDU_DOUTV_sig	:		STD_LOGIC;
SIGNAL	PDU_Out_EOP_sig:		STD_LOGIC;

BEGIN

	RXFSM_proc:PROCESS(clk,rst,CE,RXFSM_State,PDU_IN_Ind,PDU_Out_ErrIn,PDU_OUT_Ack,PDU_IN_SOP,PDU_DINV,PDU_IN_ErrIn,RX_CNTR,PDU_IN_EOP)
	BEGIN
		IF(RISING_EDGE(clk))THEN
			IF(rst = Hi) THEN
				DOUTV_OVR			<=	Lo;
				Out_EOP_OVRN		<=	Hi;
				OuT_EOP_OVR		<=	Lo;
				PDU_OUT_Ind_sig	<=	Lo;
				PDU_IN_Ack		<=	Lo;
				RX_CNTR			<=	ETHMindPDU_vec;
				RXFSM_State		<=	INIT;
			ELSIF(rst = Lo AND CE = Hi) THEN
				CASE RXFSM_State IS
					WHEN IDLE =>
						DOUTV_OVR			<=	Lo;
						Out_EOP_OVRN		<=	Hi;
						OuT_EOP_OVR		<=	Lo;
						PDU_OUT_Ind_sig	<=	Lo;
						PDU_IN_Ack		<=	Lo;
						RX_CNTR			<=	ETHMindPDU_vec;
						IF(PDU_IN_Ind = Hi)THEN
							IF(SYNC_OUT)THEN
								RXFSM_State	<=	WFOR_ACK;
							ELSE
								RXFSM_State	<=	SendAck;
							END IF;
						ELSE
							RXFSM_State	<=	IDLE;
						END IF;
					WHEN WFOR_ACK =>
						PDU_OUT_Ind_sig	<=	Hi;
						IF(PDU_IN_Ind = Hi AND PDU_Out_ErrIn = Lo)THEN
							IF(PDU_OUT_Ack = Hi)THEN
								RXFSM_State	<=	SendAck;
							ELSE
								RXFSM_State	<=	WFOR_ACK;
							END IF;
						ELSE
							RXFSM_State	<=	IDLE;
						END IF;
					WHEN SendAck =>
						PDU_IN_Ack	<=	Hi;
						IF(PDU_IN_Ind = Hi) THEN
							IF(PDU_IN_SOP = Hi AND PDU_DINV = Hi AND PDU_IN_ErrIn = Lo) THEN
								RX_CNTR		<=	RX_CNTR - 1;
								RXFSM_State	<=	IPGR;
							ELSE
								RXFSM_State	<=	SendAck;
							END IF;
						ELSE
							RXFSM_State	<=	IDLE;
						END IF;
					WHEN IPGR =>
						PDU_IN_Ack		<=	Lo;
						PDU_OUT_Ind_sig	<=	Lo;
						IF(PDU_IN_ErrIn = Lo) THEN
							IF(PDU_DINV = Hi)THEN
								IF(RX_CNTR = NULL_vec)THEN
									RX_CNTR	<=	NULL_vec;
								ELSE
									RX_CNTR	<=	RX_CNTR - 1;
								END IF;
								IF(PDU_IN_EOP = Hi AND RX_CNTR = NULL_vec)THEN
									RXFSM_State	<=	IDLE;
								ELSIF(PDU_IN_EOP = Hi AND RX_CNTR /= NULL_vec)THEN
									RXFSM_State	<=	PaddingNeeded;
								ELSE
									RXFSM_State	<=	IPGR;
								END IF;
							ELSE
								RXFSM_State	<=	IPGR;
							END IF;
						ELSE
							RXFSM_State	<=	IDLE;
						END IF;
					WHEN PaddingNeeded =>
						DOUTV_OVR		<=	Hi;
						Out_EOP_OVRN	<=	Lo;
						OuT_EOP_OVR	<=	Lo;
						RX_CNTR		<=	RX_CNTR - 1;
						IF(RX_CNTR = NULL_vec)THEN
							RXFSM_State	<=	PutEOP;
						ELSE
							RXFSM_State	<=	PaddingNeeded;
						END IF;
					WHEN PutEOP =>
						DOUTV_OVR		<=	Hi;
						OuT_EOP_OVR	<=	Hi;
						RXFSM_State	<=	IDLE;
					-- WHEN OTHERS => --INIT
					WHEN INIT =>
						DOUTV_OVR			<=	Lo;
						Out_EOP_OVRN		<=	Hi;
						OuT_EOP_OVR		<=	Lo;
						PDU_OUT_Ind_sig	<=	Lo;
						PDU_IN_Ack		<=	Lo;
						RX_CNTR			<=	ETHMindPDU_vec;
						RXFSM_State		<=	IDLE;
				END CASE;
			END IF;
		END IF;
	END PROCESS RXFSM_proc;

DINTPD		: aPipe		GENERIC MAP( Length => TH_delay, Size => DataWidth)	PORT MAP( C => CLK, I => PDU_DIN,			CE => CE, Q => PDU_DOUT);
DINVTPD		: aDelay		GENERIC MAP( Length => TH_delay)					PORT MAP( C => CLK, I => PDU_DINV,			CE => CE, Q => PDU_DOUTV_sig);
SOPTPD		: aDelay		GENERIC MAP( Length => TH_delay)					PORT MAP( C => CLK, I => PDU_IN_SOP,		CE => CE, Q => PDU_Out_SOP);
EOPTPD		: aDelay		GENERIC MAP( Length => TH_delay)					PORT MAP( C => CLK, I => PDU_IN_EOP,		CE => CE, Q => PDU_Out_EOP_sig);
PIEInTPD		: aDelay		GENERIC MAP( Length => TH_delay)					PORT MAP( C => CLK, I => PDU_IN_ErrIn,		CE => CE, Q => PDU_OUT_ErrOut);
POIndTPD		: aDelay		GENERIC MAP( Length => TH_delay)					PORT MAP( C => CLK, I => PDU_OUT_Ind_sig,	CE => CE, Q => PDU_OUT_Ind);
PIEoutTPD		: aDelay		GENERIC MAP( Length => TH_delay)					PORT MAP( C => CLK, I => PDU_Out_ErrIn,		CE => CE, Q => PDU_IN_ErrOut);

PDU_Out_EOP	<=	(PDU_Out_EOP_sig AND Out_EOP_OVRN) or OuT_EOP_OVR;
PDU_DOUTV		<=	PDU_DOUTV_sig or DOUTV_OVR;

END ArchEthernetPadderBehav;
