--
-- SNMPModulePkg.vhd
-- ============
--
-- (C) Ferenc Janky, BME TMIT
--   file name:	SNMPModulePkg.vhd
--   PACKAGE:		SNMPModulePkg
--

LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;

USE work.ProtoLayerTypesAndDefs.ALL;

PACKAGE SNMPModulePkg IS

	--		============
	COMPONENT SNMPModule IS
	--		============
	GENERIC(
		DataWidth		:	INTEGER	:= 8;
		CLK_freq		:	REAL		:= 125.0;
		TX_SYNC		:	BOOLEAN	:= false;
		NumOfEvents  	:	INTEGER	:= 32; --max 255, transferred in specific trap
		NumOfLinks  	:	INTEGER	:= 2 --max 255
	);
	PORT(
		CLK					: IN		STD_LOGIC;
		CE					: IN		STD_LOGIC;
		CFG_CE				: IN		STD_LOGIC;
		RST					: IN		STD_LOGIC;
		------------------------------------------------------------
		--				UDP IF
		------------------------------------------------------------
		DstIPAddr_In			: IN		STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
		SrcIPAddr_In			: IN		STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
		DstPort_In			: IN		STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
		SrcPort_In			: IN		STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
		Length_In				: IN		STD_LOGIC_VECTOR( UDPLengthSize-1 DOWNTO 0);
		-------------------------------------------------------------
		DstIPAddr_Out			: OUT	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
		SrcIPAddr_Out			: OUT	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
		DstPort_Out			: OUT	STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
		SrcPort_Out			: OUT	STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
		Length_Out			: OUT	STD_LOGIC_VECTOR( UDPLengthSize-1 DOWNTO 0);
		-------------------------------------------------------------
		-- RX INterface signals
		PDU_DIN				: IN		STD_LOGIC_VECTOR( DataWidth	-1	DOWNTO 0);
		PDU_DINV				: IN		STD_LOGIC;
		PDU_IN_SOP			: IN		STD_LOGIC;
		PDU_IN_EOP			: IN		STD_LOGIC;
		PDU_IN_INd			: IN		STD_LOGIC;
		PDU_IN_ErrOUT			: OUT	STD_LOGIC;
		PDU_IN_Ack			: OUT	STD_LOGIC;
		PDU_IN_ErrIN			: IN		STD_LOGIC;
		-------------------------------------------------------------
		-- TX INterface signals
		PDU_DOUT				: OUT	STD_LOGIC_VECTOR( DataWidth	-1	DOWNTO 0);
		PDU_DOUTV				: OUT	STD_LOGIC;
		PDU_OUT_SOP			: OUT	STD_LOGIC;
		PDU_OUT_EOP			: OUT	STD_LOGIC;
		PDU_OUT_INd			: OUT	STD_LOGIC;
		PDU_OUT_ErrOUT			: OUT	STD_LOGIC;
		PDU_OUT_Ack			: IN		STD_LOGIC;
		PDU_OUT_ErrIN			: IN		STD_LOGIC;
		-------------------------------------------------------------
		-- MGMT INputs
		WR_EN				: IN		STD_LOGIC;
		RD_EN				: IN		STD_LOGIC;
		CFG_ADDR				: IN		STD_LOGIC_VECTOR( SNMPAddrWidth-1	DOWNTO 0);
		DATA_IN				: IN		STD_LOGIC_VECTOR( SNMPDataWidth-1	DOWNTO 0);
		RD_DV				: OUT	STD_LOGIC;
		DATA_OUT				: OUT	STD_LOGIC_VECTOR( SNMPDataWidth-1	DOWNTO 0);
		----SNMP TRAP INitiator INput
		EventIN				: IN		STD_LOGIC_VECTOR( NumOfEvents	-1	DOWNTO 0); --Send with BaseOID.[Bitpos] OID enterpriseSpecific(6)
		LinkStatusIn			: IN		STD_LOGIC_VECTOR( NumOfLinks	-1	DOWNTO 0) --
	);
	END COMPONENT SNMPModule;

END SNMPModulePkg;

LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.MATH_REAL.ALL;

USE work.ProtoLayerTypesAndDefs.ALL;
USE WORK.arch.aRegister;
USE WORK.arch.aFlopC;
USE WORK.arch.aFlop;
USE WORK.arch.aRise;
USE WORK.arch.aFall;
USE WORK.arch.aDelay;
USE WORK.ProtoModulePkg.Serializer;

--		============
ENTITY SNMPModule IS
--		============
GENERIC(
	DataWidth		:	INTEGER	:= 8;
	CLK_freq		:	REAL		:= 125.0;
	TX_SYNC		:	BOOLEAN	:= false;
	NumOfEvents  	:	INTEGER	:= 32; --max 255, transferred in specific trap
	NumOfLinks  	:	INTEGER	:= 2 --max 255
);
PORT(
	CLK					: IN		STD_LOGIC;
	CE					: IN		STD_LOGIC;
	CFG_CE				: IN		STD_LOGIC;
	RST					: IN		STD_LOGIC;
	------------------------------------------------------------
	--				UDP IF
	------------------------------------------------------------
	DstIPAddr_In			: IN		STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
	SrcIPAddr_In			: IN		STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
	DstPort_In			: IN		STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
	SrcPort_In			: IN		STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
	Length_In				: IN		STD_LOGIC_VECTOR( UDPLengthSize-1 DOWNTO 0);
	-------------------------------------------------------------
	DstIPAddr_Out			: OUT	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
	SrcIPAddr_Out			: OUT	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
	DstPort_Out			: OUT	STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
	SrcPort_Out			: OUT	STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
	Length_Out			: OUT	STD_LOGIC_VECTOR( UDPLengthSize-1 DOWNTO 0);
	-------------------------------------------------------------
	-- RX INterface signals
	PDU_DIN				: IN		STD_LOGIC_VECTOR( DataWidth	-1	DOWNTO 0);
	PDU_DINV				: IN		STD_LOGIC;
	PDU_IN_SOP			: IN		STD_LOGIC;
	PDU_IN_EOP			: IN		STD_LOGIC;
	PDU_IN_INd			: IN		STD_LOGIC;
	PDU_IN_ErrOUT			: OUT	STD_LOGIC;
	PDU_IN_Ack			: OUT	STD_LOGIC;
	PDU_IN_ErrIN			: IN		STD_LOGIC;
	-------------------------------------------------------------
	-- TX INterface signals
	PDU_DOUT				: OUT	STD_LOGIC_VECTOR( DataWidth	-1	DOWNTO 0);
	PDU_DOUTV				: OUT	STD_LOGIC;
	PDU_OUT_SOP			: OUT	STD_LOGIC;
	PDU_OUT_EOP			: OUT	STD_LOGIC;
	PDU_OUT_INd			: OUT	STD_LOGIC;
	PDU_OUT_ErrOUT			: OUT	STD_LOGIC;
	PDU_OUT_Ack			: IN		STD_LOGIC;
	PDU_OUT_ErrIN			: IN		STD_LOGIC;
	-------------------------------------------------------------
	-- MGMT INputs
	WR_EN				: IN		STD_LOGIC;
	RD_EN				: IN		STD_LOGIC;
	CFG_ADDR				: IN		STD_LOGIC_VECTOR( SNMPAddrWidth-1	DOWNTO 0);
	DATA_IN				: IN		STD_LOGIC_VECTOR( SNMPDataWidth-1	DOWNTO 0);
	RD_DV				: OUT	STD_LOGIC;
	DATA_OUT				: OUT	STD_LOGIC_VECTOR( SNMPDataWidth-1	DOWNTO 0);
	----SNMP TRAP INitiator INput
	EventIN				: IN		STD_LOGIC_VECTOR( NumOfEvents	-1	DOWNTO 0); --Send with BaseOID.[Bitpos] OID enterpriseSpecific(6)
	LinkStatusIn			: IN		STD_LOGIC_VECTOR( NumOfLinks	-1	DOWNTO 0) --
);
END SNMPModule;

