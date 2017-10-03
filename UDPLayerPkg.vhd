--
-- UDPLayerPkg.vhd
-- ============
--
-- (C) Ferenc Janky, BME TMIT
--   file name:	UDPLayerPkg.vhd
--   PACKAGE:		UDPLayerPkg
--
-- 		User Datagram Header Format
--  0	 7 8	    15 16	   23 24	  31
-- +--------+--------+--------+--------+
-- | Source		 | Destination	    |
-- | PORT			 | PORT		    |
-- +--------+--------+--------+--------+
-- |				 |			    |
-- |		Length	 |	Checksum	    |
-- +--------+--------+--------+--------+
-- |
-- | 		data octets ...
-- +---------------- ...
------------------------------------
-- Source PORT: 16 bits
------------------------------------
-- -- Source PORT IS an optional field, WHEN meaningful, it indicates the PORT
-- -- OF the sending PROCESS, AND may be assumed to be the PORT to which a
-- -- reply should be addressed IN the absence OF any other information. IF
-- -- not used, a value OF zero IS inserted.
------------------------------------
-- Destination PORT: 16 bits
------------------------------------
-- -- Destination PORT has a meaning within the context OF a particular
-- -- internet destination address.
------------------------------------
-- Length: 16 bits
------------------------------------
-- -- Length  IS the length  IN octets  OF this user datagram  including  this
-- -- header  AND the data.   (This  means  the minimum value OF the length IS
-- -- eight.)
------------------------------------
-- Checksum: 16 bits
------------------------------------
-- -- Checksum IS the 16-bit one’s complement OF the one’s complement sum OF a
-- -- pseudo header OF information from the IP header, the UDP header, AND the
-- -- data, padded with zero octets at the END (IF necessary) to make a
-- -- multiple OF two octets.
-- -- The pseudo header conceptually prefixed to the UDP header contains the
-- -- source address, the destination address, the protocol, AND the UDP
-- -- length. This information gives protection against misrouted datagrams.
-- -- This checksum procedure IS the same as IS used IN TCP.
-- -- 0 	    7 8	  15 16	 23 24	31
-- -- +--------+--------+--------+--------+
-- -- | 		source address 		  |
-- -- +--------+--------+--------+--------+
-- -- | 		destination address		  |
-- -- +--------+--------+--------+--------+
-- -- | zero 	|protocol| UDP length 	  |
-- -- +--------+--------+--------+--------+
-- -- IF the computed checksum IS zero, it IS transmitted as ALL ones (the
-- -- equivalent IN one’s complement arithmetic). An ALL zero transmitted
-- -- checksum value means that the transmitter generated no checksum (for
-- -- debugging or for higher level protocols that don’t care).

-- Kell még, MiniCAM a PORT tárolásra, RX part,RX cheksum validation

LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

USE work.ProtoLayerTypesAndDefs.ALL;

