--
-- ProtoModulePkg.vhd
-- ============
--
-- (C) Ferenc Janky, BME TMIT
--   file name:	ProtoModulePkg.vhd
--   PACKAGE:		ProtoModulePkg
--

LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;

-- USE IEEE.std_logic_misc.ALL;
USE IEEE.math_real.ALL;

--LIBRARY work;
USE work.ProtoLayerTypesAndDefs.ALL;

-- ====================================================================
PACKAGE ProtoModulePkg IS
-- ====================================================================
--
	COMPONENT PDUQueue IS
	generic
	(
		DataWidth					:		INTEGER	:=	DefDataWidth;
		SYNC_IN					:		BOOLEAN	:=	false;
		SYNC_OUT					:		BOOLEAN	:=	true;
		SYNC_CTRL					:		BOOLEAN	:=	false;
		MINPDUSize				:		INTEGER	:=	DefMinPDUSize;
		MAXPDUSize				:		INTEGER	:=	DefMaxPDUSize;
		MaxPDUToQ					:		INTEGER	:=	DefPDUToQ
	);
	PORT
	(
		CLK						: IN		STD_LOGIC;
		CE_In					: IN		STD_LOGIC;
		CE_Out					: IN		STD_LOGIC;
		RST						: IN		STD_LOGIC;
		-------------------------------------------------------------
		-- IN interface signals
		DIN						: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		DINV						: IN		STD_LOGIC;
		In_SOP					: IN		STD_LOGIC;
		In_EOP					: IN		STD_LOGIC;
		In_Ind					: IN		STD_LOGIC;
		In_ErrIn					: IN		STD_LOGIC;
		In_Ack					: OUT	STD_LOGIC;
		In_ErrOut					: OUT	STD_LOGIC;
		-------------------------------------------------------------
		-- OUT interface signals
		DOUT						: OUT	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		DOUTV					: OUT	STD_LOGIC;
		Out_SOP					: OUT	STD_LOGIC;
		Out_EOP					: OUT	STD_LOGIC;
		Out_Ind					: OUT	STD_LOGIC;
		Out_ErrOut				: OUT	STD_LOGIC;
		Out_Ack					: IN		STD_LOGIC;
		Out_ErrIn					: IN		STD_LOGIC;
		-------------------------------------------------------------
		-- Control interface signals
		CTRL_DOUT					: OUT	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		CTRL_DV					: OUT	STD_LOGIC;
		CTRL_SOP					: OUT	STD_LOGIC;
		CTRL_EOP					: OUT	STD_LOGIC;
		CTRL_ErrOut				: OUT	STD_LOGIC;
		CTRL_Ind					: OUT	STD_LOGIC;
		CTRL_Ack					: IN		STD_LOGIC;
		CTRL_FWD					: IN		STD_LOGIC;
		CTRL_Pause				: IN		STD_LOGIC;
		CTRL_DROP_ERR				: IN		STD_LOGIC;
		-------------------------------------------------------------
		-- Extra user signals
		USER_IN					: IN		STD_LOGIC_VECTOR(USER_width-1 downto 0);
		USER_Out					: OUT	STD_LOGIC_VECTOR(USER_width-1 downto 0);
		USER_Out_CTRL				: OUT	STD_LOGIC_VECTOR(USER_width-1 downto 0)

	);

	END COMPONENT PDUQueue;

	COMPONENT ProtoModule_TXPart IS
	GENERIC
	(
		DataWidth				:		INTEGER	:=	DefDataWidth;
		SYNC_IN_SDU			:		BOOLEAN	:=	false;
		SYNC_IN_PCI			:		BOOLEAN	:=	false;
		SYNC_OUT				:		BOOLEAN	:=	false;
		MINSDUSize			:		INTEGER	:=	DefMinSDUSize;
		MAXSDUSize			:		INTEGER	:=	DefMaxSDUSize;
		MaxSDUToQ				:		INTEGER	:=	DefPDUToQ;
		MINPCISize			:		INTEGER	:=	DefPCISize;
		MAXPCISize			:		INTEGER	:=	DefPCISize;
		MaxPCIToQ				:		INTEGER	:=	DefPDUToQ
	);
	PORT
	(
		CLK					: IN		STD_LOGIC;
		CE					: IN		STD_LOGIC;
		RST					: IN		STD_LOGIC;
		-------------------------------------------------------------
		PCI_DIN				: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		PCI_DINV				: IN		STD_LOGIC;
		PCI_SOP				: IN		STD_LOGIC;
		PCI_EOP				: IN		STD_LOGIC;
		PCI_Ind				: IN		STD_LOGIC;
		PCI_ErrIn				: IN		STD_LOGIC;
		PCI_USER_In			: IN		STD_LOGIC_VECTOR(USER_width-1 downto 0);
		PCI_Ack				: OUT	STD_LOGIC;
		PCI_ErrOut			: OUT	STD_LOGIC;
		-------------------------------------------------------------
		SDU_DIN				: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		SDU_DINV				: IN		STD_LOGIC;
		SDU_SOP				: IN		STD_LOGIC;
		SDU_EOP				: IN		STD_LOGIC;
		SDU_Ind				: IN		STD_LOGIC;
		SDU_ErrIn				: IN		STD_LOGIC;
		SDU_USER_In			: IN		STD_LOGIC_VECTOR(USER_width-1 downto 0);
		SDU_Ack				: OUT	STD_LOGIC;
		SDU_ErrOut			: OUT	STD_LOGIC;
		-------------------------------------------------------------
		DOUT					: OUT	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		DOUTV				: OUT	STD_LOGIC;
		Out_SOP				: OUT	STD_LOGIC;
		Out_EOP				: OUT	STD_LOGIC;
		Out_Ind				: OUT	STD_LOGIC;
		Out_ErrOut			: OUT	STD_LOGIC;
		USER_Out				: OUT	STD_LOGIC_VECTOR(USER_width-1 downto 0);
		Out_Ack				: IN		STD_LOGIC;
		Out_ErrIn				: IN		STD_LOGIC
	);
	END COMPONENT ProtoModule_TXPart;

	COMPONENT ProtoLayer IS
	generic(
		DataWidth				:		INTEGER	:=	DefDataWidth;
		RX_SYNC_IN			:		BOOLEAN	:=	false;
		RX_SYNC_OUT			:		BOOLEAN	:=	false;
		RX_CTRL_SYNC			:		BOOLEAN	:=	false;
		TX_CTRL_SYNC			:		BOOLEAN	:=	false;
		TX_SYNC_IN			:		BOOLEAN	:=	false;
		TX_SYNC_OUT			:		BOOLEAN	:=	false;
		TX_AUX_Q				:		BOOLEAN	:=	false;
		TX_AUX_widthDW			:		INTEGER	:=	DefAuxWidth;
		RX_AUX_Q				:		BOOLEAN	:=	false;
		RX_AUX_widthDW			:		INTEGER	:=	DefAuxWidth;
		MINSDUSize			:		INTEGER	:=	DefMinPDUSize;
		MAXSDUSize			:		INTEGER	:=	DefMaxPDUSize;
		MaxSDUToQ				:		INTEGER	:=	DefPDUToQ;
		MINPCISize			:		INTEGER	:=	DefMinPDUSize;
		MAXPCISize			:		INTEGER	:=	DefMinPDUSize;
		MaxPCIToQ				:		INTEGER	:=	DefPDUToQ
	);
	PORT(
		CLK					: IN		STD_LOGIC;
		CE					: IN		STD_LOGIC;
		RST					: IN		STD_LOGIC;
		------------------------------------------------------------
		PCI_DIN				: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		PCI_DINV				: IN		STD_LOGIC;
		PCI_IN_SOP			: IN		STD_LOGIC;
		PCI_IN_EOP			: IN		STD_LOGIC;
		PCI_IN_Ind			: IN		STD_LOGIC;
		PCI_IN_ErrIn			: IN		STD_LOGIC;
		PCI_IN_USER_In			: IN		STD_LOGIC_VECTOR(USER_width-1 downto 0);
		PCI_IN_Ack			: OUT	STD_LOGIC;
		PCI_IN_ErrOut			: OUT	STD_LOGIC;
		-------------------------------------------------------------
		SDU_DIN				: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		SDU_DINV				: IN		STD_LOGIC;
		SDU_IN_SOP			: IN		STD_LOGIC;
		SDU_IN_EOP			: IN		STD_LOGIC;
		SDU_IN_Ind			: IN		STD_LOGIC;
		SDU_IN_ErrIn			: IN		STD_LOGIC;
		SDU_IN_USER_In			: IN		STD_LOGIC_VECTOR(USER_width-1 downto 0);
		SDU_IN_Ack			: OUT	STD_LOGIC;
		SDU_IN_ErrOut			: OUT	STD_LOGIC;
		-------------------------------------------------------------
		PDU_DOUT				: OUT	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		PDU_DOUTV				: OUT	STD_LOGIC;
		PDU_Out_SOP			: OUT	STD_LOGIC;
		PDU_Out_EOP			: OUT	STD_LOGIC;
		PDU_Out_Ind			: OUT	STD_LOGIC;
		PDU_Out_ErrOut			: OUT	STD_LOGIC;
		PDU_Out_USER_Out		: OUT	STD_LOGIC_VECTOR(USER_width-1 downto 0);
		PDU_Out_Ack			: IN		STD_LOGIC;
		PDU_Out_ErrIn			: IN		STD_LOGIC;
		-------------------------------------------------------------
		PDU_DIN				: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		PDU_DINV				: IN		STD_LOGIC;
		PDU_IN_SOP			: IN		STD_LOGIC;
		PDU_IN_EOP			: IN		STD_LOGIC;
		PDU_IN_Ind			: IN		STD_LOGIC;
		PDU_IN_USER_In			: IN		STD_LOGIC_VECTOR(USER_width-1 downto 0);
		PDU_IN_ErrIn			: IN		STD_LOGIC;
		PDU_IN_ErrOut			: OUT	STD_LOGIC;
		PDU_IN_Ack			: OUT	STD_LOGIC;
		-------------------------------------------------------------
		CTRL_DOUT				: OUT	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		CTRL_DV				: OUT	STD_LOGIC;
		CTRL_SOP				: OUT	STD_LOGIC;
		CTRL_EOP				: OUT	STD_LOGIC;
		CTRL_ErrOut			: OUT	STD_LOGIC;
		CTRL_Ind				: OUT	STD_LOGIC;
		CTLR_USER_Out			: OUT	STD_LOGIC_VECTOR(USER_width-1 downto 0);
		CTRL_Ack				: IN		STD_LOGIC;
		CTRL_FWD				: IN		STD_LOGIC;
		CTRL_Pause			: IN		STD_LOGIC;
		CTRL_DROP_ERR			: IN		STD_LOGIC;
		-------------------------------------------------------------
		SDU_DOUT				: OUT	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		SDU_DOUTV				: OUT	STD_LOGIC;
		SDU_Out_SOP			: OUT	STD_LOGIC;
		SDU_OUT_EOP			: OUT	STD_LOGIC;
		SDU_OUT_Ind			: OUT	STD_LOGIC;
		SDU_OUT_USER_Out		: OUT	STD_LOGIC_VECTOR(USER_width-1 downto 0);
		SDU_OUT_ErrOut			: OUT	STD_LOGIC;
		SDU_OUT_ErrIn			: IN		STD_LOGIC;
		SDU_OUT_Ack			: IN		STD_LOGIC;
		----------------------------------------------------------------
		--============================================================--
		----------------------------------------------------------------
		TX_AUX_Out			: OUT	STD_LOGIC_VECTOR(TX_AUX_widthDW*DataWidth-1 downto 0);
		TX_AUX_outV			: OUT	STD_LOGIC;
		TX_AUX_in				: IN		STD_LOGIC_VECTOR(TX_AUX_widthDW*DataWidth-1 downto 0);
		RX_AUX_Out			: OUT	STD_LOGIC_VECTOR(RX_AUX_widthDW*DataWidth-1 downto 0);
		RX_AUX_OutV			: OUT	STD_LOGIC;
		RX_AUX_in				: IN		STD_LOGIC_VECTOR(RX_AUX_widthDW*DataWidth-1 downto 0)
	);
	END  COMPONENT ProtoLayer;

	COMPONENT PDUMux IS
	generic(
		Datawidth				: INTEGER := DefDataWidth
	);
	PORT(
		CLK					: IN		STD_LOGIC;
		SEL					: IN		STD_LOGIC;
		----------------------------------------------------------------------------
		I_0					: IN		STD_LOGIC_VECTOR(Datawidth -1 downto 0);
		UI_0					: IN		STD_LOGIC_VECTOR(USER_width -1 downto 0);
		DV_0					: IN		STD_LOGIC;
		SOP_0				: IN		STD_LOGIC;
		EOP_0				: IN		STD_LOGIC;
		ERRIn_0				: IN		STD_LOGIC;
		IndIn_0				: IN		STD_LOGIC;
		AckOut_0				: OUT	STD_LOGIC;
		ErrOut_0				: OUT	STD_LOGIC;
		----------------------------------------------------------------------------
		I_1					: IN		STD_LOGIC_VECTOR(Datawidth -1 downto 0);
		UI_1					: IN		STD_LOGIC_VECTOR(USER_width -1 downto 0);
		DV_1					: IN		STD_LOGIC;
		SOP_1				: IN		STD_LOGIC;
		EOP_1				: IN		STD_LOGIC;
		ERRIn_1				: IN		STD_LOGIC;
		IndIn_1				: IN		STD_LOGIC;
		AckOut_1				: OUT	STD_LOGIC;
		ErrOut_1				: OUT	STD_LOGIC;
		----------------------------------------------------------------------------
		Q					: OUT	STD_LOGIC_VECTOR(Datawidth -1 downto 0);
		QU					: OUT	STD_LOGIC_VECTOR(USER_width -1 downto 0);
		Q_DV					: OUT	STD_LOGIC;
		Q_SOP				: OUT	STD_LOGIC;
		Q_EOP				: OUT	STD_LOGIC;
		Q_ERROut				: OUT	STD_LOGIC;
		Q_Ind				: OUT	STD_LOGIC;
		Q_AckIn				: IN		STD_LOGIC;
		Q_ErrIn				: IN		STD_LOGIC
	);
	END COMPONENT PDUMux;
	
	
	COMPONENT Serializer IS
	generic(
		DataWidth			:		INTEGER	:=	DefDataWidth;
		ToSer			:		INTEGER	:=	DefToSer
	);

	PORT(
		CLK				: IN		STD_LOGIC;
		RST				: IN		STD_LOGIC;
		CE				: IN		STD_LOGIC;
		Start			: IN		STD_LOGIC;
		Ser_Start			: OUT	STD_LOGIC;
		Complete			: OUT	STD_LOGIC;
		--------------------------------------------
		PIn				: IN		STD_LOGIC_VECTOR(DataWidth*ToSer-1 downto 0);
		SOut				: OUT	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		OuTV				: OUT	STD_LOGIC
	);
	END COMPONENT Serializer;

	COMPONENT DeSerializer IS
	generic(
		DataWidth			:		INTEGER	:=	DefDataWidth;
		ToDeSer			:		INTEGER	:=	DefToDeSer
	);
	PORT(
		CLK				: IN		STD_LOGIC;
		RST				: IN		STD_LOGIC;
		CE				: IN		STD_LOGIC;
		--------------------------------------------
		SIn				: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		Ser_DV			: IN		STD_LOGIC;
		Ser_SOP			: IN		STD_LOGIC;
		Ser_EOP			: IN		STD_LOGIC;
		Ser_ErrIn			: IN		STD_LOGIC;
		POut				: OUT	STD_LOGIC_VECTOR(DataWidth*ToDeSer-1 downto 0);
		POuTV			: OUT	STD_LOGIC;
		POuT_err			: OUT	STD_LOGIC
	);
	END COMPONENT DeSerializer;
	
	COMPONENT	MiniCAM IS
	generic(
		DataWidth			:		INTEGER	:=	DefDataWidth;
		Elements			:		INTEGER	:=	DefCAMElems;
		InitToFF			:		BOOLEAN	:=	true
	);
	PORT(
		CLK				: IN		STD_LOGIC;
		RST				: IN		STD_LOGIC;
		CE				: IN		STD_LOGIC;
		CFG_CE			: IN		STD_LOGIC;
		WR_EN			: IN		STD_LOGIC;
		RD_EN			: IN		STD_LOGIC;
		DIN				: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		ADDR_In			: IN		STD_LOGIC_VECTOR(INTEGER(CEIL(LOG2(REAL(Elements))))-1 downto 0);
		CAM_DIN			: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		CAM_SRCH			: IN		STD_LOGIC;
		Match			: OUT	STD_LOGIC;
		MatchV			: OUT	STD_LOGIC;
		DOUT				: OUT	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		ADDR_Out			: OUT	STD_LOGIC_VECTOR(INTEGER(CEIL(LOG2(REAL(Elements))))-1 downto 0);
		DOUTV			: OUT	STD_LOGIC
	);
	END COMPONENT MiniCAM;
	
	
	COMPONENT GenCRC IS
	Generic(
		DataWidth		:		INTEGER			:=	DefDataWidth;
		DataEndiannes	:		BOOLEAN			:=	false; --false = MSByte first, true=LSByte first
		DataBitFormat	:		BOOLEAN			:=	false; --false = MSB first, true=LSB first
		Poly			:		STD_LOGIC_VECTOR	:=	"000000000";
		PolyFormat	:		INTEGER			:=1;-- 1= Normal(MSB first), 2= Reversed (LSB first),3=Reversed Reciprocial (Koopman)
		Phase		:		INTEGER			:=1
	);
	PORT(
		CLK			: IN		STD_LOGIC;
		RST			: IN		STD_LOGIC;
		CE			: IN		STD_LOGIC;
		DataIn		: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		CRCOut		: OUT	STD_LOGIC_VECTOR(Poly'Length-2 downto 0);
		CRCValid		: OUT	STD_LOGIC
	);
	END COMPONENT GenCRC;
	
	-- COMPONENT Arbitrator IS
	-- GENERIC(
		-- NumOfClients		:		INTEGER	:=	2;
		-- DiscriminatorWidth	:		INTEGER	:=	EtherTypeSize;
		-- TXInWidth			:		INTEGER	:=	DefDataWidth;
		-- TXOutWidth		:		INTEGER	:=	DefDataWidth;
		-- RXInWidth			:		INTEGER	:=	DefDataWidth;
		-- RXOutWidth		:		INTEGER	:=	DefDataWidth
	-- );
	-- PORT(
		-- CLK				: IN		STD_LOGIC;
		-- RST				: IN		STD_LOGIC;
		-- CE				: IN		STD_LOGIC;
		-- CFG_CE			: IN		STD_LOGIC;
		-- ---------------------------------------------------
		-- --			CFG IF
		-- ---------------------------------------------------
		
		
		-- ---------------------------------------------------
		-- TX_Client_In		: IN		array (0 to NumOfClients-1) OF STD_LOGIC_VECTOR(TXInWidth-1 downto 0);
		-- TX_Client_Out		: OUT	array (0 to NumOfClients-1) OF STD_LOGIC_VECTOR(TXOutWidth-1 downto 0);
		-- From_TX			: IN		STD_LOGIC_VECTOR(TXOutWidth-1 downto 0);
		-- From_TX			: IN		STD_LOGIC_VECTOR(TXOutWidth-1 downto 0);
		-- TO_TX			: OUT	STD_LOGIC_VECTOR(TXInWidth-1 downto 0);
		-- RX_Client_In		: IN		array (0 to NumOfClients-1) OF STD_LOGIC_VECTOR(RXInWidth-1 downto 0);
		-- RX_Client_Out		: OUT	array (0 to NumOfClients-1) OF STD_LOGIC_VECTOR(RXOutWidth-1 downto 0);
		-- From_RX			: IN		STD_LOGIC_VECTOR(RXOutWidth-1 downto 0);
		-- TO_RX			: OUT	STD_LOGIC_VECTOR(RXInWidth-1 downto 0)
	-- );
	-- END COMPONENT Arbitrator_2;
	COMPONENT End_Arbitrator_2 IS
	GENERIC(
		DataWidth			:		INTEGER	:=	DefDataWidth
	);
	PORT(
		CLK				: IN		STD_LOGIC;
		RST				: IN		STD_LOGIC;
		CE				: IN		STD_LOGIC;
		---------------------------------------------------
		--			IF0
		---------------------------------------------------
		In_0_Data			: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		In_0_DataV		: IN		STD_LOGIC;
		In_0_SOP			: IN		STD_LOGIC;
		In_0_EOP			: IN		STD_LOGIC;
		In_0_ErrIn		: IN		STD_LOGIC;
		In_0_Ind			: IN		STD_LOGIC;
		In_0_Ack			: OUT	STD_LOGIC;
		Out_0_Data		: OUT	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		Out_0_DataV		: OUT	STD_LOGIC;
		Out_0_SOP			: OUT	STD_LOGIC;
		Out_0_EOP			: OUT	STD_LOGIC;
		Out_0_ErrOut		: OUT	STD_LOGIC;
		---------------------------------------------------
		--			IF1
		---------------------------------------------------
		In_1_Data			: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		In_1_DataV		: IN		STD_LOGIC;
		In_1_SOP			: IN		STD_LOGIC;
		In_1_EOP			: IN		STD_LOGIC;
		In_1_ErrIn		: IN		STD_LOGIC;
		In_1_Ind			: IN		STD_LOGIC;
		In_1_Ack			: OUT	STD_LOGIC;
		Out_1_Data		: OUT	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		Out_1_DataV		: OUT	STD_LOGIC;
		Out_1_SOP			: OUT	STD_LOGIC;
		Out_1_EOP			: OUT	STD_LOGIC;
		Out_1_ErrOut		: OUT	STD_LOGIC;
		---------------------------------------------------
		--			OUT_IF
		---------------------------------------------------
		Out_Data			: OUT	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		Out_DataV			: OUT	STD_LOGIC;
		Out_SOP			: OUT	STD_LOGIC;
		Out_EOP			: OUT	STD_LOGIC;
		Out_ErrOut		: OUT	STD_LOGIC;
		In_Data			: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		In_DataV			: IN		STD_LOGIC;
		In_SOP			: IN		STD_LOGIC;
		In_EOP			: IN		STD_LOGIC;
		In_ErrIn			: IN		STD_LOGIC;
		---------------------------------------------------
		--			Debug_IF
		---------------------------------------------------
		Status			: OUT	STD_LOGIC_VECTOR(3 downto 0)
	);
	END COMPONENT End_Arbitrator_2;

	COMPONENT EthLayer_Arbitrator_2 IS
	GENERIC(
		DataWidth			:		INTEGER	:=	DefDataWidth
		);
	PORT(
		CLK				: IN		STD_LOGIC;
		RST				: IN		STD_LOGIC;
		CE				: IN		STD_LOGIC;
		---------------------------------------------------
		--			IF0
		---------------------------------------------------
		DstMacAddr_In_0	: IN		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
		SrcMacAddr_In_0	: IN		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
		EthType_In_0		: IN		STD_LOGIC_VECTOR(EtherTypeSize-1 downto 0);
		In_0_Data			: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		In_0_DataV		: IN		STD_LOGIC;
		In_0_SOP			: IN		STD_LOGIC;
		In_0_EOP			: IN		STD_LOGIC;
		In_0_ErrIn		: IN		STD_LOGIC;
		In_0_Ind			: IN		STD_LOGIC;
		In_0_Ack			: OUT	STD_LOGIC;
		In_0_ErrOut		: OUT	STD_LOGIC;
		DstMacAddr_Out_0	: OUT	STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
		SrcMacAddr_Out_0	: OUT	STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
		EthType_Out_0		: OUT	STD_LOGIC_VECTOR(EtherTypeSize-1 downto 0);
		Out_0_Data		: OUT	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		Out_0_DataV		: OUT	STD_LOGIC;
		Out_0_SOP			: OUT	STD_LOGIC;
		Out_0_EOP			: OUT	STD_LOGIC;
		Out_0_ErrOut		: OUT	STD_LOGIC;
		---------------------------------------------------
		--			IF1
		---------------------------------------------------
		DstMacAddr_In_1	: IN		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
		SrcMacAddr_In_1	: IN		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
		EthType_In_1		: IN		STD_LOGIC_VECTOR(EtherTypeSize-1 downto 0);
		In_1_Data			: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		In_1_DataV		: IN		STD_LOGIC;
		In_1_SOP			: IN		STD_LOGIC;
		In_1_EOP			: IN		STD_LOGIC;
		In_1_ErrIn		: IN		STD_LOGIC;
		In_1_Ind			: IN		STD_LOGIC;
		In_1_Ack			: OUT	STD_LOGIC;
		In_1_ErrOut		: OUT	STD_LOGIC;
		Out_1_Data		: OUT	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		Out_1_DataV		: OUT	STD_LOGIC;
		Out_1_SOP			: OUT	STD_LOGIC;
		Out_1_EOP			: OUT	STD_LOGIC;
		Out_1_ErrOut		: OUT	STD_LOGIC;
		DstMacAddr_Out_1	: OUT	STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
		SrcMacAddr_Out_1	: OUT	STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
		EthType_Out_1		: OUT	STD_LOGIC_VECTOR(EtherTypeSize-1 downto 0);
		---------------------------------------------------
		--			OUT_IF
		---------------------------------------------------
		DstMacAddr_Out		: OUT	STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
		SrcMacAddr_Out		: OUT	STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
		EthType_Out		: OUT	STD_LOGIC_VECTOR(EtherTypeSize-1 downto 0);
		Out_Data			: OUT	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		Out_DataV			: OUT	STD_LOGIC;
		Out_SOP			: OUT	STD_LOGIC;
		OUT_EOP			: OUT	STD_LOGIC;
		Out_ErrOut		: OUT	STD_LOGIC;
		Out_ErrIn			: IN		STD_LOGIC;
		DstMacAddr_In		: IN		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
		SrcMacAddr_In		: IN		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
		EthType_In		: IN		STD_LOGIC_VECTOR(EtherTypeSize-1 downto 0);
		In_Data			: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
		In_DataV			: IN		STD_LOGIC;
		In_SOP			: IN		STD_LOGIC;
		In_EOP			: IN		STD_LOGIC;
		In_ErrIn			: IN		STD_LOGIC;
		In_ErrOut			: OUT	STD_LOGIC;
		---------------------------------------------------
		--			Debug_IF
		---------------------------------------------------
		Status			: OUT	STD_LOGIC_VECTOR(3 downto 0)
	);
	END COMPONENT EthLayer_Arbitrator_2;

END PACKAGE ProtoModulePkg;

-- ============================
PACKAGE BODY ProtoModulePkg IS
-- ============================

END PACKAGE BODY ProtoModulePkg;


LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;

USE work.ProtoLayerTypesAndDefs.ALL;

ENTITY End_Arbitrator_2 IS
GENERIC(
	DataWidth			:		INTEGER	:=	DefDataWidth
);
PORT(
	CLK				: IN		STD_LOGIC;
	RST				: IN		STD_LOGIC;
	CE				: IN		STD_LOGIC;
	---------------------------------------------------
	--			IF0
	---------------------------------------------------
	In_0_Data			: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
	In_0_DataV		: IN		STD_LOGIC;
	In_0_SOP			: IN		STD_LOGIC;
	In_0_EOP			: IN		STD_LOGIC;
	In_0_ErrIn		: IN		STD_LOGIC;
	In_0_Ind			: IN		STD_LOGIC;
	In_0_Ack			: OUT	STD_LOGIC;
	Out_0_Data		: OUT	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
	Out_0_DataV		: OUT	STD_LOGIC;
	Out_0_SOP			: OUT	STD_LOGIC;
	Out_0_EOP			: OUT	STD_LOGIC;
	Out_0_ErrOut		: OUT	STD_LOGIC;
	---------------------------------------------------
	--			IF1
	---------------------------------------------------
	In_1_Data			: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
	In_1_DataV		: IN		STD_LOGIC;
	In_1_SOP			: IN		STD_LOGIC;
	In_1_EOP			: IN		STD_LOGIC;
	In_1_ErrIn		: IN		STD_LOGIC;
	In_1_Ind			: IN		STD_LOGIC;
	In_1_Ack			: OUT	STD_LOGIC;
	Out_1_Data		: OUT	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
	Out_1_DataV		: OUT	STD_LOGIC;
	Out_1_SOP			: OUT	STD_LOGIC;
	Out_1_EOP			: OUT	STD_LOGIC;
	Out_1_ErrOut		: OUT	STD_LOGIC;
	---------------------------------------------------
	--			OUT_IF
	---------------------------------------------------
	Out_Data			: OUT	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
	Out_DataV			: OUT	STD_LOGIC;
	Out_SOP			: OUT	STD_LOGIC;
	Out_EOP			: OUT	STD_LOGIC;
	Out_ErrOut		: OUT	STD_LOGIC;
	In_Data			: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
	In_DataV			: IN		STD_LOGIC;
	In_SOP			: IN		STD_LOGIC;
	In_EOP			: IN		STD_LOGIC;
	In_ErrIn			: IN		STD_LOGIC;
	---------------------------------------------------
	--			Debug_IF
	---------------------------------------------------
	Status			: OUT	STD_LOGIC_VECTOR(3 downto 0)
);
END End_Arbitrator_2;

ARCHITECTURE ArchEnd_Arbitrator_2Behav OF End_Arbitrator_2 IS

--For Gigabit Ethernet received IFG can be reduced to a period OF 64 bit times (8 bytes).
CONSTANT	IFGAP		:		INTEGER	:=	8;
CONSTANT	IFGWidth		:		INTEGER	:=	3;
CONSTANT	IFGAP_vec		:		STD_LOGIC_VECTOR( IFGWidth-1 downto 0)	:=	"111";

SIGNAL	IFGAPCNTR		:		STD_LOGIC_VECTOR( IFGWidth-1 downto 0);

TYPE ARB_StateType IS(
	INIT,
	IDLE,
	IDLE_1stP,
	GRANT_0,
	IPGR_0,
	Finished_0,
	GRANT_1,
	IPGR_1,
	Finished_1
);
ATTRIBUTE ENUM_ENCODING	:		STRING;
SIGNAL	ARB_State		:		ARB_StateType;

CONSTANT	Status_Init		:		STD_LOGIC_VECTOR(3 downto 0)	:=	X"0";
CONSTANT	Status_IDLE		:		STD_LOGIC_VECTOR(3 downto 0)	:=	X"1";
CONSTANT	Status_IDLE_1stP	:		STD_LOGIC_VECTOR(3 downto 0)	:=	X"2";
CONSTANT	Status_GRANT_0		:		STD_LOGIC_VECTOR(3 downto 0)	:=	X"3";
CONSTANT	Status_IPGR_0		:		STD_LOGIC_VECTOR(3 downto 0)	:=	X"4";
CONSTANT	Status_Finished_0	:		STD_LOGIC_VECTOR(3 downto 0)	:=	X"5";
CONSTANT	Status_GRANT_1		:		STD_LOGIC_VECTOR(3 downto 0)	:=	X"6";
CONSTANT	Status_IPGR_1		:		STD_LOGIC_VECTOR(3 downto 0)	:=	X"7";
CONSTANT	Status_Finished_1	:		STD_LOGIC_VECTOR(3 downto 0)	:=	X"8";

BEGIN

	Out_0_Data	<=	In_Data;
	Out_0_DataV	<=	In_DataV;
	Out_0_SOP		<=	In_SOP;
	Out_0_EOP		<=	In_EOP;
	Out_0_ErrOut	<=	In_ErrIn;

	Out_1_Data	<=	In_Data;
	Out_1_DataV	<=	In_DataV;
	Out_1_SOP		<=	In_SOP;
	Out_1_EOP		<=	In_EOP;
	Out_1_ErrOut	<=	In_ErrIn;

	FSM_proc:PROCESS(	clk,
					rst,
					CE,
					ARB_State,
					In_0_Ind,
					In_0_ErrIn,
					In_1_Ind,
					In_1_ErrIn,
					In_0_DataV,
					In_0_SOP,
					In_0_EOP,
					IFGAPCNTR,
					In_1_DataV,
					In_1_SOP,
					In_1_EOP
					)
	BEGIN
		IF(RISING_EDGE(clk))THEN
			IF(rst = Hi) THEN
				In_0_Ack	<=	Lo;
				In_1_Ack		<=	Lo;
				Out_Data		<=	(OTHERS => Lo);
				Out_DataV		<=	Lo;
				Out_SOP		<=	Lo;
				Out_EOP		<=	Lo;
				Out_ErrOut	<=	Lo;
				IFGAPCNTR	<=	(OTHERS => Lo);
				Status	<=	Status_Init;
				ARB_State	<=	INIT;
			ELSIF(rst = Lo AND CE = Hi) THEN
				CASE ARB_State IS
					WHEN IDLE =>
						Status		<=	Status_IDLE;
						In_0_Ack		<=	Lo;
						In_1_Ack		<=	Lo;
						Out_Data		<=	(OTHERS => Lo);
						Out_DataV		<=	Lo;
						Out_SOP		<=	Lo;
						Out_EOP		<=	Lo;
						Out_ErrOut	<=	Lo;
						IFGAPCNTR	<=	(OTHERS => Lo);
						IF(In_0_Ind = Hi AND In_0_ErrIn = Lo) THEN
							ARB_State	<=	GRANT_0;
						ELSIF(In_0_Ind = Lo AND In_1_Ind = Hi AND In_1_ErrIn = Lo)THEN
							ARB_State	<=	GRANT_1;
						ELSE
							ARB_State	<=	IDLE;
						END IF;
					WHEN IDLE_1stP =>
						Status		<=	Status_IDLE_1stP;
						In_0_Ack		<=	Lo;
						In_1_Ack		<=	Lo;
						Out_Data		<=	(OTHERS => Lo);
						Out_DataV		<=	Lo;
						Out_SOP		<=	Lo;
						Out_EOP		<=	Lo;
						Out_ErrOut	<=	Lo;
						IFGAPCNTR	<=	(OTHERS => Lo);
						IF(In_1_Ind = Hi AND In_1_ErrIn = Lo) THEN
							ARB_State	<=	GRANT_1;
						ELSIF(In_1_Ind = Lo AND In_0_Ind = Hi AND In_0_ErrIn = Lo)THEN
							ARB_State	<=	GRANT_0;
						ELSE
							ARB_State	<=	IDLE_1stP;
						END IF;
					WHEN GRANT_0 =>
						Status	<=	Status_GRANT_0;
						In_0_Ack	<=	Hi;
						Out_Data	<=	In_0_Data;
						Out_DataV	<=	In_0_DataV;
						Out_SOP	<=	In_0_SOP;
						Out_EOP	<=	In_0_EOP;
						Out_ErrOut<=	In_0_ErrIn;
						IF(In_0_Ind = Hi AND In_0_ErrIn = Lo) THEN
							IF(In_0_DataV = Hi AND In_0_SOP = Hi) THEN
								ARB_State	<=	IPGR_0;
							ELSE
								ARB_State	<=	GRANT_0;
							END IF;
						ELSE
							ARB_State	<=	IDLE_1stP;
						END IF;
					WHEN IPGR_0 =>
						Status	<=	Status_IPGR_0;
						In_0_Ack	<=	Lo;
						Out_Data	<=	In_0_Data;
						Out_DataV	<=	In_0_DataV;
						Out_SOP	<=	In_0_SOP;
						Out_EOP	<=	In_0_EOP;
						Out_ErrOut<=	In_0_ErrIn;
						IF(In_0_ErrIn = Lo)THEN
							IF(In_0_DataV = Hi AND In_0_EOP = Hi) THEN
								ARB_State	<=	Finished_0;
							ELSE
								ARB_State	<=	IPGR_0;
							END IF;
						ELSE
							ARB_State	<=	Finished_0;
						END IF;
					WHEN Finished_0 =>
						Status	<=	Status_Finished_0;
						Out_Data	<=	(OTHERS => Lo);
						Out_DataV	<=	Lo;
						Out_SOP		<=	Lo;
						Out_EOP		<=	Lo;
						Out_ErrOut	<=	Lo;
						IFGAPCNTR	<=	IFGAPCNTR + 1;
						IF(IFGAPCNTR = IFGAP_vec)THEN
							ARB_State	<=	IDLE_1stP;
						ELSE
							ARB_State	<=	Finished_0;
						END IF;
					WHEN GRANT_1 =>
						Status	<=	Status_GRANT_1;
						In_1_Ack	<=	Hi;
						Out_Data	<=	In_1_Data;
						Out_DataV	<=	In_1_DataV;
						Out_SOP	<=	In_1_SOP;
						Out_EOP	<=	In_1_EOP;
						Out_ErrOut<=	In_1_ErrIn;
						IF(In_1_Ind = Hi AND In_1_ErrIn = Lo) THEN
							IF(In_1_DataV = Hi AND In_1_SOP = Hi) THEN
								ARB_State	<=	IPGR_1;
							ELSE
								ARB_State	<=	GRANT_1;
							END IF;
						ELSE
							ARB_State	<=	IDLE;
						END IF;
					WHEN IPGR_1 =>
						Status	<=	Status_IPGR_1;
						In_1_Ack	<=	Lo;
						Out_Data	<=	In_1_Data;
						Out_DataV	<=	In_1_DataV;
						Out_SOP	<=	In_1_SOP;
						Out_EOP	<=	In_1_EOP;
						Out_ErrOut<=	In_1_ErrIn;
						IF(In_1_ErrIn = Lo)THEN
							IF(In_1_DataV = Hi AND In_1_EOP = Hi) THEN
								ARB_State	<=	Finished_1;
							ELSE
								ARB_State	<=	IPGR_1;
							END IF;
						ELSE
							ARB_State	<=	Finished_1;
						END IF;
					WHEN Finished_1 =>
						Status		<=	Status_Finished_1;
						Out_Data		<=	(OTHERS => Lo);
						Out_DataV		<=	Lo;
						Out_SOP		<=	Lo;
						Out_EOP		<=	Lo;
						Out_ErrOut	<=	Lo;
						IFGAPCNTR		<=	IFGAPCNTR + 1;
						IF(IFGAPCNTR = IFGAP_vec)THEN
							ARB_State	<=	IDLE;
						ELSE
							ARB_State	<=	Finished_1;
						END IF;
					-- WHEN OTHERS => --INIT
					WHEN INIT =>
						Status		<=	Status_Init;
						In_0_Ack		<=	Lo;
						In_1_Ack		<=	Lo;
						Out_Data		<=	(OTHERS => Lo);
						Out_DataV		<=	Lo;
						Out_SOP		<=	Lo;
						Out_EOP		<=	Lo;
						Out_ErrOut	<=	Lo;
						IFGAPCNTR		<=	(OTHERS => Lo);
						ARB_State		<=	IDLE;
				END CASE;
			END IF;
		END IF;
	END PROCESS FSM_proc;
END ArchEnd_Arbitrator_2Behav;

LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;

USE work.ProtoLayerTypesAndDefs.ALL;

ENTITY EthLayer_Arbitrator_2 IS
GENERIC(
	DataWidth			:		INTEGER	:=	DefDataWidth
	);
PORT(
	CLK				: IN		STD_LOGIC;
	RST				: IN		STD_LOGIC;
	CE				: IN		STD_LOGIC;
	---------------------------------------------------
	--			IF0
	---------------------------------------------------
	DstMacAddr_In_0	: IN		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
	SrcMacAddr_In_0	: IN		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
	EthType_In_0		: IN		STD_LOGIC_VECTOR(EtherTypeSize-1 downto 0);
	In_0_Data			: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
	In_0_DataV		: IN		STD_LOGIC;
	In_0_SOP			: IN		STD_LOGIC;
	In_0_EOP			: IN		STD_LOGIC;
	In_0_ErrIn		: IN		STD_LOGIC;
	In_0_Ind			: IN		STD_LOGIC;
	In_0_Ack			: OUT	STD_LOGIC;
	In_0_ErrOut		: OUT	STD_LOGIC;
	DstMacAddr_Out_0	: OUT	STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
	SrcMacAddr_Out_0	: OUT	STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
	EthType_Out_0		: OUT	STD_LOGIC_VECTOR(EtherTypeSize-1 downto 0);
	Out_0_Data		: OUT	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
	Out_0_DataV		: OUT	STD_LOGIC;
	Out_0_SOP			: OUT	STD_LOGIC;
	Out_0_EOP			: OUT	STD_LOGIC;
	Out_0_ErrOut		: OUT	STD_LOGIC;
	---------------------------------------------------
	--			IF1
	---------------------------------------------------
	DstMacAddr_In_1	: IN		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
	SrcMacAddr_In_1	: IN		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
	EthType_In_1		: IN		STD_LOGIC_VECTOR(EtherTypeSize-1 downto 0);
	In_1_Data			: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
	In_1_DataV		: IN		STD_LOGIC;
	In_1_SOP			: IN		STD_LOGIC;
	In_1_EOP			: IN		STD_LOGIC;
	In_1_ErrIn		: IN		STD_LOGIC;
	In_1_Ind			: IN		STD_LOGIC;
	In_1_Ack			: OUT	STD_LOGIC;
	In_1_ErrOut		: OUT	STD_LOGIC;
	Out_1_Data		: OUT	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
	Out_1_DataV		: OUT	STD_LOGIC;
	Out_1_SOP			: OUT	STD_LOGIC;
	Out_1_EOP			: OUT	STD_LOGIC;
	Out_1_ErrOut		: OUT	STD_LOGIC;
	DstMacAddr_Out_1	: OUT	STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
	SrcMacAddr_Out_1	: OUT	STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
	EthType_Out_1		: OUT	STD_LOGIC_VECTOR(EtherTypeSize-1 downto 0);
	---------------------------------------------------
	--			OUT_IF
	---------------------------------------------------
	DstMacAddr_Out		: OUT	STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
	SrcMacAddr_Out		: OUT	STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
	EthType_Out		: OUT	STD_LOGIC_VECTOR(EtherTypeSize-1 downto 0);
	Out_Data			: OUT	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
	Out_DataV			: OUT	STD_LOGIC;
	Out_SOP			: OUT	STD_LOGIC;
	OUT_EOP			: OUT	STD_LOGIC;
	Out_ErrOut		: OUT	STD_LOGIC;
	Out_ErrIn			: IN		STD_LOGIC;
	DstMacAddr_In		: IN		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
	SrcMacAddr_In		: IN		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
	EthType_In		: IN		STD_LOGIC_VECTOR(EtherTypeSize-1 downto 0);
	In_Data			: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
	In_DataV			: IN		STD_LOGIC;
	In_SOP			: IN		STD_LOGIC;
	In_EOP			: IN		STD_LOGIC;
	In_ErrIn			: IN		STD_LOGIC;
	In_ErrOut			: OUT	STD_LOGIC;
	---------------------------------------------------
	--			Debug_IF
	---------------------------------------------------
	Status			: OUT	STD_LOGIC_VECTOR(3 downto 0)
);
END EthLayer_Arbitrator_2;

ARCHITECTURE ArchEthLayer_Arbitrator_2Behav OF EthLayer_Arbitrator_2 IS

TYPE ARB_StateType IS(
	INIT,
	IDLE,
	IDLE_1stP,
	GRANT_0,
	IPGR_0,
	Finished_0,
	GRANT_1,
	IPGR_1,
	Finished_1
);
ATTRIBUTE ENUM_ENCODING	:		STRING;
SIGNAL	ARB_State		:		ARB_StateType;

CONSTANT	Status_Init		:		STD_LOGIC_VECTOR(3 downto 0)	:=	X"0";
CONSTANT	Status_IDLE		:		STD_LOGIC_VECTOR(3 downto 0)	:=	X"1";
CONSTANT	Status_IDLE_1stP	:		STD_LOGIC_VECTOR(3 downto 0)	:=	X"2";
CONSTANT	Status_GRANT_0		:		STD_LOGIC_VECTOR(3 downto 0)	:=	X"3";
CONSTANT	Status_IPGR_0		:		STD_LOGIC_VECTOR(3 downto 0)	:=	X"4";
CONSTANT	Status_Finished_0	:		STD_LOGIC_VECTOR(3 downto 0)	:=	X"5";
CONSTANT	Status_GRANT_1		:		STD_LOGIC_VECTOR(3 downto 0)	:=	X"6";
CONSTANT	Status_IPGR_1		:		STD_LOGIC_VECTOR(3 downto 0)	:=	X"7";
CONSTANT	Status_Finished_1	:		STD_LOGIC_VECTOR(3 downto 0)	:=	X"8";

BEGIN

	Out_0_Data		<=	In_Data;
	Out_0_DataV		<=	In_DataV;
	Out_0_SOP			<=	In_SOP;
	Out_0_EOP			<=	In_EOP;
	Out_0_ErrOut		<=	In_ErrIn;
	DstMacAddr_Out_0	<=	DstMacAddr_In;
	SrcMacAddr_Out_0	<=	SrcMacAddr_In;
	EthType_Out_0		<=	EthType_In;
	
	Out_1_Data		<=	In_Data;
	Out_1_DataV		<=	In_DataV;
	Out_1_SOP			<=	In_SOP;
	Out_1_EOP			<=	In_EOP;
	Out_1_ErrOut		<=	In_ErrIn;
	DstMacAddr_Out_1	<=	DstMacAddr_In;
	SrcMacAddr_Out_1	<=	SrcMacAddr_In;
	EthType_Out_1		<=	EthType_In;
	
	In_ErrOut			<=	Lo;
	
	FSM_proc:PROCESS(	clk,
					rst,
					CE,
					ARB_State,
					In_0_Ind,
					In_0_ErrIn,
					In_1_Ind,
					In_1_ErrIn,
					In_0_DataV,
					In_0_SOP,
					In_0_EOP,
					In_1_DataV,
					In_1_SOP,
					In_1_EOP
					)
	BEGIN
		IF(RISING_EDGE(clk))THEN
			IF(rst = Hi) THEN
				In_0_Ack		<=	Lo;
				In_1_Ack		<=	Lo;
				In_0_ErrOut	<=	Lo;
				In_1_ErrOut	<=	Lo;
				Out_Data		<=	(OTHERS => Lo);
				Out_DataV		<=	Lo;
				Out_SOP		<=	Lo;
				Out_EOP		<=	Lo;
				Out_ErrOut	<=	Lo;
				Status		<=	Status_Init;
				ARB_State		<=	INIT;
			ELSIF(rst = Lo AND CE = Hi) THEN
				CASE ARB_State IS
					WHEN IDLE =>
						Status		<=	Status_IDLE;
						In_0_Ack		<=	Lo;
						In_1_Ack		<=	Lo;
						In_0_ErrOut	<=	Lo;
						In_1_ErrOut	<=	Lo;
						Out_Data		<=	(OTHERS => Lo);
						Out_DataV		<=	Lo;
						Out_SOP		<=	Lo;
						Out_EOP		<=	Lo;
						Out_ErrOut	<=	Lo;
						IF(In_0_Ind = Hi AND In_0_ErrIn = Lo) THEN
							ARB_State		<=	GRANT_0;
						ELSIF(In_0_Ind = Lo AND In_1_Ind = Hi AND In_1_ErrIn = Lo)THEN
							ARB_State		<=	GRANT_1;
						ELSE
							ARB_State		<=	IDLE;
						END IF;
					WHEN IDLE_1stP =>
						Status		<=	Status_IDLE_1stP;
						In_0_Ack		<=	Lo;
						In_1_Ack		<=	Lo;
						In_0_ErrOut	<=	Lo;
						In_1_ErrOut	<=	Lo;
						Out_Data		<=	(OTHERS => Lo);
						Out_DataV		<=	Lo;
						IF(In_1_Ind = Hi AND In_1_ErrIn = Lo) THEN
							ARB_State		<=	GRANT_1;
						ELSIF(In_1_Ind = Lo AND In_0_Ind = Hi AND In_0_ErrIn = Lo)THEN
							ARB_State		<=	GRANT_0;
						ELSE
							ARB_State		<=	IDLE_1stP;
						END IF;
					WHEN GRANT_0 =>
						Status	<=	Status_GRANT_0;
						In_0_Ack		<=	Hi;
						Out_Data		<=	In_0_Data;
						Out_DataV		<=	In_0_DataV;
						Out_SOP		<=	In_0_SOP;
						Out_EOP		<=	In_0_EOP;
						Out_ErrOut	<=	In_0_ErrIn;
						In_0_ErrOut	<=	Out_ErrIn;
						DstMacAddr_Out	<=	DstMacAddr_In_0;
						SrcMacAddr_Out	<=	SrcMacAddr_In_0;
						EthType_Out	<=	EthType_In_0;
						IF(In_0_Ind = Hi AND In_0_ErrIn = Lo) THEN
							IF(In_0_DataV = Hi AND In_0_SOP = Hi) THEN
								ARB_State	<=	IPGR_0;
							ELSE
								ARB_State	<=	GRANT_0;
							END IF;
						ELSE
							ARB_State	<=	IDLE_1stP;
						END IF;
					WHEN IPGR_0 =>
						Status	<=	Status_IPGR_0;
						In_0_Ack	<=	Lo;
						Out_Data		<=	In_0_Data;
						Out_DataV		<=	In_0_DataV;
						Out_SOP		<=	In_0_SOP;
						Out_EOP		<=	In_0_EOP;
						Out_ErrOut	<=	In_0_ErrIn;
						In_0_ErrOut	<=	Out_ErrIn;
						DstMacAddr_Out	<=	DstMacAddr_In_0;
						SrcMacAddr_Out	<=	SrcMacAddr_In_0;
						EthType_Out	<=	EthType_In_0;
						IF(In_0_ErrIn = Lo)THEN
							IF(In_0_DataV = Hi AND In_0_EOP = Hi) THEN
								ARB_State	<=	Finished_0;
							ELSE
								ARB_State	<=	IPGR_0;
							END IF;
						ELSE
							ARB_State	<=	Finished_0;
						END IF;
					WHEN Finished_0 =>
						Status		<=	Status_Finished_0;
						Out_Data		<=	(OTHERS => Lo);
						Out_DataV		<=	Lo;
						Out_SOP		<=	Lo;
						Out_EOP		<=	Lo;
						Out_ErrOut	<=	Lo;
						In_0_ErrOut	<=	Lo;
						ARB_State		<=	IDLE_1stP;
					WHEN GRANT_1 =>
						Status		<=	Status_GRANT_1;
						In_1_Ack		<=	Hi;
						Out_Data		<=	In_1_Data;
						Out_DataV		<=	In_1_DataV;
						Out_SOP		<=	In_1_SOP;
						Out_EOP		<=	In_1_EOP;
						Out_ErrOut	<=	In_1_ErrIn;
						In_1_ErrOut	<=	Out_ErrIn;
						DstMacAddr_Out	<=	DstMacAddr_In_1;
						SrcMacAddr_Out	<=	SrcMacAddr_In_1;
						EthType_Out	<=	EthType_In_1;
						IF(In_1_Ind = Hi AND In_1_ErrIn = Lo) THEN
							IF(In_1_DataV = Hi AND In_1_SOP = Hi) THEN
								ARB_State	<=	IPGR_1;
							ELSE
								ARB_State	<=	GRANT_1;
							END IF;
						ELSE
							ARB_State	<=	IDLE;
						END IF;
					WHEN IPGR_1 =>
						Status	<=	Status_IPGR_1;
						In_1_Ack	<=	Lo;
						Out_Data		<=	In_1_Data;
						Out_DataV		<=	In_1_DataV;
						Out_SOP		<=	In_1_SOP;
						Out_EOP		<=	In_1_EOP;
						Out_ErrOut	<=	In_1_ErrIn;
						In_1_ErrOut	<=	Out_ErrIn;
						DstMacAddr_Out	<=	DstMacAddr_In_1;
						SrcMacAddr_Out	<=	SrcMacAddr_In_1;
						EthType_Out	<=	EthType_In_1;
						IF(In_1_ErrIn = Lo)THEN
							IF(In_1_DataV = Hi AND In_1_EOP = Hi) THEN
								ARB_State	<=	Finished_1;
							ELSE
								ARB_State	<=	IPGR_1;
							END IF;
						ELSE
							ARB_State	<=	Finished_1;
						END IF;
					WHEN Finished_1 =>
						Status	<=	Status_Finished_1;
						Out_Data		<=	(OTHERS => Lo);
						Out_DataV		<=	Lo;
						Out_SOP		<=	Lo;
						Out_EOP		<=	Lo;
						Out_ErrOut	<=	Lo;
						In_1_ErrOut	<=	Lo;
						ARB_State	<=	IDLE;
					-- WHEN OTHERS => --INIT
					WHEN INIT =>
						Status		<=	Status_Init;
						In_0_Ack		<=	Lo;
						In_1_Ack		<=	Lo;
						Out_Data		<=	(OTHERS => Lo);
						Out_DataV		<=	Lo;
						Out_SOP		<=	Lo;
						Out_EOP		<=	Lo;
						Out_ErrOut	<=	Lo;
						In_0_ErrOut	<=	Lo;
						In_1_ErrOut	<=	Lo;
						ARB_State	<=	IDLE;
				END CASE;
			END IF;
		END IF;
	END PROCESS FSM_proc;
END ArchEthLayer_Arbitrator_2Behav;



LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;

--LIBRARY work;
USE work.arch.aFlop;
USE work.arch.aRegister;
USE work.ProtoLayerTypesAndDefs.ALL;

ENTITY PDUMux IS
generic(
	Datawidth				: INTEGER := DefDataWidth
);
PORT(
	CLK					: IN		STD_LOGIC;
	SEL					: IN		STD_LOGIC;
	----------------------------------------------------------------------------
	I_0					: IN		STD_LOGIC_VECTOR(Datawidth -1 downto 0);
	UI_0					: IN		STD_LOGIC_VECTOR(USER_width -1 downto 0);
	DV_0					: IN		STD_LOGIC;
	SOP_0				: IN		STD_LOGIC;
	EOP_0				: IN		STD_LOGIC;
	ERRIn_0				: IN		STD_LOGIC;
	IndIn_0				: IN		STD_LOGIC;
	AckOut_0				: OUT	STD_LOGIC;
	ErrOut_0				: OUT	STD_LOGIC;
	----------------------------------------------------------------------------
	I_1					: IN		STD_LOGIC_VECTOR(Datawidth -1 downto 0);
	UI_1					: IN		STD_LOGIC_VECTOR(USER_width -1 downto 0);
	DV_1					: IN		STD_LOGIC;
	SOP_1				: IN		STD_LOGIC;
	EOP_1				: IN		STD_LOGIC;
	ERRIn_1				: IN		STD_LOGIC;
	IndIn_1				: IN		STD_LOGIC;
	AckOut_1				: OUT	STD_LOGIC;
	ErrOut_1				: OUT	STD_LOGIC;
	----------------------------------------------------------------------------
	Q					: OUT	STD_LOGIC_VECTOR(Datawidth -1 downto 0);
	QU					: OUT	STD_LOGIC_VECTOR(USER_width -1 downto 0);
	Q_DV					: OUT	STD_LOGIC;
	Q_SOP				: OUT	STD_LOGIC;
	Q_EOP				: OUT	STD_LOGIC;
	Q_ERROut				: OUT	STD_LOGIC;
	Q_Ind				: OUT	STD_LOGIC;
	Q_AckIn				: IN		STD_LOGIC;
	Q_ErrIn				: IN		STD_LOGIC
);
END  PDUMux;

ARCHITECTURE BehavioralPDUMux OF PDUMux IS

SIGNAL	SEL_sig			:	STD_LOGIC;

SIGNAL	I_0_sig			:	STD_LOGIC_VECTOR(Datawidth -1 downto 0);
SIGNAL	UI_0_sig			:	STD_LOGIC_VECTOR(USER_width -1 downto 0);
SIGNAL	DV_0_sig			:	STD_LOGIC;
SIGNAL	SOP_0_sig			:	STD_LOGIC;
SIGNAL	EOP_0_sig			:	STD_LOGIC;
SIGNAL	ERRIn_0_sig		:	STD_LOGIC;
SIGNAL	IndIn_0_sig		:	STD_LOGIC;
SIGNAL	AckOut_0_sig		:	STD_LOGIC;
SIGNAL	ErrOut_0_sig		:	STD_LOGIC;

SIGNAL	I_1_sig			:	STD_LOGIC_VECTOR(Datawidth -1 downto 0);
SIGNAL	UI_1_sig			:	STD_LOGIC_VECTOR(USER_width -1 downto 0);
SIGNAL	DV_1_sig			:	STD_LOGIC;
SIGNAL	SOP_1_sig			:	STD_LOGIC;
SIGNAL	EOP_1_sig			:	STD_LOGIC;
SIGNAL	ERRIn_1_sig		:	STD_LOGIC;
SIGNAL	IndIn_1_sig		:	STD_LOGIC;
SIGNAL	AckOut_1_sig		:	STD_LOGIC;
SIGNAL	ErrOut_1_sig		:	STD_LOGIC;

SIGNAL	Q_sig			:	STD_LOGIC_VECTOR(Datawidth -1 downto 0);
SIGNAL	QU_sig			:	STD_LOGIC_VECTOR(USER_width -1 downto 0);
SIGNAL	Q_DV_sig			:	STD_LOGIC;
SIGNAL	Q_SOP_sig			:	STD_LOGIC;
SIGNAL	Q_EOP_sig			:	STD_LOGIC;
SIGNAL	Q_ERROut_sig		:	STD_LOGIC;
SIGNAL	Q_Ind_sig			:	STD_LOGIC;
SIGNAL	Q_AckIn_sig		:	STD_LOGIC;
SIGNAL	Q_ErrIn_sig		:	STD_LOGIC;

BEGIN

SEL_reg		:	aFlop								PORT MAP(D=>SEL,C=>CLK,CE=>Hi,Q=>SEL_sig);

I_0_reg		:	aRegister	GENERIC MAP(Size =>	Datawidth)	PORT MAP(D=>I_0,C=>CLK,CE=>Hi,Q=>I_0_sig);
UI_0_reg		:	aRegister	GENERIC MAP(Size =>	USER_width)	PORT MAP(D=>UI_0,C=>CLK,CE=>Hi,Q=>UI_0_sig);
DV_0_reg		:	aFlop								PORT MAP(D=>DV_0,C=>CLK,CE=>Hi,Q=>DV_0_sig);
SOP_0_reg		:	aFlop								PORT MAP(D=>SOP_0,C=>CLK,CE=>Hi,Q=>SOP_0_sig);
EOP_0_reg		:	aFlop								PORT MAP(D=>EOP_0,C=>CLK,CE=>Hi,Q=>EOP_0_sig);
ERRIn_0_reg	:	aFlop								PORT MAP(D=>ERRIn_0,C=>CLK,CE=>Hi,Q=>ERRIn_0_sig);
IndIn_0_reg	:	aFlop								PORT MAP(D=>IndIn_0,C=>CLK,CE=>Hi,Q=>IndIn_0_sig);
AckOut_0_reg	:	aFlop								PORT MAP(D=>AckOut_0_sig,C=>CLK,CE=>Hi,Q=>AckOut_0);
ERROut_0_reg	:	aFlop								PORT MAP(D=>ErrOut_0_sig,C=>CLK,CE=>Hi,Q=>ErrOut_0);


I_1_reg		:	aRegister	GENERIC MAP(Size =>	Datawidth)	PORT MAP(D=>I_1,C=>CLK,CE=>Hi,Q=>I_1_sig);
UI_1_reg		:	aRegister	GENERIC MAP(Size =>	USER_width)	PORT MAP(D=>UI_1,C=>CLK,CE=>Hi,Q=>UI_1_sig);
DV_1_reg		:	aFlop								PORT MAP(D=>DV_1,C=>CLK,CE=>Hi,Q=>DV_1_sig);
SOP_1_reg		:	aFlop								PORT MAP(D=>SOP_1,C=>CLK,CE=>Hi,Q=>SOP_1_sig);
EOP_1_reg		:	aFlop								PORT MAP(D=>EOP_1,C=>CLK,CE=>Hi,Q=>EOP_1_sig);
ERRIn_1_reg	:	aFlop								PORT MAP(D=>ERRIn_1,C=>CLK,CE=>Hi,Q=>ERRIn_1_sig);
IndIn_1_reg	:	aFlop								PORT MAP(D=>IndIn_1,C=>CLK,CE=>Hi,Q=>IndIn_1_sig);
AckOut_1_reg	:	aFlop								PORT MAP(D=>AckOut_1_sig,C=>CLK,CE=>Hi,Q=>AckOut_1);
ERROut_1_reg	:	aFlop								PORT MAP(D=>ErrOut_1_sig,C=>CLK,CE=>Hi,Q=>ErrOut_1);

Q_reg		:	aRegister	GENERIC MAP(Size =>	Datawidth)	PORT MAP(D=>Q_sig,C=>CLK,CE=>Hi,Q=>Q);
QU_reg		:	aRegister	GENERIC MAP(Size =>	USER_width)	PORT MAP(D=>QU_sig,C=>CLK,CE=>Hi,Q=>QU);
Q_DV_reg		:	aFlop								PORT MAP(D=>Q_DV_sig,C=>CLK,CE=>Hi,Q=>Q_DV);
Q_SOP_reg		:	aFlop								PORT MAP(D=>Q_SOP_sig,C=>CLK,CE=>Hi,Q=>Q_SOP);
Q_EOP_reg		:	aFlop								PORT MAP(D=>Q_EOP_sig,C=>CLK,CE=>Hi,Q=>Q_EOP);
Q_ERRout_reg	:	aFlop								PORT MAP(D=>Q_ERROut_sig,C=>CLK,CE=>Hi,Q=>Q_ERROut);
Q_Ind_reg		:	aFlop								PORT MAP(D=>Q_Ind_sig,C=>CLK,CE=>Hi,Q=>Q_Ind);
Q_AckIn_reg	:	aFlop								PORT MAP(D=>Q_AckIn,C=>CLK,CE=>Hi,Q=>Q_AckIn_sig);
Q_ERRIn_reg	:	aFlop								PORT MAP(D=>Q_ErrIn,C=>CLK,CE=>Hi,Q=>Q_ErrIn_sig);

WITH SEL_sig SELECT	Q_sig		<=	I_0_sig		WHEN '0',	I_1_sig		WHEN '1',	(OTHERS =>'X')	WHEN	OTHERS;
WITH SEL_sig SELECT	QU_sig		<=	UI_0_sig		WHEN '0',	UI_1_sig		WHEN '1',	(OTHERS =>'X')	WHEN	OTHERS;
WITH SEL_sig SELECT	Q_DV_sig		<=	DV_0_sig		WHEN '0',	DV_1_sig		WHEN '1',	'X'			WHEN	OTHERS;
WITH SEL_sig SELECT	Q_SOP_sig		<=	SOP_0_sig		WHEN '0',	SOP_1_sig		WHEN '1',	'X'			WHEN	OTHERS;
WITH SEL_sig SELECT	Q_EOP_sig		<=	EOP_0_sig		WHEN '0',	EOP_1_sig		WHEN '1',	'X'			WHEN	OTHERS;
WITH SEL_sig SELECT	Q_ERROut_sig	<=	ERRIn_0_sig	WHEN '0',	ERRIn_1_sig	WHEN '1',	'X'			WHEN	OTHERS;
WITH SEL_sig SELECT	Q_Ind_sig		<=	IndIn_0_sig	WHEN '0',	IndIn_1_sig	WHEN '1',	'X'			WHEN	OTHERS;
WITH SEL_sig SELECT	AckOut_0_sig	<=	Q_AckIn_sig	WHEN '0',	Lo			WHEN '1',	'X'			WHEN	OTHERS;
WITH SEL_sig SELECT	ErrOut_0_sig	<=	Q_ErrIn_sig	WHEN '0',	Lo			WHEN '1',	'X'			WHEN	OTHERS;
WITH SEL_sig SELECT	AckOut_1_sig	<=	Lo			WHEN '0',	Q_AckIn_sig	WHEN '1',	'X'			WHEN	OTHERS;
WITH SEL_sig SELECT	ErrOut_1_sig	<=	Lo			WHEN '0',	Q_ErrIn_sig	WHEN '1',	'X'			WHEN	OTHERS;

END BehavioralPDUMux;



	--
-- ProtoModule_TXPart.vhd
-- ============
--
-- (C) Ferenc Janky, BME TMIT
--   file name:	ProtoModule_TXPart.vhd
--   PACKAGE:		ProtoModulePkg
--
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;

LIBRARY UNISIM;
USE UNISIM.vcomponents.ALL;

--LIBRARY work;
USE work.ProtoLayerTypesAndDefs.ALL;
USE work.ProtoModulePkg.ALL;
USE work.ProtoModulePkg.PDUQueue;

ENTITY ProtoModule_TXPart IS
GENERIC
(
	DataWidth				:		INTEGER	:=	DefDataWidth;
	SYNC_IN_SDU			:		BOOLEAN	:=	false;
	SYNC_IN_PCI			:		BOOLEAN	:=	false;
	SYNC_OUT				:		BOOLEAN	:=	false;
	MINSDUSize			:		INTEGER	:=	64;
	MAXSDUSize			:		INTEGER	:=	1500;
	MaxSDUToQ				:		INTEGER	:=	30;
	MINPCISize			:		INTEGER	:=	64;
	MAXPCISize			:		INTEGER	:=	64;
	MaxPCIToQ				:		INTEGER	:=	30
);
PORT
(
	CLK					: IN		STD_LOGIC;
	CE					: IN		STD_LOGIC;
	RST					: IN		STD_LOGIC;
	-------------------------------------------------------------
	PCI_DIN				: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
	PCI_DINV				: IN		STD_LOGIC;
	PCI_SOP				: IN		STD_LOGIC;
	PCI_EOP				: IN		STD_LOGIC;
	PCI_Ind				: IN		STD_LOGIC;
	PCI_ErrIn				: IN		STD_LOGIC;
	PCI_USER_In			: IN		STD_LOGIC_VECTOR(USER_width-1 downto 0);
	PCI_Ack				: OUT	STD_LOGIC;
	PCI_ErrOut			: OUT	STD_LOGIC;
	-------------------------------------------------------------
	SDU_DIN				: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
	SDU_DINV				: IN		STD_LOGIC;
	SDU_SOP				: IN		STD_LOGIC;
	SDU_EOP				: IN		STD_LOGIC;
	SDU_Ind				: IN		STD_LOGIC;
	SDU_ErrIn				: IN		STD_LOGIC;
	SDU_USER_In			: IN		STD_LOGIC_VECTOR(USER_width-1 downto 0);
	SDU_Ack				: OUT	STD_LOGIC;
	SDU_ErrOut			: OUT	STD_LOGIC;
	-------------------------------------------------------------
	DOUT					: OUT	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
	DOUTV				: OUT	STD_LOGIC;
	Out_SOP				: OUT	STD_LOGIC;
	Out_EOP				: OUT	STD_LOGIC;
	Out_Ind				: OUT	STD_LOGIC;
	Out_ErrOut			: OUT	STD_LOGIC;
	USER_Out				: OUT	STD_LOGIC_VECTOR(USER_width-1 downto 0);
	Out_Ack				: IN		STD_LOGIC;
	Out_ErrIn				: IN		STD_LOGIC
);
END ProtoModule_TXPart;

ARCHITECTURE ARCH_ProtoModule_TXPart OF ProtoModule_TXPart IS

CONSTANT MAXPDUtoQ				: INTEGER						:= maximum(MaxPCIToQ,MaxSDUToQ);
CONSTANT PDUMUX_Delay			: STD_LOGIC_VECTOR(1 downto 0)	:= "10";
CONSTANT INIT_Delay				: STD_LOGIC_VECTOR(1 downto 0)	:= "11";
CONSTANT ASQ_In_Delay			: STD_LOGIC_VECTOR(1 downto 0)	:= STD_LOGIC_VECTOR(to_unsigned(PDUQ_INPUT_DELAY,2));

TYPE ASMControl_State_Type IS
(
	INIT,
	IDLE,
	ASM_Start,
	JustPCIASM,
	PCI_Part_Start,
	PCI_Part_IPGR,
	DISABLE_ASMQIN_WError,
	SDU_Part_IPGR_WError,
	DISABLE_ASMQIN,
	SEND_ACK,
	SDU_Part_IPGR,
	ASM_COMPLETE,
	WFOR_Out,
	ASM_ERROR
);


ATTRIBUTE ENUM_ENCODING : STRING;
----------------
----------------
--ASMControl part  signals
----------------
--FSM signals
SIGNAL	ASMCTRL_State		:	ASMControl_State_Type;
-- SIGNAL	PDUMUX_Delay_CNTR	:	STD_LOGIC_VECTOR(PDUMUX_Delay'Length -1 downto 0);
SIGNAL	INIT_Delay_CNTR	:	STD_LOGIC_VECTOR(INIT_Delay'Length -1 downto 0);
SIGNAL	ASQ_In_Delay_CNTR	:	STD_LOGIC_VECTOR(INIT_Delay'Length -1 downto 0);
----------------
-- OUTPUT signals
SIGNAL	PCI_SDU_switch		:	STD_LOGIC;
SIGNAL	SDU_Out_Ack_OVR	:	STD_LOGIC;
SIGNAL	ASQ_InEOP_OVRN		:	STD_LOGIC;
SIGNAL	SDU_Out_Ack_OVR_sig	:	STD_LOGIC;
SIGNAL	SDU_Out_Ind_OVRN	:	STD_LOGIC;
SIGNAL	PCI_Out_Ind_OVRN	:	STD_LOGIC;
SIGNAL	PCI_Out_Ack_OVRN	:	STD_LOGIC;

----------------
----------------
--Supplementay  signals
----------------
SIGNAL	ASQ_Ack			:	STD_LOGIC;
SIGNAL	PCI_Out_SOP		:	STD_LOGIC;
SIGNAL	PCI_Out_EOP		:	STD_LOGIC;
SIGNAL	PCI_Out_Ind		:	STD_LOGIC;
SIGNAL	PCI_Out_Ind_sig	:	STD_LOGIC;
SIGNAL	SDU_Out_SOP		:	STD_LOGIC;
SIGNAL	SDU_Out_EOP		:	STD_LOGIC;
SIGNAL	SDU_Out_Ind		:	STD_LOGIC;
SIGNAL	SDU_Out_Ind_sig	:	STD_LOGIC;
SIGNAL	ASQ_SOP			:	STD_LOGIC;
SIGNAL	ASQ_EOP			:	STD_LOGIC;
SIGNAL	asq_out_eop		:	STD_LOGIC;
SIGNAL	ASQ_Ind			:	STD_LOGIC;
SIGNAL	PCI_Out_Ack		:	STD_LOGIC;
SIGNAL	SDU_Out_Ack		:	STD_LOGIC;
SIGNAL	ASQ_DIN			:	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
SIGNAL	ASQ_DINV			:	STD_LOGIC;
SIGNAL	ASQ_DOUTV			:	STD_LOGIC;
SIGNAL	ASQ_ErrIn			:	STD_LOGIC;
SIGNAL	ASQ_EOP_sig		:	STD_LOGIC;
--SIGNAL	ASQ_EOP			:	STD_LOGIC;
SIGNAL	ASQ_ErrOut		:	STD_LOGIC;
SIGNAL	ASQ_CEIn			:	STD_LOGIC;
SIGNAL	ASQ_CEOut			:	STD_LOGIC;
SIGNAL	ASQ_OUT_SOP		:	STD_LOGIC;
SIGNAL	ASQ_Out_ErrOut		:	STD_LOGIC;
SIGNAL	PCI_DOut			:	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
SIGNAL	PCI_DOutV			:	STD_LOGIC;
SIGNAL	PCI_Out_ErrIn		:	STD_LOGIC;
--SIGNAL	PCI_Out_ErrIn_sig	:	STD_LOGIC;
SIGNAL	PCI_Out_ErrOut		:	STD_LOGIC;
SIGNAL	SDU_DOut			:	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
SIGNAL	SDU_DOutV			:	STD_LOGIC;
SIGNAL	SDU_Out_ErrIn		:	STD_LOGIC;
--SIGNAL	SDU_Out_ErrIn_sig	:	STD_LOGIC;
SIGNAL	SDU_Out_ErrOut		:	STD_LOGIC;
SIGNAL	PCI_Out_Ack_sig 	:	STD_LOGIC;

SIGNAL	PCI_USER_Out		:	STD_LOGIC_VECTOR(USER_width-1 downto 0);
SIGNAL	SDU_USER_Out		:	STD_LOGIC_VECTOR(USER_width-1 downto 0);
SIGNAL	ASQ_USER_In		:	STD_LOGIC_VECTOR(USER_width-1 downto 0);


SIGNAL	Just_PCIPart_sig	:	STD_LOGIC;

BEGIN


FSM_ASM_CORE:PROCESS(	clk,
					RST,
					CE,
					PCI_Out_Ind,
					SDU_Out_Ind,
					ASQ_DOUTV,
					ASQ_Out_EOP,
					ASQ_Ack,
					ASQ_SOP,
					Just_PCIPart_sig,
					ASQ_ErrIn,
					ASQ_EOP,
					PCI_Out_EOP,
					PCI_DOutV,
					ASQ_In_Delay_CNTR,
					SDU_DOUTV,
					SDU_Out_SOP,
					SDU_Out_EOP,
					INIT_Delay_CNTR,
					ASQ_OUT_SOP,
					ASQ_Out_ErrOut,
					Out_ErrIn
				)
BEGIN
IF(RISING_EDGE(clk)) THEN
	IF(rst = Hi)THEN
		PCI_SDU_switch		<=	Lo;
		SDU_Out_Ack_OVR	<=	Lo;
		ASQ_CEIn			<=	Hi;
		ASQ_CEOut			<=	Hi;
		ASQ_InEOP_OVRN		<=	Lo;
		SDU_Out_Ind_OVRN	<=	Lo;
		PCI_Out_Ind_OVRN	<=	Lo;
		PCI_Out_Ack_OVRN	<=	Lo;
		INIT_Delay_CNTR	<=	(OTHERS =>	Lo);
		ASQ_In_Delay_CNTR	<=	(OTHERS =>	Lo);
		ASMCTRL_State		<=	INIT;
	ELSE
		IF(CE = Hi) THEN
			CASE ASMCTRL_State IS
				WHEN IDLE =>
					ASQ_CEIn			<=	Lo;
					PCI_SDU_switch		<=	Lo;
					ASQ_InEOP_OVRN		<=	Lo;
					IF((PCI_Out_Ind = Hi or SDU_Out_Ind = Hi) AND ASQ_DOUTV = Lo) THEN
						ASQ_CEOut			<=	Lo;
						ASMCTRL_State		<=	ASM_Start;
					ELSIF((PCI_Out_Ind = Hi or SDU_Out_Ind = Hi) AND ASQ_DOUTV = Hi AND ASQ_Out_EOP = Hi) THEN
						ASMCTRL_State		<=	ASM_Start;
					ELSE
						ASMCTRL_State		<=	IDLE;
					END IF;
				WHEN ASM_Start =>
					PCI_Out_Ind_OVRN	<=	Hi;
					PCI_Out_Ack_OVRN	<=	Hi;
					ASQ_CEOut			<=	Lo;
					ASQ_CEIn			<=	Hi;
					IF(ASQ_Ack = Hi) THEN
						ASMCTRL_State	<=	PCI_Part_Start;
					ELSE
						ASMCTRL_State	<=	ASM_Start;
					END IF;
				WHEN PCI_Part_Start =>
					-- PCI_Out_Ind_OVRN	<=	Lo;
					IF(ASQ_DINV = Hi AND ASQ_SOP = Hi) THEN
						IF(Just_PCIPart_sig = Hi) THEN
							ASMCTRL_State	<=	JustPCIASM;
						ELSE
							ASQ_InEOP_OVRN	<=	Lo;
							ASMCTRL_State	<=	PCI_Part_IPGR;
						END IF;
					ELSE
						ASMCTRL_State	<=	PCI_Part_Start;
					END IF;
				WHEN JustPCIASM =>
					ASQ_CEOut			<=	Hi;
					PCI_Out_Ind_OVRN	<=	Lo;
					PCI_Out_Ack_OVRN	<=	Lo;
					IF(ASQ_ErrIn = Hi) THEN
						ASMCTRL_State	<=	ASM_ERROR;
					ELSIF(ASQ_DINV = Hi AND ASQ_EOP = Hi) THEN
						ASMCTRL_State	<=	ASM_COMPLETE;
					ELSE
						ASMCTRL_State	<=	JustPCIASM;
					END IF;
				WHEN	PCI_Part_IPGR =>
					ASQ_InEOP_OVRN		<=	Lo;
					PCI_Out_Ind_OVRN	<=	Lo;
					PCI_Out_Ack_OVRN	<=	Lo;
					IF(ASQ_ErrIn = Hi) THEN --itt azért nem kell figyelni, mert különben beragad az SDU
						ASMCTRL_State	<=	DISABLE_ASMQIN_WError;--azért működik, mert mivel az ASQ megkapja az errort, így az idle-be fog már menni előbb,
													-- de mivel az sdu rész handshake nélkül megy le, így az nem kerül bele a fifoba
					ELSE
						IF(PCI_Out_EOP = Hi AND PCI_DOutV = Hi) THEN
							ASQ_In_Delay_CNTR	<=	ASQ_In_Delay - 1;
							ASMCTRL_State		<=	DISABLE_ASMQIN;
						ELSE
							ASMCTRL_State		<=	PCI_Part_IPGR;
						END IF;
					END IF;
				WHEN	DISABLE_ASMQIN_WError =>
					PCI_SDU_switch		<=	Hi;
					SDU_Out_Ack_OVR	<=	Hi;
					ASQ_CEIn			<=	Lo;
					IF(SDU_OUT_Ind = Hi)THEN
						IF(SDU_DOUTV = Hi AND SDU_Out_SOP = Hi) THEN
							ASMCTRL_State		<=	SDU_Part_IPGR_WError;
						ELSE
							ASMCTRL_State		<=	DISABLE_ASMQIN_WError;
						END IF;
					ELSE
						ASMCTRL_State		<=	IDLE; --EZ elvileg nem fordulhat elő
					END IF;
				WHEN SDU_Part_IPGR_WError =>
					SDU_Out_Ack_OVR	<=	Lo;
					IF((SDU_DOUTV = Hi AND SDU_Out_EOP = Hi) OR SDU_Out_ErrOut = Hi) THEN
						ASMCTRL_State		<=	IDLE;
					ELSE
						ASMCTRL_State		<=	SDU_Part_IPGR_WError;
					END IF;
				WHEN	DISABLE_ASMQIN =>
					PCI_SDU_switch	<=	Hi;
					IF(ASQ_In_Delay_CNTR = ASQ_In_Delay) THEN
						ASQ_In_Delay_CNTR	<=	(OTHERS => Lo);
						ASQ_CEIn			<=	Lo;
						-- ASQ_InEOP_OVRN		<=	Hi;
						ASMCTRL_State		<=	SEND_ACK;
					ELSE
						ASQ_In_Delay_CNTR	<=	ASQ_In_Delay_CNTR + 1;
						ASMCTRL_State		<=	DISABLE_ASMQIN;
					END IF;
				WHEN	SEND_ACK =>
					SDU_Out_Ack_OVR	<=	Hi;
					ASQ_InEOP_OVRN		<=	Hi;
					IF(SDU_DOUTV = Hi AND SDU_Out_SOP = Hi) THEN
						ASMCTRL_State		<=	SDU_Part_IPGR;
					ELSE
						ASMCTRL_State		<=	SEND_ACK;
					END IF;
				WHEN SDU_Part_IPGR =>
					ASQ_CEOut			<=	Hi;
					ASQ_CEIn			<=	Hi;
					SDU_Out_Ack_OVR	<=	Lo;
					IF(ASQ_ErrIn = Hi) THEN
						ASMCTRL_State	<=	ASM_ERROR;
					ELSE
						IF(ASQ_DINV = Hi AND ASQ_EOP = Hi) THEN
						-- IF(SDU_DOUTV = Hi AND SDU_Out_EOP = Hi) THEN
							ASMCTRL_State	<=	ASM_COMPLETE;
						ELSE
							ASMCTRL_State	<=	SDU_Part_IPGR;
						END IF;
					END IF;
				WHEN ASM_COMPLETE =>
					PCI_SDU_switch	<=	Lo;
					IF(ASQ_In_Delay_CNTR = ASQ_In_Delay) THEN
						PCI_SDU_switch	<=	Lo;
						ASQ_In_Delay_CNTR	<=	(OTHERS =>	Lo);
						ASQ_CEIn			<=	Lo;
						ASMCTRL_State		<=	WFOR_Out;
					ELSE
						ASQ_In_Delay_CNTR	<=	ASQ_In_Delay_CNTR +1;
						ASMCTRL_State		<=	ASM_COMPLETE;
					END IF;
				WHEN WFOR_Out =>
					IF(ASQ_DOUTV = Hi OR ASQ_Out_ErrOut = Hi OR Out_ErrIn = Hi)THEN
						ASMCTRL_State		<=	IDLE;
					ELSE
						ASMCTRL_State		<=	WFOR_Out;
					END IF;
				WHEN ASM_ERROR =>
					ASMCTRL_State	<=	IDLE;
				-- WHEN INIT =>
				WHEN OTHERS =>	--INIT
					PCI_SDU_switch		<=	Lo;
					SDU_Out_Ack_OVR	<=	Lo;
					ASQ_CEIn			<=	Hi;
					ASQ_CEOut			<=	Hi;
					IF(INIT_Delay_CNTR = INIT_Delay) THEN
						ASQ_CEIn			<=	Lo;
						ASMCTRL_State		<=	IDLE;
					ELSE
						INIT_Delay_CNTR	<=	INIT_Delay_CNTR + 1;
						ASMCTRL_State		<=	INIT;
					END IF;
			END CASE;
		END IF;
	END IF;
END IF;
END PROCESS FSM_ASM_CORE;


-- SDU_Out_Ack_OVR_sig	<=	SDU_Out_Ack_OVR or SDU_Out_Ack;
SDU_Out_Ack_OVR_sig	<=	SDU_Out_Ack_OVR;
Out_SOP			<=	ASQ_OUT_SOP;
Out_ErrOut		<=	ASQ_Out_ErrOut;
	Assembly_Queue: PDUQueue --IN pass-through mode!
	GENERIC MAP
	(
		DataWidth		=>	DataWidth,
		SYNC_IN		=>	true,
		SYNC_OUT		=>	SYNC_OUT,
		SYNC_CTRL		=>	false,
		MINPDUSize	=>	MINPCISize + MINSDUSize,
		MAXPDUSize	=>	MAXPCISize + MAXSDUSize,
		MaxPDUToQ		=>	MAXPDUtoQ
	)
	PORT MAP
	(
		CLK			=>	CLK,
		CE_In		=>	ASQ_CEIn,
		CE_Out		=>	ASQ_CEOut,
		RST			=>	RST,
		DIN			=>	ASQ_DIN,
		DINV			=>	ASQ_DINV,
		In_SOP		=>	ASQ_SOP,
		In_EOP		=>	ASQ_EOP_sig,
		In_Ind		=>	ASQ_Ind,
		In_ErrIn		=>	ASQ_ErrIn,
		In_Ack		=>	ASQ_Ack,
		In_ErrOut		=>	ASQ_ErrOut,
		DOUT			=>	DOUT,
		DOUTV		=>	ASQ_DOUTV ,
		Out_SOP		=>	ASQ_OUT_SOP,
		Out_EOP		=>	asq_out_eop,
		Out_Ind		=>	Out_Ind,
		Out_ErrOut	=>	ASQ_Out_ErrOut,
		Out_Ack		=>	Out_Ack,
		Out_ErrIn		=>	Out_ErrIn,
		CTRL_DOUT		=>	OPEN,
		CTRL_DV		=>	OPEN,
		CTRL_ErrOut	=>	OPEN,
		CTRL_Ind		=>	OPEN,
		CTRL_Ack		=>	Lo,
		CTRL_FWD		=>	Hi,
		CTRL_Pause	=>	Lo,
		CTRL_DROP_ERR	=>	Lo,
		USER_IN		=>	ASQ_USER_In,
		USER_Out		=>	USER_Out,
		USER_Out_CTRL	=>	OPEN
	);
	ASQ_EOP_sig	<=	ASQ_EOP AND ASQ_InEOP_OVRN;
	DOUTV		<=	ASQ_DOUTV;
	Out_EOP		<=	asq_out_eop;
	PCI_Out_Ack_sig	<=	PCI_Out_Ack AND PCI_Out_Ack_OVRN;
	PCI_Queue: PDUQueue
	GENERIC MAP
	(
		DataWidth		=>	DataWidth,
		SYNC_IN		=>	SYNC_IN_PCI,
		SYNC_OUT		=>	true,
		SYNC_CTRL		=>	false,
		MINPDUSize	=>	MINPCISize,
		MAXPDUSize	=>	MAXPCISize,
		MaxPDUToQ		=>	MaxPCIToQ
	)
	PORT MAP
	(
		CLK			=>	CLK,
		CE_In		=>	CE,
		CE_Out		=>	CE,
		RST			=>	RST,
		DIN			=>	PCI_DIN,
		DINV			=>	PCI_DINV,
		In_SOP		=>	PCI_SOP,
		In_EOP		=>	PCI_EOP,
		In_Ind		=>	PCI_Ind,
		In_ErrIn		=>	PCI_ErrIn,
		In_Ack		=>	PCI_Ack,
		In_ErrOut		=>	PCI_ErrOut,
		DOUT			=>	PCI_DOut,
		DOUTV		=>	PCI_DOutV,
		Out_SOP		=>	PCI_Out_SOP,
		Out_EOP		=>	PCI_Out_EOP,
		Out_Ind		=>	PCI_Out_Ind,
		Out_ErrOut	=>	PCI_Out_ErrOut,
		Out_Ack		=>	PCI_Out_Ack_sig,
		Out_ErrIn		=>	PCI_Out_ErrIn,
		CTRL_DOUT		=>	OPEN,
		CTRL_DV		=>	OPEN,
		CTRL_ErrOut	=>	OPEN,
		CTRL_Ind		=>	OPEN,
		CTRL_Ack		=>	Lo,
		CTRL_FWD		=>	Hi,
		CTRL_Pause	=>	Lo,
		CTRL_DROP_ERR	=>	Lo,
		USER_IN		=>	PCI_User_In,
		USER_Out		=>	PCI_User_Out,
		USER_Out_CTRL	=>	OPEN
	);

	Just_PCIPart_sig	<=	PCI_User_Out(0);
	PCI_Out_Ind_sig	<=	PCI_Out_Ind AND PCI_Out_Ind_OVRN;
	SDU_Queue: PDUQueue
	GENERIC MAP
	(
		DataWidth		=>	DataWidth,
		SYNC_IN		=>	SYNC_IN_SDU,
		SYNC_OUT		=>	true,
		SYNC_CTRL		=>	false,
		MINPDUSize	=>	MINSDUSize,
		MAXPDUSize	=>	MAXSDUSize,
		MaxPDUToQ		=>	MaxSDUToQ
	)
	PORT MAP(
		CLK			=>	CLK,
		CE_In		=>	CE,
		CE_Out		=>	CE,
		RST			=>	RST,
		DIN			=>	SDU_DIN,
		DINV			=>	SDU_DINV,
		In_SOP		=>	SDU_SOP,
		In_EOP		=>	SDU_EOP,
		In_Ind		=>	SDU_Ind,
		In_ErrIn		=>	SDU_ErrIn,
		In_Ack		=>	SDU_Ack,
		In_ErrOut		=>	SDU_ErrOut,
		DOUT			=>	SDU_DOut,
		DOUTV		=>	SDU_DOutV,
		Out_SOP		=>	SDU_Out_SOP,
		Out_EOP		=>	SDU_Out_EOP,
		Out_Ind		=>	SDU_Out_Ind,
		Out_ErrOut	=>	SDU_Out_ErrOut,
		Out_Ack		=>	SDU_Out_Ack_OVR_sig,
		Out_ErrIn		=>	SDU_Out_ErrIn,
		CTRL_DOUT		=>	OPEN,
		CTRL_DV		=>	OPEN,
		CTRL_ErrOut	=>	OPEN,
		CTRL_Ind		=>	OPEN,
		CTRL_Ack		=>	Lo,
		CTRL_FWD		=>	Hi,
		CTRL_Pause	=>	Lo,
		CTRL_DROP_ERR	=>	Lo,
		USER_IN		=>	SDU_USER_In,
		USER_Out		=>	SDU_USER_Out,
		USER_Out_CTRL	=>	OPEN
	);
	SDU_Out_Ind_sig	<=	SDU_Out_Ind AND SDU_Out_Ind_OVRN;
	
	DaPDUMuxxx: PDUMux
	GENERIC MAP(
		Datawidth		=>	DefDataWidth
	)
	PORT MAP(
		CLK		=>	CLK,
		SEL		=>	PCI_SDU_switch,
		----------------------------------------------------------------------------
		I_0		=>	PCI_DOut,
		UI_0		=>	PCI_USER_Out,
		DV_0		=>	PCI_DOutV,
		SOP_0	=>	PCI_Out_SOP,
		EOP_0	=>	PCI_Out_EOP,
		ERRIn_0	=>	PCI_Out_ErrOut,
		IndIn_0	=>	PCI_Out_Ind_sig,
		AckOut_0	=>	PCI_Out_Ack,
		ErrOut_0	=>	PCI_Out_ErrIn,
		----------------------------------------------------------------------------
		I_1		=>	SDU_DOut,
		UI_1		=>	SDU_USER_Out,
		DV_1		=>	SDU_DOutV,
		SOP_1	=>	SDU_Out_SOP,
		EOP_1	=>	SDU_Out_EOP,
		ERRIn_1	=>	SDU_Out_ErrOut,
		IndIn_1	=>	SDU_Out_Ind_sig,
		AckOut_1	=>	SDU_Out_Ack,
		ErrOut_1	=>	SDU_Out_ErrIn,
		----------------------------------------------------------------------------
		Q		=>	ASQ_DIN,
		QU		=>	ASQ_User_In,
		Q_DV		=>	ASQ_DINV,
		Q_SOP	=>	ASQ_SOP,
		Q_EOP	=>	ASQ_EOP,
		Q_ERROut	=>	ASQ_ErrIn,
		Q_Ind	=>	ASQ_Ind,
		Q_AckIn	=>	ASQ_Ack,
		Q_ErrIn	=>	ASQ_ErrOut
	);

END ARCH_ProtoModule_TXPart;


LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;

--LIBRARY work;
USE work.ProtoLayerTypesAndDefs.ALL;
USE work.ProtoModulePkg.ProtoModule_TXPart;
USE work.ProtoModulePkg.Serializer;
USE work.ProtoModulePkg.DeSerializer;
USE work.ProtoModulePkg.PDUQueue;
USE work.arch.aFlop;
USE work.arch.aFlopC;
USE work.arch.aRise;
USE work.arch.aFall;
--ProtoLayer felhasználó felelőssége, hogy a ha az SDU_DINV = Hi AND SDU_IN_SOP = Hi AND SDU_IN_ErrIn = Hi fennáll, akkor ne írjon be PCI részt,
-- hogy megőrizze a konzisztenciát!!!
ENTITY ProtoLayer IS
generic(
	DataWidth				:		INTEGER	:=	DefDataWidth;
	RX_SYNC_IN			:		BOOLEAN	:=	false;
	RX_SYNC_OUT			:		BOOLEAN	:=	false;
	RX_CTRL_SYNC			:		BOOLEAN	:=	false;
	TX_CTRL_SYNC			:		BOOLEAN	:=	false;
	TX_SYNC_IN			:		BOOLEAN	:=	false;
	TX_SYNC_OUT			:		BOOLEAN	:=	false;
	TX_AUX_Q				:		BOOLEAN	:=	false;
	TX_AUX_widthDW			:		INTEGER	:=	DefAuxWidth;
	RX_AUX_Q				:		BOOLEAN	:=	false;
	RX_AUX_widthDW			:		INTEGER	:=	DefAuxWidth;
	MINSDUSize			:		INTEGER	:=	DefMinPDUSize;
	MAXSDUSize			:		INTEGER	:=	DefMaxPDUSize;
	MaxSDUToQ				:		INTEGER	:=	DefPDUToQ;
	MINPCISize			:		INTEGER	:=	DefMinPDUSize;
	MAXPCISize			:		INTEGER	:=	DefMinPDUSize;
	MaxPCIToQ				:		INTEGER	:=	DefPDUToQ
);
PORT(
	CLK					: IN		STD_LOGIC;
	CE					: IN		STD_LOGIC;
	RST					: IN		STD_LOGIC;
	------------------------------------------------------------
	PCI_DIN				: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
	PCI_DINV				: IN		STD_LOGIC;
	PCI_IN_SOP			: IN		STD_LOGIC;
	PCI_IN_EOP			: IN		STD_LOGIC;
	PCI_IN_Ind			: IN		STD_LOGIC;
	PCI_IN_ErrIn			: IN		STD_LOGIC;
	PCI_IN_USER_In			: IN		STD_LOGIC_VECTOR(USER_width-1 downto 0);
	PCI_IN_Ack			: OUT	STD_LOGIC;
	PCI_IN_ErrOut			: OUT	STD_LOGIC;
	-------------------------------------------------------------
	SDU_DIN				: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
	SDU_DINV				: IN		STD_LOGIC;
	SDU_IN_SOP			: IN		STD_LOGIC;
	SDU_IN_EOP			: IN		STD_LOGIC;
	SDU_IN_Ind			: IN		STD_LOGIC;
	SDU_IN_ErrIn			: IN		STD_LOGIC;
	SDU_IN_USER_In			: IN		STD_LOGIC_VECTOR(USER_width-1 downto 0);
	SDU_IN_Ack			: OUT	STD_LOGIC;
	SDU_IN_ErrOut			: OUT	STD_LOGIC;
	-------------------------------------------------------------
	PDU_DOUT				: OUT	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
	PDU_DOUTV				: OUT	STD_LOGIC;
	PDU_Out_SOP			: OUT	STD_LOGIC;
	PDU_Out_EOP			: OUT	STD_LOGIC;
	PDU_Out_Ind			: OUT	STD_LOGIC;
	PDU_Out_ErrOut			: OUT	STD_LOGIC;
	PDU_Out_USER_Out		: OUT	STD_LOGIC_VECTOR(USER_width-1 downto 0);
	PDU_Out_Ack			: IN		STD_LOGIC;
	PDU_Out_ErrIn			: IN		STD_LOGIC;
	-------------------------------------------------------------
	PDU_DIN				: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
	PDU_DINV				: IN		STD_LOGIC;
	PDU_IN_SOP			: IN		STD_LOGIC;
	PDU_IN_EOP			: IN		STD_LOGIC;
	PDU_IN_Ind			: IN		STD_LOGIC;
	PDU_IN_USER_In			: IN		STD_LOGIC_VECTOR(USER_width-1 downto 0);
	PDU_IN_ErrIn			: IN		STD_LOGIC;
	PDU_IN_ErrOut			: OUT	STD_LOGIC;
	PDU_IN_Ack			: OUT	STD_LOGIC;
	-------------------------------------------------------------
	CTRL_DOUT				: OUT	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
	CTRL_DV				: OUT	STD_LOGIC;
	CTRL_SOP				: OUT	STD_LOGIC;
	CTRL_EOP				: OUT	STD_LOGIC;
	CTRL_ErrOut			: OUT	STD_LOGIC;
	CTRL_Ind				: OUT	STD_LOGIC;
	CTLR_USER_Out			: OUT	STD_LOGIC_VECTOR(USER_width-1 downto 0);
	CTRL_Ack				: IN		STD_LOGIC;
	CTRL_FWD				: IN		STD_LOGIC;
	CTRL_Pause			: IN		STD_LOGIC;
	CTRL_DROP_ERR			: IN		STD_LOGIC;
	-------------------------------------------------------------
	SDU_DOUT				: OUT	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
	SDU_DOUTV				: OUT	STD_LOGIC;
	SDU_Out_SOP			: OUT	STD_LOGIC;
	SDU_OUT_EOP			: OUT	STD_LOGIC;
	SDU_OUT_Ind			: OUT	STD_LOGIC;
	SDU_OUT_USER_Out		: OUT	STD_LOGIC_VECTOR(USER_width-1 downto 0);
	SDU_OUT_ErrOut			: OUT	STD_LOGIC;
	SDU_OUT_ErrIn			: IN		STD_LOGIC;
	SDU_OUT_Ack			: IN		STD_LOGIC;
	----------------------------------------------------------------
	--============================================================--
	----------------------------------------------------------------
	TX_AUX_Out			: OUT	STD_LOGIC_VECTOR(TX_AUX_widthDW*DataWidth-1 downto 0);
	TX_AUX_outV			: OUT	STD_LOGIC;
	TX_AUX_in				: IN		STD_LOGIC_VECTOR(TX_AUX_widthDW*DataWidth-1 downto 0);
	RX_AUX_Out			: OUT	STD_LOGIC_VECTOR(RX_AUX_widthDW*DataWidth-1 downto 0);
	RX_AUX_OutV			: OUT	STD_LOGIC;
	RX_AUX_in				: IN		STD_LOGIC_VECTOR(RX_AUX_widthDW*DataWidth-1 downto 0)
);
END ProtoLayer;



ARCHITECTURE ARCH_ProtoLayerBehav OF ProtoLayer IS

SIGNAL	TX_SOF			:		STD_LOGIC;
SIGNAL	TX_SOF_d			:		STD_LOGIC;
SIGNAL	AUXQ_CE_Out		:		STD_LOGIC;
SIGNAL	AUXQ_CE_Out_sig	:		STD_LOGIC;
SIGNAL	AUXQ_In_SOP		:		STD_LOGIC;
SIGNAL	AUXQ_In_EOP		:		STD_LOGIC;
SIGNAL	AUXQ_In_ErrIn		:		STD_LOGIC;
SIGNAL	AUXQ_Out_Ind		:		STD_LOGIC;
SIGNAL	AUXQ_Out_Ack		:		STD_LOGIC;
SIGNAL	AUXQ_DIN			:		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
SIGNAL	AUXQ_DINV			:		STD_LOGIC;
SIGNAL	AUXQ_DOUT			:		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
SIGNAL	AUXQ_DOUTV		:		STD_LOGIC;
SIGNAL	AUXQ_OUT_SOP		:		STD_LOGIC;
SIGNAL	AUXQ_Out_EOP		:		STD_LOGIC;
SIGNAL	auxq_out_errout	:		STD_LOGIC;

SIGNAL	RX_SOF			:		STD_LOGIC;
SIGNAL	RX_AUXQ_EOF		:		STD_LOGIC;
SIGNAL	RX_AUXQ_CE_Out		:		STD_LOGIC;
SIGNAL	RX_AUXQ_CE_Out_sig	:		STD_LOGIC;
SIGNAL	RX_AUXQ_In_SOP		:		STD_LOGIC;
SIGNAL	RX_AUXQ_In_EOP		:		STD_LOGIC;
SIGNAL	RX_AUXQ_Out_Ind	:		STD_LOGIC;
SIGNAL	RX_AUXQ_Out_Ack	:		STD_LOGIC;
SIGNAL	RX_AUXQ_DIN		:		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
SIGNAL	RX_AUXQ_DINV		:		STD_LOGIC;
SIGNAL	RX_AUXQ_DOUT		:		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
SIGNAL	RX_AUXQ_DOUTV		:		STD_LOGIC;
SIGNAL	RX_AUXQ_OUT_SOP	:		STD_LOGIC;
SIGNAL	RX_AUXQ_Out_EOP	:		STD_LOGIC;
SIGNAL	RX_AUXQ_Out_ErrOut	:		STD_LOGIC;

SIGNAL	PDU_OUT_SOF		:		STD_LOGIC;
SIGNAL	PDU_OUT_SOP_sig	:		STD_LOGIC;
SIGNAL	PDU_DOUTV_sig		:		STD_LOGIC;
SIGNAL	TX_AUX_outV_sig	:		STD_LOGIC;
SIGNAL	TX_AUX_Started		:		STD_LOGIC;
SIGNAL	sdu_doutv_sig		:		STD_LOGIC;
SIGNAL	sdu_out_sop_sig	:		STD_LOGIC;
SIGNAL	sdu_out_sof		:		STD_LOGIC;
SIGNAL	rx_aux_outv_sig	:		STD_LOGIC;
SIGNAL	pdu_in_errin_reg	:		STD_LOGIC;
SIGNAL	PCI_IN_ErrIn_reg_2	:		STD_LOGIC;
SIGNAL	PCI_IN_ErrIn_reg	:		STD_LOGIC;
SIGNAL	PDU_Out_ErrOut_sig	:		STD_LOGIC;
SIGNAL	CTRL_ErrOut_sig	:		STD_LOGIC;


TYPE RXAUXQ_FSM_StateType IS
(
	INIT,
	IDLE,
	SendAck,
	Serialize_IPGR,
	Serialized
);


TYPE TXAUXQ_FSM_StateType IS
(
	INIT,
	IDLE,
	SendAck,
	Serialize_IPGR,
	Serialized
);
ATTRIBUTE	ENUM_ENCODING	:	STRING;

SIGNAL	RXAUXQ_FSM_State			:	RXAUXQ_FSM_StateType;
SIGNAL	TXAUXQ_FSM_State			:	TXAUXQ_FSM_StateType;



BEGIN
	TX_Part: ProtoModule_TXPart
	GENERIC MAP(
		DataWidth		=>	DataWidth,
		SYNC_IN_SDU	=>	TX_SYNC_IN,
		SYNC_IN_PCI	=>	TX_CTRL_SYNC,
		SYNC_OUT		=>	TX_SYNC_OUT,
		MINSDUSize	=>	MINSDUSize,
		MAXSDUSize	=>	MAXSDUSize,
		MaxSDUToQ		=>	MaxSDUToQ,
		MINPCISize	=>	MINPCISize,
		MAXPCISize	=>	MAXPCISize,
		MaxPCIToQ		=>	MaxPCIToQ
	)
	PORT MAP(
		CLK			=>	CLK,
		CE			=>	CE,
		RST			=>	RST,
		PCI_DIN		=>	PCI_DIN,
		PCI_DINV		=>	PCI_DINV,
		PCI_SOP		=>	PCI_IN_SOP,
		PCI_EOP		=>	PCI_IN_EOP,
		PCI_Ind		=>	PCI_IN_Ind,
		PCI_ErrIn		=>	PCI_IN_ErrIn,
		PCI_USER_In	=>	PCI_IN_USER_In,
		PCI_Ack		=>	PCI_IN_Ack,
		PCI_ErrOut	=>	PCI_IN_ErrOut,
		SDU_DIN		=>	SDU_DIN,
		SDU_DINV		=>	SDU_DINV,
		SDU_SOP		=>	SDU_IN_SOP,
		SDU_EOP		=>	SDU_IN_EOP,
		SDU_Ind		=>	SDU_IN_Ind,
		SDU_ErrIn		=>	SDU_IN_ErrIn,
		SDU_USER_In	=>	SDU_IN_USER_In,
		SDU_Ack		=>	SDU_IN_Ack,
		SDU_ErrOut	=>	SDU_IN_ErrOut,
		DOUT			=>	PDU_DOUT,
		DOUTV		=>	PDU_DOUTV_sig,
		Out_SOP		=>	PDU_Out_SOP_sig,
		Out_EOP		=>	PDU_Out_EOP,
		Out_Ind		=>	PDU_Out_Ind,
		Out_ErrOut	=>	PDU_Out_ErrOut_sig,
		USER_Out		=>	PDU_Out_USER_Out,
		Out_Ack		=>	PDU_Out_Ack,
		Out_ErrIn		=>	PDU_Out_ErrIn
	);
	PDU_DOUTV		<=	PDU_DOUTV_sig;
	PDU_Out_SOP	<=	PDU_Out_SOP_sig;
	PDU_Out_ErrOut	<=	PDU_Out_ErrOut_sig;

	
	RX_Part: PDUQueue
	GENERIC MAP
	(
		DataWidth		=>	DataWidth,
		SYNC_IN		=>	RX_SYNC_IN,
		SYNC_OUT		=>	RX_SYNC_OUT,
		SYNC_CTRL		=>	RX_CTRL_SYNC,
		MINPDUSize	=>	MINSDUSize+MINPCISize,
		MAXPDUSize	=>	MAXSDUSize+MAXPCISize,
		MaxPDUToQ		=>	maximum(MaxPCIToQ,MaxSDUToQ)
	)
	PORT MAP(
		CLK			=>	CLK,
		CE_In		=>	CE,
		CE_Out		=>	CE,
		RST			=>	RST,
		DIN			=>	PDU_DIN,
		DINV			=>	PDU_DINV,
		In_SOP		=>	PDU_IN_SOP,
		In_EOP		=>	PDU_IN_EOP,
		In_Ind		=>	PDU_IN_Ind,
		In_ErrIn		=>	PDU_IN_ErrIn,
		In_Ack		=>	PDU_IN_Ack,
		In_ErrOut		=>	PDU_IN_ErrOut,
		DOUT			=>	SDU_DOUT,
		DOUTV		=>	SDU_DOUTV_sig,
		Out_SOP		=>	SDU_Out_SOP_sig,
		Out_EOP		=>	SDU_Out_EOP,
		Out_Ind		=>	SDU_OUT_Ind,
		Out_ErrOut	=>	SDU_OUT_ErrOut,
		Out_Ack		=>	SDU_OUT_Ack,
		Out_ErrIn		=>	SDU_OUT_ErrIn,
		CTRL_DOUT		=>	CTRL_DOUT,
		CTRL_DV		=>	CTRL_DV,
		CTRL_SOP		=>	CTRL_SOP,
		CTRL_EOP		=>	CTRL_EOP,
		CTRL_ErrOut	=>	CTRL_ErrOut_sig,
		CTRL_Ind		=>	CTRL_Ind,
		CTRL_Ack		=>	CTRL_Ack,
		CTRL_FWD		=>	CTRL_FWD,
		CTRL_Pause	=>	CTRL_Pause,
		CTRL_DROP_ERR	=>	CTRL_DROP_ERR,
		USER_IN		=>	PDU_IN_USER_In,
		USER_Out		=>	SDU_OUT_USER_Out,
		USER_Out_CTRL	=>	CTLR_USER_Out
	);
	SDU_DOUTV			<=	SDU_DOUTV_sig;
	SDU_Out_SOP		<=	SDU_Out_SOP_sig;
	CTRL_ErrOut		<=	CTRL_ErrOut_sig;
	--AUXQ_OUT_Ack	<=	PDU_OUT_SOF;
	
	GEN_TX_AUXQ:
	IF (TX_AUX_Q) generate
		TX_SOF			<=	PCI_In_SOP AND PCI_DINV;
		PDU_OUT_SOF		<=	PDU_Out_SOP_sig AND PDU_DOUTV_sig;
		PCIEIN_reg_inst	:	aFlop	PORT MAP(D=>PCI_IN_ErrIn,C=>CLK,CE=>TX_SOF,Q=>PCI_IN_ErrIn_reg);
		TXSOF_reg_inst		:	aFlop	PORT MAP(D=>TX_SOF,C=>CLK,CE=>CE,Q=>TX_SOF_d);
		PCIEIN_reg2_inst	:	aFlop	PORT MAP(D=>PCI_IN_ErrIn_reg,C=>CLK,CE=>TX_SOF_d,Q=>PCI_IN_ErrIn_reg_2);
		AUXQ_In_ErrIn		<=	PCI_IN_ErrIn_reg or PCI_IN_ErrIn_reg_2; 
		--Ez azért kell, mert a PDUQ a PDU eleje felé tolja a hibát 1 órajelnyivel, 
		--és a Protolayer bemeneti PCIQueue miatt a második órajel esetén már nem kerül az összeállított PDU a kimeneti Queue-ba,
		--viszont a konzisztencia miatt az AUX infonak sem szabad ez esetben bekerülnie, ezér a a két jel vagy kapcsolata adja meg
		--a helyes hibajelet ,az RX_AUXQ esetén ez nem áll fent, mivel ott csak egy PDUQ-n át megy az adat
		TX_AUXQSerializer : Serializer
		GENERIC MAP(
			DataWidth	=>	DataWidth,
			ToSer	=>	TX_AUX_widthDW
		)
		PORT MAP(
			CLK		=>	CLK,
			RST		=>	RST,
			CE		=>	CE,
			Start	=>	TX_SOF,
			Ser_Start	=>	AUXQ_In_SOP,
			Complete	=>	AUXQ_In_EOP,
			PIn		=>	TX_AUX_in,
			SOut		=>	AUXQ_DIN,
			OuTV		=>	AUXQ_DINV
		);
		TX_AUXQ : PDUQueue
		GENERIC MAP(
			DataWidth		=>	DataWidth,
			SYNC_IN		=>	false,
			SYNC_OUT		=>	true,
			SYNC_CTRL		=>	false,
			MINPDUSize	=>	MINPCISize,
			MAXPDUSize	=>	MAXPCISize,
			MaxPDUToQ		=>	MaxPCIToQ
		)
		PORT MAP(
			CLK			=>	CLK,
			CE_In		=>	CE,
			CE_Out		=>	CE,
			RST			=>	RST,
			DIN			=>	AUXQ_DIN,
			DINV			=>	AUXQ_DINV,
			In_SOP		=>	AUXQ_In_SOP,
			In_EOP		=>	AUXQ_In_EOP,
			In_Ind		=>	Lo,
			In_ErrIn		=>	AUXQ_In_ErrIn,
			In_Ack		=>	OPEN,
			In_ErrOut		=>	OPEN,
			DOUT			=>	AUXQ_DOUT,
			DOUTV		=>	AUXQ_DOUTV,
			Out_SOP		=>	AUXQ_OUT_SOP,
			Out_EOP		=>	AUXQ_Out_EOP,
			Out_Ind		=>	AUXQ_Out_Ind,
			Out_ErrOut	=>	AUXQ_Out_ErrOut,
			Out_Ack		=>	AUXQ_Out_Ack,
			Out_ErrIn		=>	Lo,
			CTRL_DOUT		=>	OPEN,
			CTRL_DV		=>	OPEN,
			CTRL_SOP		=>	OPEN,
			CTRL_EOP		=>	OPEN,
			CTRL_ErrOut	=>	OPEN,
			CTRL_Ind		=>	OPEN,
			CTRL_Ack		=>	Lo,
			CTRL_FWD		=>	Hi, --PASSTHROUGH Mode
			CTRL_Pause	=>	Lo,
			CTRL_DROP_ERR	=>	Lo,
			USER_IN		=>	(OTHERS => Lo),
			USER_Out		=>	OPEN,
			USER_Out_CTRL	=>	OPEN
		);
		--AUXQ_CE_Out	<=	not(TX_AUX_outV_sig) or AUXQ_CE_Out_sig;
		
		PROCESS(	clk,
				rst,
				CE,
				TXAUXQ_FSM_State,
				AUXQ_Out_Ind,
				AUXQ_DOUTV,
				AUXQ_OUT_SOP,
				AUXQ_Out_ErrOut,
				AUXQ_Out_EOP,
				PDU_Out_ErrOut_sig,
				PDU_DOUTV_sig,
				PDU_Out_SOP_sig
				)
		BEGIN
			IF(RISING_EDGE(clk))THEN
				IF(rst = Hi) THEN
					AUXQ_Out_Ack		<=	Lo;
					TXAUXQ_FSM_State	<=	INIT;
				ELSIF(rst = Lo AND CE = Hi) THEN
					CASE TXAUXQ_FSM_State IS
						WHEN IDLE =>
							AUXQ_Out_Ack	<=	Lo;
							IF(AUXQ_Out_Ind = Hi)THEN
								TXAUXQ_FSM_State	<=	SendAck;
							ELSE
								TXAUXQ_FSM_State	<=	IDLE;
							END IF;
						WHEN SendAck =>
							AUXQ_Out_Ack	<=	Hi;
							IF(AUXQ_Out_Ind = Hi)THEN
								IF(AUXQ_DOUTV = Hi AND AUXQ_Out_SOP = Hi)THEN
									TXAUXQ_FSM_State	<=	Serialize_IPGR;
								ELSE
									TXAUXQ_FSM_State	<=	SendAck;
								END IF;
							ELSE
								TXAUXQ_FSM_State	<=	IDLE;
							END IF;
						WHEN Serialize_IPGR =>
							AUXQ_Out_Ack	<=	Lo;
							IF(AUXQ_Out_ErrOut = Lo)THEN
								IF(AUXQ_DOUTV = Hi AND AUXQ_Out_EOP = Hi)THEN
									TXAUXQ_FSM_State	<=	Serialized;
								ELSE
									TXAUXQ_FSM_State	<=	Serialize_IPGR;
								END IF;
							ELSE
								TXAUXQ_FSM_State	<=	IDLE;
							END IF;
						WHEN Serialized =>
							IF(PDU_Out_ErrOut_sig = Hi or (PDU_DOUTV_sig = Hi AND PDU_Out_SOP_sig = Hi))THEN
								IF(AUXQ_Out_Ind = Hi)THEN
									TXAUXQ_FSM_State	<=	SendAck;
								ELSE
									TXAUXQ_FSM_State	<=	Idle;
								END IF;
							ELSE
								TXAUXQ_FSM_State	<=	Serialized;
							END IF;
						-- WHEN OTHERS => --INIT
						WHEN INIT =>
							AUXQ_Out_Ack	<=	Lo;
							TXAUXQ_FSM_State	<=	IDLE;
					END CASE;
				END IF;
			END IF;
		END PROCESS;
		
		TX_AUXQDeSerializer : DeSerializer
		GENERIC MAP(
			DataWidth	=>	DataWidth,
			ToDeSer	=>	TX_AUX_widthDW
		)
		PORT MAP(
			CLK		=>	CLK,
			RST		=>	RST,
			CE		=>	CE,
			SIn		=>	AUXQ_DOUT,
			Ser_DV	=>	AUXQ_DOUTV,
			Ser_SOP	=>	AUXQ_OUT_SOP,
			Ser_EOP	=>	AUXQ_Out_EOP,
			Ser_ErrIn	=>	AUXQ_Out_ErrOut,
			POut		=>	TX_AUX_out,
			POuTV	=>	TX_AUX_outV_sig
		);
		TX_AUX_outV	<=	TX_AUX_outV_sig;
	END generate;
	
	-- primary goal :	queue auxilliary data beside data the source IS composed from the lower layer input, or
	--				or any arbitrary signals
	GEN_RX_AUXQ:
	IF (RX_AUX_Q) generate

		RX_SOF			<=	PDU_In_SOP AND PDU_DINV;
		RX_AUXQ_EOF		<=	RX_AUXQ_DINV AND RX_AUXQ_In_EOP;

		PDUEIN_reg_inst	:	aFlopC	PORT MAP(D=>PDU_In_ErrIn,C=>CLK,CE=>RX_SOF,CLR=>RX_AUXQ_EOF,Q=>PDU_In_ErrIn_reg);

		SDU_OUT_SOF	<=	SDU_Out_SOP_sig AND SDU_DOUTV_sig;
		
		RX_AUXQSerializer : Serializer
		GENERIC MAP(
			DataWidth	=>	DataWidth,
			ToSer	=>	RX_AUX_widthDW
		)
		PORT MAP(
			CLK		=>	CLK,
			RST		=>	RST,
			CE		=>	CE,
			Start	=>	RX_SOF,
			Ser_Start	=>	RX_AUXQ_In_SOP,
			Complete	=>	RX_AUXQ_In_EOP,
			PIn		=>	RX_AUX_in,
			SOut		=>	RX_AUXQ_DIN,
			OuTV		=>	RX_AUXQ_DINV
		);
		RX_AUXQ : PDUQueue
		GENERIC MAP(
			DataWidth		=>	DataWidth,
			SYNC_IN		=>	false,
			SYNC_OUT		=>	true,
			SYNC_CTRL		=>	false,
			MINPDUSize	=>	MINPCISize,
			MAXPDUSize	=>	MAXPCISize,
			MaxPDUToQ		=>	MaxPCIToQ
		)
		PORT MAP(
			CLK			=>	CLK,
			CE_In		=>	CE,
			CE_Out		=>	CE,
			RST			=>	RST,
			DIN			=>	RX_AUXQ_DIN,
			DINV			=>	RX_AUXQ_DINV,
			In_SOP		=>	RX_AUXQ_In_SOP,
			In_EOP		=>	RX_AUXQ_In_EOP,
			In_Ind		=>	Lo,
			In_ErrIn		=>	PDU_In_ErrIn_reg,
			In_Ack		=>	OPEN,
			In_ErrOut		=>	OPEN,
			DOUT			=>	RX_AUXQ_DOUT,
			DOUTV		=>	RX_AUXQ_DOUTV,
			Out_SOP		=>	RX_AUXQ_OUT_SOP,
			Out_EOP		=>	RX_AUXQ_Out_EOP,
			Out_Ind		=>	RX_AUXQ_Out_Ind,
			Out_ErrOut	=>	RX_AUXQ_Out_ErrOut,
			Out_Ack		=>	RX_AUXQ_Out_Ack,
			Out_ErrIn		=>	Lo,
			CTRL_DOUT		=>	OPEN,
			CTRL_DV		=>	OPEN,
			CTRL_SOP		=>	OPEN,
			CTRL_EOP		=>	OPEN,
			CTRL_ErrOut	=>	OPEN,
			CTRL_Ind		=>	OPEN,
			CTRL_Ack		=>	Lo,
			CTRL_FWD		=>	Hi, --PASSTHROUGH Mode
			CTRL_Pause	=>	Lo,
			CTRL_DROP_ERR	=>	Lo,
			USER_IN		=>	(OTHERS => Lo),
			USER_Out		=>	OPEN,
			USER_Out_CTRL	=>	OPEN
		);

		PROCESS(	clk,
				rst,
				CE,
				RXAUXQ_FSM_State,
				RX_AUXQ_Out_Ind,
				RX_AUXQ_DOUTV,
				RX_AUXQ_Out_SOP,
				RX_AUXQ_Out_ErrOut,
				RX_AUXQ_Out_EOP,
				CTRL_DROP_ERR,
				SDU_DOUTV_sig,
				SDU_Out_SOP_sig
				)
		BEGIN
			IF(RISING_EDGE(clk))THEN
				IF(rst = Hi) THEN
					RX_AUXQ_Out_Ack	<=	Lo;
					RXAUXQ_FSM_State	<=	INIT;
				ELSIF(rst = Lo AND CE = Hi) THEN
					CASE RXAUXQ_FSM_State IS
						WHEN IDLE =>
							RX_AUXQ_Out_Ack	<=	Lo;
							IF(RX_AUXQ_Out_Ind = Hi)THEN
								RXAUXQ_FSM_State	<=	SendAck;
							ELSE
								RXAUXQ_FSM_State	<=	IDLE;
							END IF;
						WHEN SendAck =>
							RX_AUXQ_Out_Ack	<=	Hi;
							IF(RX_AUXQ_Out_Ind = Hi)THEN
								IF(RX_AUXQ_DOUTV = Hi AND RX_AUXQ_Out_SOP = Hi)THEN
									RXAUXQ_FSM_State	<=	Serialize_IPGR;
								ELSE
									RXAUXQ_FSM_State	<=	SendAck;
								END IF;
							ELSE
								RXAUXQ_FSM_State	<=	IDLE;
							END IF;
						WHEN Serialize_IPGR =>
							RX_AUXQ_Out_Ack	<=	Lo;
							IF(RX_AUXQ_Out_ErrOut = Lo)THEN
								IF(RX_AUXQ_DOUTV = Hi AND RX_AUXQ_Out_EOP = Hi)THEN
									RXAUXQ_FSM_State	<=	Serialized;
								ELSE
									RXAUXQ_FSM_State	<=	Serialize_IPGR;
								END IF;
							ELSE
								RXAUXQ_FSM_State	<=	IDLE;
							END IF;
						WHEN Serialized =>
							IF(CTRL_DROP_ERR = Hi or CTRL_ErrOut_sig = Hi or (SDU_DOUTV_sig = Hi AND SDU_Out_SOP_sig = Hi))THEN
								IF(RX_AUXQ_Out_Ind = Hi)THEN
									RXAUXQ_FSM_State	<=	SendAck;
								ELSE
									RXAUXQ_FSM_State	<=	Idle;
								END IF;
							ELSE
								RXAUXQ_FSM_State	<=	Serialized;
							END IF;
						-- WHEN OTHERS => --INIT
						WHEN INIT =>
							RX_AUXQ_Out_Ack	<=	Lo;
							RXAUXQ_FSM_State	<=	IDLE;
					END CASE;
				END IF;
			END IF;
		END PROCESS;
		
		RX_AUXQDeSerializer : DeSerializer
		GENERIC MAP(
			DataWidth	=>	DataWidth,
			ToDeSer	=>	RX_AUX_widthDW
		)
		PORT MAP(
			CLK		=>	CLK,
			RST		=>	RST,
			CE		=>	CE,
			SIn		=>	RX_AUXQ_DOUT,
			Ser_DV	=>	RX_AUXQ_DOUTV,
			Ser_SOP	=>	RX_AUXQ_OUT_SOP,
			Ser_EOP	=>	RX_AUXQ_Out_EOP,
			Ser_ErrIn	=>	RX_AUXQ_Out_ErrOut,
			POut		=>	RX_AUX_out,
			POuTV	=>	RX_AUX_outV_sig
		);
		RX_AUX_outV	<=	RX_AUX_outV_sig;
	END generate;

END ARCH_ProtoLayerBehav;


LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;

-- USE IEEE.std_logic_misc.ALL;
USE IEEE.math_real.ALL;
-- USE work.arch.aDelay;
USE work.arch.aFlop;
USE work.arch.aRegister;
USE work.arch.aRise;
USE work.ProtoLayerTypesAndDefs.ALL;

ENTITY Serializer IS
generic(
	DataWidth			:		INTEGER	:=	DefDataWidth;
	ToSer			:		INTEGER	:=	DefToSer
	-- DataWidth*ToSer			:		INTEGER	:=	ToSer*DataWidth
);

PORT(
	CLK				: IN		STD_LOGIC;
	RST				: IN		STD_LOGIC;
	CE				: IN		STD_LOGIC;
	Start			: IN		STD_LOGIC;
	Ser_Start			: OUT	STD_LOGIC;
	Complete			: OUT	STD_LOGIC;
	--------------------------------------------
	PIn				: IN		STD_LOGIC_VECTOR( DataWidth*ToSer-1 downto 0);
	SOut				: OUT	STD_LOGIC_VECTOR( DataWidth-1 downto 0);
	OuTV				: OUT	STD_LOGIC
);
END Serializer;

ARCHITECTURE Arch_SerializerBehav OF Serializer IS

CONSTANT	CNTRWidth		:		INTEGER							:=	INTEGER(CEIL(LOG2(REAL(ToSer))));
CONSTANT	CNTR_vec		:		STD_LOGIC_VECTOR( CNTRWidth-1 downto 0)	:=	STD_LOGIC_VECTOR(to_unsigned(ToSer-1,CNTRWidth));

SIGNAL	Pin_reg		:		STD_LOGIC_VECTOR( DataWidth*ToSer-1 downto 0);
SIGNAL	Pin_shreg		:		STD_LOGIC_VECTOR( DataWidth*ToSer-1 downto 0);
SIGNAL	SOut_sig		:		STD_LOGIC_VECTOR( DataWidth-1 downto 0);
SIGNAL	CNTR			:		STD_LOGIC_VECTOR( CNTRWidth-1 downto 0);
SIGNAL	Complete_sig	:		STD_LOGIC;
SIGNAL	OuTV_sig		:		STD_LOGIC;
SIGNAL	Ser_IPGR		:		STD_LOGIC;
SIGNAL	Ser_Start_sig	:		STD_LOGIC;
SIGNAL	Start_reg		:		STD_LOGIC;
SIGNAL	Start_rise	:		STD_LOGIC;
SIGNAL	Start_rise_d	:		STD_LOGIC;

BEGIN


S_flop	: aFlop										PORT MAP(D=>Start,C=>CLK,CE=>CE,Q=>Start_reg);
S_rise	: aRise										PORT MAP(I => Start_reg, C => CLK, Q => Start_rise);
S_rise_d	: aFlop										PORT MAP(D=>Start_rise,C=>CLK,CE=>CE,Q=>Start_rise_d);
PINR		: aRegister	GENERIC MAP(Size => DataWidth*ToSer)	PORT MAP(D=>PIn,C=>CLK,CE=>Start_rise,Q=>Pin_reg);

SS_flop	: aFlop										PORT MAP(D=>Ser_Start_sig,C=>CLK,CE=>CE,Q=>Ser_Start);



PROCESS(	clk,
		rst,
		CE,
		Start_rise_d,
		Ser_IPGR,
		CNTR
		)
BEGIN
	IF(RISING_EDGE(clk)) THEN
		IF(rst = Hi) THEN
			CNTR			<=	(OTHERS => Lo);
			SOut_sig		<=	(OTHERS => Lo);
			Pin_shreg		<=	(OTHERS => Lo);
			Complete_sig	<=	Lo;
			OuTV_sig		<=	Lo;
			Ser_IPGR		<=	Lo;
			Ser_Start_sig	<=	Lo;
		ELSIF(rst = Lo AND CE = Hi) THEN

			SOut_sig		<=	Pin_shreg(DataWidth*ToSer-1 downto DataWidth*(ToSer-1));

			IF(Start_rise_d = Hi AND Ser_IPGR = Lo) THEN
				Ser_IPGR		<=	Hi;
				Pin_shreg		<=	Pin_reg;
				Ser_Start_sig	<=	Hi;
				CNTR			<=	STD_LOGIC_VECTOR(to_unsigned(0,CNTR'Length));
			ELSIF(Ser_IPGR = Hi) THEN
				OuTV_sig		<=	Hi;
				Ser_Start_sig	<=	Lo;
				IF(CNTR = CNTR_vec) THEN
					Ser_IPGR		<=	Lo;
					Complete_sig	<=	Hi;
				ELSE
					CNTR							<=	CNTR + 1;
					Pin_shreg(DataWidth*ToSer-1
								downto
									DataWidth)	<=	Pin_shreg(DataWidth*(ToSer-1)-1 downto 0);
				END IF;
			ELSE
				Complete_sig	<=	Lo;
				OuTV_sig		<=	Lo;
				Ser_IPGR		<=	Lo;
				Ser_Start_sig	<=	Lo;
			END IF;
		END IF;
	END IF;
END PROCESS;
	Complete	<=	Complete_sig;
	OuTV		<=	OuTV_sig;
	SOut		<=	SOut_sig;

END Arch_SerializerBehav;


LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;

-- USE IEEE.std_logic_misc.ALL;
USE IEEE.math_real.ALL;
USE work.arch.aPipe;
USE work.arch.aRegister;
USE work.arch.aFlop;
-- USE work.arch.aDelay;
USE work.ProtoLayerTypesAndDefs.ALL;

ENTITY DeSerializer IS
generic(
	DataWidth			:		INTEGER	:=	DefDataWidth;
	ToDeSer			:		INTEGER	:=	DefToDeSer
);

PORT(
	CLK				: IN		STD_LOGIC;
	RST				: IN		STD_LOGIC;
	CE				: IN		STD_LOGIC;
	--------------------------------------------
	SIn				: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
	Ser_DV			: IN		STD_LOGIC;
	Ser_SOP			: IN		STD_LOGIC;
	Ser_EOP			: IN		STD_LOGIC;
	Ser_ErrIn			: IN		STD_LOGIC;
	POut				: OUT	STD_LOGIC_VECTOR(DataWidth*ToDeSer-1 downto 0);
	POuTV			: OUT	STD_LOGIC;
	POuT_err			: OUT	STD_LOGIC
);
END DeSerializer;

ARCHITECTURE	ArchDeSerializerBehav OF DeSerializer IS
CONSTANT	OutWidth		:		INTEGER	:=	DataWidth*ToDeSer;
CONSTANT	CNTRLen		:		INTEGER	:=	INTEGER(CEIL(LOG2(REAL(ToDeSer))));
SIGNAL	POut_reg		:		STD_LOGIC_VECTOR(OutWidth - 1 downto 0);
SIGNAL	POutV_sig		:		STD_LOGIC;
SIGNAL	POuT_err_sig	:		STD_LOGIC;

CONSTANT	ToDeSer_vec	:		STD_LOGIC_VECTOR(CNTRLen-1 downto 0)	:=	STD_LOGIC_VECTOR(to_unsigned(ToDeSer - 1,CNTRLen));
SIGNAL	ToDeSer_CNTR	:		STD_LOGIC_VECTOR(CNTRLen-1 downto 0);

SIGNAL	SIn_delayed	:		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
SIGNAL	SIn_reg		:		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
SIGNAL	Ser_DV_reg	:		STD_LOGIC;
SIGNAL	Ser_SOP_reg	:		STD_LOGIC;
SIGNAL	Ser_EOP_reg	:		STD_LOGIC;
SIGNAL	Ser_ErrIn_reg	:		STD_LOGIC;


CONSTANT	INPUT_DELAY	:		INTEGER	:=	2;
TYPE DeSer_State_Type IS
(
	INIT,
	IDLE,
	DeSerIPGR,
	DeSerComplete,
	DeSerComplete_2,
	DeSerError
);

attribute ENUM_ENCODING : STRING;

SIGNAL	DeSer_State	:		DeSer_State_Type;

BEGIN

POuTV	<=	POutV_sig;
POut		<=	POut_reg;
POuT_err	<=	POuT_err_sig;

DV_reg	: aFlop	PORT MAP( D => Ser_DV,C => CLK, CE => Hi, Q => Ser_DV_reg);
SOP_reg	: aFlop	PORT MAP( D => Ser_SOP,C => CLK, CE => Hi, Q => Ser_SOP_reg);
EOP_reg	: aFlop	PORT MAP( D => Ser_EOP,C => CLK, CE => Hi, Q => Ser_EOP_reg);
SErrI_reg	: aFlop	PORT MAP( D => Ser_ErrIn,C => CLK, CE => Hi, Q => Ser_ErrIn_reg);
in_reg	: aRegister	GENERIC MAP(Size => DataWidth)	PORT MAP(D=>SIn,C => CLK,CE => Hi,Q => SIn_reg);

In_d		: aPipe	GENERIC MAP(Size => DataWidth,Length => INPUT_DELAY)		PORT MAP(I=>SIn_reg,C => CLK,CE => CE,Q => SIn_delayed);

PROCESS(	clk,
		rst,
		CE,
		DeSer_State,
		Ser_SOP_reg,
		Ser_DV_reg,
		Ser_EOP_reg,
		ToDeSer_CNTR
		
		)
BEGIN
	IF(RISING_EDGE(clk))THEN
		IF(rst = Hi) THEN
			POutV_sig		<=	Lo;
			POut_reg		<=	(OTHERS => Lo);
			ToDeSer_CNTR	<=	STD_LOGIC_VECTOR(to_unsigned(1,ToDeSer_CNTR'Length));
			POuT_err_sig	<=	Lo;
			DeSer_State	<=	INIT;
		ELSE
			IF(CE = Hi) THEN
				CASE DeSer_State IS
					WHEN IDLE =>
						ToDeSer_CNTR					<=	STD_LOGIC_VECTOR(to_unsigned(1,ToDeSer_CNTR'Length));
						IF(Ser_SOP_reg = Hi AND Ser_DV_reg = Hi AND Ser_ErrIn_reg = Lo)THEN
							DeSer_State	<=	DeSerIPGR;
						ELSE
							DeSer_State	<=	IDLE;
						END IF;
					WHEN DeSerIPGR =>
						POutV_sig		<=	Lo;
						POuT_err_sig	<=	Lo;
						POut_reg(DataWidth - 1 downto 0)			<=	SIn_delayed;
						POut_reg(OutWidth  - 1 downto DataWidth)	<=	POut_reg(OutWidth -1 - DataWidth downto 0);
						IF(Ser_DV_reg = Hi AND Ser_ErrIn_reg = Lo) THEN
							ToDeSer_CNTR	<=	ToDeSer_CNTR + 1;
							IF(Ser_EOP_reg = Hi) THEN
								IF(ToDeSer_CNTR = ToDeSer_vec) THEN
									DeSer_State	<=	DeSerComplete;
								ELSE
									DeSer_State	<=	DeSerError;
								END IF;
							ELSIF(Ser_EOP_reg = Lo AND ToDeSer_CNTR = ToDeSer_vec) THEN
								DeSer_State	<=	DeSerComplete;
							ELSE
								DeSer_State	<=	DeSerIPGR;
							END IF;
						ELSIF(Ser_ErrIn_reg = Hi) THEN
							DeSer_State	<=	DeSerError;
						ELSE
							DeSer_State	<=	DeSerIPGR;
						END IF;
					WHEN DeSerComplete =>
						POut_reg(DataWidth-1 downto 0)		<=	SIn_delayed;
						POut_reg(OutWidth - 1 downto DataWidth)	<=	POut_reg(OutWidth -1 - DataWidth downto 0);
						DeSer_State						<=	DeSerComplete_2;
					WHEN DeSerComplete_2 =>
						POut_reg(DataWidth-1 downto 0)		<=	SIn_delayed;
						POut_reg(OutWidth - 1 downto DataWidth)	<=	POut_reg(OutWidth -1 - DataWidth downto 0);
						POuT_err_sig						<=	Lo;
						POutV_sig							<=	Hi;
						DeSer_State						<=	IDLE;
					WHEN DeSerError =>
						POuT_err_sig	<=	Hi;
						POutV_sig		<=	Lo;
						DeSer_State	<=	IDLE;
					WHEN OTHERS => --INIT
					-- WHEN INIT =>
						ToDeSer_CNTR					<=	STD_LOGIC_VECTOR(to_unsigned(1,ToDeSer_CNTR'Length));
						POutV_sig						<=	Lo;
						POuT_err_sig					<=	Lo;
						DeSer_State					<=	IDLE;
				END CASE;
			END IF;
		END IF;
	END IF;
END PROCESS;

END ArchDeSerializerBehav;


LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;

-- USE IEEE.std_logic_misc.ALL;
USE IEEE.math_real.ALL;
USE work.arch.aFlop;
USE work.arch.aRise;
USE work.ProtoLayerTypesAndDefs.ALL;

ENTITY MiniCAM IS --IN ReadFirst Mode
generic(
	DataWidth			:		INTEGER	:=	DefDataWidth;
	Elements			:		INTEGER	:=	DefCAMElems;
	InitToFF			:		BOOLEAN	:=	true
);
PORT(
	CLK				: IN		STD_LOGIC;
	RST				: IN		STD_LOGIC;
	CE				: IN		STD_LOGIC;
	CFG_CE			: IN		STD_LOGIC;
	WR_EN			: IN		STD_LOGIC;
	RD_EN			: IN		STD_LOGIC;
	DIN				: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
	ADDR_In			: IN		STD_LOGIC_VECTOR(INTEGER(CEIL(LOG2(REAL(Elements))))-1 downto 0);
	CAM_DIN			: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
	CAM_SRCH			: IN		STD_LOGIC;
	Match			: OUT	STD_LOGIC;
	MatchV			: OUT	STD_LOGIC;
	DOUT				: OUT	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
	ADDR_Out			: OUT	STD_LOGIC_VECTOR(INTEGER(CEIL(LOG2(REAL(Elements))))-1 downto 0);
	DOUTV			: OUT	STD_LOGIC
	);
END MiniCAM;

ARCHITECTURE ArchMiniCAMBehav OF MiniCAM IS

CONSTANT	AddrWidth		:	INTEGER	:=	INTEGER(CEIL(LOG2(REAL(Elements))));
CONSTANT	ArrayENum		:	INTEGER	:=	2**AddrWidth;

TYPE		Darray_type IS array (0 to ArrayENum-1) OF STD_LOGIC_VECTOR(DataWidth-1 downto 0);
SIGNAL	Darray		:	Darray_type;
SIGNAL	Match_vector	:	STD_LOGIC_VECTOR(ArrayENum-1 downto 0);
SIGNAL	Check_Match	:	STD_LOGIC;
SIGNAL	MatchV_sig	:	STD_LOGIC;
SIGNAL	Match_sig		:	STD_LOGIC;
SIGNAL	CAM_SRCH_rise	:	STD_LOGIC;
SIGNAL	CAM_SRCH_reg	:	STD_LOGIC;
SIGNAL	Addr_Out_sig	:	STD_LOGIC_VECTOR(ADDR_Out'Length-1 downto 0);

BEGIN

-- assert 2**INTEGER(CEIL(LOG2(REAL(Elements)))) = Elements	severity failure;
Match	<=	Match_sig;
MatchV	<=	MatchV_sig;
ADDR_Out	<=	Addr_Out_sig;

SRCH_reg_inst	: aFlop	PORT MAP( D => CAM_SRCH,C => CLK,CE => CE,Q => CAM_SRCH_reg);
SRCH_rise		: aRise	PORT MAP( I => CAM_SRCH_reg, C => CLK, Q => CAM_SRCH_rise);

WR_PROC:PROCESS(	clk,
				rst,
				CFG_CE,
				WR_EN,
				RD_EN
				)
BEGIN
	IF(RISING_EDGE(clk))THEN
		IF(rst = Hi) THEN
			DOUT	<=	Darray(0);
			for i IN 0 to ArrayENum-2 loop
				Darray(i)		<=	(OTHERS => Lo); --ALL zeros
			END loop;
			IF(InitToFF) THEN
				Darray(ArrayENum-1)	<=	(OTHERS => Hi); --ALL ones
			ELSE
				Darray(ArrayENum-1)	<=	(OTHERS => Lo); --ALL zeros
			END IF;
		ELSIF(rst = Lo AND CFG_CE = Hi) THEN
			IF(WR_EN = Hi) THEN
				Darray(to_integer(unsigned(ADDR_In)))	<=	DIN;
			ELSIF(WR_EN = Lo AND RD_EN = Hi) THEN
				DOUT		<=	Darray(to_integer(unsigned(ADDR_In)));
				DOUTV	<=	Hi;
			ELSE
				DOUTV	<=	Lo;
			END IF;
		END IF;
	END IF;
END PROCESS WR_PROC;

FIND_PROC:PROCESS(	clk,
				rst,
				CE,
				CAM_SRCH_rise
				)
BEGIN
	IF(RISING_EDGE(clk))THEN
		IF(rst = Hi) THEN
			Check_Match	<=	Lo;
		ELSIF(rst = Lo AND CE = Hi) THEN
			IF(CAM_SRCH_rise = Hi) THEN
				Check_Match	<=	Hi;
				for i IN 0 to ArrayENum-1 loop
					IF(Darray(i) = CAM_DIN) THEN
						Match_vector(i)	<=	Hi;
					ELSE
						Match_vector(i)	<=	Lo;
					END IF;
				END loop;
			ELSE
				Check_Match	<=	Lo;
			END IF;
		END IF;
	END IF;
END PROCESS FIND_PROC;

Match_Proc:PROCESS(clk) 
BEGIN
	IF(RISING_EDGE(clk))THEN
		IF(rst = Hi) THEN
			MatchV_sig	<=	Lo;
			Match_sig		<=	Lo;
			Addr_Out_sig	<=	(OTHERS => Lo);
		ELSIF(rst = Lo AND CE = Hi) THEN
			IF(Check_Match = Hi) THEN
				MatchV_sig	<=	Hi;
				IF(Match_vector = STD_LOGIC_VECTOR(to_unsigned(0,Match_vector'Length)))THEN
					Match_sig		<=	Lo;
				ELSE
					Match_sig		<=	Hi;
				END IF;
				for i IN 0 to ArrayENum-1 loop
					IF(Match_vector(i) = Hi) THEN
						Addr_Out_sig	<=	STD_LOGIC_VECTOR(to_unsigned(i,Addr_Out_sig'Length));
					END IF;
				END loop;
			ELSE
				MatchV_sig	<=	Lo;
				Match_sig		<=	Lo;
			END IF;
		END IF;
	END IF;
END PROCESS Match_Proc;

END ArchMiniCAMBehav;


--
-- PDUQueue module
-- ============
--
-- (C) Ferenc Janky,BME TMIT
--   modul name:	PDUQueue
--   PACKAGE:		ProtoModulePkg
--
-------------------------------------------------------------------------
--===========================
--PDUQueue module description
--===========================
-------------------------------------------------------------------------
--PDUQueue IS a generic queue,which uses a FWFT mode FIFO as it's main
--COMPONENT. 
--The depth OF the FIFO should be as great as to be able to fully queue
--the MAXPDUSize generic number OF DataWidth wide bits. 
--The module has 3 interfaces: IN,OUT,Control
--Each interface IS capable OF two operation mode. 
--Async,where the start OF a PDU IS indicated with the simultaneous
--transition OF the DV AND SOP signals from Low to High.
--IN Sync mode  before the start OF packet a handshake with Ind AND Ack 
--sigs must be done before the PDU input
--Each interface's op mode IS configured separately with generics
--The Control interface IS notified with the confiugred op mode 
--every time WHEN there's a valid PDU IN the queue.
--The operation cycle IS split to the Detection AND the Extraction part
--both parts are runnig individually.
--The extraction has two subcycle: IN order they are 
--the control part AND the forward part.
--The Control interface can drop the actual PDU or Forward it through the 
--OUT interface or it could pause the operation
--before or during the control part IS IN progress
--The module IS equipped with separate CE signals for the
--IN AND output sides. WHEN deasserting CE_IN during the last PDU IN
--queue with active Extraction part that leads to corruption OF the 
--read OUT OF the PDU.-------------------------------------------------------------------------
-------------------------------------------------------------------------
--===========================
--TO IMPLEMENT: 
--I.
--based on FIFO_1_MinSize := MAX(MaxPDUToQ * (MINPDUSize + 1) -1,MAXPDUSize)
--CONSTANT the automatic instantiantion OF the correct FIFO 
--using the correct primitives now the module IS using only the 
--FIFO18 primitive IN 9 bit width config
--II. 
--Protection against counter overflow OF QUEUECNTR register!!!!! Done at 05.11.2012 removed on 2013.04.04
--III. 
--Check the size OF PDU based on MIN PDU AND MAX PDU size attribute
--===========================
--===========================
--Changes
--===========================
--2013.04.04 - Queue counter removed,not necessary
--
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;

LIBRARY UNISIM;
USE UNISIM.vcomponents.ALL;

--LIBRARY work;
USE work.ProtoLayerTypesAndDefs.ALL;
USE work.arch.aPipe;
USE work.arch.aDelay;

ENTITY PDUQueue IS
generic
(
	DataWidth					:		INTEGER	:=	DefDataWidth;
	SYNC_IN					:		BOOLEAN	:=	false;
	SYNC_OUT					:		BOOLEAN	:=	true;
	SYNC_CTRL					:		BOOLEAN	:=	false;
	MINPDUSize				:		INTEGER	:=	DefMinPDUSize;
	MAXPDUSize				:		INTEGER	:=	DefMaxPDUSize;
	MaxPDUToQ					:		INTEGER	:=	DefPDUToQ
);
PORT
(
	CLK						: IN		STD_LOGIC;
	CE_In					: IN		STD_LOGIC;
	CE_Out					: IN		STD_LOGIC;
	RST						: IN		STD_LOGIC;
	-------------------------------------------------------------
	-- IN interface signals
	DIN						: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
	DINV						: IN		STD_LOGIC;
	In_SOP					: IN		STD_LOGIC;
	In_EOP					: IN		STD_LOGIC;
	In_Ind					: IN		STD_LOGIC;
	In_ErrIn					: IN		STD_LOGIC;
	In_Ack					: OUT	STD_LOGIC;
	In_ErrOut					: OUT	STD_LOGIC;
	-------------------------------------------------------------
	-- OUT interface signals
	DOUT						: OUT	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
	DOUTV					: OUT	STD_LOGIC;
	Out_SOP					: OUT	STD_LOGIC;
	Out_EOP					: OUT	STD_LOGIC;
	Out_Ind					: OUT	STD_LOGIC;
	Out_ErrOut				: OUT	STD_LOGIC;
	Out_Ack					: IN		STD_LOGIC;
	Out_ErrIn					: IN		STD_LOGIC;
	-------------------------------------------------------------
	-- Control interface signals
	CTRL_DOUT					: OUT	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
	CTRL_DV					: OUT	STD_LOGIC;
	CTRL_SOP					: OUT	STD_LOGIC;
	CTRL_EOP					: OUT	STD_LOGIC;
	CTRL_ErrOut				: OUT	STD_LOGIC;
	CTRL_Ind					: OUT	STD_LOGIC;
	CTRL_Ack					: IN		STD_LOGIC;
	CTRL_FWD					: IN		STD_LOGIC;
	CTRL_Pause				: IN		STD_LOGIC;
	CTRL_DROP_ERR				: IN		STD_LOGIC;
	-------------------------------------------------------------
	-- Extra user signals
	USER_IN					: IN		STD_LOGIC_VECTOR(USER_width-1 downto 0);
	USER_Out					: OUT	STD_LOGIC_VECTOR(USER_width-1 downto 0);
	USER_Out_CTRL				: OUT	STD_LOGIC_VECTOR(USER_width-1 downto 0)
);

END PDUQueue;

ARCHITECTURE PDUQueue_ARCH OF PDUQueue IS

CONSTANT FIFO_2_AFO_INT			:		INTEGER		:= 2000 - MAXPDUSize;
CONSTANT FIFO_2_AFO_BV			:		bit_vector	:= to_bitvector(STD_LOGIC_VECTOR(to_unsigned(FIFO_2_AFO_INT,13)));
CONSTANT INPUT_DELAY			:		INTEGER		:= PDUQ_INPUT_DELAY;
CONSTANT OUT_SIG_PREDELAY		:		INTEGER		:= 3;-- 1 from CTRL FWD, 2 FROM FIFO RD-EN delay
CONSTANT OUT_SIG_POSTDELAY		:		INTEGER		:= 1;
CONSTANT OUT_DAT_PREDELAY		:		INTEGER		:= 3;
CONSTANT OUT_DAT_POSTDELAY		:		INTEGER		:= 1;
CONSTANT CTRL_DELAY				:		INTEGER		:= 1;

CONSTANT PTRH_DELAY				:		STD_LOGIC_VECTOR(1 downto 0)	:= "10";
CONSTANT OVR_DELAY				:		STD_LOGIC_VECTOR(1 downto 0)	:= "01";
CONSTANT CTRLOVR_DELAY			:		STD_LOGIC_VECTOR(1 downto 0)	:= "01";
CONSTANT RST_Delay				:		STD_LOGIC_VECTOR(1 downto 0)	:= "01";
CONSTANT INTERCYCLE_Delay		:		STD_LOGIC_VECTOR(3 downto 0)	:= "0000";

TYPE DETECT_State_Type IS
(
	INIT,
	RESETFIFO,-- FIFO RESET hold for 3 clk period
	IDLE,
	SendAck,
	INPROGRESS,
	OUTRO,
	OP_ERR
);
TYPE EXTRACT_State_Type IS
(
	INIT,
	IDLE,
	CTRL_WFORACK,
	CTRL_INPROGRESS_START,
	CTRL_INPROGRESS,
	PEEK_NEXT_PDU,
	PEEK_NEXT_PDU_wERR,
	SEEK_NEXT_PDU,
	CTRL_PAUSED,
	PASSTHROUGH_WFORACK,
	PASSTHROUGH_DELAY,
	FWD_WFORACK,
	FWD_INPROGRESS_START,
	FWD_INPROGRESS,
	HOLD_OUTOVR,
	OUTRO
);

ATTRIBUTE ENUM_ENCODING : STRING;

----------------
----------------
--DETECT part  signals
----------------
--FSM signals
SIGNAL	DETECT_State			:	DETECT_State_Type;
SIGNAL	RST_Delay_CNTR			:	STD_LOGIC_VECTOR(RST_Delay'Length downto 0);
----------------
-- OUTPUT signals
SIGNAL	RSTFIFO				:	STD_LOGIC := '0';
SIGNAL	RCPT_ERR				:	STD_LOGIC := '0';
SIGNAL	In_Ack_sig			:	STD_LOGIC := '0';
SIGNAL	WREN_OVR_NEG			:	STD_LOGIC := '0';
----------------
----------------
--RX EXTRACT part signals
----------------
--FSM signals
SIGNAL	EXTRACT_State			:	EXTRACT_State_Type;
SIGNAL	PTRH_DELAY_CNTR		:	STD_LOGIC_VECTOR(1 downto 0);
SIGNAL	OVR_Delay_CNTR			:	STD_LOGIC_VECTOR(1 downto 0);
SIGNAL	INTERCYCLE_Delay_CNTR	:	STD_LOGIC_VECTOR(1 downto 0);
----------------
-- OUTPUT signals
SIGNAL	Out_SOP_sig			:	STD_LOGIC;
SIGNAL	Out_Ind_sig			:	STD_LOGIC;
SIGNAL	CTRL_OVR_NEG			:	STD_LOGIC;
SIGNAL	OUT_OVR_NEG			:	STD_LOGIC;
SIGNAL	CTRL_Ind_sig			:	STD_LOGIC;
SIGNAL	ErrOutOVR				:	STD_LOGIC;
SIGNAL	OUT_delay_en			:	STD_LOGIC;
SIGNAL	CTRL_delay_en			:	STD_LOGIC;
----------------
----------------
--Delayed input signals
SIGNAL	DIN_delayed			:	STD_LOGIC_VECTOR(DataWidth-1 downto 0);
SIGNAL	DINV_delayed			:	STD_LOGIC;
SIGNAL	In_SOP_delayed			:	STD_LOGIC;
SIGNAL	In_EOP_delayed			:	STD_LOGIC;
SIGNAL	In_ErrIn_delayed		:	STD_LOGIC;


----------------
----------------
--FIFO 1 signals
SIGNAL	FIFO_1_ALMOSTEMPTY		:	STD_LOGIC;
SIGNAL	FIFO_1_ALMOSTFULL		:	STD_LOGIC;
SIGNAL	FIFO_1_DO				:	STD_LOGIC_VECTOR(31 downto 0);
SIGNAL	FIFO_1_DOP			:	STD_LOGIC_VECTOR(3 downto 0);
SIGNAL	FIFO_1_EMPTY			:	STD_LOGIC;
SIGNAL	FIFO_1_FULL			:	STD_LOGIC;
SIGNAL	FIFO_1_RDERR			:	STD_LOGIC;
SIGNAL	FIFO_1_WRERR			:	STD_LOGIC;
SIGNAL	FIFO_1_DI				:	STD_LOGIC_VECTOR(31 downto 0);
SIGNAL	FIFO_1_DIP			:	STD_LOGIC_VECTOR(3 downto 0);
SIGNAL	FIFO_1_RDEN			:	STD_LOGIC;
SIGNAL	FIFO_RST				:	STD_LOGIC;
SIGNAL	FIFO_1_WREN			:	STD_LOGIC;
----------------
----------------
--FIFO 2 signals
SIGNAL	FIFO_2_ALMOSTEMPTY		:	STD_LOGIC;
SIGNAL	FIFO_2_ALMOSTFULL		:	STD_LOGIC;
SIGNAL	FIFO_2_DO				:	STD_LOGIC_VECTOR(31 downto 0);
SIGNAL	FIFO_2_DO_delayed		:	STD_LOGIC_VECTOR(31 downto 0);
SIGNAL	FIFO_2_DOP			:	STD_LOGIC_VECTOR(3 downto 0);
SIGNAL	FIFO_2_EMPTY			:	STD_LOGIC;
SIGNAL	FIFO_2_FULL			:	STD_LOGIC;
SIGNAL	FIFO_2_RDERR			:	STD_LOGIC;
SIGNAL	FIFO_2_WRERR			:	STD_LOGIC;
SIGNAL	FIFO_2_DI				:	STD_LOGIC_VECTOR(31 downto 0);
SIGNAL	FIFO_2_DIP			:	STD_LOGIC_VECTOR(3 downto 0);
SIGNAL	FIFO_2_RDEN			:	STD_LOGIC;
SIGNAL	FIFO_2_RDEN_sig		:	STD_LOGIC;
SIGNAL	FIFO_2_WREN			:	STD_LOGIC;
----------------
--SUPPL. signals
SIGNAL	FIFO_SOP				:	STD_LOGIC;
SIGNAL	FIFO_EOP				:	STD_LOGIC;
SIGNAL	FIFO_DINV				:	STD_LOGIC;
SIGNAL	FIFO_Error			:	STD_LOGIC;
SIGNAL	In_ErrIn_INT			:	STD_LOGIC;
SIGNAL	CTRL_DV_sig			:	STD_LOGIC;
SIGNAL	OUT_EOP_sig			:	STD_LOGIC;
SIGNAL	out_eop_sig_ovr		:	STD_LOGIC;
SIGNAL	out_eop_sig_pred		:	STD_LOGIC;
SIGNAL	DOUTV_sig				:	STD_LOGIC;
SIGNAL	doutv_sig_pred			:	STD_LOGIC;
SIGNAL	DOUTV_sig_ovr			:	STD_LOGIC;
SIGNAL	CTRL_SOP_sig			:	STD_LOGIC;
SIGNAL	CTRL_EOP_sig			:	STD_LOGIC;
SIGNAL	CTRL_DOUT_sig			:	STD_LOGIC_VECTOR(Datawidth-1 downto 0);
SIGNAL	FIFO_DOUT_sig			:	STD_LOGIC_VECTOR(Datawidth-1 downto 0);
SIGNAL	DOUT_sig				:	STD_LOGIC_VECTOR(Datawidth-1 downto 0);
SIGNAL	dout_sig_pred			:	STD_LOGIC_VECTOR(Datawidth-1 downto 0);
SIGNAL	USER_in_delayed		:	STD_LOGIC_VECTOR(USER_in'Length-1 downto 0);
SIGNAL	USER_out_sig			:	STD_LOGIC_VECTOR(USER_out'Length-1 downto 0);
SIGNAL	USER_out_sig_pred		:	STD_LOGIC_VECTOR(USER_out'Length-1 downto 0);
SIGNAL	OUT_delay_en_sig		:	STD_LOGIC;
SIGNAL	Out_ErrOut_sig			:	STD_LOGIC;
SIGNAL	CTRL_OUT_delay_en_sig	:	STD_LOGIC;
SIGNAL	IN_delay_en_sig		:	STD_LOGIC;
----------------


BEGIN

DETECT_FSM_LOGIC:PROCESS(	CLK,
						rst,
						ce_in,
						DETECT_State,
						In_SOP,
						DINV,
						FIFO_2_ALMOSTFULL,
						In_ErrIn,
						In_Ind,
						In_ErrIn_INT,
						IN_EOP
						)
BEGIN
	IF(RISING_EDGE(clk)) THEN
		IF(rst = Hi) THEN
			RSTFIFO		<=	Hi;
			In_Ack_sig	<=	Lo;
			RCPT_ERR		<=	Lo;
			WREN_OVR_NEG	<=	Lo;
			RST_Delay_CNTR	<=	(OTHERS =>Lo);
			DETECT_State	<=	RESETFIFO;
		ELSE
			IF(CE_In = Hi) THEN
				CASE DETECT_State IS
					--The RST  OF FIFO must be asserted for 3 CLK periods
					WHEN INIT =>
						RSTFIFO		<=	Lo;
						RCPT_ERR		<=	Lo;
						WREN_OVR_NEG	<=	Lo;
						IF(In_SOP = Lo AND DINV = Lo AND FIFO_2_ALMOSTFULL = Lo AND In_ErrIn = Lo AND In_EOP = Lo)THEN
							DETECT_State	<=	IDLE;
						ELSE 
							DETECT_State	<=	INIT;
						END IF;
					WHEN IDLE =>
						RCPT_ERR		<=	Lo;
						In_Ack_sig	<=	Lo;
						WREN_OVR_NEG	<=	Lo;
						IF(not SYNC_IN) THEN
							IF(In_SOP = Hi AND DINV= Hi AND In_ErrIn = Lo) THEN --ASYNC Start OF PDU
								DETECT_State	<=	INPROGRESS;
							ELSIF(In_SOP = Lo AND DINV = Lo) THEN
								DETECT_State	<=	IDLE;
							ELSE
								DETECT_State	<=	OP_ERR;
							END IF;
						ELSE
							IF(In_Ind = Hi AND DINV=Lo AND In_SOP = Lo AND In_ErrIn = Lo) THEN --SYNC handshake start
								DETECT_State	<=	SendAck;
							ELSIF(In_Ind = Lo AND DINV=Lo AND In_SOP = Lo) THEN
								DETECT_State	<=	IDLE;
							ELSE
								DETECT_State	<=	OP_ERR;
							END IF;
						END IF;
					WHEN SendAck => --Waiting for start OF PDU
						In_Ack_sig	<=	Hi;
						IF(DINV = Hi AND In_SOP = Hi AND In_ErrIn = Lo) THEN
							DETECT_State	<=	INPROGRESS;
						ELSIF(DINV = Lo AND In_ErrIn = Hi) THEN
							DETECT_State	<=	IDLE;
						ELSIF((DINV = Hi AND In_ErrIn = Hi) or (DINV = Hi AND In_SOP = Lo)) THEN
							DETECT_State	<=	OP_ERR;
						ELSE
							DETECT_State	<=	SendAck;
						END IF;
					WHEN INPROGRESS => --PDU reception IN progress
						WREN_OVR_NEG	<=	Hi;
						In_Ack_sig	<=	Lo;
						-- IF(In_ErrIn = Hi) THEN
						IF(In_ErrIn_INT = Hi) THEN --ez azért kell, hogy ha hibás adat jön, akkor IS írodjon be valami
							DETECT_State	<=	OP_ERR; --FIFO_2_FULL included IN In_ErrIn_INT SIGNAL
						ELSE
							IF(DINV = Hi AND IN_EOP = Hi) THEN 
								DETECT_State	<=	OUTRO;
							ELSE
								DETECT_State	<=	INPROGRESS;
							END IF;
						END IF;
					WHEN OUTRO => --ez azért, hogy meglegyen a 2 órajel bemeneti késleltetés
						IF(In_SOP = Lo AND DINV = Lo AND FIFO_2_ALMOSTFULL = Lo AND In_ErrIn = Lo)THEN
							DETECT_State	<=	IDLE;
						ELSE 
							DETECT_State	<=	INIT;
						END IF;
					WHEN OP_ERR =>
						WREN_OVR_NEG	<=	Lo;
						RCPT_ERR		<=	Hi;
						In_Ack_sig	<=	Lo;
						IF(DINV = Hi) THEN
							DETECT_State	<=	OP_ERR;
						ELSE
							IF(In_SOP = Lo AND DINV = Lo AND FIFO_2_ALMOSTFULL = Lo AND In_ErrIn = Lo AND IN_EOP = Lo)THEN
								RCPT_ERR		<=	Lo; -- for faster recovery
								DETECT_State	<=	IDLE;
							ELSE
								DETECT_State	<=	INIT;
							END IF;
						END IF;
					WHEN OTHERS =>		--RESETFIFO state
					-- WHEN RESETFIFO =>		--RESETFIFO state
						IF(RST_Delay_CNTR = RST_Delay) THEN
							DETECT_State	<=	INIT;
						ELSE
							RST_Delay_CNTR	<=	RST_Delay_CNTR + 1;
							DETECT_State	<=	RESETFIFO;
						END IF;
				END CASE;
			END IF;
		END IF;
	END IF;
END PROCESS DETECT_FSM_LOGIC;



EXTRACT_State_LOGIC:PROCESS(	clk,
						rst,
						CE_Out,
						EXTRACT_State,
						FIFO_2_EMPTY,
						FIFO_SOP,
						FIFO_DINV,
						FIFO_Error,
						CTRL_FWD,
						CTRL_Ack,
						CTRL_DROP_ERR,
						FIFO_EOP,
						CTRL_PAUSE,
						Out_Ack,
						PTRH_DELAY_CNTR,
						OVR_Delay_CNTR)--IN order OF appearance :)
BEGIN
	IF(RISING_EDGE(clk)) THEN
		IF(RST = Hi) THEN
			Out_SOP_sig	<=	Lo;
			Out_Ind_sig	<=	Lo;
			CTRL_OVR_NEG	<=	Lo;
			OUT_OVR_NEG	<=	Lo;
			CTRL_Ind_sig	<=	Lo;
			FIFO_2_RDEN	<=	Lo;
			OUT_delay_en	<=	Hi;
			ErrOutOVR		<=	Lo;
			CTRL_delay_en	<=	Hi;
			OVR_Delay_CNTR	<=	(OTHERS => Lo);--resetting  counters,AND setting to Init state
			PTRH_DELAY_CNTR<=	(OTHERS => Lo);
			EXTRACT_State	<=	INIT;
		ELSE
			IF(CE_Out = Hi) THEN	
				CASE EXTRACT_State IS
					WHEN IDLE =>
						-- OUT_delay_en	<=	Lo;
						CTRL_delay_en	<=	Hi;
						OUT_OVR_NEG	<=	Lo;
						CTRL_OVR_NEG	<=	Lo;
						ErrOutOVR		<=	Lo;
						IF(FIFO_2_EMPTY = Lo) THEN --there IS something IN the FIFO
							IF(FIFO_SOP = Hi AND FIFO_DINV = Hi AND FIFO_Error = Lo) THEN --valid PDU Start
								IF(CTRL_FWD = Hi) THEN
									IF(SYNC_OUT) THEN
										EXTRACT_State	<=	PASSTHROUGH_WFORACK;--passthrough mode
									ELSE
										EXTRACT_State	<=	PASSTHROUGH_DELAY;
									END IF;
								ELSE
									IF(SYNC_CTRL) THEN		--start handshake
										EXTRACT_State	<=	CTRL_WFORACK;
									ELSE
										EXTRACT_State	<=	CTRL_INPROGRESS_START;
									END IF;
								END IF;
							ELSE --Start OF PDU Error
								FIFO_2_RDEN	<=	Hi;
								EXTRACT_State	<=	SEEK_NEXT_PDU;
							END IF;
						ELSE
							EXTRACT_State	<=	IDLE;
						END IF;
					WHEN CTRL_WFORACK =>
						CTRL_Ind_sig	<=	Hi;
						IF(CTRL_DROP_ERR = Lo) THEN
							IF(CTRL_Ack = Hi) THEN
								EXTRACT_State	<=	CTRL_INPROGRESS_START;
							ELSE
								EXTRACT_State	<=	CTRL_WFORACK;
							END IF;
						ELSE
							EXTRACT_State	<=	seek_next_pdu;
						END IF;
					WHEN CTRL_INPROGRESS_START =>
						CTRL_OVR_NEG	<=	Hi;
						FIFO_2_RDEN	<=	Hi;
						EXTRACT_State	<=	CTRL_INPROGRESS;
					WHEN CTRL_INPROGRESS =>
						CTRL_Ind_sig	<=	Lo;
						OUT_delay_en	<=	Hi;
						CTRL_delay_en	<=	Hi;
						FIFO_2_RDEN	<=	Hi;
						IF(FIFO_2_EMPTY = Hi) THEN --underflow_error
							FIFO_2_RDEN	<=	Lo;
							EXTRACT_State	<=	peek_next_pdu_wErr;
						ELSE
							IF(CTRL_DROP_ERR = Hi or FIFO_Error = Hi or (FIFO_EOP = Hi AND FIFO_DINV = Hi)) THEN
								FIFO_2_RDEN	<=	Lo;
								CTRL_OVR_NEG	<=	Lo;
								OVR_Delay_CNTR	<=	(OTHERS => Lo);
								EXTRACT_State	<=	peek_next_pdu;
							ELSE
								IF(CTRL_PAUSE = Hi AND CTRL_FWD = Lo) THEN
									OUT_delay_en	<=	Lo;
									CTRL_delay_en	<=	Lo;
									FIFO_2_RDEN	<=	Lo;
									EXTRACT_State	<=	CTRL_PAUSED;
								ELSIF(CTRL_FWD = Hi) THEN
									OUT_delay_en	<=	Lo;
									IF(SYNC_OUT) THEN
										EXTRACT_State	<=	FWD_WFORACK;
									ELSE
										EXTRACT_State	<=	FWD_INPROGRESS_START;
									END IF;
								ELSE
									EXTRACT_State	<=	CTRL_INPROGRESS;
								END IF;
							END IF;
						END IF;
					WHEN CTRL_PAUSED=>
						OUT_delay_en	<=	Lo;
						CTRL_delay_en	<=	Lo;
						FIFO_2_RDEN	<=	Lo;
						IF(CTRL_DROP_ERR = Hi or FIFO_Error = Hi or FIFO_EOP = Hi) THEN
							FIFO_2_RDEN	<=	Lo;
							OVR_Delay_CNTR	<=	(OTHERS => Lo);
							EXTRACT_State	<=	peek_next_pdu;
						ELSE
							IF(CTRL_PAUSE = Hi AND CTRL_FWD = Lo) THEN
								EXTRACT_State	<=	CTRL_PAUSED;
							ELSIF(CTRL_FWD = Hi) THEN
								IF(SYNC_OUT) THEN
									EXTRACT_State	<=	FWD_WFORACK;
								ELSE
									EXTRACT_State	<=	FWD_INPROGRESS_START;
								END IF;
							ELSE
								EXTRACT_State	<=	CTRL_INPROGRESS;
							END IF;
						END IF;
					WHEN FWD_WFORACK=>
						CTRL_OVR_NEG	<=	Lo;
						OUT_OVR_NEG	<=	Lo;
						FIFO_2_RDEN	<=	Lo;
						Out_Ind_sig	<=	Hi;
						OUT_delay_en	<=	Lo;
						CTRL_delay_en	<=	Hi;
						IF(Out_ErrIn = Lo) THEN
							IF(Out_Ack = Hi) THEN
								EXTRACT_State	<=	FWD_INPROGRESS_START;
							ELSE
								EXTRACT_State	<=	FWD_WFORACK;
							END IF;
						ELSE
							EXTRACT_State	<=	seek_next_pdu;
						END IF;
					WHEN PASSTHROUGH_WFORACK=>
						CTRL_OVR_NEG	<=	Lo;
						OUT_OVR_NEG	<=	Lo;
						FIFO_2_RDEN	<=	Lo;
						Out_Ind_sig	<=	Hi;
						IF(Out_ErrIn = Lo) THEN
							IF(Out_Ack = Hi) THEN
								EXTRACT_State	<=	PASSTHROUGH_DELAY;
							ELSE
								EXTRACT_State	<=	PASSTHROUGH_WFORACK;
							END IF;
						ELSE
							EXTRACT_State	<=	seek_next_pdu;
						END IF;
					WHEN PASSTHROUGH_DELAY =>
						FIFO_2_RDEN	<=	Hi;
						IF(PTRH_DELAY_CNTR = PTRH_DELAY) THEN
							PTRH_DELAY_CNTR	<=	(OTHERS => Lo);
							EXTRACT_State		<=	FWD_INPROGRESS_START;
						ELSE
							PTRH_DELAY_CNTR	<=	PTRH_DELAY_CNTR + 1;
							EXTRACT_State		<=	PASSTHROUGH_DELAY;
						END IF;
					WHEN FWD_INPROGRESS_START =>
						CTRL_OVR_NEG	<=	Lo;
						OUT_OVR_NEG	<=	Hi;
						Out_SOP_sig	<=	Hi;
						Out_Ind_sig	<=	Lo;
						FIFO_2_RDEN	<=	Hi;
						OUT_delay_en	<=	Hi;
						CTRL_delay_en	<=	Hi;
						IF(FIFO_Error = Hi) THEN
							FIFO_2_RDEN	<=	Lo;
							EXTRACT_State	<=	PEEK_NEXT_PDU_wERR;
						ELSE
							EXTRACT_State	<=	FWD_INPROGRESS;
						END IF;
					WHEN FWD_INPROGRESS =>
						OUT_delay_en	<=	Hi;
						Out_SOP_sig	<=	Lo;
						FIFO_2_RDEN	<=	Hi;
						OVR_Delay_CNTR	<=	(OTHERS => Lo);
						IF(FIFO_2_EMPTY = Hi)THEN --underflow_error
							FIFO_2_RDEN	<=	Lo;
							EXTRACT_State	<=	PEEK_NEXT_PDU_wERR;
						ELSE
							IF(FIFO_Error = Hi) THEN
								FIFO_2_RDEN	<=	Lo;
								-- EXTRACT_State	<=	PEEK_NEXT_PDU;
								EXTRACT_State	<=	PEEK_NEXT_PDU_wERR;
							ELSIF(FIFO_Error = Lo AND FIFO_EOP = Hi) THEN
								FIFO_2_RDEN	<=	Lo;
								EXTRACT_State	<=	HOLD_OUTOVR;
							ELSE
								EXTRACT_State	<=	FWD_INPROGRESS;
							END IF;
						END IF;
					WHEN HOLD_OUTOVR =>
						FIFO_2_RDEN	<=	Lo;
						IF(OVR_Delay_CNTR = OVR_Delay) THEN
							INTERCYCLE_Delay_CNTR	<=	(OTHERS => Lo);
							OVR_Delay_CNTR			<=	(OTHERS => Lo);
							EXTRACT_State			<=	OUTRO;
						ELSE
							OVR_Delay_CNTR	<=	OVR_Delay_CNTR + 1;
							EXTRACT_State	<=	HOLD_OUTOVR;
						END IF;
					WHEN	OUTRO =>
						OUT_OVR_NEG	<=	Lo;
						CTRL_OVR_NEG	<=	Lo;
						IF(INTERCYCLE_Delay_CNTR = INTERCYCLE_Delay) THEN
							IF(CTRL_DROP_ERR = Lo AND CTRL_PAUSE = Lo AND Out_ErrIn = Lo AND FIFO_Error = Lo) THEN
								EXTRACT_State	<=	IDLE;
							ELSE
								EXTRACT_State	<=	INIT;
							END IF;
						ELSE
							INTERCYCLE_Delay_CNTR	<=	INTERCYCLE_Delay_CNTR - 1;
						END IF;
					WHEN peek_next_pdu =>
						CTRL_delay_en	<=	Hi;
						OUT_OVR_NEG	<=	Lo;
						CTRL_OVR_NEG	<=	Lo;
						FIFO_2_RDEN	<=	Lo;
						IF(FIFO_SOP = Hi AND FIFO_DINV = Hi AND FIFO_2_EMPTY = Lo) THEN
							EXTRACT_State	<=	IDLE;
						ELSE
							FIFO_2_RDEN	<=	Hi;
							EXTRACT_State	<=	seek_next_pdu;
						END IF;
					WHEN peek_next_pdu_wErr =>
						OUT_OVR_NEG	<=	Lo;
						CTRL_OVR_NEG	<=	Lo;
						FIFO_2_RDEN	<=	Lo;
						Out_SOP_sig	<=	Lo;
						ErrOutOVR		<=	Hi;
						IF(Out_Ack = Lo)THEN
							IF(FIFO_SOP = Hi AND FIFO_DINV = Hi AND FIFO_2_EMPTY = Lo) THEN
								EXTRACT_State	<=	IDLE;
							ELSE
								FIFO_2_RDEN	<=	Hi;
								EXTRACT_State	<=	seek_next_pdu;
							END IF;
						ELSE
							EXTRACT_State	<=	peek_next_pdu_wErr;
						END IF;
					WHEN seek_next_pdu =>
						CTRL_Ind_sig	<=	Lo;
						Out_Ind_sig	<=	Lo;
						FIFO_2_RDEN	<=	Hi;
						ErrOutOVR		<=	Lo;
						IF(FIFO_2_EMPTY = Hi) THEN 
							EXTRACT_State	<=	INIT;
						ELSE
							FIFO_2_RDEN	<=	Lo;
							EXTRACT_State	<=	peek_next_pdu;
						END IF;
					WHEN OTHERS => -- INIT
	--				WHEN INIT => --
						Out_SOP_sig	<=	Lo;
						Out_Ind_sig	<=	Lo;
						CTRL_OVR_NEG	<=	Lo;
						OUT_OVR_NEG	<=	Lo;
						CTRL_Ind_sig	<=	Lo;
						FIFO_2_RDEN	<=	Lo;
						IF(CTRL_DROP_ERR = Lo AND CTRL_PAUSE = Lo AND Out_ErrIn = Lo AND FIFO_Error = Lo) THEN
							EXTRACT_State	<=	IDLE;
						ELSE
							EXTRACT_State	<=	INIT;
						END IF;
				END CASE;
			END IF;
		END IF;
	END IF;
END PROCESS EXTRACT_State_LOGIC;

FIFO_2_RDEN_sig	<=	FIFO_2_RDEN and CE_Out;
FIFO36_2ND : FIFO36
GENERIC MAP 
(
	-- ALMOST_FULL_OFFSET		=> X"080",-- Sets almost full threshold
	ALMOST_FULL_OFFSET		=>	FIFO_2_AFO_BV,-- Sets the almost empty threshold
	ALMOST_EMPTY_OFFSET		=>	X"080",-- Sets the almost empty threshold
	-- ALMOST_EMPTY_OFFSET	=>	to_bitvector(STD_LOGIC_VECTOR(to_unsigned(FIFO_2_AFO_INT,13))),-- Sets the almost empty threshold
	DATA_WIDTH			=>	FIFO_Width,-- Sets data width to 4,9,or 18
	DO_REG				=>	1,-- Enable output register ( 0 or 1)
	-- Must be 1 IF the EN_SYN = FALSE
	EN_SYN				=>	FALSE,-- Specified FIFO as Asynchronous (FALSE) or
	-- Synchronous (TRUE)
	FIRST_WORD_FALL_THROUGH	=>	TRUE,-- Sets the FIFO FWFT to TRUE or FALSE
	SIM_MODE				=>	"FAST"
)	-- Simulation: "SAFE" vs "FAST",see "Synthesis AND Simulation
	-- Design Guide" for details
PORT MAP 
(
	ALMOSTEMPTY	=>	FIFO_2_ALMOSTEMPTY,-- 1-bit almost empty output flag
	ALMOSTFULL	=>	FIFO_2_ALMOSTFULL,-- 1-bit almost full output flag
	DO			=>	FIFO_2_DO,-- 32-bit data output
	DOP			=>	FIFO_2_DOP,-- 2-bit parity data output
	EMPTY		=>	FIFO_2_EMPTY,-- 1-bit empty output flag
	FULL			=>	FIFO_2_FULL,-- 1-bit full output flag
	RDCOUNT		=>	OPEN,-- 12-bit read count output
	RDERR		=>	FIFO_2_RDERR,-- 1-bit read error output
	WRCOUNT		=>	OPEN,-- 12-bit write count output
	WRERR		=>	FIFO_2_WRERR,-- 1-bit write error
	DI			=>	FIFO_2_DI,-- 16-bit data input
	DIP			=>	FIFO_2_DIP,-- 2-bit parity input
	RDCLK		=>	CLK,-- 1-bit read clock input
	RDEN			=>	FIFO_2_RDEN_sig,-- 1-bit read enable input
	RST			=>	FIFO_RST,-- 1-bit reset input
	WRCLK		=>	CLK,-- 1-bit write clock input
	WREN			=>	FIFO_2_WREN -- 1-bit write enable input
);


FIFO_RST		<=	RSTFIFO;


FIFO_2_DI(Datawidth-1 downto 0)						<=	DIN_delayed ;
FIFO_2_DI(Datawidth)								<=	In_ErrIn_INT;--Aux signals
FIFO_2_DI(Datawidth+1)								<=	DINV_delayed ;
FIFO_2_DI(Datawidth+2)								<=	In_EOP_delayed;
FIFO_2_DI(Datawidth+3)								<=	In_SOP_delayed;
FIFO_2_DI(FIFO_real_Width-1 downto DataWidth+AUX_signals)	<=	USER_In_delayed(FIFO_real_Width-DataWidth-AUX_signals-1 downto 0);--REAL input width 16 !
FIFO_2_DI(FIFO_2_DI'Length-1 downto FIFO_real_Width)		<=	(OTHERS => Lo);--virtex 5 libguide p117

FIFO_2_WREN										<=	DINV_delayed  AND CE_In AND WREN_OVR_NEG;
FIFO_2_DIP(FIFO_parity_Width-1 downto 0)				<=	USER_In_delayed(USER_In_delayed'Length-1 downto FIFO_real_Width-DataWidth-AUX_signals);
FIFO_2_DIP(FIFO_2_DIP'length-1 downto FIFO_parity_Width)	<=	(OTHERS => '0');

USER_out_sig(USER_out_sig'Length-1 
				downto 
					FIFO_real_Width-DataWidth-AUX_signals)	<=	FIFO_2_DOP(FIFO_parity_Width-1 downto 0);
USER_out_sig(FIFO_real_Width-DataWidth-AUX_signals-1 downto 0)	<=	FIFO_2_DO(FIFO_real_Width-1 downto DataWidth+AUX_signals);
FIFO_SOP												<=	FIFO_2_DO(Datawidth+3);
FIFO_EOP												<=	FIFO_2_DO(Datawidth+2);
FIFO_DINV												<=	FIFO_2_DO(Datawidth+1);
FIFO_Error											<=	FIFO_2_DO(Datawidth);
FIFO_DOUT_sig											<=	FIFO_2_DO(Datawidth-1 downto 0);

In_Ack		<=	In_Ack_sig;
In_ErrOut		<=	RCPT_ERR;
In_ErrIn_INT	<=	RCPT_ERR or In_ErrIn_delayed or FIFO_2_FULL;

CTRL_DOUT_sig	<=	FIFO_DOUT_sig;
CTRL_DV_sig	<=	FIFO_DINV		AND	CTRL_OVR_NEG;
CTRL_SOP_sig	<=	FIFO_SOP		AND	CTRL_OVR_NEG;
CTRL_EOP_sig	<=	FIFO_EOP		AND	CTRL_OVR_NEG;
CTRL_ErrOut	<=	(FIFO_Error	AND	CTRL_OVR_NEG) or ErrOutOVR;


DOUT_sig		<=	FIFO_DOUT_sig;
DOUTV_sig		<=	FIFO_DINV;
OUT_EOP_sig	<=	FIFO_EOP;


IN_delay_en_sig	<=	CE_In;
--input delay
ID_d		: aPipe	GENERIC MAP(Size => DataWidth,Length => INPUT_DELAY)		PORT MAP(I=>DIN,C => CLK,CE => IN_delay_en_sig,Q => DIN_delayed);
IUD_d	: aPipe	GENERIC MAP(Size => USER_in'Length,Length => INPUT_DELAY)	PORT MAP(I=>USER_in,C => CLK,CE => IN_delay_en_sig,Q => USER_in_delayed);
IDV_d	: aDelay	GENERIC MAP(Length => INPUT_DELAY)						PORT MAP(I=>DINV,C => CLK,CE => IN_delay_en_sig,Q => DINV_delayed);
ISOP_d	: aDelay	GENERIC MAP(Length => INPUT_DELAY)						PORT MAP(I=>IN_SOP,C => CLK,CE => IN_delay_en_sig,Q => IN_SOP_delayed);
IEOP_d	: aDelay	GENERIC MAP(Length => INPUT_DELAY)						PORT MAP(I=>IN_EOP,C => CLK,CE => IN_delay_en_sig,Q => IN_EOP_delayed);
IEerr_d	: aDelay	GENERIC MAP(Length => INPUT_DELAY)						PORT MAP(I=>In_ErrIn,C => CLK,CE => IN_delay_en_sig,Q => In_ErrIn_delayed);


OUT_delay_en_sig	<=	OUT_delay_en AND CE_Out;
--output predelay,perevious to AND with OVR SIGNAL 
OD_pred		: aPipe	GENERIC MAP(Size => Datawidth,Length => OUT_DAT_PREDELAY)		PORT MAP(I=>DOUT_sig,C => CLK,CE => OUT_delay_en_sig,Q => DOUT_sig_pred);
OUD_pred		: aPipe	GENERIC MAP(Size => USER_out'Length,Length => OUT_DAT_PREDELAY)	PORT MAP(I=>USER_out_sig,C => CLK,CE => OUT_delay_en_sig,Q => USER_out_sig_pred);
ODV_pred		: aDelay	GENERIC MAP(Length => OUT_SIG_PREDELAY)						PORT MAP(I=>DOUTV_sig,C => CLK,CE => OUT_delay_en_sig,Q => DOUTV_sig_pred);
OEOP_pred		: aDelay	GENERIC MAP(Length => OUT_SIG_PREDELAY)						PORT MAP(I=>OUT_EOP_sig,C => CLK,CE => OUT_delay_en_sig,Q => OUT_EOP_sig_pred);

DOUTV_sig_ovr		<=	DOUTV_sig_pred		AND	OUT_OVR_NEG;
OUT_EOP_sig_ovr	<=	OUT_EOP_sig_pred	AND	OUT_OVR_NEG;
-- Out_Ind			<=	Out_Ind_sig;--		AND	OUT_OVR_NEG; no need to overwrite, since it IS produced by the FSM
-- Out_ErrOut		<=	(FIFO_Error		AND	OUT_OVR_NEG) or ErrOutOVR;
Out_ErrOut_sig		<=	(FIFO_Error		AND	OUT_OVR_NEG) or ErrOutOVR;

--output post delay,post AND with OVR SIGNAL 
OD_postd		: aPipe	GENERIC MAP(Size => DataWidth,Length => OUT_DAT_POSTDELAY)		PORT MAP(I=>DOUT_sig_pred,C => CLK,CE => OUT_delay_en_sig,Q => DOUT);
OUD_postd		: aPipe	GENERIC MAP(Size => USER_out'Length,Length => OUT_DAT_POSTDELAY)	PORT MAP(I=>USER_out_sig_pred,C => CLK,CE => OUT_delay_en_sig,Q => USER_Out);
ODV_postd		: aDelay	GENERIC MAP(Length => OUT_SIG_POSTDELAY)					PORT MAP(I=>DOUTV_sig_ovr,C => CLK,CE => OUT_delay_en_sig,Q => DOUTV);
OSOP_postd	: aDelay	GENERIC MAP(Length => OUT_SIG_POSTDELAY)					PORT MAP(I=>OUT_SOP_sig,C => CLK,CE => OUT_delay_en_sig,Q => Out_SOP);
OEOP_postd	: aDelay	GENERIC MAP(Length => OUT_SIG_POSTDELAY)					PORT MAP(I=>OUT_EOP_sig_ovr,C => CLK,CE => OUT_delay_en_sig,Q => Out_EOP);
OERRO_postd	: aDelay	GENERIC MAP(Length => OUT_SIG_POSTDELAY)					PORT MAP(I=>Out_ErrOut_sig,C => CLK,CE => OUT_delay_en_sig,Q => Out_ErrOut);
--OUT ind delay wo overwrite
OIND_d		: aDelay	GENERIC MAP(Length => OUT_SIG_PREDELAY+OUT_SIG_POSTDELAY)		PORT MAP(I=>Out_Ind_sig,C => CLK,CE => Hi,Q => Out_Ind);


CTRL_OUT_delay_en_sig	<=	CTRL_delay_en AND CE_Out;
--control output delay data + control signals
CTRL_Delay_p		: aPipe	GENERIC MAP(Size => DataWidth,Length => CTRL_DELAY)		PORT MAP(I=>CTRL_DOUT_sig,C => CLK,CE => CTRL_OUT_delay_en_sig,Q => CTRL_DOUT);
CTRL_USRD_Delay_p	: aPipe	GENERIC MAP(Size => USER_out'Length,Length => CTRL_DELAY)	PORT MAP(I=>USER_out_sig,C => CLK,CE => CTRL_OUT_delay_en_sig,Q => USER_Out_CTRL);
CTRL_SOP_Delay_p	: aDelay	GENERIC MAP(Length => CTRL_DELAY)						PORT MAP(I=>CTRL_SOP_sig,C => CLK,CE => CTRL_OUT_delay_en_sig,Q => CTRL_SOP);
CTRL_EOP_Delay_p	: aDelay	GENERIC MAP(Length => CTRL_DELAY)						PORT MAP(I=>CTRL_EOP_sig,C => CLK,CE => CTRL_OUT_delay_en_sig,Q => CTRL_EOP);
CTRL_DV_Delay_p	: aDelay	GENERIC MAP(Length => CTRL_DELAY)						PORT MAP(I=>CTRL_DV_sig,C => CLK,CE => CTRL_OUT_delay_en_sig,Q => CTRL_DV);

CTRL_INd_Delay_p	: aDelay	GENERIC MAP(Length => CTRL_DELAY)						PORT MAP(I=>CTRL_Ind_sig,C => CLK,CE => Hi,Q => CTRL_Ind);


END PDUQueue_ARCH;

-- LIBRARY UNISIM;
-- USE UNISIM.VCOMPONENTS.ALL;

-- LIBRARY IEEE;
-- USE IEEE.STD_LOGIC_1164.ALL;
-- USE IEEE.STD_LOGIC_UNSIGNED.ALL;
-- USE IEEE.numeric_std.ALL;

-- -- USE IEEE.std_logic_misc.ALL;
-- USE IEEE.math_real.ALL;
-- -- USE work.arch.aDelay;
-- USE work.ProtoLayerTypesAndDefs.ALL;


-- ENTITY GenCRC IS
-- Generic(
	-- DataWidth			:		INTEGER								:=	DefDataWidth;
	-- REFIN			:		BOOLEAN								:=	false; --false = MSB first, true=LSB first
	-- Poly				:		STD_LOGIC_VECTOR						:=	"000000000";
	-- RemainderInit		:		STD_LOGIC_VECTOR(Poly'Length-2 downto 0)	:=	(OTHERS => Lo);
	-- PolyFormat		:		INTEGER								:=	1;-- 1= Normal(MSB first), 2= Reversed (LSB first),3=Reversed Reciprocial (Koopman)
	-- REFOut			:		BOOLEAN								:=	false; --Reflect output false
	-- XOROut			:		STD_LOGIC_VECTOR(Poly'Length-2 downto 0)	:=	(OTHERS => Lo);
	-- Phase			:		INTEGER								:=	1
-- );
-- PORT(
	-- CLK				: IN		STD_LOGIC;
	-- RST				: IN		STD_LOGIC;
	-- CE				: IN		STD_LOGIC;
	-- DataIn			: IN		STD_LOGIC_VECTOR(DataWidth-1 downto 0);
	-- CRCOut			: OUT	STD_LOGIC_VECTOR(Poly'Length-2 downto 0);
	-- CRCValid			: OUT	STD_LOGIC
-- );
-- END GenCRC;

-- ARCHITECTURE ArchGenCRCBehav  OF GenCRC IS

-- CONSTANT	PCNTRWidth	:		INTEGER							:=	INTEGER(CEIL(LOG2(REAL(maximum(2,Phase)))));
-- CONSTANT	PhaseCNT_vec	:		STD_LOGIC_VECTOR(PCNTRWidth-1 downto 0)	:=	STD_LOGIC_VECTOR(to_unsigned(Phase,PCNTRWidth));
-- SIGNAL	PhaseCNTR		:		STD_LOGIC_VECTOR(PCNTRWidth-1 downto 0);

-- BEGIN



-- END ArchGenCRCBehav;