ARCHITECTURE ArchSNMPModuleBehav OF SNMPModule IS
-- EXperimental OID Base 1.3.6.1.3 - experimental
CONSTANT	ExperimentalBASEOID			:		STD_LOGIC_VECTOR( 4*8 - 1	DOWNTO 0)					:=	X"2b060103";
CONSTANT	RelEnterpriseID			:		STD_LOGIC_VECTOR( 8 -1 		DOWNTO 0)					:=	X"07";
CONSTANT	EnterpriseID				:		STD_LOGIC_VECTOR( ExperimentalBASEOID'LENGTH + RelEnterpriseID'LENGTH - 1 DOWNTO 0)	:=	ExperimentalBASEOID & RelEnterpriseID;
CONSTANT	SNMPCommunityStringLegth		:		INTEGER											:=	8*8;
CONSTANT	SNMPCommunityString			:		STD_LOGIC_VECTOR( SNMPCommunityStringLegth	-1	DOWNTO 0)	:=	X"4169746961494e43";

CONSTANT	SNMPTRAPPDULength_Base		:		INTEGER		:=	29+SNMPCommunityStringLegth/8 + EnterpriseID'LENGTH/8;
CONSTANT	SNMPTRAPPDULength_BaseBit	:		INTEGER		:=	SNMPTRAPPDULength_Base*8;
CONSTANT	SNMPTRAPPDULength_Link		:		INTEGER		:=	18 + SNMPTRAPPDULength_Base + ifIndexBaseOid'LENGTH/8 + ifDescrBaseOid'LENGTH/8 + ETHString'LENGTH/8;
CONSTANT	SNMPTRAPPDULength_LinkBit	:		INTEGER		:=	SNMPTRAPPDULength_Link*8;

CONSTANT	TRAPPDUOffset				:		INTEGER		:=	SNMPTRAPPDULength_BaseBit - 56 - SNMPCommunityStringLegth;
CONSTANT	NetworkAddrOffset			:		INTEGER		:=	TRAPPDUOffset - 32 - EnterpriseID'Length;
CONSTANT	GenericTrapOffset			:		INTEGER		:=	NetworkAddrOffset - 48;
CONSTANT	SpecificTrapOffset			:		INTEGER		:=	GenericTrapOffset - 24;
CONSTANT	TimeTickOffset				:		INTEGER		:=	SpecificTrapOffset - 24;

CONSTANT	TRAPPDUOffset_Link			:		INTEGER		:=	SNMPTRAPPDULength_LinkBit - 56 - SNMPCommunityStringLegth;
CONSTANT	NetworkAddrOffset_Link		:		INTEGER		:=	TRAPPDUOffset_Link - 32 - EnterpriseID'Length;
CONSTANT	GenericTrapOffset_Link		:		INTEGER		:=	NetworkAddrOffset_Link - 48;
CONSTANT	SpecificTrapOffset_Link		:		INTEGER		:=	GenericTrapOffset_Link - 24;
CONSTANT	TimeTickOffset_Link			:		INTEGER		:=	SpecificTrapOffset_Link - 24;
CONSTANT	VarbindListOffset_Link		:		INTEGER		:=	TimeTickOffset_Link - TIMETICKLength - 16;
CONSTANT	ifIndexOffset_Link			:		INTEGER		:=	VarbindListOffset_Link - 16;
CONSTANT	ifDescrOffset_Link			:		INTEGER		:=	ifIndexOffset_Link - 40 - ifIndexOidSize;

CONSTANT	LinkStateNULLvec			:		STD_LOGIC_VECTOR( NumOfLinks	-1	DOWNTO 0)	:=	STD_LOGIC_VECTOR(TO_UNSIGNED(0,NumOfLinks));
CONSTANT	EventStateNULLvec			:		STD_LOGIC_VECTOR( NumOfEvents	-1	DOWNTO 0)	:=	STD_LOGIC_VECTOR(TO_UNSIGNED(0,NumOfEvents));

CONSTANT	TimeFaktor				:		REAL			:=	1000.0;
CONSTANT	TimerWidth				:		INTEGER								:=	INTEGER(CEIL(LOG2(10.0*CLK_freq*TimeFaktor)));
CONSTANT	Time10ms_vec				:		STD_LOGIC_VECTOR( TimerWidth-1 DOWNTO 0)	:=	STD_LOGIC_VECTOR(TO_UNSIGNED(INTEGER(10.0*CLK_freq*TimeFaktor-1.0),TimerWidth)); --10 ms vec