PACKAGE UDPLayerPkg IS
	COMPONENT UDPLayer IS
	GENERIC(
		DataWidth			:		INTEGER	:=	DefDataWidth;
		RX_SYNC_IN		:		BOOLEAN	:=	false;
		RX_SYNC_OUT		:		BOOLEAN	:=	false;
		-- TX_SYNC_IN		:		BOOLEAN	:=	false; Just IN Sync mode
		TX_SYNC_OUT		:		BOOLEAN	:=	false;
		NumOfUDPPorts		:		INTEGER	:=	DefNumOfUDPPorts;
		PDUToQueue		:		INTEGER	:=	DefPDUToQ
		);
	PORT(
		CLK				: IN		STD_LOGIC;
		RST				: IN		STD_LOGIC;
		CE				: IN		STD_LOGIC;
		CFG_CE			: IN		STD_LOGIC;
		------------------------------------------------------------
		--				Management IF
		------------------------------------------------------------
		WR_EN			: IN		STD_LOGIC;
		RD_EN			: IN		STD_LOGIC;
		ADDR				: IN		STD_LOGIC_VECTOR( INTEGER(CEIL(LOG2(REAL(NumOfUDPPorts))))-1 DOWNTO 0);
		DATA_IN			: IN		STD_LOGIC_VECTOR( UDPPortSize+1-1 DOWNTO 0); --Format : V|PORT = 1+ 16 bit
		DATA_OUT			: OUT	STD_LOGIC_VECTOR( UDPPortSize+1-1 DOWNTO 0);
		DOUTV			: OUT	STD_LOGIC;
		------------------------------------------------------------
		--				IP IF
		------------------------------------------------------------	
		IP_DstIPAddr_In	: IN		STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
		IP_SrcIPAddr_In	: IN		STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
		IP_Proto_In		: IN		STD_LOGIC_VECTOR( IP_ProtSize-1 DOWNTO 0);
		IP_Length_In		: IN		STD_LOGIC_VECTOR( 15 DOWNTO 0);
		-------------------------------------------------------------
		IP_DstIPAddr_Out	: OUT	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
		IP_SrcIPAddr_Out	: OUT	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
		IP_Proto_Out		: OUT	STD_LOGIC_VECTOR( IP_ProtSize-1 DOWNTO 0);
		IP_Length_Out		: OUT	STD_LOGIC_VECTOR( 15 DOWNTO 0);
		------------------------------------------------------------
		--				UDP IF
		------------------------------------------------------------
		DstIPAddr_In		: IN		STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
		SrcIPAddr_In		: IN		STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
		DstPort_In		: IN		STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
		SrcPort_In		: IN		STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
		Length_In			: IN		STD_LOGIC_VECTOR( UDPLengthSize-1 DOWNTO 0);
		-------------------------------------------------------------
		DstIPAddr_Out		: OUT	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
		SrcIPAddr_Out		: OUT	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
		DstPort_Out		: OUT	STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
		SrcPort_Out		: OUT	STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
		Length_Out		: OUT	STD_LOGIC_VECTOR( UDPLengthSize-1 DOWNTO 0);
		------------------------------------------------------------
		--				Framework IF
		------------------------------------------------------------
		SDU_DIN			: IN		STD_LOGIC_VECTOR( DataWidth-1 DOWNTO 0);
		SDU_DINV			: IN		STD_LOGIC;
		SDU_IN_SOP		: IN		STD_LOGIC;
		SDU_IN_EOP		: IN		STD_LOGIC;
		SDU_IN_Ind		: IN		STD_LOGIC;
		SDU_IN_ErrIn		: IN		STD_LOGIC;
		SDU_IN_USER_In		: IN		STD_LOGIC_VECTOR( USER_width-1 DOWNTO 0);
		SDU_IN_Ack		: OUT	STD_LOGIC;
		SDU_IN_ErrOut		: OUT	STD_LOGIC;
		-------------------------------------------------------------
		PDU_DOUT			: OUT	STD_LOGIC_VECTOR( DataWidth-1 DOWNTO 0);
		PDU_DOUTV			: OUT	STD_LOGIC;
		PDU_Out_SOP		: OUT	STD_LOGIC;
		PDU_Out_EOP		: OUT	STD_LOGIC;
		PDU_Out_Ind		: OUT	STD_LOGIC;
		PDU_Out_ErrOut		: OUT	STD_LOGIC;
		PDU_Out_USER_Out	: OUT	STD_LOGIC_VECTOR( USER_width-1 DOWNTO 0);
		PDU_Out_Ack		: IN		STD_LOGIC;
		PDU_Out_ErrIn		: IN		STD_LOGIC;
		-------------------------------------------------------------
		PDU_DIN			: IN		STD_LOGIC_VECTOR( DataWidth-1 DOWNTO 0);
		PDU_DINV			: IN		STD_LOGIC;
		PDU_IN_SOP		: IN		STD_LOGIC;
		PDU_IN_EOP		: IN		STD_LOGIC;
		PDU_IN_Ind		: IN		STD_LOGIC;
		PDU_IN_USER_In		: IN		STD_LOGIC_VECTOR( USER_width-1 DOWNTO 0);
		PDU_IN_ErrIn		: IN		STD_LOGIC;
		PDU_IN_ErrOut		: OUT	STD_LOGIC;
		PDU_IN_Ack		: OUT	STD_LOGIC;
		-------------------------------------------------------------
		SDU_DOUT			: OUT	STD_LOGIC_VECTOR( DataWidth-1 DOWNTO 0);
		SDU_DOUTV			: OUT	STD_LOGIC;
		SDU_Out_SOP		: OUT	STD_LOGIC;
		SDU_OUT_EOP		: OUT	STD_LOGIC;
		SDU_OUT_Ind		: OUT	STD_LOGIC;
		SDU_OUT_USER_Out	: OUT	STD_LOGIC_VECTOR( USER_width-1 DOWNTO 0);
		SDU_OUT_ErrOut		: OUT	STD_LOGIC;
		SDU_OUT_ErrIn		: IN		STD_LOGIC;
		SDU_OUT_Ack		: IN		STD_LOGIC;
		--------------------------------------------------------------
		Status			: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
	END COMPONENT UDPLayer;
	
	COMPONENT UDP_RX_PreVerifier IS -- verifying Proto_In, Cheksum, Length
	GENERIC(
		DataWidth			:		INTEGER	:=	DefDataWidth;
		SYNC_IN			:		BOOLEAN	:=	false
	);
	PORT(
		CLK				: IN		STD_LOGIC;
		RST				: IN		STD_LOGIC;
		CE				: IN		STD_LOGIC;
		-----------------------------------------
		IP_DstIPAddr_In	: IN		STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
		IP_SrcIPAddr_In	: IN		STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
		IP_Proto_In		: IN		STD_LOGIC_VECTOR( IP_ProtSize-1 DOWNTO 0);
		IP_Length_In		: IN		STD_LOGIC_VECTOR( IPLengthSize-1 DOWNTO 0);
		-----------------------------------------
		DstIPAddr_out		: OUT	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
		SrcIPAddr_out		: OUT	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
		-----------------------------------------
		DIN				: IN		STD_LOGIC_VECTOR(DataWidth-1 DOWNTO 0);
		DINV				: IN		STD_LOGIC;
		In_SOP			: IN		STD_LOGIC;
		In_EOP			: IN		STD_LOGIC;
		In_Ind			: IN		STD_LOGIC;
		In_ErrIn			: IN		STD_LOGIC;
		In_Ack			: OUT	STD_LOGIC;
		In_ErrOut			: OUT	STD_LOGIC;
		-----------------------------------------
		DOUT				: OUT	STD_LOGIC_VECTOR(DataWidth-1 DOWNTO 0);
		DOUTV			: OUT	STD_LOGIC;
		Out_SOP			: OUT	STD_LOGIC;
		Out_EOP			: OUT	STD_LOGIC;
		Out_Ind			: OUT	STD_LOGIC;
		Out_ErrOut		: OUT	STD_LOGIC;
		Out_Ack			: IN		STD_LOGIC;
		Out_ErrIn			: IN		STD_LOGIC
	);
	END COMPONENT UDP_RX_PreVerifier;

END PACKAGE UDPLayerPkg;

LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

USE work.ProtoLayerTypesAndDefs.ALL;
USE work.ProtoModulePkg.ProtoLayer;
USE work.arch.aRegister;
USE work.arch.aFlop;
USE work.arch.aRise;
USE work.arch.aDelay;
USE work.ProtoModulePkg.MiniCAM;
USE work.ProtoModulePkg.Serializer;
USE work.ProtoModulePkg.DeSerializer;
USE WORK.UDPLayerPkg.UDP_RX_PreVerifier;


ENTITY UDPLayer IS
GENERIC(
	DataWidth			:		INTEGER	:=	DefDataWidth;
	RX_SYNC_IN		:		BOOLEAN	:=	false;
	RX_SYNC_OUT		:		BOOLEAN	:=	false;
	-- TX_SYNC_IN		:		BOOLEAN	:=	false; Just IN Sync mode
	TX_SYNC_OUT		:		BOOLEAN	:=	false;
	NumOfUDPPorts		:		INTEGER	:=	DefNumOfUDPPorts;
	PDUToQueue		:		INTEGER	:=	DefPDUToQ
	);
PORT(
	CLK				: IN		STD_LOGIC;
	RST				: IN		STD_LOGIC;
	CE				: IN		STD_LOGIC;
	CFG_CE			: IN		STD_LOGIC;
	------------------------------------------------------------
	--				Management IF
	------------------------------------------------------------
	WR_EN			: IN		STD_LOGIC;
	RD_EN			: IN		STD_LOGIC;
	ADDR				: IN		STD_LOGIC_VECTOR( INTEGER(CEIL(LOG2(REAL(NumOfUDPPorts))))-1 DOWNTO 0);
	DATA_IN			: IN		STD_LOGIC_VECTOR( UDPPortSize+1-1 DOWNTO 0); --Format : V|PORT = 1+ 16 bit
	DATA_OUT			: OUT	STD_LOGIC_VECTOR( UDPPortSize+1-1 DOWNTO 0);
	DOUTV			: OUT	STD_LOGIC;
	------------------------------------------------------------
	--				IP IF
	------------------------------------------------------------	
	IP_DstIPAddr_In	: IN		STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
	IP_SrcIPAddr_In	: IN		STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
	IP_Proto_In		: IN		STD_LOGIC_VECTOR( IP_ProtSize-1 DOWNTO 0);
	IP_Length_In		: IN		STD_LOGIC_VECTOR( 15 DOWNTO 0);
	-------------------------------------------------------------
	IP_DstIPAddr_Out	: OUT	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
	IP_SrcIPAddr_Out	: OUT	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
	IP_Proto_Out		: OUT	STD_LOGIC_VECTOR( IP_ProtSize-1 DOWNTO 0);
	IP_Length_Out		: OUT	STD_LOGIC_VECTOR( 15 DOWNTO 0);
	------------------------------------------------------------
	--				UDP IF
	------------------------------------------------------------
	DstIPAddr_In		: IN		STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
	SrcIPAddr_In		: IN		STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
	DstPort_In		: IN		STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
	SrcPort_In		: IN		STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
	Length_In			: IN		STD_LOGIC_VECTOR( UDPLengthSize-1 DOWNTO 0);
	-------------------------------------------------------------
	DstIPAddr_Out		: OUT	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
	SrcIPAddr_Out		: OUT	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
	DstPort_Out		: OUT	STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
	SrcPort_Out		: OUT	STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
	Length_Out		: OUT	STD_LOGIC_VECTOR( UDPLengthSize-1 DOWNTO 0);
	------------------------------------------------------------
	--				Framework IF
	------------------------------------------------------------
	SDU_DIN			: IN		STD_LOGIC_VECTOR( DataWidth-1 DOWNTO 0);
	SDU_DINV			: IN		STD_LOGIC;
	SDU_IN_SOP		: IN		STD_LOGIC;
	SDU_IN_EOP		: IN		STD_LOGIC;
	SDU_IN_Ind		: IN		STD_LOGIC;
	SDU_IN_ErrIn		: IN		STD_LOGIC;
	SDU_IN_USER_In		: IN		STD_LOGIC_VECTOR( USER_width-1 DOWNTO 0);
	SDU_IN_Ack		: OUT	STD_LOGIC;
	SDU_IN_ErrOut		: OUT	STD_LOGIC;
	-------------------------------------------------------------
	PDU_DOUT			: OUT	STD_LOGIC_VECTOR( DataWidth-1 DOWNTO 0);
	PDU_DOUTV			: OUT	STD_LOGIC;
	PDU_Out_SOP		: OUT	STD_LOGIC;
	PDU_Out_EOP		: OUT	STD_LOGIC;
	PDU_Out_Ind		: OUT	STD_LOGIC;
	PDU_Out_ErrOut		: OUT	STD_LOGIC;
	PDU_Out_USER_Out	: OUT	STD_LOGIC_VECTOR( USER_width-1 DOWNTO 0);
	PDU_Out_Ack		: IN		STD_LOGIC;
	PDU_Out_ErrIn		: IN		STD_LOGIC;
	-------------------------------------------------------------
	PDU_DIN			: IN		STD_LOGIC_VECTOR( DataWidth-1 DOWNTO 0);
	PDU_DINV			: IN		STD_LOGIC;
	PDU_IN_SOP		: IN		STD_LOGIC;
	PDU_IN_EOP		: IN		STD_LOGIC;
	PDU_IN_Ind		: IN		STD_LOGIC;
	PDU_IN_USER_In		: IN		STD_LOGIC_VECTOR( USER_width-1 DOWNTO 0);
	PDU_IN_ErrIn		: IN		STD_LOGIC;
	PDU_IN_ErrOut		: OUT	STD_LOGIC;
	PDU_IN_Ack		: OUT	STD_LOGIC;
	-------------------------------------------------------------
	SDU_DOUT			: OUT	STD_LOGIC_VECTOR( DataWidth-1 DOWNTO 0);
	SDU_DOUTV			: OUT	STD_LOGIC;
	SDU_Out_SOP		: OUT	STD_LOGIC;
	SDU_OUT_EOP		: OUT	STD_LOGIC;
	SDU_OUT_Ind		: OUT	STD_LOGIC;
	SDU_OUT_USER_Out	: OUT	STD_LOGIC_VECTOR( USER_width-1 DOWNTO 0);
	SDU_OUT_ErrOut		: OUT	STD_LOGIC;
	SDU_OUT_ErrIn		: IN		STD_LOGIC;
	SDU_OUT_Ack		: IN		STD_LOGIC;
	--------------------------------------------------------------
	Status			: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END UDPLayer;

ARCHITECTURE ArchUDPLayerBehav OF UDPLayer IS

CONSTANT	UDPPCILengthDW				:	INTEGER	:=	UDPPCILength/DataWidth;
CONSTANT	UDP_PseudoLenW				:	INTEGER	:=	(UDPPseudoLength + UDPPCILength)/16;
CONSTANT	TX_PseudoHCNTRWidth			:	INTEGER	:=	INTEGER(CEIL(LOG2(REAL(UDP_PseudoLenW+1))));
CONSTANT	AddrWidth					:	INTEGER	:=	INTEGER(CEIL(LOG2(REAL(NumOfUDPPorts))));
CONSTANT	UDP_RX_PCILen_vec			:	STD_LOGIC_VECTOR(2 DOWNTO 0)	:=	"111"; -- 8 -1

CONSTANT	TX_Stat_INIT				:		STD_LOGIC_VECTOR(3 downto 0)	:= X"0";
CONSTANT	TX_Stat_IDLE				:		STD_LOGIC_VECTOR(3 downto 0)	:= X"1";
CONSTANT	TX_Stat_EmitPCI_Ind			:		STD_LOGIC_VECTOR(3 downto 0)	:= X"2";
CONSTANT	TX_Stat_Send_Ack			:		STD_LOGIC_VECTOR(3 downto 0)	:= X"3";
CONSTANT	TX_Stat_Reg_Lo				:		STD_LOGIC_VECTOR(3 downto 0)	:= X"4";
CONSTANT	TX_Stat_Reg_Hi_and_Sum		:		STD_LOGIC_VECTOR(3 downto 0)	:= X"5";
CONSTANT	TX_Stat_Reg_Lo_DUMMY		:		STD_LOGIC_VECTOR(3 downto 0)	:= X"6";
CONSTANT	TX_Stat_Last_SUM			:		STD_LOGIC_VECTOR(3 downto 0)	:= X"7";
CONSTANT	TX_Stat_SumPseudoHeader		:		STD_LOGIC_VECTOR(3 downto 0)	:= X"8";
CONSTANT	TX_Stat_CHK_Calculated		:		STD_LOGIC_VECTOR(3 downto 0)	:= X"9";
CONSTANT	TX_Stat_Inject_DUMMY_PCI		:		STD_LOGIC_VECTOR(3 downto 0)	:= X"a";
CONSTANT	TX_Stat_EmitPCI_Start		:		STD_LOGIC_VECTOR(3 downto 0)	:= X"b";

CONSTANT	RX_Stat_INIT				:		STD_LOGIC_VECTOR(3 downto 0)	:= X"0";
CONSTANT	RX_Stat_IDLE				:		STD_LOGIC_VECTOR(3 downto 0)	:= X"1";
CONSTANT	RX_Stat_SendAck			:		STD_LOGIC_VECTOR(3 downto 0)	:= X"2";
CONSTANT	RX_Stat_DeSer_IPGR			:		STD_LOGIC_VECTOR(3 downto 0)	:= X"3";
CONSTANT	RX_Stat_PAUSE_CTRL			:		STD_LOGIC_VECTOR(3 downto 0)	:= X"4";
CONSTANT	RX_Stat_LOOKUP_DSTPORT		:		STD_LOGIC_VECTOR(3 downto 0)	:= X"5";
CONSTANT	RX_Stat_WFOR_RAUXQ			:		STD_LOGIC_VECTOR(3 downto 0)	:= X"6";
CONSTANT	RX_Stat_ForwardPDU			:		STD_LOGIC_VECTOR(3 downto 0)	:= X"7";
CONSTANT	RX_Stat_DropPDU			:		STD_LOGIC_VECTOR(3 downto 0)	:= X"8";


--------------------------
-- TX checksum calc SIGNALs
--------------------------
TYPE TX_FSM_StateType IS
(
	INIT,
	IDLE,
	EmitPCI_Ind,
	Send_Ack,
	Reg_Lo,
	Reg_Hi_and_Sum,
	Reg_Lo_DUMMY,
	Last_SUM,
	SumPseudoHeader,
	AddCarry_1,
	AddCarry_2,
	CHK_Calculated,
	EmitPCI_Start
);

ATTRIBUTE	ENUM_ENCODING			:	STRING;
SIGNAL	TX_FSM_State			:	TX_FSM_StateType;
SIGNAL	TX_Status				:	STD_LOGIC_VECTOR(3 downto 0);


--------------------------
-- RX FSM SIGNALs
--------------------------
TYPE RX_FSM_StateType IS
(
	INIT,
	IDLE,
	Send_Ack,
	DeSer_IPGR,
	PAUSE_CTRL,
	LOOKUP_DSTPORT,
	WFOR_RAUXQ,
	ForwardPDU,
	DropPDU
);

SIGNAL	RX_FSM_State			:	RX_FSM_StateType;
SIGNAL	RX_Status				:	STD_LOGIC_VECTOR(3 downto 0);

SIGNAL	UDP_RX_PCICNTR			:	STD_LOGIC_VECTOR(2 DOWNTO 0);

SIGNAL	UDP_RX_PCI_sig		:		STD_LOGIC_VECTOR( UDPPCILength-1 DOWNTO 0);
SIGNAL	UDP_RX_SrcPort		:		STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
SIGNAL	UDP_RX_DstPort		:		STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
SIGNAL	UDP_RX_Length		:		STD_LOGIC_VECTOR( UDPLengthSize-1 DOWNTO 0);
SIGNAL	UDP_RX_CHKSUM		:		STD_LOGIC_VECTOR( UDPCHKSize-1 DOWNTO 0);


SIGNAL	DW_reg_Hi				:	STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	DW_reg_Lo				:	STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	DW_reg				:	STD_LOGIC_VECTOR(15 DOWNTO 0);

SIGNAL	TX_CheksumCalc			:	STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	TX_CheksumCalc_temp		:	STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	TX_CheksumV			:	STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	TX_PseudoHCNTR			:	STD_LOGIC_VECTOR(TX_PseudoHCNTRWidth-1 DOWNTO 0);
SIGNAL	TX_PseudoHLen_vec		:	STD_LOGIC_VECTOR(TX_PseudoHCNTRWidth-1 DOWNTO 0)	:=	STD_LOGIC_VECTOR(to_unsigned(UDP_PseudoLenW-1,TX_PseudoHCNTRWidth));
SIGNAL	TXFSM_ack				:	STD_LOGIC;
--------------------------
-- DeSerializer SIGNALs
--------------------------
SIGNAL	Deser_V				:	STD_LOGIC;
SIGNAL	DeSer_Err				:	STD_LOGIC;
--------------------------
-- Serializer SIGNALs
--------------------------
SIGNAL	PCI_Ser_Start			:	STD_LOGIC;
--------------------------
-- Input register SIGNALs
--------------------------
SIGNAL	SDU_DIN_reg			:	STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SDU_DINV_reg			:	STD_LOGIC;
SIGNAL	SDU_In_SOP_reg			:	STD_LOGIC;
SIGNAL	SDU_In_EOP_reg			:	STD_LOGIC;
SIGNAL	SDU_IN_Ind_reg			:	STD_LOGIC;
SIGNAL	SDU_IN_ErrIn_reg		:	STD_LOGIC;
SIGNAL	StartOfSDUIn			:	STD_LOGIC;
SIGNAL	StartOfSDUIn_reg		:	STD_LOGIC;
SIGNAL	StartOfSDUIn_rise		:	STD_LOGIC;
SIGNAL	DstPort_In_reg			:	STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
SIGNAL	SrcPort_In_reg			:	STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
SIGNAL	Length_In_reg			:	STD_LOGIC_VECTOR( UDPLengthSize-1 DOWNTO 0);
SIGNAL	DstIPAddr_In_reg		:	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
SIGNAL	SrcIPAddr_In_reg		:	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
--------------------------
-- TX PCI SIGNALs
--------------------------
SIGNAL	TX_PCI_register		:	STD_LOGIC_VECTOR( UDPPCILength-1 DOWNTO 0);
SIGNAL	TX_PseudoHeader		:	STD_LOGIC_VECTOR( UDPPseudoLength + UDPPCILength -1 DOWNTO 0);
SIGNAL	TX_PseudoHeader_reg		:	STD_LOGIC_VECTOR( UDPPseudoLength + UDPPCILength -1 DOWNTO 0);
SIGNAL	UDP_TX_Cheksum			:	STD_LOGIC_VECTOR( UDPCHKSize-1 DOWNTO 0);
SIGNAL	UDP_TX_Length			:	STD_LOGIC_VECTOR( UDPLengthSize-1 DOWNTO 0);
SIGNAL	DstIPAddr_TX_AUX_In		:	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
SIGNAL	SrcIPAddr_TX_AUX_In		:	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
SIGNAL	UDP_TX_Length_TX_AUX_In	:	STD_LOGIC_VECTOR( UDPLengthSize-1 DOWNTO 0);
--------------------------------
--ProtoLayer SIGNALs
--------------------------------
SIGNAL	pci_din			:		STD_LOGIC_VECTOR( DataWidth-1 DOWNTO 0);
SIGNAL	pci_dinv			:		STD_LOGIC;
SIGNAL	pci_dinv_sig		:		STD_LOGIC;
SIGNAL	pci_in_sop		:		STD_LOGIC;
SIGNAL	pci_in_sop_sig		:		STD_LOGIC;
SIGNAL	pci_in_eop		:		STD_LOGIC;
SIGNAL	pci_in_eop_sig		:		STD_LOGIC;
SIGNAL	pci_in_ind		:		STD_LOGIC;
SIGNAL	pci_in_errin		:		STD_LOGIC;
SIGNAL	pci_in_user_in		:		STD_LOGIC_VECTOR( USER_width-1 DOWNTO 0);
SIGNAL	pdu_in_user_in_sig	:		STD_LOGIC_VECTOR( USER_width-1 DOWNTO 0);
SIGNAL	pci_in_ack		:		STD_LOGIC;
SIGNAL	pci_in_errout		:		STD_LOGIC;
SIGNAL	PL_SDU_In_ACK		:		STD_LOGIC;
SIGNAL	SDU_IN_Ack_sig		:		STD_LOGIC;
SIGNAL	ctrl_dout			:		STD_LOGIC_VECTOR( DataWidth-1 DOWNTO 0);
SIGNAL	ctrl_dv			:		STD_LOGIC;
SIGNAL	ctrl_sop			:		STD_LOGIC;
SIGNAL	ctrl_eop			:		STD_LOGIC;
SIGNAL	ctrl_errout		:		STD_LOGIC;
SIGNAL	ctrl_ind			:		STD_LOGIC;
SIGNAL	ctlr_user_out		:		STD_LOGIC_VECTOR( USER_width-1 DOWNTO 0);
SIGNAL	ctrl_ack			:		STD_LOGIC;
SIGNAL	ctrl_fwd			:		STD_LOGIC;
SIGNAL	ctrl_pause		:		STD_LOGIC;
SIGNAL	ctrl_drop_err		:		STD_LOGIC;
SIGNAL	SDU_DOUTV_sig		:		STD_LOGIC;
SIGNAL	SDU_Out_SOP_sig	:		STD_LOGIC;
SIGNAL	TX_AUX_Out		:		STD_LOGIC_VECTOR(2*IPAddrSize+IPLengthSize-1 DOWNTO 0);
SIGNAL	TX_AUX_OutV		:		STD_LOGIC;
SIGNAL	TX_AUX_in			:		STD_LOGIC_VECTOR(2*IPAddrSize+IPLengthSize-1 DOWNTO 0);
SIGNAL	RX_AUX_Out		:		STD_LOGIC_VECTOR(2*IPAddrSize-1 DOWNTO 0);
SIGNAL	RX_AUX_OutV		:		STD_LOGIC;
SIGNAL	RX_AUX_in			:		STD_LOGIC_VECTOR(2*IPAddrSize-1 DOWNTO 0);
--------------------------------
--MiniCAM SIGNALs
--------------------------------
SIGNAL	MiniCAM_WR_En		:		STD_LOGIC;
SIGNAL	MiniCAM_RD_En		:		STD_LOGIC;
SIGNAL	MiniCAM_PortIN		:		STD_LOGIC_VECTOR( UDPPortSize DOWNTO 0);
SIGNAL	MiniCAM_CAM_PortIN	:		STD_LOGIC_VECTOR( UDPPortSize DOWNTO 0);
SIGNAL	MiniCAM_SRCH		:		STD_LOGIC;
SIGNAL	MiniCAM_Match		:		STD_LOGIC;
SIGNAL	MiniCAM_MatchV		:		STD_LOGIC;
SIGNAL	MiniCAM_PortOUT	:		STD_LOGIC_VECTOR( UDPPortSize DOWNTO 0);
SIGNAL	MiniCAM_ADDR_Out	:		STD_LOGIC_VECTOR( AddrWidth-1 DOWNTO 0);
SIGNAL	MiniCAM_ADDR_In	:		STD_LOGIC_VECTOR( AddrWidth-1 DOWNTO 0);
SIGNAL	MiniCAM_DOUTV		:		STD_LOGIC;
--------------------------------
--RX_Preverifier SIGNALs
--------------------------------
SIGNAL	IP_DstIPAddr_In_verified	:	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
SIGNAL	IP_SrcIPAddr_In_verified	:	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
SIGNAL	PDU_DIN_verified		:	STD_LOGIC_VECTOR( DataWidth-1 DOWNTO 0);
SIGNAL	PDU_DINV_verified		:	STD_LOGIC;
SIGNAL	PDU_In_SOP_verified		:	STD_LOGIC;
SIGNAL	PDU_In_EOP_verified		:	STD_LOGIC;
SIGNAL	PDU_In_Ind_verified		:	STD_LOGIC;
SIGNAL	PDU_In_ErrOut_verified	:	STD_LOGIC;
SIGNAL	PDU_In_Ack_verified		:	STD_LOGIC;
SIGNAL	PDU_In_ErrIn_verified	:	STD_LOGIC;
			
BEGIN
	Status			<=	RX_Status & TX_Status;
	TX_AUX_in			<=	DstIPAddr_TX_AUX_In & SrcIPAddr_TX_AUX_In & UDP_TX_Length_TX_AUX_In;
	IP_Proto_Out		<=	IPProt_UDP;
	IP_DstIPAddr_Out	<=	TX_AUX_Out(79 DOWNTO 48);
	IP_SrcIPAddr_Out	<=	TX_AUX_Out(47 DOWNTO 16);
	IP_Length_Out		<=	TX_AUX_Out(15 DOWNTO 0);
	
	RX_AUX_in			<=	IP_DstIPAddr_In_verified & IP_SrcIPAddr_In_verified;
	DstIPAddr_Out		<=	RX_AUX_Out(63 DOWNTO 32);
	SrcIPAddr_Out		<=	RX_AUX_Out(31 DOWNTO 0);

	StartOfSDUIn		<=	SDU_DINV AND SDU_In_SOP;

	SDU_DIn_reg_inst	: aRegister	GENERIC MAP	( Size => DataWidth)	PORT MAP( D => SDU_DIN,C => CLK,CE => CE,Q => SDU_DIN_reg);
	SDU_DINV_reg_inst	: aFlop		PORT MAP		( D => SDU_DINV,C => CLK,CE => CE,Q => SDU_DINV_reg);
	SDU_IN_SOP_reg_inst	: aFlop		PORT MAP		( D => SDU_In_SOP,C => CLK,CE => CE,Q => SDU_In_SOP_reg);
	SDU_IN_EOP_reg_inst	: aFlop		PORT MAP		( D => SDU_In_EOP,C => CLK,CE => CE,Q => SDU_In_EOP_reg);
	SDU_IN_Ind_reg_inst	: aFlop		PORT MAP		( D => SDU_IN_Ind,C => CLK,CE => CE,Q => SDU_IN_Ind_reg);
	SDU_IN_EIn_reg_inst	: aFlop		PORT MAP		( D => SDU_IN_ErrIn,C => CLK,CE => CE,Q => SDU_IN_ErrIn_reg);
	-- SOFSDUIn_reg_inst	: aFlop		PORT MAP		( D => StartOfSDUIn,C => CLK,CE => CE,Q => StartOfSDUIn_reg);
	SOFSDUIn_rise_inst	: aRise		PORT MAP		( I => StartOfSDUIn, C => CLK, Q => StartOfSDUIn_rise);
	DPORTIn_reg_inst	: aRegister	GENERIC MAP	( Size => UDPPortSize)	PORT MAP( D => DstPort_In,C => CLK,CE => StartOfSDUIn_rise,Q => DstPort_In_reg);
	SRCPORTIn_reg_inst	: aRegister	GENERIC MAP	( Size => UDPPortSize)	PORT MAP( D => SrcPort_In,C => CLK,CE => StartOfSDUIn_rise,Q => SrcPort_In_reg);
	LenINreg_inst		: aRegister	GENERIC MAP	( Size => UDPLengthSize)	PORT MAP( D => Length_In,C => CLK,CE => StartOfSDUIn_rise,Q => Length_In_reg);
	DSTIPIn_reg_inst	: aRegister	GENERIC MAP	( Size => IPAddrSize)	PORT MAP( D => DstIPAddr_In,C => CLK,CE => StartOfSDUIn_rise,Q => DstIPAddr_In_reg);
	SRCIPIn_reg_inst	: aRegister	GENERIC MAP	( Size => IPAddrSize)	PORT MAP( D => SrcIPAddr_In,C => CLK,CE => StartOfSDUIn_rise,Q => SrcIPAddr_In_reg);
	--------------------------
	-- Assigning static parts
	--------------------------
	UDP_TX_Length					<=	Length_In_reg + X"0008";	

	TX_PCI_register(63 DOWNTO 48)		<=	SrcPort_In_reg;
	TX_PCI_register(47 DOWNTO 32)		<=	DstPort_In_reg;
	TX_PCI_register(31 DOWNTO 16)		<=	UDP_TX_Length;
	TX_PCI_register(15 DOWNTO 0)		<=	UDP_TX_Cheksum;
	
	TX_PseudoHeader(159 DOWNTO 128)	<=	SrcIPAddr_In_reg;
	TX_PseudoHeader(127 DOWNTO 96)	<=	DstIPAddr_In_reg;
	TX_PseudoHeader(95 DOWNTO 88)		<=	X"00";
	TX_PseudoHeader(87 DOWNTO 80)		<=	IPProt_UDP;
	TX_PseudoHeader(79 DOWNTO 64)		<=	UDP_TX_Length;
	TX_PseudoHeader(63 DOWNTO 48)		<=	SrcPort_In_reg;
	TX_PseudoHeader(47 DOWNTO 32)		<=	DstPort_In_reg;
	TX_PseudoHeader(31 DOWNTO 16)		<=	UDP_TX_Length;
	TX_PseudoHeader(15 DOWNTO 0)		<=	X"0000";
	-- TX_PseudoHeader(63 DOWNTO 0)		<=	TX_PCI_register;
	--------------------------
	-- END OF Assigning static parts
	--------------------------
	SDU_IN_Ack_sig		<=	TXFSM_ack AND PL_SDU_In_ACK;
	SDUIA_reg			:	aFlop	PORT MAP( C => CLK , D => SDU_IN_Ack_sig , CE => CE, Q => SDU_IN_Ack);
	DW_reg			<=	DW_reg_Hi & DW_reg_Lo;
	
	TX_FSM_proc:PROCESS(clk,rst,CE,TX_FSM_State,SDU_IN_Ind_reg,SDU_DINV_reg,SDU_In_SOP_reg,SDU_IN_ErrIn_reg,SDU_In_EOP_reg,TX_PseudoHCNTR,PCI_IN_Ack,PCI_DINV_sig,PCI_IN_SOP_sig)
	BEGIN
		IF(RISING_EDGE(clk))THEN
			IF(rst = Hi) THEN
				TX_CheksumCalc			<=	(OTHERS => Lo);
				TX_CheksumCalc_temp		<=	(OTHERS => Lo);
				UDP_TX_Cheksum			<=	(OTHERS => Lo);
				TXFSM_ack				<=	Lo;
				PCI_IN_Ind			<=	Lo;
				PCI_IN_ErrIn			<=	Lo;
				PCI_Ser_Start			<=	Lo;
				DW_reg_Hi				<=	(OTHERS => Lo);
				DW_reg_Lo				<=	(OTHERS => Lo);
				TX_PseudoHCNTR			<=	(OTHERS => Lo);
				DstIPAddr_TX_AUX_In		<=	(OTHERS => Lo);
				SrcIPAddr_TX_AUX_In		<=	(OTHERS => Lo);
				UDP_TX_Length_TX_AUX_In	<=	(OTHERS => Lo);
				TX_Status				<=	TX_Stat_INIT;
				TX_FSM_State			<=	INIT;
			ELSIF(rst = Lo AND CE = Hi) THEN
				CASE TX_FSM_State IS
					WHEN IDLE =>
						TX_Status				<=	TX_Stat_IDLE;
						TXFSM_ack				<=	Lo;
						PCI_Ser_Start			<=	Lo;
						PCI_IN_Ind			<=	Lo;
						DW_reg_Hi				<=	(OTHERS => Lo);
						DW_reg_Lo				<=	(OTHERS => Lo);
						TX_PseudoHCNTR			<=	(OTHERS => Lo);
						TX_CheksumCalc			<=	(OTHERS => Lo);
						TX_CheksumCalc_temp		<=	(OTHERS => Lo);
						IF(SDU_IN_Ind_reg = Hi)THEN
							TX_FSM_State	<=	Send_Ack;
						ELSE
							TX_FSM_State	<=	IDLE;
						END IF;
					WHEN Send_Ack =>
						TX_Status	<=	TX_Stat_Send_Ack;
						TXFSM_ack	<=	Hi;
						IF(SDU_IN_Ind_reg = Hi) THEN
							IF(SDU_DINV_reg = Hi AND SDU_In_SOP_reg = Hi AND SDU_IN_ErrIn_reg = Lo)THEN
								DW_reg_Hi		<=	SDU_DIN_reg;
								TX_FSM_State	<=	Reg_Lo;
							ELSE
								TX_FSM_State	<=	Send_Ack;
							END IF;
						ELSE
							TX_FSM_State	<=	IDLE;
						END IF;
					WHEN Reg_Lo =>
						TXFSM_ack	<=	Lo;
						TX_Status	<=	TX_Stat_Reg_Lo;
						IF(SDU_IN_ErrIn_reg = Lo)THEN
							IF(SDU_DINV_reg = Hi)THEN
								DW_reg_Lo		<=	SDU_DIN_reg;
								IF(SDU_In_EOP_reg = Hi) THEN
									TX_FSM_State	<=	Last_SUM;
								ELSE
									TX_FSM_State	<=	Reg_Hi_and_Sum;
								END IF;
							ELSE
								TX_FSM_State	<=	Reg_Lo;
							END IF;
						ELSE
							TX_FSM_State	<=	EmitPCI_Ind;
						END IF;
					WHEN Reg_Hi_and_Sum =>
						TX_Status	<=	TX_Stat_Reg_Hi_and_Sum;
						IF(SDU_IN_ErrIn_reg = Lo)THEN
							IF(SDU_DINV_reg = Hi)THEN
								DW_reg_Hi		<=	SDU_DIN_reg;
								TX_CheksumCalc	<=	TX_CheksumCalc + ( X"0000" & DW_reg);
								IF(SDU_In_EOP_reg = Hi) THEN
									TX_FSM_State	<=	Reg_Lo_DUMMY;
								ELSE
									TX_FSM_State	<=	Reg_Lo;
								END IF;
							ELSE
								TX_FSM_State	<=	Reg_Hi_and_Sum;
							END IF;
						ELSE
							TX_FSM_State	<=	EmitPCI_Ind;
						END IF;
					WHEN Reg_Lo_DUMMY =>
						TX_Status			<=	TX_Stat_Reg_Lo_DUMMY;
						DW_reg_Lo			<=	(OTHERS => Lo);
						TX_FSM_State		<=	Last_SUM;
					WHEN Last_SUM =>
						TX_Status				<=	TX_Stat_Last_SUM;
						TX_CheksumCalc			<=	TX_CheksumCalc + ( X"0000" & DW_reg);
						TX_PseudoHeader_reg		<=	TX_PseudoHeader;
						DstIPAddr_TX_AUX_In		<=	DstIPAddr_In_reg;
						SrcIPAddr_TX_AUX_In		<=	SrcIPAddr_In_reg;
						UDP_TX_Length_TX_AUX_In	<=	UDP_TX_Length;
						TX_FSM_State			<=	SumPseudoHeader;
					-- WHEN OTHERS => --INIT
					WHEN SumPseudoHeader =>
						TX_Status			<=	TX_Stat_SumPseudoHeader;
						TX_CheksumCalc		<=	TX_CheksumCalc + (X"0000" & TX_PseudoHeader_reg(TX_PseudoHeader_reg'Length-1 DOWNTO TX_PseudoHeader_reg'Length-16));
						TX_PseudoHeader_reg(TX_PseudoHeader_reg'Length-1 DOWNTO 16)
										<=	TX_PseudoHeader_reg(TX_PseudoHeader_reg'Length-16-1 DOWNTO 0);
						TX_PseudoHCNTR		<=	TX_PseudoHCNTR + 1;
						IF(TX_PseudoHCNTR = TX_PseudoHLen_vec)THEN
							TX_FSM_State		<=	AddCarry_1;
						ELSE
							TX_FSM_State		<=	SumPseudoHeader;
						END IF;
					WHEN AddCarry_1 =>
						TX_CheksumCalc_temp	<=	(X"0000" & TX_CheksumCalc(31 DOWNTO 16)) + (X"0000" & TX_CheksumCalc(15 DOWNTO 0));
						TX_FSM_State		<=	AddCarry_2;
					WHEN	AddCarry_2 =>
						IF(TX_CheksumCalc_temp(16) = Hi) THEN
							TX_CheksumCalc	<=	TX_CheksumCalc_temp + 1;
						ELSE
							TX_CheksumCalc	<=	TX_CheksumCalc_temp;
						END IF;
						TX_FSM_State		<=	CHK_Calculated;
					WHEN CHK_Calculated =>
						TX_Status			<=	TX_Stat_CHK_Calculated;
						UDP_TX_Cheksum		<=	NOT TX_CheksumCalc(15 DOWNTO 0);
						TX_CheksumCalc		<=	(OTHERS => Lo);
						TX_FSM_State		<=	EmitPCI_Ind;
					WHEN EmitPCI_Ind =>
						TX_Status		<=	TX_Stat_EmitPCI_Ind;
						PCI_IN_Ind	<=	Hi;
						IF(PCI_IN_ErrOut = Lo)THEN
							IF(PCI_IN_Ack = Hi)THEN
								TX_FSM_State	<=	EmitPCI_Start;
							ELSE
								TX_FSM_State	<=	EmitPCI_Ind;
							END IF;
						ELSE
							TX_FSM_State	<=	IDLE;
						END IF;
					WHEN EmitPCI_Start =>
						TX_Status		<=	TX_Stat_EmitPCI_Start;
						PCI_Ser_Start	<=	Hi;
						IF(PCI_DINV_sig = Hi AND PCI_IN_SOP_sig = Hi) THEN
							TX_FSM_State	<=	IDLE;
						ELSE
							TX_FSM_State	<=	EmitPCI_Start;
						END IF;
					WHEN INIT =>
						TX_FSM_State	<=	IDLE;
				END CASE;
			END IF;
		END IF;
	END PROCESS TX_FSM_proc;
	
	UDP_RX_SrcPort	<=	UDP_RX_PCI_sig(63 DOWNTO 48);
	UDP_RX_DstPort	<=	UDP_RX_PCI_sig(47 DOWNTO 32);
	UDP_RX_Length	<=	UDP_RX_PCI_sig(31 DOWNTO 16);
	UDP_RX_CHKSUM	<=	UDP_RX_PCI_sig(15 DOWNTO 00);

	UDPPCIDeSerializer : DeSerializer
	GENERIC MAP(
		DataWidth	=>	DataWidth,
		ToDeSer	=>	UDPPCILength/DataWidth
	)	
	PORT MAP(
		CLK		=>	CLK,
		RST		=>	RST,
		CE		=>	CE,
		SIn		=>	CTRL_DOUT,
		Ser_DV	=>	CTRL_DV,
		Ser_SOP	=>	CTRL_SOP,
		Ser_EOP	=>	CTRL_EOP,
		Ser_ErrIn	=>	CTRL_ErrOut,
		POut		=>	UDP_RX_PCI_sig,
		POuTV	=>	Deser_V,
		POuT_err	=>	DeSer_Err
	);

	RX_FSM_proc:PROCESS(clk,rst,CE,RX_FSM_State,CTRL_Ind,CTRL_SOP,CTRL_DV,CTRL_ErrOut,UDP_RX_PCICNTR,CTRL_EOP,DeSer_Err,CTRL_ErrOut,Deser_V,MiniCAM_MatchV,MiniCAM_Match,RX_AUX_OutV,SDU_Out_SOP_sig,SDU_DOUTV_sig,SDU_OUT_ErrIn)
	BEGIN
		IF(RISING_EDGE(clk))THEN
			IF(rst = Hi) THEN
				ctrl_ack		<=	Lo;
				ctrl_fwd		<=	Lo;
				ctrl_pause	<=	Lo;
				ctrl_drop_err	<=	Lo;
				UDP_RX_PCICNTR	<=	(OTHERS => Lo);
				MiniCAM_SRCH	<=	Lo;
				RX_Status		<=	RX_Stat_INIT;
				RX_FSM_State	<=	INIT;
			ELSIF(rst = Lo AND CE = Hi) THEN
				CASE RX_FSM_State IS
					WHEN IDLE =>
						RX_Status		<=	RX_Stat_IDLE;
						ctrl_ack		<=	Lo;
						ctrl_fwd		<=	Lo;
						ctrl_pause	<=	Lo;
						ctrl_drop_err	<=	Lo;
						UDP_RX_PCICNTR	<=	(OTHERS => Lo);
						MiniCAM_SRCH	<=	Lo;
						IF(CTRL_Ind = Hi) THEN
							RX_FSM_State	<=	Send_Ack;
						ELSE
							RX_FSM_State	<=	IDLE;
						END IF;
					WHEN Send_Ack =>
						RX_Status		<=	RX_Stat_SendAck;
						ctrl_ack		<=	Hi;
						IF(CTRL_Ind = Hi) THEN
							IF(CTRL_SOP = Hi and CTRL_DV = Hi)THEN
								UDP_RX_PCICNTR	<=	UDP_RX_PCICNTR + 1;
								RX_FSM_State	<=	DeSer_IPGR;
							ELSE
								RX_FSM_State	<=	Send_Ack;
							END IF;
						ELSE
							RX_FSM_State	<=	IDLE;
						END IF;
					WHEN DeSer_IPGR =>
						RX_Status		<=	RX_Stat_DeSer_IPGR;
						ctrl_ack		<=	Lo;
						IF(CTRL_ErrOut = Lo)THEN
							IF(CTRL_DV = Hi)THEN
								UDP_RX_PCICNTR	<=	UDP_RX_PCICNTR + 1;
								IF(UDP_RX_PCICNTR = UDP_RX_PCILen_vec)THEN
									IF(CTRL_EOP = Hi)THEN
										RX_FSM_State	<=	IDLE;
									ELSE
										RX_FSM_State	<=	PAUSE_CTRL;
									END IF;
								ELSE
									RX_FSM_State	<=	DeSer_IPGR;
								END IF;
							ELSE
								RX_FSM_State	<=	DeSer_IPGR;
							END IF;
						ELSE
							RX_FSM_State	<=	IDLE;
						END IF;
					WHEN PAUSE_CTRL =>
						RX_Status		<=	RX_Stat_PAUSE_CTRL;
						CTRL_Pause	<=	Hi;
						IF(DeSer_Err = Lo AND CTRL_ErrOut = Lo)THEN
							IF(Deser_V = Hi)THEN
								RX_FSM_State	<=	LOOKUP_DSTPORT;
							ELSE
								RX_FSM_State	<=	PAUSE_CTRL;
							END IF;
						ELSE
							RX_FSM_State	<=	IDLE;
						END IF;
					WHEN LOOKUP_DSTPORT =>
						MiniCAM_SRCH	<=	Hi;
						RX_Status		<=	RX_Stat_LOOKUP_DSTPORT;
						IF(MiniCAM_MatchV = Hi and MiniCAM_Match = Hi)THEN
							DstPort_Out	<=	UDP_RX_DstPort;
							SrcPort_Out	<=	UDP_RX_SrcPort;
							Length_Out	<=	UDP_RX_Length - X"0008";
							IF(RX_AUX_OutV = Hi)THEN
								RX_FSM_State	<=	ForwardPDU;
							ELSE
								RX_FSM_State	<=	WFOR_RAUXQ;
							END IF;
						ELSIF(MiniCAM_MatchV = Hi and MiniCAM_Match = Lo)THEN
							RX_FSM_State	<=	DropPDU;
						ELSE
							RX_FSM_State	<=	LOOKUP_DSTPORT;
						END IF;
					WHEN WFOR_RAUXQ =>
						RX_Status		<=	RX_Stat_WFOR_RAUXQ;
						IF(RX_AUX_OutV = Hi)THEN
							RX_FSM_State	<=	ForwardPDU;
						ELSE
							RX_FSM_State	<=	WFOR_RAUXQ;
						END IF;
					WHEN ForwardPDU =>
						CTRL_FWD		<=	Hi;
						MiniCAM_SRCH	<=	Lo;
						RX_Status		<=	RX_Stat_ForwardPDU;
						IF((SDU_Out_SOP_sig = Hi and SDU_DOUTV_sig = Hi) or SDU_OUT_ErrIn = Hi)THEN
							RX_FSM_State	<=	IDLE;
						ELSE
							RX_FSM_State	<=	ForwardPDU;
						END IF;
					WHEN DropPDU =>
						CTRL_DROP_ERR	<=	Hi;
						MiniCAM_SRCH	<=	Lo;
						RX_Status		<=	RX_Stat_DropPDU;
						RX_FSM_State	<=	IDLE;
					-- WHEN OTHERS => --INIT
					WHEN INIT =>
						ctrl_ack		<=	Lo;
						ctrl_fwd		<=	Lo;
						ctrl_pause	<=	Lo;
						ctrl_drop_err	<=	Lo;
						UDP_RX_PCICNTR	<=	(OTHERS => Lo);
						MiniCAM_SRCH	<=	Lo;
						RX_FSM_State	<=	IDLE;
				END CASE;
			END IF;
		END IF;
	END PROCESS RX_FSM_proc;
	MiniCAM_CAM_PortIN	<=	"1" & UDP_RX_DstPort;
	MiniCAM_WR_En		<=	WR_EN;
	MiniCAM_ADDR_In	<=	ADDR;
	MiniCAM_RD_En		<=	RD_EN;
	MiniCAM_PortIN		<=	DATA_IN;
	DATA_OUT			<=	MiniCAM_PortOUT;
	DOUTV			<=	MiniCAM_DOUTV;
	Inst_MiniCAM: MiniCAM 
	GENERIC MAP(
		DataWidth	=>	UDPPortSize+1,
		Elements	=>	NumOfUDPPorts,
		InitToFF	=>	false
	)
	PORT MAP(
		CLK		=>	CLK,
		RST		=>	RST,
		CE		=>	CE,
		CFG_CE	=>	CFG_CE,
		WR_EN	=>	MiniCAM_WR_En,
		RD_EN	=>	MiniCAM_RD_En,
		DIN		=>	MiniCAM_PortIN,
		ADDR_In	=>	MiniCAM_ADDR_In,
		CAM_DIN	=>	MiniCAM_CAM_PortIN, -- CAM IN
		CAM_SRCH	=>	MiniCAM_SRCH, -- CAM IN
		Match	=>	MiniCAM_Match, -- CAM OUT
		MatchV	=>	MiniCAM_MatchV, -- CAM OUT
		DOUT		=>	MiniCAM_PortOUT,
		ADDR_Out	=>	MiniCAM_ADDR_Out, -- CAM OUT
		DOUTV	=>	MiniCAM_DOUTV
	);

	
	Inst_Serializer: Serializer 
	GENERIC MAP(
		DataWidth	=>	DataWidth,
		ToSer	=>	UDPPCILengthDW
	)
	PORT MAP(
		CLK		=>	CLK,
		RST		=>	RST,
		CE		=>	CE,
		Start	=>	PCI_Ser_Start,
		Ser_Start	=>	PCI_IN_SOP_sig,
		Complete	=>	PCI_IN_EOP_sig,
		PIn		=>	TX_PCI_register,
		SOut		=>	PCI_DIN,
		OuTV		=>	PCI_DINV_sig
	);
	PCI_IN_SOP	<=	PCI_IN_SOP_sig;
	PCI_IN_EOP	<=	PCI_IN_EOP_sig;
	PCI_DINV		<=	PCI_DINV_sig;
	
	UDP_RX_PreVerifier_inst: UDP_RX_PreVerifier 
	GENERIC MAP(
		DataWidth				=>	DefDataWidth,
		SYNC_IN				=>	RX_SYNC_IN
	)
	PORT MAP (
			CLK				=>	CLK,
			RST				=>	RST,
			CE				=>	CE,
			------------------------------------------
			IP_DstIPAddr_In	=>	IP_DstIPAddr_In,
			IP_SrcIPAddr_In	=>	IP_SrcIPAddr_In,
			IP_Proto_In		=>	IP_Proto_In,
			IP_Length_In		=>	IP_Length_In,
			DstIPAddr_out		=>	IP_DstIPAddr_In_verified,
			SrcIPAddr_out		=>	IP_SrcIPAddr_In_verified,
			------------------------------------------
			DIN				=>	PDU_DIN,
			DINV				=>	PDU_DINV,
			In_SOP			=>	PDU_In_SOP,
			In_EOP			=>	PDU_In_EOP,
			In_Ind			=>	PDU_In_Ind,
			In_ErrIn			=>	PDU_In_ErrIn,
			In_Ack			=>	PDU_In_Ack,
			In_ErrOut			=>	PDU_In_ErrOut,
			------------------------------------------
			DOUT				=>	PDU_DIN_verified,
			DOUTV			=>	PDU_DINV_verified,
			Out_SOP			=>	PDU_In_SOP_verified,
			Out_EOP			=>	PDU_In_EOP_verified,
			Out_Ind			=>	PDU_In_Ind_verified,
			Out_ErrOut		=>	PDU_In_ErrIn_verified,
			Out_Ack			=>	PDU_In_Ack_verified,
			Out_ErrIn			=>	PDU_In_ErrOut_verified
		 );
	SDU_DOUTV		<=	SDU_DOUTV_sig;
	SDU_Out_SOP	<=	SDU_Out_SOP_sig;
	UDP_ProtoLayer: ProtoLayer
	GENERIC MAP(
		DataWidth				=>	DataWidth,
		RX_SYNC_IN			=>	true,
		RX_SYNC_OUT			=>	RX_SYNC_OUT,
		RX_CTRL_SYNC			=>	true,
		TX_CTRL_SYNC			=>	true, -- PCI_In IN SYNC mode !!!
		TX_SYNC_IN			=>	true, -- must be used IN SYNC IN Mode!!
		TX_SYNC_OUT			=>	TX_SYNC_OUT,
		TX_AUX_Q				=>	true,
		TX_AUX_widthDW			=>	(2*IPAddrSize+IPLengthSize)/DataWidth, --SRCIP,DSTIP & Length
		RX_AUX_Q				=>	true,
		RX_AUX_widthDW			=>	2*IPAddrSize/DataWidth, --SRCIP & DSTIP
		MINSDUSize			=>	1,
		MAXSDUSize			=>	DefMaxSDUSize,
		MaxSDUToQ				=>	DefPDUToQ,
		MINPCISize			=>	UDPPCILength,
		MAXPCISize			=>	UDPPCILength,
		MaxPCIToQ				=>	DefPDUToQ
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
		PCI_IN_USER_In			=>	STD_LOGIC_VECTOR(to_unsigned(0,USER_width)),
		PCI_IN_Ack			=>	PCI_IN_Ack,
		PCI_IN_ErrOut			=>	PCI_IN_ErrOut,
		-------------------------------------------------------------
		SDU_DIN				=>	SDU_DIN_reg,
		SDU_DINV				=>	SDU_DINV_reg,
		SDU_IN_SOP			=>	SDU_IN_SOP_reg,
		SDU_IN_EOP			=>	SDU_IN_EOP_reg,
		SDU_IN_Ind			=>	SDU_IN_Ind_reg,
		SDU_IN_ErrIn			=>	SDU_IN_ErrIn_reg,
		SDU_IN_USER_In			=>	SDU_IN_USER_In,
		SDU_IN_Ack			=>	PL_SDU_In_ACK,
		SDU_IN_ErrOut			=>	SDU_IN_ErrOut,
		-------------------------------------------------------------
		PDU_DOUT				=>	PDU_DOUT,
		PDU_DOUTV				=>	PDU_DOUTV,
		PDU_Out_SOP			=>	PDU_Out_SOP,
		PDU_Out_EOP			=>	PDU_Out_EOP,
		PDU_Out_Ind			=>	PDU_Out_Ind,
		PDU_Out_ErrOut			=>	PDU_Out_ErrOut,
		PDU_Out_USER_Out		=>	PDU_Out_USER_Out,
		PDU_Out_Ack			=>	PDU_Out_Ack,
		PDU_Out_ErrIn			=>	PDU_Out_ErrIn,
		-------------------------------------------------------------
		PDU_DIN				=>	PDU_DIN_verified,
		PDU_DINV				=>	PDU_DINV_verified,
		PDU_IN_SOP			=>	PDU_IN_SOP_verified,
		PDU_IN_EOP			=>	PDU_IN_EOP_verified,
		PDU_IN_Ind			=>	PDU_IN_Ind_verified,
		PDU_IN_USER_In			=>	PDU_IN_USER_In,
		PDU_IN_ErrIn			=>	PDU_IN_ErrIn_verified,
		PDU_IN_ErrOut			=>	PDU_IN_ErrOut_verified,
		PDU_IN_Ack			=>	PDU_IN_Ack_verified,
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
		SDU_DOUTV				=>	SDU_DOUTV_sig,
		SDU_Out_SOP			=>	SDU_Out_SOP_sig,
		SDU_OUT_EOP			=>	SDU_OUT_EOP,
		SDU_OUT_Ind			=>	SDU_OUT_Ind,
		SDU_OUT_USER_Out		=>	SDU_OUT_USER_Out,
		SDU_OUT_ErrOut			=>	SDU_OUT_ErrOut,
		SDU_OUT_ErrIn			=>	SDU_OUT_ErrIn,
		SDU_OUT_Ack			=>	SDU_OUT_Ack,
		-------------------------------------------------------------
		TX_AUX_Out			=>	TX_AUX_Out, -- Used for DST IPAddr AND Source IpAddr AND length
		TX_AUX_outV			=>	TX_AUX_outV,
		TX_AUX_in				=>	TX_AUX_in,
		RX_AUX_Out			=>	RX_AUX_Out, --Not used
		RX_AUX_OutV			=>	RX_AUX_OutV, --Not used
		RX_AUX_in				=>	RX_AUX_in --Not used
	);




END ArchUDPLayerBehav;



LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

USE work.ProtoLayerTypesAndDefs.ALL;
USE work.ProtoModulePkg.PDUQueue;
USE work.arch.aRegister;
USE work.arch.aFlop;
USE work.arch.aRise;
USE work.arch.aDelay;
USE work.arch.aPipe;
USE work.ProtoModulePkg.Serializer;
USE work.ProtoModulePkg.DeSerializer;

ENTITY UDP_RX_PreVerifier IS -- verifying Proto_In, Cheksum, Length
GENERIC(
	DataWidth			:		INTEGER	:=	DefDataWidth;
	SYNC_IN			:		BOOLEAN	:=	false
);
PORT(
	CLK				: IN		STD_LOGIC;
	RST				: IN		STD_LOGIC;
	CE				: IN		STD_LOGIC;
	-----------------------------------------
	IP_DstIPAddr_In	: IN		STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
	IP_SrcIPAddr_In	: IN		STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
	IP_Proto_In		: IN		STD_LOGIC_VECTOR( IP_ProtSize-1 DOWNTO 0);
	IP_Length_In		: IN		STD_LOGIC_VECTOR( IPLengthSize-1 DOWNTO 0);
	-----------------------------------------
	DstIPAddr_out		: OUT	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
	SrcIPAddr_out		: OUT	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
	-----------------------------------------
	DIN				: IN		STD_LOGIC_VECTOR(DataWidth-1 DOWNTO 0);
	DINV				: IN		STD_LOGIC;
	In_SOP			: IN		STD_LOGIC;
	In_EOP			: IN		STD_LOGIC;
	In_Ind			: IN		STD_LOGIC;
	In_ErrIn			: IN		STD_LOGIC;
	In_Ack			: OUT	STD_LOGIC;
	In_ErrOut			: OUT	STD_LOGIC;
	-----------------------------------------
	DOUT				: OUT	STD_LOGIC_VECTOR(DataWidth-1 DOWNTO 0);
	DOUTV			: OUT	STD_LOGIC;
	Out_SOP			: OUT	STD_LOGIC;
	Out_EOP			: OUT	STD_LOGIC;
	Out_Ind			: OUT	STD_LOGIC;
	Out_ErrOut		: OUT	STD_LOGIC;
	Out_Ack			: IN		STD_LOGIC;
	Out_ErrIn			: IN		STD_LOGIC
);
END  UDP_RX_PreVerifier;

ARCHITECTURE ArchUDP_RX_PreVerifierBehav OF UDP_RX_PreVerifier IS

CONSTANT	Input_delay		:		INTEGER	:=	2;
CONSTANT	TH_delay			:		INTEGER	:=	4;
CONSTANT	OUT_delay			:		INTEGER	:=	TH_delay-2;
CONSTANT	RX_PseudoHCNTRWidth	:		INTEGER	:=	INTEGER(CEIL(LOG2(REAL(UDPPseudoLength/16+1))));

SIGNAL	DOUTV_sig			:		STD_LOGIC;
SIGNAL	Out_SOP_sig		:		STD_LOGIC;
SIGNAL	DINV_reg			:		STD_LOGIC;
SIGNAL	DINV_d			:		STD_LOGIC;
SIGNAL	In_Ind_reg		:		STD_LOGIC;
SIGNAL	In_Ind_d			:		STD_LOGIC;
SIGNAL	IN_ErrIn_reg		:		STD_LOGIC;
SIGNAL	IN_ErrIn_sig		:		STD_LOGIC;
SIGNAL	IN_ErrIn_OVR		:		STD_LOGIC;
SIGNAL	IN_ErrIn_d		:		STD_LOGIC;
SIGNAL	In_SOP_reg		:		STD_LOGIC;
SIGNAL	In_SOP_rise_sig	:		STD_LOGIC;
SIGNAL	In_SOP_rise		:		STD_LOGIC;
SIGNAL	In_EOP_reg		:		STD_LOGIC;
SIGNAL	In_EOP_rise		:		STD_LOGIC;
SIGNAL	In_EOP_rise_sig	:		STD_LOGIC;
SIGNAL	DIN_reg			:		STD_LOGIC_VECTOR( DataWidth-1 DOWNTO 0);
SIGNAL	DIN_d			:		STD_LOGIC_VECTOR( DataWidth-1 DOWNTO 0);
SIGNAL	DIN_d_DW			:		STD_LOGIC_VECTOR( 2*DataWidth-1 DOWNTO 0);
SIGNAL	DIN_d_DW_Hi		:		STD_LOGIC_VECTOR( DataWidth-1 DOWNTO 0);
SIGNAL	DIN_d_DW_Lo		:		STD_LOGIC_VECTOR( DataWidth-1 DOWNTO 0);

SIGNAL	IN_Ack_sig		:		STD_LOGIC;
SIGNAL	IN_Ack_OVRN		:		STD_LOGIC;
SIGNAL	Out_Ind_OVRN		:		STD_LOGIC;
SIGNAL	Out_Ind_sig		:		STD_LOGIC;


SIGNAL	IP_Proto_In_reg	:		STD_LOGIC_VECTOR( IP_ProtSize-1 DOWNTO 0);
SIGNAL	IP_DstIPAddr_In_reg	:		STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
SIGNAL	IP_SrcIPAddr_In_reg	:		STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
SIGNAL	IP_Length_In_reg	:		STD_LOGIC_VECTOR( IPLengthSize-1 DOWNTO 0);
SIGNAL	Proto_In_check		:		STD_LOGIC_VECTOR( IP_ProtSize-1 DOWNTO 0);
SIGNAL	ProtoInValid		:		STD_LOGIC;
SIGNAL	ProtoInValid_d		:		STD_LOGIC;

SIGNAL	RX_SOF_OVRN		:		STD_LOGIC;
SIGNAL	Out_ErrIn_OVR		:		STD_LOGIC;
SIGNAL	RX_SOF			:		STD_LOGIC;
SIGNAL	RX_SOF_pre		:		STD_LOGIC;
SIGNAL	Deser_V			:		STD_LOGIC;

SIGNAL	RXAUXQ_IN_Ack		:		STD_LOGIC;
SIGNAL	RXAUXQ_Out_Ind		:		STD_LOGIC;
SIGNAL	RXAUXQ_Out_ErrIn_sig:		STD_LOGIC;
SIGNAL	RXAUXQ_Out_ErrIn	:		STD_LOGIC;
SIGNAL	RXAUXQ_In_ErrOut	:		STD_LOGIC;

SIGNAL	UDP_RX_PCI_sig		:		STD_LOGIC_VECTOR( UDPPCILength-1 DOWNTO 0);
SIGNAL	UDP_RX_SrcPort		:		STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
SIGNAL	UDP_RX_DstPort		:		STD_LOGIC_VECTOR( UDPPortSize-1 DOWNTO 0);
SIGNAL	UDP_RX_Length		:		STD_LOGIC_VECTOR( UDPLengthSize-1 DOWNTO 0);
SIGNAL	UDP_RX_LengthCNTR	:		STD_LOGIC_VECTOR( UDPLengthSize-1 DOWNTO 0);
SIGNAL	UDP_RX_CHKSUM		:		STD_LOGIC_VECTOR( UDPCHKSize-1 DOWNTO 0);
SIGNAL	UDP_RX_CHKSUM_calc	:		STD_LOGIC_VECTOR( 32-1 DOWNTO 0);
SIGNAL	UDP_RX_CHKSUM_temp	:		STD_LOGIC_VECTOR( 32-1 DOWNTO 0);
SIGNAL	RX_PseudoHeader	:		STD_LOGIC_VECTOR( UDPPseudoLength-1 DOWNTO 0);
SIGNAL	RX_PseudoHeader_reg	:		STD_LOGIC_VECTOR( UDPPseudoLength-1 DOWNTO 0);


TYPE RXFSM_StateType IS
(
	INIT,
	IDLE,
	WFOR_Start,
	Reg_Lo,
	Reg_Hi_and_Sum,
	Reg_Lo_Dummy,
	LastSum,
	WFOR_DeSer,
	SumPseudoHeader,
	AddCarry_1,
	AddCarry_2,
	CHK_Calculated,
	ValidPDU,
	RemoveOutIndOVR,
	Drop_From_Q
);

ATTRIBUTE	ENUM_ENCODING	:	STRING;
SIGNAL	RXFSM_State	:	RXFSM_StateType;

SIGNAL	RX_PseudoHCNTR			:	STD_LOGIC_VECTOR(RX_PseudoHCNTRWidth-1 DOWNTO 0);
SIGNAL	RX_PseudoHLen_vec		:	STD_LOGIC_VECTOR(RX_PseudoHCNTRWidth-1 DOWNTO 0)	:=	STD_LOGIC_VECTOR(to_unsigned(UDPPseudoLength/16-1,RX_PseudoHCNTRWidth));
SIGNAL	IP_Length_In_reg_FSM	:	STD_LOGIC_VECTOR( IPLengthSize-1 DOWNTO 0);


-- Regiszterezett inputok, pszeudo fejlecet ossze kell allitani pipelinosítva, azt a végén hozzáadni, ha FFFF az összeg vagy eredetlieg 0000 akkor OK
-- egyébként kisöpörni a Qból
BEGIN


	DINV_reg_inst	: aFlop										PORT MAP( D => DINV,C => CLK,CE => CE,Q => DINV_reg);
	DINV_d_inst	: aDelay		GENERIC MAP(Length => Input_delay)		PORT MAP( I => DINV_reg,C => CLK,CE => CE,Q => DINV_d);
	
	ININD_reg_inst	: aFlop										PORT MAP( D => In_Ind,C => CLK,CE => CE,Q => In_Ind_reg);
	ININD_d_inst	: aDelay		GENERIC MAP(Length => Input_delay)		PORT MAP( I => In_Ind_reg,C => CLK,CE => CE,Q => In_Ind_d);

	InER_reg_inst	: aFlop										PORT MAP( D => IN_ErrIn,C => CLK,CE => CE,Q => IN_ErrIn_reg);
	IN_ErrIn_sig	<=	IN_ErrIn_reg or IN_ErrIn_OVR;
	InER_d_inst	: aDelay		GENERIC MAP(Length => Input_delay)		PORT MAP( I => IN_ErrIn_sig,C => CLK,CE => CE,Q => IN_ErrIn_d);

	INSOP_reg_inst	: aFlop										PORT MAP( D => In_SOP,C => CLK,CE => CE,Q => In_SOP_reg);
	InSOP_rise	: aRise										PORT MAP( I => In_SOP_reg, C => CLK, Q => In_SOP_rise_sig);
	InSOPr_d_inst	: aDelay		GENERIC MAP(Length => Input_delay-1)	PORT MAP( I => In_SOP_rise_sig,C => CLK,CE => CE,Q => In_SOP_rise);

	INEOP_reg_inst	: aFlop										PORT MAP( D => In_EOP,C => CLK,CE => CE,Q => In_EOP_reg);
	InEOP_rise	: aRise										PORT MAP( I => In_EOP_reg, C => CLK, Q => In_EOP_rise_sig);
	InEOPr_d_inst	: aDelay		GENERIC MAP(Length => Input_delay-1)	PORT MAP( I => In_EOP_rise_sig,C => CLK,CE => CE,Q => In_EOP_rise);

	DIn_reg_inst	: aRegister	GENERIC MAP( Size => DataWidth)		PORT MAP( D => DIN,C => CLK,CE => CE,Q => DIN_reg);
	DINID		: aPipe		GENERIC MAP( Size => DataWidth, Length => Input_delay)
															PORT MAP( I => DIN_reg, C => CLK, CE => CE, Q => DIN_d);
	RX_SOF_pre	<=	DINV AND In_SOP;
	DstIP_reg_inst	: aRegister	GENERIC MAP( Size => IPAddrSize)		PORT MAP( D => IP_DstIPAddr_In,C => CLK,CE => RX_SOF_pre,Q => IP_DstIPAddr_In_reg);
	SrcIP_reg_inst	: aRegister	GENERIC MAP( Size => IPAddrSize)		PORT MAP( D => IP_SrcIPAddr_In,C => CLK,CE => RX_SOF_pre,Q => IP_SrcIPAddr_In_reg);
	ProtI_reg_inst	: aRegister	GENERIC MAP( Size => IP_ProtSize)		PORT MAP( D => IP_Proto_In,C => CLK,CE => RX_SOF_pre,Q => IP_Proto_In_reg);
	LenI_reg_inst	: aRegister	GENERIC MAP( Size => IPLengthSize)		PORT MAP( D => IP_Length_In,C => CLK,CE => RX_SOF_pre,Q => IP_Length_In_reg);

	Proto_In_check	<=	IP_Proto_In_reg XOR IPProt_UDP;
	with Proto_In_check SELECT	ProtoInValid	<=	Hi WHEN X"00" , Lo WHEN OTHERS;
	PrIV_d_inst	: aDelay		GENERIC MAP(Length => Input_delay)		PORT MAP( I => ProtoInValid,C => CLK,CE => CE,Q => ProtoInValid_d);


	DIN_d_DW		<=	DIN_d_DW_Hi & DIN_d_DW_Lo;

	RX_SOF		<=	In_SOP_rise AND DINV_d AND ProtoInValid_d AND RX_SOF_OVRN;
	
	UDP_RX_SrcPort	<=	UDP_RX_PCI_sig(63 DOWNTO 48);
	UDP_RX_DstPort	<=	UDP_RX_PCI_sig(47 DOWNTO 32);
	UDP_RX_Length	<=	UDP_RX_PCI_sig(31 DOWNTO 16);
	UDP_RX_CHKSUM	<=	UDP_RX_PCI_sig(15 DOWNTO 00);
	
	UDPPCIDeSerializer : DeSerializer
	GENERIC MAP(
		DataWidth	=>	DataWidth,
		ToDeSer	=>	UDPPCILength/DataWidth
	)	
	PORT MAP(
		CLK		=>	CLK,
		RST		=>	RST,
		CE		=>	CE,
		SIn		=>	DIN_d,
		Ser_DV	=>	DINV_d,
		Ser_SOP	=>	RX_SOF,
		Ser_EOP	=>	In_EOP_rise,
		Ser_ErrIn	=>	IN_ErrIn_d,
		POut		=>	UDP_RX_PCI_sig,
		POuTV	=>	Deser_V
	);
	IN_Ack_sig			<=	RXAUXQ_IN_Ack AND IN_Ack_OVRN ;
	INA_reg_inst			: aFlop	PORT MAP( D => IN_Ack_sig,C => CLK,CE => CE,Q => In_Ack);
	Out_Ind_sig			<=	RXAUXQ_Out_Ind AND Out_Ind_OVRN ;
	OInd_reg_inst			: aFlop	PORT MAP( D => Out_Ind_sig,C => CLK,CE => CE,Q => Out_Ind);
	RXAUXQ_Out_ErrIn_sig	<=	Out_ErrIn or Out_ErrIn_OVR ;
	RXQOEIn_reg_inst		: aFlop	PORT MAP( D => RXAUXQ_Out_ErrIn_sig,C => CLK,CE => CE,Q => RXAUXQ_Out_ErrIn);
	
	DOUTV		<=	DOUTV_sig;
	Out_SOP		<=	Out_SOP_sig;
	
	In_ErrOut		<=	RXAUXQ_In_ErrOut;
	RX_AUXQ : PDUQueue
	GENERIC MAP(
		DataWidth		=>	DataWidth,
		SYNC_IN		=>	SYNC_IN,
		SYNC_OUT		=>	true,
		SYNC_CTRL		=>	false,
		MINPDUSize	=>	DefPCISize,
		MAXPDUSize	=>	DefPCISize,
		MaxPDUToQ		=>	DefPDUToQ
	)
	PORT MAP(
		CLK			=>	CLK,
		CE_In		=>	CE,
		CE_Out		=>	CE,
		RST			=>	RST,
		DIN			=>	DIN_d,
		DINV			=>	DINV_d,
		In_SOP		=>	RX_SOF,
		In_EOP		=>	In_EOP_rise,
		In_Ind		=>	In_Ind,
		In_ErrIn		=>	IN_ErrIn_d,
		In_Ack		=>	RXAUXQ_IN_Ack,
		In_ErrOut		=>	RXAUXQ_In_ErrOut,
		DOUT			=>	DOUT,
		DOUTV		=>	DOUTV_sig,
		Out_SOP		=>	Out_SOP_sig,
		Out_EOP		=>	Out_EOP,
		Out_Ind		=>	RXAUXQ_Out_Ind,
		Out_ErrOut	=>	Out_ErrOut,
		Out_Ack		=>	Out_Ack,
		Out_ErrIn		=>	RXAUXQ_Out_ErrIn,
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


	RXFSM_proc:PROCESS(clk,rst,CE,RXFSM_State,In_Ind_d,RX_SOF,IN_ErrIn_d,In_EOP_rise,RXAUXQ_In_ErrOut,RX_PseudoHCNTR,UDP_RX_CHKSUM_calc,UDP_RX_CHKSUM,UDP_RX_LengthCNTR,UDP_RX_Length,IP_Length_In_reg,RXAUXQ_Out_Ind,DOUTV_sig,Out_SOP_sig)
	BEGIN
		IF(RISING_EDGE(clk))THEN
			IF(rst = Hi) THEN
				IN_Ack_OVRN		<=	Hi;
				RX_SOF_OVRN		<=	Hi;
				Out_ErrIn_OVR		<=	Lo;
				Out_Ind_OVRN		<=	Lo;
				IN_ErrIn_OVR		<=	Lo;
				UDP_RX_CHKSUM_calc	<=	(OTHERS => Lo);
				UDP_RX_CHKSUM_temp	<=	(OTHERS => Lo);
				UDP_RX_LengthCNTR	<=	(OTHERS => Lo);
				RX_PseudoHeader_reg	<=	(OTHERS => Lo);
				IP_Length_In_reg_FSM<=	(OTHERS => Lo);
				DstIPAddr_out		<=	(OTHERS => Lo);
				SrcIPAddr_Out		<=	(OTHERS => Lo);
				RXFSM_State		<=	INIT;
			ELSIF(rst = Lo AND CE = Hi) THEN
				CASE RXFSM_State IS
					WHEN IDLE =>
						IN_Ack_OVRN		<=	Hi;
						RX_SOF_OVRN		<=	Hi;
						Out_Ind_OVRN		<=	Lo;
						Out_ErrIn_OVR		<=	Lo;
						UDP_RX_CHKSUM_calc	<=	(OTHERS => Lo);
						UDP_RX_CHKSUM_temp	<=	(OTHERS => Lo);
						UDP_RX_LengthCNTR	<=	(OTHERS => Lo);
						IF(SYNC_IN)THEN
							IF(In_Ind_d = Hi)THEN
								RXFSM_State		<=	WFOR_Start;
							ELSE
								RXFSM_State		<=	IDLE;
							END IF;
						ELSE
							IF(RX_SOF = Hi AND IN_ErrIn_d = Lo AND In_EOP_rise = Lo AND RXAUXQ_In_ErrOut = Lo)THEN
								DIN_d_DW_Hi		<=	DIN_d;
								RX_SOF_OVRN		<=	Lo;
								IN_Ack_OVRN		<=	Lo;
								UDP_RX_LengthCNTR	<=	UDP_RX_LengthCNTR + 1;
								RX_PseudoHeader_reg	<=	IP_SrcIPAddr_In_reg & IP_DstIPAddr_In_reg & X"00" & IP_Proto_In_reg & IP_Length_In_reg;
								IP_Length_In_reg_FSM<=	IP_Length_In_reg;
								DstIPAddr_out		<=	IP_DstIPAddr_In;
								SrcIPAddr_Out		<=	IP_SrcIPAddr_In;
								RXFSM_State		<=	Reg_Lo;
							ELSIF(RX_SOF = Hi AND IN_ErrIn_d = Lo AND In_EOP_rise = Hi AND RXAUXQ_In_ErrOut = Lo)THEN
								DIN_d_DW_Hi		<=	DIN_d;
								RX_SOF_OVRN		<=	Lo;
								IN_Ack_OVRN		<=	Lo;
								UDP_RX_LengthCNTR	<=	UDP_RX_LengthCNTR + 1;
								RX_PseudoHeader_reg	<=	IP_SrcIPAddr_In_reg & IP_DstIPAddr_In_reg & X"00" & IP_Proto_In_reg & IP_Length_In_reg;
								IP_Length_In_reg_FSM<=	IP_Length_In_reg;
								DstIPAddr_out		<=	IP_DstIPAddr_In;
								SrcIPAddr_Out		<=	IP_SrcIPAddr_In;
								RXFSM_State		<=	Reg_Lo_Dummy;
							ELSE
								RXFSM_State	<=	IDLE;
							END IF;
						END IF;
					WHEN WFOR_Start =>
						IF(In_Ind_d = Hi)THEN
							IF(RX_SOF = Hi AND IN_ErrIn_d = Lo AND In_EOP_rise = Lo AND RXAUXQ_In_ErrOut = Lo)THEN
								DIN_d_DW_Hi		<=	DIN_d;
								RX_SOF_OVRN		<=	Lo;
								IN_Ack_OVRN		<=	Lo;
								UDP_RX_LengthCNTR	<=	UDP_RX_LengthCNTR + 1;
								RX_PseudoHeader_reg	<=	IP_SrcIPAddr_In_reg & IP_DstIPAddr_In_reg & X"00" & IP_Proto_In_reg & IP_Length_In_reg;
								DstIPAddr_out		<=	IP_DstIPAddr_In;
								SrcIPAddr_Out		<=	IP_SrcIPAddr_In;
								IP_Length_In_reg_FSM<=	IP_Length_In_reg;
								RXFSM_State		<=	Reg_Lo;
							ELSIF(RX_SOF = Hi AND IN_ErrIn_d = Lo AND In_EOP_rise = Hi AND RXAUXQ_In_ErrOut = Lo)THEN
								DIN_d_DW_Hi		<=	DIN_d;
								RX_SOF_OVRN		<=	Lo;
								IN_Ack_OVRN		<=	Lo;
								UDP_RX_LengthCNTR	<=	UDP_RX_LengthCNTR + 1;
								RX_PseudoHeader_reg	<=	IP_SrcIPAddr_In_reg & IP_DstIPAddr_In_reg & X"00" & IP_Proto_In_reg & IP_Length_In_reg;
								DstIPAddr_out		<=	IP_DstIPAddr_In;
								SrcIPAddr_Out		<=	IP_SrcIPAddr_In;
								IP_Length_In_reg_FSM<=	IP_Length_In_reg;
								RXFSM_State		<=	Reg_Lo_Dummy;
							ELSE
								RXFSM_State	<=	WFOR_Start;
							END IF;
						ELSE
							RXFSM_State		<=	IDLE;
						END IF;
					WHEN Reg_Lo =>
						IF(IN_ErrIn_d = Lo AND RXAUXQ_In_ErrOut = Lo)THEN
							IF(DINV_d = Hi)THEN
								DIN_d_DW_Lo		<=	DIN_d;
								UDP_RX_LengthCNTR	<=	UDP_RX_LengthCNTR + 1;
								IF(In_EOP_rise = Hi)THEN
									RXFSM_State	<=	LastSum;
								ELSE
									RXFSM_State	<=	Reg_Hi_and_Sum;
								END IF;
							ELSE
								RXFSM_State	<=	Reg_Lo;
							END IF;
						ELSE
							RXFSM_State	<=	Drop_From_Q;
						END IF;
					WHEN Reg_Hi_and_Sum =>
						IF(IN_ErrIn_d = Lo AND RXAUXQ_In_ErrOut = Lo)THEN
							IF(DINV_d = Hi)THEN
								DIN_d_DW_Hi		<=	DIN_d;
								UDP_RX_CHKSUM_calc	<=	UDP_RX_CHKSUM_calc + (X"0000" & DIN_d_DW);
								UDP_RX_LengthCNTR	<=	UDP_RX_LengthCNTR + 1;
								IF(In_EOP_rise = Hi)THEN
									RXFSM_State	<=	Reg_Lo_Dummy;
								ELSE
									RXFSM_State	<=	Reg_Lo;
								END IF;
							ELSE
								RXFSM_State	<=	Reg_Hi_and_Sum;
							END IF;
						ELSE
							RXFSM_State	<=	Drop_From_Q;
						END IF;
					WHEN Reg_Lo_Dummy =>
						DIN_d_DW_Lo	<=	(OTHERS => Lo);
						RXFSM_State	<=	LastSum;
					WHEN LastSum =>
						UDP_RX_CHKSUM_calc	<=	UDP_RX_CHKSUM_calc + (X"0000" & DIN_d_DW);
						RX_PseudoHCNTR		<=	(OTHERS => Lo);
						IF(Deser_V = Hi)THEN
							RXFSM_State		<=	SumPseudoHeader;
						ELSE
							RXFSM_State		<=	WFOR_DeSer;
						END IF;
					WHEN WFOR_DeSer =>
						IF(Deser_V = Hi)THEN
							RXFSM_State		<=	SumPseudoHeader;
						ELSE
							RXFSM_State		<=	WFOR_DeSer;
						END IF;
					WHEN SumPseudoHeader =>
						UDP_RX_CHKSUM_calc		<=	UDP_RX_CHKSUM_calc + (X"0000" & RX_PseudoHeader_reg(RX_PseudoHeader_reg'Length-1 DOWNTO RX_PseudoHeader_reg'Length-16));
						RX_PseudoHeader_reg(RX_PseudoHeader_reg'Length-1 DOWNTO 16)
											<=	RX_PseudoHeader_reg(RX_PseudoHeader_reg'Length-16-1 DOWNTO 0);
						RX_PseudoHCNTR			<=	RX_PseudoHCNTR + 1;
						IF(RX_PseudoHCNTR = RX_PseudoHLen_vec)THEN
							RXFSM_State		<=	AddCarry_1;
						ELSE
							RXFSM_State		<=	SumPseudoHeader;
						END IF;
					WHEN AddCarry_1 =>
						UDP_RX_CHKSUM_temp	<=	(X"0000" & UDP_RX_CHKSUM_calc(31 DOWNTO 16)) + (X"0000" & UDP_RX_CHKSUM_calc(15 DOWNTO 0));
						RXFSM_State		<=	AddCarry_2;
					WHEN AddCarry_2 =>
						IF(UDP_RX_CHKSUM_temp(16) = Hi) THEN
							UDP_RX_CHKSUM_calc	<=	UDP_RX_CHKSUM_temp + 1;
						ELSE
							UDP_RX_CHKSUM_calc	<=	UDP_RX_CHKSUM_temp;
						END IF;
						RXFSM_State		<=	CHK_Calculated;
					WHEN CHK_Calculated =>
						IF((UDP_RX_CHKSUM_calc(15 DOWNTO 0) = X"FFFF" OR UDP_RX_CHKSUM = X"0000") AND UDP_RX_LengthCNTR = UDP_RX_Length AND UDP_RX_LengthCNTR = IP_Length_In_reg_FSM)THEN
							RXFSM_State	<=	ValidPDU;
						ELSE
							RXFSM_State	<=	Drop_From_Q;
						END IF;
					WHEN ValidPDU =>
						IF(RXAUXQ_Out_Ind = Hi)THEN
							RXFSM_State	<=	RemoveOutIndOVR;
						ELSE
							RXFSM_State	<=	ValidPDU;
						END IF;
					WHEN RemoveOutIndOVR =>
						Out_Ind_OVRN	<=	Hi;
						IF(RXAUXQ_Out_Ind = Hi)THEN
							IF(DOUTV_sig = Hi AND Out_SOP_sig = Hi)THEN
								RXFSM_State	<=	IDLE;
							ELSE
								RXFSM_State	<=	RemoveOutIndOVR;
							END IF;
						ELSE
							RXFSM_State	<=	IDLE;
						END IF;
					WHEN Drop_From_Q =>
						Out_ErrIn_OVR	<=	Hi;
						IF(RXAUXQ_Out_Ind = Hi)THEN
							RXFSM_State	<=	Drop_From_Q;
						ELSE
							RXFSM_State	<=	IDLE;
						END IF;
					-- WHEN OTHERS => --INIT
					WHEN INIT =>
						RXFSM_State	<=	IDLE;
				END CASE;
			END IF;
		END IF;
	END PROCESS RXFSM_proc;

END ArchUDP_RX_PreVerifierBehav;