CONSTANT	RDV_delay					:		INTEGER								:=	2;
--------------------------------------
-- Config Mapping
--------------------------------------
CONSTANT	CFGADDR_ManagerIPAddr		:		INTEGER	:=	0;
CONSTANT	CFGADDR_AgentIPAddr			:		INTEGER	:=	1;
CONSTANT	CFGADDR_ManagerTrapPort		:		INTEGER	:=	2;
CONSTANT	CFGADDR_AgentTrapPort		:		INTEGER	:=	3;
--------------------------------------
-- Config Registers
--------------------------------------
SIGNAL	ManagerIPAddr				:		STD_LOGIC_VECTOR( IPAddrSize	-1	DOWNTO 0);
SIGNAL	AgentIPAddr				:		STD_LOGIC_VECTOR( IPAddrSize	-1	DOWNTO 0);
SIGNAL	ManagerTrapPort			:		STD_LOGIC_VECTOR( UDPPortSize	-1	DOWNTO 0);
SIGNAL	AgentTrapPort				:		STD_LOGIC_VECTOR( UDPPortSize	-1	DOWNTO 0);
--------------------------------------
--CFG IF signals
--------------------------------------
SIGNAL	CFG_ADDR_temp				:		STD_LOGIC_VECTOR( SNMPAddrWidth-1 downto 0);
SIGNAL	CFG_ADDR_reg				:		STD_LOGIC_VECTOR( SNMPAddrWidth-1 downto 0);
SIGNAL	WR_EN_reg					:		STD_LOGIC;
SIGNAL	WR_EN_rise				:		STD_LOGIC;
SIGNAL	RD_EN_reg					:		STD_LOGIC;
SIGNAL	RD_EN_rise				:		STD_LOGIC;
SIGNAL	WRRD_EN_rise				:		STD_LOGIC;
SIGNAL	DATA_IN_temp				:		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
SIGNAL	DATA_IN_reg				:		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
SIGNAL	Port_IN_reg				:		STD_LOGIC_VECTOR( UDPPortSize-1 downto 0);

TYPE		CFG_sig_Array IS array (0 to SNMPNumOFCFGRegs-1) OF STD_LOGIC;
TYPE		CFG_vec_Array IS array (0 to SNMPNumOFCFGRegs-1) OF STD_LOGIC_VECTOR( SNMPDataWidth-1 downto 0);
SIGNAL	WR_EN_Array				:		CFG_sig_Array;
SIGNAL	RD_EN_Array				:		CFG_sig_Array;
SIGNAL	DATA_Out_Array				:		CFG_vec_Array;
--------------------------------------

SIGNAL	TX_PDU_register_Event		:		STD_LOGIC_VECTOR( SNMPTRAPPDULength_BaseBit	- 1	DOWNTO 0);
SIGNAL	TX_PDU_register_Link		:		STD_LOGIC_VECTOR( SNMPTRAPPDULength_LinkBit	- 1	DOWNTO 0);

SIGNAL	TimeTick_Link				:		STD_LOGIC_VECTOR( TIMETICKLength			- 1	DOWNTO 0)	:=	(OTHERS => Hi);
SIGNAL	GenericTrap_Link			:		STD_LOGIC_VECTOR( 8						- 1	DOWNTO 0)	:=	(OTHERS => Hi);
SIGNAL	ifID						:		STD_LOGIC_VECTOR( 8						- 1	DOWNTO 0)	:=	(OTHERS => Hi);
SIGNAL	ifIDString				:		STD_LOGIC_VECTOR( 24					- 1	DOWNTO 0)	:=	(OTHERS => Hi);

SIGNAL	LinkStatusIn_reg			:		STD_LOGIC_VECTOR( NumOfLinks	-1	DOWNTO 0);
SIGNAL	LinkStatusIn_rise			:		STD_LOGIC_VECTOR( NumOfLinks	-1	DOWNTO 0);
SIGNAL	LinkStatusIn_fall			:		STD_LOGIC_VECTOR( NumOfLinks	-1	DOWNTO 0);
SIGNAL	LinkUp_vec				:		STD_LOGIC_VECTOR( NumOfLinks	-1	DOWNTO 0);
SIGNAL	LinkDown_vec				:		STD_LOGIC_VECTOR( NumOfLinks	-1	DOWNTO 0);
SIGNAL	ClearLinkUp_vec			:		STD_LOGIC_VECTOR( NumOfLinks	-1	DOWNTO 0);
SIGNAL	ClearLinkDown_vec			:		STD_LOGIC_VECTOR( NumOfLinks	-1	DOWNTO 0);

SIGNAL	Timer					:		STD_LOGIC_VECTOR( TimerWidth -1	DOWNTO 0);
SIGNAL	TimeTick_reg				:		STD_LOGIC_VECTOR( TIMETICKLength-1	DOWNTO 0);

SIGNAL	EventIN_reg				:		STD_LOGIC_VECTOR( NumOfEvents	-1	DOWNTO 0);
SIGNAL	EventIN_rise				:		STD_LOGIC_VECTOR( NumOfEvents	-1	DOWNTO 0);
SIGNAL	EventIN_vec				:		STD_LOGIC_VECTOR( NumOfEvents	-1	DOWNTO 0);
SIGNAL	ClearEventIN_vec			:		STD_LOGIC_VECTOR( NumOfEvents	-1	DOWNTO 0);

TYPE LinkTrapFSM_StateType IS
(
	INIT,
	IDLE,
	InitLinkDownTrap,
	ClearInput_LinkDown,
	InitLinkUpTrap,
	ClearInput_LinkUp,
	SendLinkTrap_WFORACK,
	SendLinkTrap
);
ATTRIBUTE	ENUM_ENCODING	:	STRING;

SIGNAL	LinkTrapFSM_State			:		LinkTrapFSM_StateType;
SIGNAL	IfIndex_reg				:		STD_LOGIC_VECTOR( 8 - 1 DOWNTO 0);
SIGNAL	SerStart_LinkTrap			:		STD_LOGIC;
SIGNAL	Length_Out_Link			:		STD_LOGIC_VECTOR( UDPLengthSize - 1 DOWNTO 0);


TYPE EventTrapFSM_StateType IS
(
	InitColdStartTrap,
	InitWarmStartTrap,
	IDLE,
	InitEventTrap,
	ClearInput_Event,
	SendEventTrap_WFORACK,
	SendEventTrap
);

SIGNAL	EventTrapFSM_State			:		EventTrapFSM_StateType;
SIGNAL	GenericTrap_Event			:		STD_LOGIC_VECTOR( 8						- 1 DOWNTO 0);
SIGNAL	SpecificTrap_Event			:		STD_LOGIC_VECTOR( 8						- 1 DOWNTO 0);
SIGNAL	EventINIndex_reg			:		STD_LOGIC_VECTOR( SpecificTrap_Event'LENGTH	- 1 DOWNTO 0);
SIGNAL	SerStart_EventTrap			:		STD_LOGIC;
SIGNAL	Length_Out_Event			:		STD_LOGIC_VECTOR( UDPLengthSize - 1 DOWNTO 0);
SIGNAL	ColdStart					:		STD_LOGIC	:=	Lo;
SIGNAL	ColdStart_Reg				:		STD_LOGIC	:=	Lo;
SIGNAL	TimeTick_Event				:		STD_LOGIC_VECTOR( TIMETICKLength-1	DOWNTO 0);



SIGNAL	PDU_DOUT_Link				:		STD_LOGIC_VECTOR( DataWidth - 1 DOWNTO 0);
SIGNAL	PDU_DOUTV_Link				:		STD_LOGIC;
SIGNAL	PDU_OUT_SOP_Link			:		STD_LOGIC;
SIGNAL	PDU_OUT_EOP_Link			:		STD_LOGIC;
SIGNAL	PDU_OUT_Ind_Link			:		STD_LOGIC;
SIGNAL	PDU_OUT_ErrIN_Link			:		STD_LOGIC;
SIGNAL	PDU_OUT_Ack_Link			:		STD_LOGIC;

SIGNAL	PDU_DOUT_Event				:		STD_LOGIC_VECTOR( DataWidth - 1 DOWNTO 0);
SIGNAL	PDU_DOUTV_Event			:		STD_LOGIC;
SIGNAL	PDU_OUT_SOP_Event			:		STD_LOGIC;
SIGNAL	PDU_OUT_EOP_Event			:		STD_LOGIC;
SIGNAL	PDU_OUT_Ind_Event			:		STD_LOGIC;
SIGNAL	PDU_OUT_ErrIN_Event			:		STD_LOGIC;
SIGNAL	PDU_OUT_Ack_Event			:		STD_LOGIC;

TYPE OutMux_StateType IS
(
	INIT,
	IDLE,
	Grant_Link,
	WFOR_Link_Start,
	Link_IPGR,
	Grant_Event,
	WFOR_Event_Start,
	Event_IPGR
);

SIGNAL	OutMux_FSMState		:		OutMux_StateType;

BEGIN
	----------------------------------------------
	-- Config Part
	----------------------------------------------
	WRRD_EN_rise	<=	WR_EN_reg or RD_EN_reg;

	WREN_reg		:	aFlop								PORT MAP( C => CLK , D => WR_EN		, CE => CFG_CE , Q => WR_EN_reg);
	WREN_rise		:	aRise								PORT MAP( C => CLK , I => WR_EN_reg	, Q => WR_EN_rise);
	RDEN_reg		:	aFlop								PORT MAP( C => CLK , D => RD_EN		, CE => CFG_CE , Q => RD_EN_reg);
	RDEN_rise		:	aRise								PORT MAP( C => CLK , I => RD_EN_reg	, Q => RD_EN_rise);
	ADRt_reg		:	aRegister	GENERIC MAP(Size => SNMPAddrWidth)	PORT MAP( C => CLK , D => CFG_ADDR		, CE => CFG_CE , Q => CFG_ADDR_temp);
	ADR_reg		:	aRegister	GENERIC MAP(Size => SNMPAddrWidth)	PORT MAP( C => CLK , D => CFG_ADDR_temp	, CE => WRRD_EN_rise , Q => CFG_ADDR_reg);
	DINt_reg		:	aRegister	GENERIC MAP(Size => SNMPDataWidth)	PORT MAP( C => CLK , D => DATA_IN		, CE => CFG_CE , Q => DATA_IN_temp);
	DIN_reg		:	aRegister	GENERIC MAP(Size => SNMPDataWidth)	PORT MAP( C => CLK , D => DATA_IN_temp	, CE => WR_EN_rise , Q => DATA_IN_reg);
	RDV_d_inst	:	 aDelay	GENERIC MAP(Length => RDV_delay)	PORT MAP( C => CLK , I => RD_EN_rise	, CE => CFG_CE , Q => RD_DV);

	MUX_proc:PROCESS(clk)
	BEGIN
		IF(RISING_EDGE(clk))THEN
			IF(RST = Hi)THEN
				WR_EN_Array	<=	(OTHERS => Lo);
				RD_En_Array	<=	(OTHERS => Lo);
				DATA_OUT		<=	(OTHERS => Lo);
			ELSE
				for i IN 0 to SNMPNumOFCFGRegs -1 loop
					IF(CFG_ADDR_reg = STD_LOGIC_VECTOR(to_unsigned(i,SNMPAddrWidth)))THEN
						WR_EN_Array(i)	<=	WR_EN_rise;
						RD_En_Array(i)	<=	RD_EN_rise;
						DATA_OUT		<=	DATA_Out_Array(i);
					END IF;
				END loop;
			END IF;
		END IF;
	END PROCESS MUX_proc;

	Port_IN_reg	<=	DATA_IN_reg( UDPPortSize-1 DOWNTO 0);

	MGRIPA_reg	:	aRegister	GENERIC MAP(Size => IPAddrSize)	PORT MAP( C => CLK , D => DATA_IN_reg , CE => WR_EN_Array(CFGADDR_ManagerIPAddr), Q => ManagerIPAddr);
	DATA_Out_Array(CFGADDR_ManagerIPAddr)	<=	ManagerIPAddr;

	AGNTIPA_reg	:	aRegister	GENERIC MAP(Size => IPAddrSize)	PORT MAP( C => CLK , D => DATA_IN_reg , CE=> WR_EN_Array(CFGADDR_AgentIPAddr) , Q => AgentIPAddr);
	DATA_Out_Array(CFGADDR_AgentIPAddr)	<=	AgentIPAddr;

	MGRTPort_reg	:	aRegister	GENERIC MAP(Size => UDPPortSize)	PORT MAP( C => CLK , D => Port_IN_reg ,CE=>WR_EN_Array(CFGADDR_ManagerTrapPort), Q => ManagerTrapPort);
	DATA_Out_Array(CFGADDR_ManagerTrapPort)	<=	X"0000" & ManagerTrapPort;

	AGNTPort_reg	:	aRegister	GENERIC MAP(Size => UDPPortSize)	PORT MAP( C => CLK , D => Port_IN_reg ,CE=>WR_EN_Array(CFGADDR_AgentTrapPort), Q => AgentTrapPort);
	DATA_Out_Array(CFGADDR_AgentTrapPort)	<=	X"0000" & AgentTrapPort;

	----------------------------------------------
	-- End Of COnfig Part
	----------------------------------------------
	----------------------------------------------
	-- Assigning Static Parts
	----------------------------------------------

	PDU_In_ErrOUT	<=	Lo;
	PDU_In_Ack	<=	Lo;

	DstIPAddr_Out	<=	ManagerIPAddr;
	SrcIPAddr_Out	<=	AgentIPAddr;
	SrcPort_Out	<=	AgentTrapPort;
	DstPort_Out	<=	ManagerTrapPort;


	TX_PDU_register_Event(SNMPTRAPPDULength_BaseBit - 01	DOWNTO SNMPTRAPPDULength_BaseBit	- 16	)	<=	BERTYPE_SEQUENCE 	&	STD_LOGIC_VECTOR(TO_UNSIGNED(SNMPTRAPPDULength_Base-2,8)); 															-- SEQUENCE & LENGTH
	TX_PDU_register_Event(SNMPTRAPPDULength_BaseBit - 17	DOWNTO SNMPTRAPPDULength_BaseBit	- 40	)	<=	BERTYPE_INTEGER	&	X"01" & X"00";																								-- VERSION
	TX_PDU_register_Event(SNMPTRAPPDULength_BaseBit - 41	DOWNTO TRAPPDUOffset				)	<=	BERTYPE_OCTETSTRING	&	STD_LOGIC_VECTOR(TO_UNSIGNED(SNMPCommunityStringLegth/8,8)) & SNMPCommunityString;										-- COMMUNITY
	TX_PDU_register_Event(TRAPPDUOffset-1				DOWNTO TRAPPDUOffset			- 16	)	<=	BERTYPE_SNMPTRAPPDU	&	STD_LOGIC_VECTOR(TO_UNSIGNED((TRAPPDUOffset-16)/8,8));																-- TRAP PDU TYPE& Length
	TX_PDU_register_Event(TRAPPDUOffset-17				DOWNTO NetworkAddrOffset				)	<=	BERTYPE_OID		&	STD_LOGIC_VECTOR(TO_UNSIGNED(EnterpriseID'Length/8,8)) & EnterpriseID;												-- Enterprise ID
	TX_PDU_register_Event(NetworkAddrOffset-1			DOWNTO NetworkAddrOffset			- 48	)	<=	BERTYPE_IPAddress	&	X"04" & AgentIPAddr; 																						-- Network address
	TX_PDU_register_Event(GenericTrapOffset-1			DOWNTO GenericTrapOffset			- 24	)	<=	BERTYPE_INTEGER	&	X"01" & GenericTrap_Event; 																					-- Generic Trap
	TX_PDU_register_Event(SpecificTrapOffset-1			DOWNTO SpecificTrapOffset		- 24	)	<=	BERTYPE_INTEGER	&	X"01" & SpecificTrap_Event; 																					-- Specific Trap
	TX_PDU_register_Event(TimeTickOffset-1				DOWNTO 						  00	)	<=	BERTYPE_TIMETICK	&	STD_LOGIC_VECTOR(TO_UNSIGNED(TIMETICKLength/8,8)) & TimeTick_Event; 													-- TimeTick_Link
	--Variables : GenericTrap_Event := [SNMPGenTrapESpecific | SNMPGenTrapColdStart | SNMPGenTrapWarmStart] , SpecificTrap_Event , TimeTick_Event

	TX_PDU_register_Link(SNMPTRAPPDULength_LinkBit - 01	DOWNTO SNMPTRAPPDULength_LinkBit	- 16	)	<=	BERTYPE_SEQUENCE 	&	STD_LOGIC_VECTOR(TO_UNSIGNED(SNMPTRAPPDULength_Link-2,8)); 															-- SEQUENCE & LENGTH
	TX_PDU_register_Link(SNMPTRAPPDULength_LinkBit - 17	DOWNTO SNMPTRAPPDULength_LinkBit	- 40	)	<=	BERTYPE_INTEGER	&	X"01" & X"00";																								-- VERSION
	TX_PDU_register_Link(SNMPTRAPPDULength_LinkBit - 41	DOWNTO TRAPPDUOffset_Link			)	<=	BERTYPE_OCTETSTRING	&	STD_LOGIC_VECTOR(TO_UNSIGNED(SNMPCommunityStringLegth/8,8)) & SNMPCommunityString;										-- COMMUNITY
	TX_PDU_register_Link(TRAPPDUOffset_Link-1			DOWNTO TRAPPDUOffset_Link		- 16	)	<=	BERTYPE_SNMPTRAPPDU	&	STD_LOGIC_VECTOR(TO_UNSIGNED((TRAPPDUOffset_Link-16)/8,8));															-- TRAP PDU TYPE& Length
	TX_PDU_register_Link(TRAPPDUOffset_Link-17			DOWNTO NetworkAddrOffset_Link			)	<=	BERTYPE_OID		&	STD_LOGIC_VECTOR(TO_UNSIGNED(EnterpriseID'Length/8,8)) & EnterpriseID;												-- Enterprise ID
	TX_PDU_register_Link(NetworkAddrOffset_Link-1		DOWNTO NetworkAddrOffset_Link		- 48	)	<=	BERTYPE_IPAddress	&	X"04" & AgentIPAddr; 																						-- Network address
	TX_PDU_register_Link(GenericTrapOffset_Link-1		DOWNTO GenericTrapOffset_Link		- 24	)	<=	BERTYPE_INTEGER	&	X"01" & GenericTrap_Link; 																					-- Generic Trap
	TX_PDU_register_Link(SpecificTrapOffset_Link-1		DOWNTO SpecificTrapOffset_Link	- 24	)	<=	BERTYPE_INTEGER	&	X"01" & X"00"; 																							-- Specific Trap
	TX_PDU_register_Link(TimeTickOffset_Link-1			DOWNTO VarbindListOffset_Link			)	<=	BERTYPE_TIMETICK	&	STD_LOGIC_VECTOR(TO_UNSIGNED(TIMETICKLength/8,8)) & TimeTick_Link; 													-- TimeTick_Link
	TX_PDU_register_Link(VarbindListOffset_Link-1		DOWNTO VarbindListOffset_Link		- 16	)	<=	BERTYPE_SEQUENCE	&	STD_LOGIC_VECTOR(TO_UNSIGNED((ifIndexOidSize + 24)/8 + 2,8));														-- VarBind Offset Link start
	TX_PDU_register_Link(ifIndexOffset_Link-1			DOWNTO ifDescrOffset_Link			)	<=	BERTYPE_OID		&	STD_LOGIC_VECTOR(TO_UNSIGNED((ifIndexOidSize)/8,8)) & ifIndexBaseOid & ifID & BERTYPE_INTEGER & X"01" & ifID;					-- IfIndex OID & NULLvalue
	TX_PDU_register_Link(ifDescrOffset_Link-1			DOWNTO ifDescrOffset_Link		- 16	)	<=	BERTYPE_SEQUENCE	&	STD_LOGIC_VECTOR(TO_UNSIGNED((ifDescrOffset_Link)/8,8));															-- IfDescrOID & and interface description
	TX_PDU_register_Link(ifDescrOffset_Link - 17			DOWNTO 						  00	)	<=	BERTYPE_OID		&	STD_LOGIC_VECTOR(TO_UNSIGNED((ifDescrOidSize)/8,8)) & ifDescrBaseOid & ifID & BERTYPE_IA5String & X"06" & ETHString & ifIDString;	-- IfDescrOID & and interface description
	--Variables : GenericTrap_Link , TimeTick_Link , ifID , ifIDString
	----------------------------------------------
	-- End of Assigning Static Parts
	----------------------------------------------


	LSIn_reg_inst	: aRegister	GENERIC MAP	( Size => NumOfLinks)	PORT MAP( C => CLK , D => LinkStatusIn , CE => CE , Q => LinkStatusIn_reg);
	GEN_UPDOWN:
	FOR i IN 0 TO NumOfLinks-1 GENERATE
		LSI_rise_inst	:	aRise	PORT MAP( C => CLK , I => LinkStatusIn_reg(i) , Q  => LinkStatusIn_rise(i));
		LSI_fall_inst	:	aFall	PORT MAP( C => CLK , I => LinkStatusIn_reg(i) , Q  => LinkStatusIn_fall(i));
		LUP_reg_inst	:	aFlopC	PORT MAP( C => CLK , D => Hi , CE => LinkStatusIn_fall(i) , CLR => ClearLinkUp_vec(i) , Q => LinkUp_vec(i));
		LDOWN_reg_inst	:	aFlopC	PORT MAP( C => CLK , D => Hi , CE => LinkStatusIn_rise(i) , CLR => ClearLinkDown_vec(i) , Q => LinkDown_vec(i));
	END GENERATE;

	EvIn_reg_inst	: aRegister	GENERIC MAP	( Size => NumOfEvents)	PORT MAP( C => CLK , D => EventIN , CE => CE , Q => EventIN_reg);
	GEN_Event:
	FOR i IN 0 TO NumOfEvents-1 GENERATE
		Ev_rise_inst	:	aRise	PORT MAP( C => CLK , I => EventIN_reg(i), Q  => EventIN_rise(i));
		EV_reg_inst	:	aFlopC	PORT MAP( C => CLK , D => Hi , CE => EventIN_rise(i) , CLR => ClearEventIN_vec(i) , Q => EventIN_vec(i));
	END GENERATE;

	Proc10MS:process(CLK)
	BEGIN
		IF(RISING_EDGE(CLK))THEN
			IF(rst = Hi)THEN
				Timer		<=	(OTHERS => Lo);
				TimeTick_reg	<=	(OTHERS => Lo);
			ELSE
				IF(Timer = Time10ms_vec)THEN
					Timer		<=	(OTHERS => Lo);
					TimeTick_reg	<=	TimeTick_reg + 1;
				ELSE
					Timer		<=	Timer + 1;
				END IF;
			END IF;
		END IF;
	END PROCESS Proc10MS;

	Inst_LinkTrapSerializer: Serializer
	GENERIC MAP(
		DataWidth	=>	DataWidth,
		ToSer	=>	SNMPTRAPPDULength_Link
	)
	PORT MAP(
		CLK		=>	CLK,
		RST		=>	RST,
		CE		=>	CE,
		Start	=>	SerStart_LinkTrap,
		Ser_Start	=>	PDU_OUT_SOP_Link,
		Complete	=>	PDU_OUT_EOP_Link,
		PIn		=>	TX_PDU_register_Link,
		SOut		=>	PDU_DOUT_Link,
		OuTV		=>	PDU_DOUTV_Link
	);
	Inst_EventTrapSerializer: Serializer
	GENERIC MAP(
		DataWidth	=>	DataWidth,
		ToSer	=>	SNMPTRAPPDULength_Base
	)
	PORT MAP(
		CLK		=>	CLK,
		RST		=>	RST,
		CE		=>	CE,
		Start	=>	SerStart_EventTrap,
		Ser_Start	=>	PDU_OUT_SOP_Event,
		Complete	=>	PDU_OUT_EOP_Event,
		PIn		=>	TX_PDU_register_Event,
		SOut		=>	PDU_DOUT_Event,
		OuTV		=>	PDU_DOUTV_Event
	);

	--Variables to Set : GenericTrap_Link , TimeTick_Link , ifID , ifIDString
	LinkTrapFSM_proc:PROCESS(clk,rst,CE,LinkTrapFSM_State)
	BEGIN
		IF(RISING_EDGE(clk))THEN
			IF(rst = Hi) THEN
				IfIndex_reg			<=	(OTHERS => Lo);
				ClearLinkDown_vec		<=	(OTHERS => Lo);
				ClearLinkUp_vec		<=	(OTHERS => Lo);
				ifID					<=	(OTHERS => Lo);
				GenericTrap_Link		<=	(OTHERS => Lo);
				TimeTick_Link			<=	(OTHERS => Lo);
				ifIDString			<=	(OTHERS => Lo);
				Length_Out_Link		<=	STD_LOGIC_VECTOR(TO_UNSIGNED(SNMPTRAPPDULength_Link,Length_Out_Link'LENGTH));
				SerStart_LinkTrap		<=	Lo;
				PDU_OUT_Ind_Link		<=	Lo;
				LinkTrapFSM_State		<=	INIT;
			ELSIF(rst = Lo AND CE = Hi) THEN
				CASE LinkTrapFSM_State IS
					WHEN IDLE =>
						PDU_OUT_Ind_Link	<=	Lo;
						SerStart_LinkTrap	<=	Lo;
						IF(LinkDown_vec /= LinkStateNULLvec)THEN
							LinkTrapFSM_State	<=	InitLinkDownTrap;
						ELSIF(LinkDown_vec = LinkStateNULLvec AND LinkUp_vec /= LinkStateNULLvec)THEN
							LinkTrapFSM_State	<=	InitLinkUpTrap;
						ELSE
							LinkTrapFSM_State	<=	IDLE;
						END IF;
					WHEN InitLinkDownTrap =>
						FOR i IN  NumOfLinks-1 DOWNTO 0 LOOP
							IF(LinkDown_vec(i) = Hi)THEN
								IfIndex_reg	<=	STD_LOGIC_VECTOR(TO_UNSIGNED(i,IfIndex_reg'LENGTH));
							END IF;
						END LOOP;
						LinkTrapFSM_State	<=	ClearInput_LinkDown;
					WHEN ClearInput_LinkDown =>
						ClearLinkDown_vec(TO_INTEGER(UNSIGNED(IfIndex_reg)))	<=	Hi;
						ifID											<=	IfIndex_reg + 1;
						GenericTrap_Link								<=	SNMPGenTrapLinkDown;
						TimeTick_Link									<=	TimeTick_reg;
						ifIDString									<=	IfIndex_reg + X"30" & X"0000";
						LinkTrapFSM_State								<=	SendLinkTrap_WFORACK;
					WHEN InitLinkUpTrap =>
						FOR i IN  NumOfLinks-1 DOWNTO 0 LOOP
							IF(LinkUp_vec(i) = Hi)THEN
								IfIndex_reg	<=	STD_LOGIC_VECTOR(TO_UNSIGNED(i,IfIndex_reg'LENGTH));
							END IF;
						END LOOP;
						LinkTrapFSM_State	<=	ClearInput_LinkUp;
					WHEN ClearInput_LinkUp =>
						ClearLinkUp_vec(TO_INTEGER(UNSIGNED(IfIndex_reg)))	<=	Hi;
						ifID											<=	IfIndex_reg + 1;
						GenericTrap_Link								<=	SNMPGenTrapLinkUp;
						TimeTick_Link									<=	TimeTick_reg;
						ifIDString									<=	IfIndex_reg + X"30" & X"0000";
						LinkTrapFSM_State								<=	SendLinkTrap_WFORACK;
					WHEN SendLinkTrap_WFORACK =>
						PDU_OUT_Ind_Link	<=	Hi;
						ClearLinkDown_vec	<=	(OTHERS => Lo);
						ClearLinkUp_vec	<=	(OTHERS => Lo);
						IF(PDU_OUT_ErrIN_Link = Hi)THEN
							LinkTrapFSM_State	<=	IDLE;
						ELSIF(PDU_OUT_ErrIN_Link = Lo AND PDU_OUT_Ack_Link = Hi AND PDU_DOUTV_Link = Lo)THEN
							LinkTrapFSM_State	<=	SendLinkTrap;
						ELSE
							LinkTrapFSM_State	<=	SendLinkTrap_WFORACK;
						END IF;
					WHEN SendLinkTrap =>
						ClearLinkDown_vec	<=	(OTHERS => Lo);
						ClearLinkUp_vec	<=	(OTHERS => Lo);
						SerStart_LinkTrap	<=	Hi;
						IF( PDU_DOUTV_Link = Hi AND PDU_OUT_SOP_Link = Hi)THEN
							LinkTrapFSM_State	<=	IDLE;
						ELSE
							LinkTrapFSM_State	<=	SendLinkTrap;
						END IF;
					-- WHEN OTHERS => --INIT
					WHEN INIT =>
						LinkTrapFSM_State	<=	IDLE;
				END CASE;
			END IF;
		END IF;
	END PROCESS LinkTrapFSM_proc;

	Cold_reg	:	aFlop	PORT MAP(C => CLK , D => Hi , CE => ColdStart , Q => ColdStart_Reg);

	--Variables to Set : GenericTrap_Link := [SNMPGenTrapESpecific | SNMPGenTrapColdStart | SNMPGenTrapWarmStart] , SpecificTrap_Event , TimeTick_Event
	EventTrapFSM_proc:PROCESS(clk,rst,CE,EventTrapFSM_State)
	BEGIN
		IF(RISING_EDGE(clk))THEN
			IF(rst = Hi) THEN
				PDU_Out_Ind_Event	<=	Lo;
				ColdStart			<=	Lo;
				SerStart_EventTrap	<=	Lo;
				ClearEventIN_vec	<=	(OTHERS => Lo);
				SpecificTrap_Event	<=	(OTHERS => Lo);
				TimeTick_Event		<=	(OTHERS => Lo);
				EventINIndex_reg	<=	(OTHERS => Lo);
				Length_Out_Event	<=	STD_LOGIC_VECTOR(TO_UNSIGNED(SNMPTRAPPDULength_Base,Length_Out_Event'LENGTH));
				IF(ColdStart_Reg = Lo)THEN
					EventTrapFSM_State	<=	InitColdStartTrap;
				ELSE
					EventTrapFSM_State	<=	InitWarmStartTrap;
				END IF;
			ELSIF(rst = Lo AND CE = Hi) THEN
				CASE EventTrapFSM_State IS
					WHEN IDLE =>
						ColdStart			<=	Lo;
						PDU_Out_Ind_Event	<=	Lo;
						SerStart_EventTrap	<=	Lo;
						IF(EventIN_vec /= EventStateNULLvec)THEN
							EventTrapFSM_State	<=	InitEventTrap;
						ELSE
							EventTrapFSM_State	<=	IDLE;
						END IF;
					WHEN InitEventTrap =>
						FOR i IN  NumOfEvents-1 DOWNTO 0 LOOP
							IF(EventIN_vec(i) = Hi)THEN
								EventINIndex_reg	<=	STD_LOGIC_VECTOR(TO_UNSIGNED(i,EventINIndex_reg'LENGTH));
							END IF;
						END LOOP;
						EventTrapFSM_State	<=	ClearInput_Event;
					WHEN ClearInput_Event =>
						ClearEventIN_vec(TO_INTEGER(UNSIGNED(EventINIndex_reg)))	<=	Hi;
						GenericTrap_Event									<=	SNMPGenTrapESpecific;
						SpecificTrap_Event									<=	EventINIndex_reg;
						TimeTick_Event										<=	TimeTick_reg;
						EventTrapFSM_State									<=	SendEventTrap_WFORACK;
					WHEN SendEventTrap_WFORACK =>
						PDU_OUT_Ind_Event	<=	Hi;
						ClearEventIN_vec	<=	(OTHERS => Lo);
						IF(PDU_OUT_ErrIN_Event = Hi)THEN
							EventTrapFSM_State	<=	IDLE;
						ELSIF(PDU_OUT_ErrIN_Event = Lo AND PDU_OUT_Ack_Event = Hi AND PDU_DOUTV_Event = Lo)THEN
							EventTrapFSM_State	<=	SendEventTrap;
						ELSE
							EventTrapFSM_State	<=	SendEventTrap_WFORACK;
						END IF;
					WHEN SendEventTrap =>
						SerStart_EventTrap	<=	Hi;
						IF( PDU_DOUTV_Event = Hi AND PDU_OUT_SOP_Event = Hi)THEN
							EventTrapFSM_State	<=	IDLE;
						ELSE
							EventTrapFSM_State	<=	SendEventTrap;
						END IF;
					WHEN InitWarmStartTrap =>
						GenericTrap_Event	<=	SNMPGenTrapWarmStart;
						SpecificTrap_Event	<=	(OTHERS => Lo);
						TimeTick_Event		<=	TimeTick_reg;
						EventTrapFSM_State	<=	SendEventTrap_WFORACK;
					-- WHEN OTHERS => --INIT
					WHEN InitColdStartTrap =>
						ColdStart			<=	Hi;
						GenericTrap_Event	<=	SNMPGenTrapColdStart;
						SpecificTrap_Event	<=	(OTHERS => Lo);
						TimeTick_Event		<=	(OTHERS => Lo);
						EventTrapFSM_State	<=	SendEventTrap_WFORACK;
				END CASE;
			END IF;
		END IF;
	END PROCESS EventTrapFSM_proc;

	OutMuxFSM_proc:PROCESS(clk,rst,CE,OutMux_FSMState)
	BEGIN
		IF(RISING_EDGE(clk))THEN
			IF(rst = Hi) THEN
				Length_Out		<=	(OTHERS => Lo);
				PDU_DOUT			<=	(OTHERS => Lo);
				PDU_DOUTV			<=	Lo;
				PDU_Out_SOP		<=	Lo;
				PDU_Out_EOP		<=	Lo;
				PDU_Out_Ind		<=	Lo;
				PDU_Out_ErrOut		<=	Lo;
				PDU_Out_Ack_Event	<=	Lo;
				PDU_Out_ErrIn_Event	<=	Lo;
				PDU_Out_Ack_Link	<=	Lo;
				PDU_Out_ErrIn_Link	<=	Lo;
				OutMux_FSMState	<=	INIT;
			ELSIF(rst = Lo AND CE = Hi) THEN
				CASE OutMux_FSMState IS
					WHEN IDLE =>
						Length_Out		<=	(OTHERS => Lo);
						PDU_DOUT			<=	(OTHERS => Lo);
						PDU_DOUTV			<=	Lo;
						PDU_Out_SOP		<=	Lo;
						PDU_Out_EOP		<=	Lo;
						PDU_Out_Ind		<=	Lo;
						PDU_Out_ErrOut		<=	Lo;
						PDU_Out_Ack_Event	<=	Lo;
						PDU_Out_ErrIn_Event	<=	Lo;
						PDU_Out_Ack_Link	<=	Lo;
						PDU_Out_ErrIn_Link	<=	Lo;
						IF(PDU_Out_Ind_Event = Hi)THEN
							OutMux_FSMState	<=	Grant_Event;
						ELSIF(PDU_Out_Ind_Event = Lo AND PDU_Out_Ind_Link = Hi)THEN
							OutMux_FSMState	<=	Grant_Link;
						ELSE
							OutMux_FSMState	<=	IDLE;
						END IF;
					WHEN Grant_Event =>
						PDU_Out_ErrIn_Event	<=	PDU_Out_ErrIn;
						IF(PDU_Out_Ind_Event = Hi)THEN
							IF(TX_SYNC)THEN
								PDU_Out_Ind	<=	PDU_Out_Ind_Event;
								IF(PDU_Out_Ind_Event = Hi AND PDU_Out_Ack = Hi)THEN
									OutMux_FSMState	<=	WFOR_Event_Start;
								ELSE
									OutMux_FSMState	<=	Grant_Event;
								END IF;
							ELSE
								OutMux_FSMState	<=	WFOR_Event_Start;
							END IF;
						ELSE
							OutMux_FSMState	<=	IDLE;
						END IF;
					WHEN WFOR_Event_Start =>
						PDU_Out_ErrIn_Event	<=	PDU_Out_ErrIn;
						PDU_Out_Ack_Event	<=	Hi;
						Length_Out		<=	Length_Out_Event;
						PDU_DOUT			<=	PDU_DOUT_Event;
						PDU_DOUTV			<=	PDU_DOUTV_Event;
						PDU_Out_SOP		<=	PDU_Out_SOP_Event;
						PDU_Out_EOP		<=	PDU_Out_EOP_Event;
						IF(PDU_Out_Ind_Event = Hi AND PDU_Out_SOP_Event = Hi AND PDU_DOUTV_Event = Hi)THEN
							OutMux_FSMState	<=	Event_IPGR;
						ELSIF(PDU_Out_Ind_Event = Lo)THEN
							OutMux_FSMState	<=	IDLE;
						ELSE
							OutMux_FSMState	<=	WFOR_Event_Start;
						END IF;
					WHEN Event_IPGR =>
						PDU_Out_ErrIn_Event	<=	PDU_Out_ErrIn;
						PDU_Out_Ack_Event	<=	Lo;
						Length_Out		<=	Length_Out_Event;
						PDU_DOUT			<=	PDU_DOUT_Event;
						PDU_DOUTV			<=	PDU_DOUTV_Event;
						PDU_Out_SOP		<=	PDU_Out_SOP_Event;
						PDU_Out_EOP		<=	PDU_Out_EOP_Event;
						IF((PDU_Out_EOP_Event = Hi AND PDU_DOUTV_Event = Hi) OR PDU_Out_ErrIn = Hi)THEN
							OutMux_FSMState	<=	IDLE;
						ELSE
							OutMux_FSMState	<=	Event_IPGR;
						END IF;
					WHEN Grant_Link =>
						PDU_Out_ErrIn_Link	<=	PDU_Out_ErrIn;
						IF(PDU_Out_Ind_Link = Hi)THEN
							IF(TX_SYNC)THEN
								PDU_Out_Ind	<=	PDU_Out_Ind_Link;
								IF(PDU_Out_Ind_Link = Hi AND PDU_Out_Ack = Hi)THEN
									OutMux_FSMState	<=	WFOR_Link_Start;
								ELSE
									OutMux_FSMState	<=	Grant_Link;
								END IF;
							ELSE
								OutMux_FSMState	<=	WFOR_Link_Start;
							END IF;
						ELSE
							OutMux_FSMState	<=	IDLE;
						END IF;
					WHEN WFOR_Link_Start =>
						PDU_Out_ErrIn_Link	<=	PDU_Out_ErrIn;
						PDU_Out_Ack_Link	<=	Hi;
						Length_Out		<=	Length_Out_Link;
						PDU_DOUT			<=	PDU_DOUT_Link;
						PDU_DOUTV			<=	PDU_DOUTV_Link;
						PDU_Out_SOP		<=	PDU_Out_SOP_Link;
						PDU_Out_EOP		<=	PDU_Out_EOP_Link;
						IF(PDU_Out_Ind_Link = Hi AND PDU_Out_SOP_Link = Hi AND PDU_DOUTV_Link = Hi)THEN
							OutMux_FSMState	<=	Link_IPGR;
						ELSIF(PDU_Out_Ind_Link = Lo)THEN
							OutMux_FSMState	<=	IDLE;
						ELSE
							OutMux_FSMState	<=	WFOR_Link_Start;
						END IF;
					WHEN Link_IPGR =>
						PDU_Out_ErrIn_Link	<=	PDU_Out_ErrIn;
						PDU_Out_Ack_Link	<=	Lo;
						Length_Out		<=	Length_Out_Link;
						PDU_DOUT			<=	PDU_DOUT_Link;
						PDU_DOUTV			<=	PDU_DOUTV_Link;
						PDU_Out_SOP		<=	PDU_Out_SOP_Link;
						PDU_Out_EOP		<=	PDU_Out_EOP_Link;
						IF((PDU_Out_EOP_Link = Hi AND PDU_DOUTV_Link = Hi) OR PDU_Out_ErrIn = Hi)THEN
							OutMux_FSMState	<=	IDLE;
						ELSE
							OutMux_FSMState	<=	Link_IPGR;
						END IF;
					-- WHEN OTHERS => --INIT
					WHEN INIT =>
						OutMux_FSMState	<=	IDLE;
				END CASE;
			END IF;
		END IF;
	END PROCESS OutMuxFSM_proc;

END ArchSNMPModuleBehav;