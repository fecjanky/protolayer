--
-- IPLayerPkg.vhd
-- ============
--
-- (C) Ferenc Janky, BME TMIT
--   file name:	IPLayerPkg.vhd
--   PACKAGE:		IPLayerPkg
--
-- A summary OF the contents OF the internet header follows:
--  0                   1                   2                   3
--  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
-- +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-- |Version| IHL   |TYPE OF Service|		Total Length		  |
-- +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-- | Identification 			|Flags| Fragment Offset		  |
-- +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-- | Time to Live  | Protocol 	| 	Header Checksum		  |
-- +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-- |					Source Address						  |
-- +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-- |					Destination Address					  |
-- +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-- |				 Options 					 |	 Padding	  |
-- +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
--  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
--  0                   1                   2                   3
--
------------------------------------
-- Version: 4 bits
------------------------------------
-- -- The Version field indicates the format OF the internet header. This
-- -- document describes version 4.
------------------------------------
-- IHL: 4 bits
------------------------------------
-- -- Internet Header Length IS the length OF the internet header IN 32
-- -- bit words, and thus points to the beginning OF the data. Note that
-- -- the minimum value for a correct header IS 5.
------------------------------------
-- TYPE OF Service: 8 bits
------------------------------------
-- -- -- The TYPE OF Service provides an indication OF the abstract
-- -- -- parameters OF the quality OF service desired.
------------------------------------
-- Total Length: 16 bits
------------------------------------
-- -- Total Length IS the length OF the datagram, measured IN octets,
-- -- including internet header and data. This field allows the length OF
-- -- a datagram to be up to 65,535 octets. Such long datagrams are
-- -- impractical for most hosts and networks. ALL hosts must be prepared
-- -- to accept datagrams OF up to 576 octets (whether they arrive whole
-- -- or IN fragments). It IS recommended that hosts only send datagrams
-- -- larger than 576 octets IF they have assurance that the destination
-- -- IS prepared to accept the larger datagrams.
------------------------------------
-- Identification: 16 bits
------------------------------------
-- -- An identifying value assigned by the sender to aid IN assembling the
-- -- fragments OF a datagram.
-- Flags: 3 bits
-- -- Various Control Flags.
-- -- Bit 0: reserved, must be zero
-- -- Bit 1: (DF) 0 = May Fragment, 1 = Don’t Fragment.
-- -- Bit 2: (MF) 0 = Last Fragment, 1 = More Fragments.
-- --  0    1   2
-- -- +---+---+---+
-- -- |   | D | M |
-- -- | 0 | F | F |
-- -- +---+---+---+
------------------------------------
-- Fragment Offset: 13 bits
------------------------------------
-- -- This field indicates where IN the datagram this fragment belongs.
-- -- The fragment offset IS measured IN units OF 8 octets (64 bits). The
-- -- first fragment has offset zero.
------------------------------------
-- Time to Live: 8 bits
------------------------------------
-- -- This field indicates the maximum time the datagram IS allowed to
-- -- remain IN the internet system. IF this field contains the value
-- -- zero, THEN the datagram must be destroyed.
------------------------------------
-- Protocol: 8 bits
------------------------------------
-- -- This field indicates the next level protocol used IN the data
-- -- portion OF the internet datagram. The values for various protocols
-- -- are specified IN "Assigned Numbers"
------------------------------------
-- Header Checksum: 16 bits
------------------------------------
-- -- The checksum algorithm IS:
-- -- The checksum field IS the 16 bit one’s complement OF the one’s
-- -- complement sum OF ALL 16 bit words IN the header. For purposes OF
-- -- computing the checksum, the value OF the checksum field IS zero.
-- -- This IS a simple to compute checksum and experimental evidence
-- -- indicates it IS adequate, but it IS provisional and may be replaced
-- -- by a CRC procedure, depending on further experience.
------------------------------------
-- Source Address: 32 bits
------------------------------------
-- The source address.
------------------------------------
-- Destination Address: 32 bits
------------------------------------
-- The destination address.
------------------------------------
-- Options: variable
------------------------------------
-- -- The options may appear or not IN datagrams. They must be
-- -- implemented by ALL IP modules (host and gateways). What IS optional
-- -- IS their transmission IN any particular datagram, not their
-- -- implementation.
-- -- IN some environments the security option may be required IN ALL
-- -- datagrams.
-- -- The option field IS variable IN length. There may be zero or more
-- -- options. There are two cases for the format OF an option:
-- -- CASE 1: A single octet OF option-TYPE.
-- -- CASE 2: An option-TYPE octet, an option-length octet, and the
-- -- actual option-data octets.
-- -- The option-length octet counts the option-TYPE octet and the
-- -- option-length octet as well as the option-data octets.
-- -- The option-TYPE octet IS viewed as having 3 fields:
-- -- 1 bit copied flag,
-- -- 2 bits option class,
-- -- 5 bits option number.
-- -- The copied flag indicates that this option IS copied into ALL
-- -- fragments on fragmentation.
-- -- 0 = not copied
-- -- 1 = copied
-- -- The option classes are:
-- -- 0 = control
-- -- 1 = reserved for future USE
-- -- 2 = debugging and measurement
-- -- 3 = reserved for future USE
-- -- The following internet options are defined:
-- -- 	CLASS NUMBER  LENGTH	DESCRIPTION
-- -- 	----- ------- ------	-----------
-- --	0		0	-		END OF Option list. This option occupies only
-- --						1 octet; it has no length octet.
-- --	0		1	- 		No Operation. This option occupies only 1
-- --						octet; it has no length octet.
-- --	0		2	11		Security. Used to carry Security,
-- --						Compartmentation, User Group (TCC), and
-- --						Handling Restriction Codes compatible with DOD
-- --						requirements.
-- --	0		3	var.		Loose Source Routing. Used to route the
-- --						internet datagram based on information
-- --						supplied by the source.
-- --	0		9	var.		Strict Source Routing. Used to route the
-- --						internet datagram based on information
-- --						supplied by the source.
-- --	0		7	var.		Record Route. Used to trace the route an
-- --						internet datagram takes.
-- --	0		8	4		Stream ID. Used to carry the stream
-- --						identifier.
-- --	2		4	var.		Internet Timestamp.
-- --
-- -- Specific Option Definitions
-- -- END OF Option List
-- -- +--------+
-- -- |00000000|
-- -- +--------+
-- -- TYPE=0
-- -- This option indicates the END OF the option list. This might
-- -- not coincide with the END OF the internet header according to
-- -- the internet header length. This IS used at the END OF ALL
-- -- options, not the END OF each option, and need only be used IF
-- -- the END OF the options would not otherwise coincide with the END
-- -- OF the internet header.
-- -- May be copied, introduced, or deleted on fragmentation, or for
-- -- any other reason.
------------------------------------
-- Padding: variable
------------------------------------
-- -- The internet header padding IS used to ensure that the internet
-- -- header ends on a 32 bit boundary. The padding IS zero.

-- TO Implement:
-- SEND(src,dst,prot,SDU, => result);
-- RECV(src,dst,prot,SDU, => result)

-- Operation IN CASE OF SEND
-- 1. Determine local network destination ( IPCAM lookup)
-- 2. Get the DST hardware address from ARP module (ARP_Request)
-- 3. Initialize IP header and DSTHWaddr and SRCHWaddr (TX_AUXQ info)
-- 4. Start Send

-- Operation IN CASE OF Recv -- Done
-- 1. Look up packet destination address and Verify checksum
-- 2. IF match, THEN forward to upper layer, discard ELSE


LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

USE work.ProtoLayerTypesAndDefs.ALL;

PACKAGE IPLayerPkg IS
	COMPONENT IPLayer IS
	generic(
		DataWidth			:		INTEGER	:=	DefDataWidth;
		RX_SYNC_IN		:		BOOLEAN	:=	false;
		RX_SYNC_OUT		:		BOOLEAN	:=	false;
		-- TX_SYNC_IN		:		BOOLEAN	:=	false; Just IN Sync mode
		TX_SYNC_OUT		:		BOOLEAN	:=	false;
		NumOfIPAddresses	:		INTEGER	:=	DefNumOfIPAddr;
		PacketToQueue		:		INTEGER	:=	DefPDUToQ;
		TTL				:		INTEGER	:=	DefTTL;
		MTU				:		INTEGER	:=	IPDefMTU
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
		CFG_ADDR_WR		: IN		STD_LOGIC;
		CFG_ADDR			: IN		STD_LOGIC_VECTOR( INTEGER(CEIL(LOG2(REAL(NumOfCFGRegs))))-1 downto 0);
		ADDR				: IN		STD_LOGIC_VECTOR( INTEGER(CEIL(LOG2(REAL(2*NumOfIPAddresses))))-1 downto 0);
		DATA_IN			: IN		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
		DATA_OUT			: OUT	STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
		DOUTV			: OUT	STD_LOGIC;
		------------------------------------------------------------
		--				ARP IF
		------------------------------------------------------------
		ARP_Request		: OUT	STD_LOGIC;
		ARP_DSTIPAddr		: OUT	STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
		ARP_ResponseV		: IN		STD_LOGIC;
		ARP_ResponseErr	: IN		STD_LOGIC;
		ARP_DstMacAddr		: IN		STD_LOGIC_VECTOR( MacAddrSize-1 downto 0);
		------------------------------------------------------------
		--				IP IF
		------------------------------------------------------------	
		DstIPAddr_In		: IN		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
		SrcIPAddr_In		: IN		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
		Prot_In			: IN		STD_LOGIC_VECTOR( IP_ProtSize-1 downto 0);
		Length_In			: IN		STD_LOGIC_VECTOR( 15 downto 0);
		-------------------------------------------------------------
		DstIPAddr_Out		: OUT	STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
		SrcIPAddr_Out		: OUT	STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
		Prot_Out			: OUT	STD_LOGIC_VECTOR( IP_ProtSize-1 downto 0);
		Length_Out		: OUT	STD_LOGIC_VECTOR( 15 downto 0);
		------------------------------------------------------------
		--				EthernetLayer IF
		------------------------------------------------------------
		DstMacAddr_In		: IN		STD_LOGIC_VECTOR( MacAddrSize-1 downto 0);
		SrcMacAddr_In		: IN		STD_LOGIC_VECTOR( MacAddrSize-1 downto 0);
		EthType_In		: IN		STD_LOGIC_VECTOR( EtherTypeSize-1 downto 0);
		DstMacAddr_Out		: OUT	STD_LOGIC_VECTOR( MacAddrSize-1 downto 0);
		SrcMacAddr_Out		: OUT	STD_LOGIC_VECTOR( MacAddrSize-1 downto 0);
		EthType_Out		: OUT	STD_LOGIC_VECTOR( EtherTypeSize-1 downto 0);
		-------------------------------------------------------------
		SDU_DIN			: IN		STD_LOGIC_VECTOR( DataWidth-1 downto 0);
		SDU_DINV			: IN		STD_LOGIC;
		SDU_IN_SOP		: IN		STD_LOGIC;
		SDU_IN_EOP		: IN		STD_LOGIC;
		SDU_IN_Ind		: IN		STD_LOGIC;
		SDU_IN_ErrIn		: IN		STD_LOGIC;
		SDU_IN_USER_In		: IN		STD_LOGIC_VECTOR( USER_width-1 downto 0);
		SDU_IN_Ack		: OUT	STD_LOGIC;
		SDU_IN_ErrOut		: OUT	STD_LOGIC;
		-------------------------------------------------------------
		PDU_DOUT			: OUT	STD_LOGIC_VECTOR( DataWidth-1 downto 0);
		PDU_DOUTV			: OUT	STD_LOGIC;
		PDU_Out_SOP		: OUT	STD_LOGIC;
		PDU_Out_EOP		: OUT	STD_LOGIC;
		PDU_Out_Ind		: OUT	STD_LOGIC;
		PDU_Out_ErrOut		: OUT	STD_LOGIC;
		PDU_Out_USER_Out	: OUT	STD_LOGIC_VECTOR( USER_width-1 downto 0);
		PDU_Out_Ack		: IN		STD_LOGIC;
		PDU_Out_ErrIn		: IN		STD_LOGIC;
		-------------------------------------------------------------
		PDU_DIN			: IN		STD_LOGIC_VECTOR( DataWidth-1 downto 0);
		PDU_DINV			: IN		STD_LOGIC;
		PDU_IN_SOP		: IN		STD_LOGIC;
		PDU_IN_EOP		: IN		STD_LOGIC;
		PDU_IN_Ind		: IN		STD_LOGIC;
		PDU_IN_USER_In		: IN		STD_LOGIC_VECTOR( USER_width-1 downto 0);
		PDU_IN_ErrIn		: IN		STD_LOGIC;
		PDU_IN_ErrOut		: OUT	STD_LOGIC;
		PDU_IN_Ack		: OUT	STD_LOGIC;
		-------------------------------------------------------------
		SDU_DOUT			: OUT	STD_LOGIC_VECTOR( DataWidth-1 downto 0);
		SDU_DOUTV			: OUT	STD_LOGIC;
		SDU_Out_SOP		: OUT	STD_LOGIC;
		SDU_OUT_EOP		: OUT	STD_LOGIC;
		SDU_OUT_Ind		: OUT	STD_LOGIC;
		SDU_OUT_USER_Out	: OUT	STD_LOGIC_VECTOR( USER_width-1 downto 0);
		SDU_OUT_ErrOut		: OUT	STD_LOGIC;
		SDU_OUT_ErrIn		: IN		STD_LOGIC;
		SDU_OUT_Ack		: IN		STD_LOGIC;
		--------------------------------------------------------------
		Status			: OUT	STD_LOGIC_VECTOR(7 downto 0)
	);
	END COMPONENT IPLayer;
	
	COMPONENT IPCAM IS --IN ReadFirst Mode
	generic(
		Elements			:		INTEGER	:=	DefNumOfIPAddr
	);
	PORT(
		CLK				: IN		STD_LOGIC;
		RST				: IN		STD_LOGIC;
		CE				: IN		STD_LOGIC;
		CFG_CE			: IN		STD_LOGIC;
		-----------------------------------------
		WR_EN			: IN		STD_LOGIC;
		RD_EN			: IN		STD_LOGIC;
		ValidAddrIn		: IN		STD_LOGIC;
		IPAddrIN			: IN		STD_LOGIC_VECTOR(IPAddrSize-1 downto 0);
		NetMaskIN			: IN		STD_LOGIC_VECTOR(IPAddrSize-1 downto 0);
		ADDR_In			: IN		STD_LOGIC_VECTOR(INTEGER(CEIL(LOG2(REAL(Elements))))-1 downto 0);
		CAM_IPaddrIN		: IN		STD_LOGIC_VECTOR(IPAddrSize-1 downto 0);
		CAM_SRCH			: IN		STD_LOGIC;
		Match			: OUT	STD_LOGIC;
		MatchV			: OUT	STD_LOGIC;
		ValidAddrOut		: OUT	STD_LOGIC;
		IPAddrOUT			: OUT	STD_LOGIC_VECTOR(IPAddrSize-1 downto 0);
		NetMaskOUT		: OUT	STD_LOGIC_VECTOR(IPAddrSize-1 downto 0);
		ADDR_Out			: OUT	STD_LOGIC_VECTOR(INTEGER(CEIL(LOG2(REAL(Elements))))-1 downto 0);
		DOUTV			: OUT	STD_LOGIC
	);
	END COMPONENT IPCAM;
	
	COMPONENT IP_RX_Cheksum_Calc IS
	generic(
		DataWidth			:		INTEGER	:=	DefDataWidth
	);
	PORT(
		CLK				: IN		STD_LOGIC;
		RST				: IN		STD_LOGIC;
		CE				: IN		STD_LOGIC;
		-----------------------------------------
		EType_In			: IN		STD_LOGIC_VECTOR( EtherTypeSize-1 downto 0);
		-----------------------------------------
		DIN				: IN		STD_LOGIC_VECTOR( DataWidth-1 downto 0);
		DINV				: IN		STD_LOGIC;
		In_SOP			: IN		STD_LOGIC;
		In_EOP			: IN		STD_LOGIC;
		IN_ErrIn			: IN		STD_LOGIC;
		-----------------------------------------
		DOUT				: OUT	STD_LOGIC_VECTOR( DataWidth-1 downto 0);
		DOUTV			: OUT	STD_LOGIC;
		Out_SOP			: OUT	STD_LOGIC;
		Out_EOP			: OUT	STD_LOGIC;
		Out_ErrOut		: OUT	STD_LOGIC;
		-----------------------------------------
		ChecksumError		: OUT	STD_LOGIC; --info transferred IN Protolayer PDU_IN_USER_In SIGNAL
		IPHeader			: OUT	STD_LOGIC; --info transferred IN Protolayer PDU_IN_USER_In SIGNAL
		OutV				: OUT	STD_LOGIC
	);
	END COMPONENT IP_RX_Cheksum_Calc;
	
END IPLayerPkg;


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
USE work.arch.aRam;
USE work.arch.aFlop;
USE work.arch.aRise;
USE work.arch.aDelay;
USE work.ProtoModulePkg.MiniCAM;
USE work.IPLayerPkg.IPCAM;
USE work.IPLayerPkg.IP_RX_Cheksum_Calc;
USE work.ProtoModulePkg.Serializer;
USE work.ProtoModulePkg.DeSerializer;

ENTITY IPLayer IS
generic(
	DataWidth			:		INTEGER	:=	DefDataWidth;
	RX_SYNC_IN		:		BOOLEAN	:=	false;
	RX_SYNC_OUT		:		BOOLEAN	:=	false;
	-- TX_SYNC_IN		:		BOOLEAN	:=	false;
	TX_SYNC_OUT		:		BOOLEAN	:=	false;
	NumOfIPAddresses	:		INTEGER	:=	DefNumOfIPAddr;
	PacketToQueue		:		INTEGER	:=	DefPDUToQ;
	TTL				:		INTEGER	:=	DefTTL;
	MTU				:		INTEGER	:=	IPDefMTU
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
	CFG_ADDR_WR		: IN		STD_LOGIC;
	CFG_ADDR			: IN		STD_LOGIC_VECTOR( INTEGER(CEIL(LOG2(REAL(NumOfCFGRegs))))-1 downto 0);
	ADDR				: IN		STD_LOGIC_VECTOR( INTEGER(CEIL(LOG2(REAL(2*NumOfIPAddresses))))-1 downto 0);
	DATA_IN			: IN		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
	DATA_OUT			: OUT	STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
	DOUTV			: OUT	STD_LOGIC;
	------------------------------------------------------------
	--				ARP IF
	------------------------------------------------------------
	ARP_Request		: OUT	STD_LOGIC;
	ARP_DSTIPAddr		: OUT	STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
	ARP_ResponseV		: IN		STD_LOGIC;
	ARP_ResponseErr	: IN		STD_LOGIC;
	ARP_DstMacAddr		: IN		STD_LOGIC_VECTOR( MacAddrSize-1 downto 0);
	------------------------------------------------------------
	--				IP IF
	------------------------------------------------------------	
	DstIPAddr_In		: IN		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
	SrcIPAddr_In		: IN		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
	Prot_In			: IN		STD_LOGIC_VECTOR( IP_ProtSize-1 downto 0);
	Length_In			: IN		STD_LOGIC_VECTOR( 15 downto 0);
	-------------------------------------------------------------
	DstIPAddr_Out		: OUT	STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
	SrcIPAddr_Out		: OUT	STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
	Prot_Out			: OUT	STD_LOGIC_VECTOR( IP_ProtSize-1 downto 0);
	Length_Out		: OUT	STD_LOGIC_VECTOR( 15 downto 0);
	------------------------------------------------------------
	--				EthernetLayer IF
	------------------------------------------------------------
	DstMacAddr_In		: IN		STD_LOGIC_VECTOR( MacAddrSize-1 downto 0);
	SrcMacAddr_In		: IN		STD_LOGIC_VECTOR( MacAddrSize-1 downto 0);
	EthType_In		: IN		STD_LOGIC_VECTOR( EtherTypeSize-1 downto 0);
	DstMacAddr_Out		: OUT	STD_LOGIC_VECTOR( MacAddrSize-1 downto 0);
	SrcMacAddr_Out		: OUT	STD_LOGIC_VECTOR( MacAddrSize-1 downto 0);
	EthType_Out		: OUT	STD_LOGIC_VECTOR( EtherTypeSize-1 downto 0);
	-------------------------------------------------------------
	SDU_DIN			: IN		STD_LOGIC_VECTOR( DataWidth-1 downto 0);
	SDU_DINV			: IN		STD_LOGIC;
	SDU_IN_SOP		: IN		STD_LOGIC;
	SDU_IN_EOP		: IN		STD_LOGIC;
	SDU_IN_Ind		: IN		STD_LOGIC;
	SDU_IN_ErrIn		: IN		STD_LOGIC;
	SDU_IN_USER_In		: IN		STD_LOGIC_VECTOR( USER_width-1 downto 0);
	SDU_IN_Ack		: OUT	STD_LOGIC;
	SDU_IN_ErrOut		: OUT	STD_LOGIC;
	-------------------------------------------------------------
	PDU_DOUT			: OUT	STD_LOGIC_VECTOR( DataWidth-1 downto 0);
	PDU_DOUTV			: OUT	STD_LOGIC;
	PDU_Out_SOP		: OUT	STD_LOGIC;
	PDU_Out_EOP		: OUT	STD_LOGIC;
	PDU_Out_Ind		: OUT	STD_LOGIC;
	PDU_Out_ErrOut		: OUT	STD_LOGIC;
	PDU_Out_USER_Out	: OUT	STD_LOGIC_VECTOR( USER_width-1 downto 0);
	PDU_Out_Ack		: IN		STD_LOGIC;
	PDU_Out_ErrIn		: IN		STD_LOGIC;
	-------------------------------------------------------------
	PDU_DIN			: IN		STD_LOGIC_VECTOR( DataWidth-1 downto 0);
	PDU_DINV			: IN		STD_LOGIC;
	PDU_IN_SOP		: IN		STD_LOGIC;
	PDU_IN_EOP		: IN		STD_LOGIC;
	PDU_IN_Ind		: IN		STD_LOGIC;
	PDU_IN_USER_In		: IN		STD_LOGIC_VECTOR( USER_width-1 downto 0);
	PDU_IN_ErrIn		: IN		STD_LOGIC;
	PDU_IN_ErrOut		: OUT	STD_LOGIC;
	PDU_IN_Ack		: OUT	STD_LOGIC;
	-------------------------------------------------------------
	SDU_DOUT			: OUT	STD_LOGIC_VECTOR( DataWidth-1 downto 0);
	SDU_DOUTV			: OUT	STD_LOGIC;
	SDU_Out_SOP		: OUT	STD_LOGIC;
	SDU_OUT_EOP		: OUT	STD_LOGIC;
	SDU_OUT_Ind		: OUT	STD_LOGIC;
	SDU_OUT_USER_Out	: OUT	STD_LOGIC_VECTOR( USER_width-1 downto 0);
	SDU_OUT_ErrOut		: OUT	STD_LOGIC;
	SDU_OUT_ErrIn		: IN		STD_LOGIC;
	SDU_OUT_Ack		: IN		STD_LOGIC;
	--------------------------------------------------------------
	Status			: OUT	STD_LOGIC_VECTOR(7 downto 0)
);
END IPLayer;

ARCHITECTURE ArchIPLayerBehav OF IPLayer IS
--------------------------------
-- Constants
--------------------------------
CONSTANT	CFGAddrWidth		:		INTEGER	:=	INTEGER(CEIL(LOG2(REAL(NumOfCFGRegs))));
CONSTANT	AddrWidth			:		INTEGER	:=	INTEGER(CEIL(LOG2(REAL(2*NumOfIPAddresses))));
CONSTANT	IPCAMAddrWidth		:		INTEGER	:=	INTEGER(CEIL(LOG2(REAL(NumOfIPAddresses))));
CONSTANT	IPPCILengthDW		:		INTEGER	:=	IPPCILength/DataWidth;
--------------------------------
--CFG IF signals
--------------------------------
SIGNAL	CFG_ADDR_reg		:		STD_LOGIC_VECTOR(CFGAddrWidth-1 downto 0);
SIGNAL	CFG_ADDR_WR_reg	:		STD_LOGIC;
SIGNAL	CFG_ADDR_WR_rise	:		STD_LOGIC;
SIGNAL	WR_EN_reg			:		STD_LOGIC;
SIGNAL	WR_EN_rise		:		STD_LOGIC;
SIGNAL	RD_EN_reg			:		STD_LOGIC;
SIGNAL	RD_EN_rise		:		STD_LOGIC;
SIGNAL	WRRD_EN_rise		:		STD_LOGIC;
SIGNAL	ADDR_reg			:		STD_LOGIC_VECTOR(AddrWidth-1 downto 0);
SIGNAL	DATA_IN_reg		:		STD_LOGIC_VECTOR(IPAddrSize-1 downto 0);

TYPE		CFG_sig_Array IS array (0 to NumOfCFGRegs-1) OF STD_LOGIC;
TYPE		CFG_vec_Array IS array (0 to NumOfCFGRegs-1) OF STD_LOGIC_VECTOR(IPAddrSize-1 downto 0);
SIGNAL	WR_EN_Array		:		CFG_sig_Array;
SIGNAL	RD_EN_Array		:		CFG_sig_Array;
SIGNAL	DATA_Out_Array		:		CFG_vec_Array;
--------------------------------
--ProtoLayer signals
--------------------------------
SIGNAL	pci_din			:		STD_LOGIC_VECTOR( DataWidth-1 downto 0);
SIGNAL	pci_dinv			:		STD_LOGIC;
SIGNAL	pci_in_sop		:		STD_LOGIC;
SIGNAL	pci_in_eop		:		STD_LOGIC;
SIGNAL	pci_in_ind		:		STD_LOGIC;
SIGNAL	pci_in_errin		:		STD_LOGIC;
SIGNAL	pci_in_user_in		:		STD_LOGIC_VECTOR( USER_width-1 downto 0);
SIGNAL	pdu_in_user_in_sig	:		STD_LOGIC_VECTOR( USER_width-1 downto 0);
SIGNAL	pci_in_ack		:		STD_LOGIC;
SIGNAL	pci_in_errout		:		STD_LOGIC;
SIGNAL	PL_SDU_In_ACK		:		STD_LOGIC;
SIGNAL	ctrl_dout			:		STD_LOGIC_VECTOR( DataWidth-1 downto 0);
SIGNAL	ctrl_dv			:		STD_LOGIC;
SIGNAL	ctrl_sop			:		STD_LOGIC;
SIGNAL	ctrl_eop			:		STD_LOGIC;
SIGNAL	ctrl_errout		:		STD_LOGIC;
SIGNAL	ctrl_ind			:		STD_LOGIC;
SIGNAL	ctlr_user_out		:		STD_LOGIC_VECTOR( USER_width-1 downto 0);
SIGNAL	ctrl_ack			:		STD_LOGIC;
SIGNAL	ctrl_fwd			:		STD_LOGIC;
SIGNAL	ctrl_pause		:		STD_LOGIC;
SIGNAL	ctrl_drop_err		:		STD_LOGIC;
SIGNAL	TX_AUX_Out		:		STD_LOGIC_VECTOR(2*MacAddrSize-1 downto 0);
SIGNAL	TX_AUX_OutV		:		STD_LOGIC;
SIGNAL	TX_AUX_in			:		STD_LOGIC_VECTOR(2*MacAddrSize-1 downto 0);
SIGNAL	SDU_Out_SOP_sig	:		STD_LOGIC;
SIGNAL	SDU_OUT_ErrOut_sig	:		STD_LOGIC;
SIGNAL	SDU_DOUTV_sig		:		STD_LOGIC;
SIGNAL	SDU_OUT_EOP_sig	:		STD_LOGIC;
SIGNAL	SDU_IN_ErrOut_sig	:		STD_LOGIC;

--------------------------------
--Configurable values
--------------------------------
CONSTANT	IPAddr_CFGAddr		:		INTEGER	:=	0;
CONSTANT	NetMask_CFGAddr	:		INTEGER	:=	1;
CONSTANT	CAMWR_CFGAddr		:		INTEGER	:=	2;
CONSTANT	CAMRD_CFGAddr		:		INTEGER	:=	3;
CONSTANT	IPCAM_IPARD_CFGAddr	:		INTEGER	:=	4;
CONSTANT	IPCAM_NMRD_CFGAddr	:		INTEGER	:=	5;
CONSTANT	CAM_IPARD_CFGAddr	:		INTEGER	:=	6;
CONSTANT	DefaultGW_CFGAddr	:		INTEGER	:=	7;
CONSTANT	DefaultTTL_CFGAddr	:		INTEGER	:=	8;
CONSTANT	ValidAddr_CFGAddr	:		INTEGER	:=	9;
CONSTANT	MTU_CFGAddr		:		INTEGER	:=	10;
CONSTANT	RXCAMWR_CFGAddr	:		INTEGER	:=	11;
CONSTANT	MACADRRHi_CFGAddr	:		INTEGER	:=	12;
CONSTANT	MACADRRLo_CFGAddr	:		INTEGER	:=	13;
CONSTANT	MACADRR_CFGAddr	:		INTEGER	:=	14;

CONSTANT	MRD_delay			:		INTEGER	:=	2;

SIGNAL	IPAddr_reg		:		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0); 
SIGNAL	NetMask_reg		:		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0); 
SIGNAL	DefaultGW			:		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
SIGNAL	DefaultTTL		:		STD_LOGIC_VECTOR( 07 downto 0)	:=	STD_LOGIC_VECTOR(to_unsigned(TTL,8));
SIGNAL	MTU_reg			:		STD_LOGIC_VECTOR( 12 downto 0)	:=	STD_LOGIC_VECTOR(to_unsigned(MTU,13));
SIGNAL	ValidAddr_reg		:		STD_LOGIC;
SIGNAL	ValidAddrOut_reg	:		STD_LOGIC;
SIGNAL	IPCAM_IPARD_reg	:		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
SIGNAL	IPCAM_NMRD_reg		:		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
SIGNAL	CAM_IPARD_reg		:		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
SIGNAL	MACADRRHi_reg		:		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
SIGNAL	MACADRRLo_reg		:		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
SIGNAL	MACADRR_read_reg	:		STD_LOGIC_VECTOR( MacAddrSize-1 downto 0);
--------------------------------
--IPCAM signals
--------------------------------
SIGNAL	IPCAM_WR_En		:		STD_LOGIC;
SIGNAL	IPCAM_RD_En		:		STD_LOGIC;
SIGNAL	IPCAM_IPaddrIN		:		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
SIGNAL	IPCAM_SRCH		:		STD_LOGIC;
SIGNAL	IPCAM_Match		:		STD_LOGIC;
SIGNAL	IPCAM_MatchV		:		STD_LOGIC;
SIGNAL	IPCAM_ValidAddrOut	:		STD_LOGIC;
SIGNAL	IPCAM_IPAddrOUT	:		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
SIGNAL	IPCAM_NetMaskOUT	:		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
SIGNAL	IPCAM_ADDR_Out		:		STD_LOGIC_VECTOR( IPCAMAddrWidth-1 downto 0);
SIGNAL	IPCAM_DOUTV		:		STD_LOGIC;
--------------------------------
--MiniCAM signals
--------------------------------
SIGNAL	MiniCAM_WR_En		:		STD_LOGIC;
SIGNAL	MiniCAM_RD_En		:		STD_LOGIC;
SIGNAL	MiniCAM_IPaddrIN	:		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
SIGNAL	MiniCAM_SRCH		:		STD_LOGIC;
SIGNAL	MiniCAM_Match		:		STD_LOGIC;
SIGNAL	MiniCAM_MatchV		:		STD_LOGIC;
SIGNAL	MiniCAM_IPAddrOUT	:		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
SIGNAL	MiniCAM_ADDR_Out	:		STD_LOGIC_VECTOR( AddrWidth-1 downto 0);
SIGNAL	MiniCAM_DOUTV		:		STD_LOGIC;
--------------------------------
--RXCalc signals
--------------------------------
SIGNAL	RXCALC_DOUT				:		STD_LOGIC_VECTOR( DataWidth-1 downto 0);
SIGNAL	RXCALC_DOUTV				:		STD_LOGIC;
SIGNAL	RXCALC_Out_SOP				:		STD_LOGIC;
SIGNAL	RXCALC_Out_EOP				:		STD_LOGIC;
SIGNAL	RXCALC_Out_ErrOut			:		STD_LOGIC;
SIGNAL	RXCALC_ChecksumError		:		STD_LOGIC;
SIGNAL	RXCALC_IPHeader			:		STD_LOGIC;
SIGNAL	RXCALC_OutV				:		STD_LOGIC;
--------------------------------
--IPLayer signals
--------------------------------
SIGNAL	TX_packet_register		:		STD_LOGIC_VECTOR( IPPCILength-1 downto 0);
SIGNAL	CHK_TX_packet_register	:		STD_LOGIC_VECTOR( IPPCILength-1 downto 0);
SIGNAL	RX_packet_register		:		STD_LOGIC_VECTOR( IPPCILength-1 downto 0);
SIGNAL	RX_packet_register_sig	:		STD_LOGIC_VECTOR( IPPCILength-1 downto 0);
SIGNAL	RX_reg_en				:		STD_LOGIC;
SIGNAL	RX_reg_en_sig			:		STD_LOGIC;
SIGNAL	RX_reg_err			:		STD_LOGIC;
SIGNAL	Ser_Start				:		STD_LOGIC;
SIGNAL	PCI_IN_SOP_sig			:		STD_LOGIC;
SIGNAL	PCI_IN_EOP_sig			:		STD_LOGIC;
SIGNAL	PCI_DINV_sig			:		STD_LOGIC;
-- SIGNAL	PDU_DINV_sig			:		STD_LOGIC;
-- SIGNAL	PDU_In_SOP_sig			:		STD_LOGIC;
-- SIGNAL	PDU_In_EOP_sig			:		STD_LOGIC;
SIGNAL	CTRL_ChecksumError		:		STD_LOGIC;
SIGNAL	CTRL_IPHeader			:		STD_LOGIC;
SIGNAL	CTRL_OutV				:		STD_LOGIC;
SIGNAL	SDU_DOUTV_OVRN			:		STD_LOGIC;
SIGNAL	SDU_Out_EOP_OVR		:		STD_LOGIC;

SIGNAL	IP_RX_PlenCNTR			:		STD_LOGIC_VECTOR( 16-1 downto 0);
SIGNAL	IP_RX_Plen			:		STD_LOGIC_VECTOR( 16-1 downto 0);

SIGNAL	IP_RX_SrcAddress		:		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
SIGNAL	IP_RX_DstAddress		:		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
SIGNAL	IP_RX_Version			:		STD_LOGIC_VECTOR( 3 downto 0);
SIGNAL	IP_RX_TotalLen			:		STD_LOGIC_VECTOR( 16-1 downto 0);
SIGNAL	IP_RX_IHL_octet		:		STD_LOGIC_VECTOR( 16-1 downto 0);
SIGNAL	IP_RX_Flags			:		STD_LOGIC_VECTOR( 2 downto 0);
SIGNAL	IP_RX_FragOffset		:		STD_LOGIC_VECTOR( 12 downto 0);
SIGNAL	IP_RX_TTL				:		STD_LOGIC_VECTOR( 7 downto 0);
SIGNAL	IP_RX_Protocol			:		STD_LOGIC_VECTOR( 7 downto 0);

SIGNAL	IP_TX_SrcAddress		:		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
SIGNAL	IP_TX_DstAddress		:		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
SIGNAL	IP_TX_Version			:		STD_LOGIC_VECTOR( 3 downto 0);
SIGNAL	IP_TX_IHL				:		STD_LOGIC_VECTOR( 3 downto 0);
SIGNAL	IP_TX_Flags			:		STD_LOGIC_VECTOR( 2 downto 0);
SIGNAL	IP_TX_FragOffset		:		STD_LOGIC_VECTOR( 12 downto 0);
SIGNAL	IP_TX_TTL				:		STD_LOGIC_VECTOR( 7 downto 0);
SIGNAL	IP_TX_Protocol			:		STD_LOGIC_VECTOR( 7 downto 0);
SIGNAL	IP_TX_TOS				:		STD_LOGIC_VECTOR( 7 downto 0);
SIGNAL	IP_TX_TotalLen			:		STD_LOGIC_VECTOR( 15 downto 0);
SIGNAL	IP_TX_Identification	:		STD_LOGIC_VECTOR( 15 downto 0);
SIGNAL	IP_TX_HCheckSum		:		STD_LOGIC_VECTOR( 15 downto 0);

SIGNAL	DstIPAddr_In_reg		:		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
SIGNAL	SrcIPAddr_In_reg		:		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
SIGNAL	Prot_In_reg			:		STD_LOGIC_VECTOR( IP_ProtSize-1 downto 0);
SIGNAL	Length_In_reg			:		STD_LOGIC_VECTOR( 16-1 downto 0);
SIGNAL	StartOfSDUIn			:		STD_LOGIC;

SIGNAL	DstMacAddr_AUX_In		:		STD_LOGIC_VECTOR( MacAddrSize-1 downto 0);
SIGNAL	SrcMacAddr_AUX_In		:		STD_LOGIC_VECTOR( MacAddrSize-1 downto 0);

SIGNAL	MACA_Ram_ADDR_int		:		STD_LOGIC_VECTOR( 3 downto 0);
SIGNAL	IPCAM_ADDR_Out_int		:		STD_LOGIC_VECTOR( 3 downto 0);
SIGNAL	MACADDR_RDADDR			:		STD_LOGIC_VECTOR( 3 downto 0);
SIGNAL	MACADDR_DATA_IN		:		STD_LOGIC_VECTOR( MacAddrSize-1 downto 0);
SIGNAL	MACADDR_DATA_OUT		:		STD_LOGIC_VECTOR( MacAddrSize-1 downto 0);
SIGNAL	ARP_DstMacAddr_reg		:		STD_LOGIC_VECTOR( MacAddrSize-1 downto 0);
SIGNAL	MACADDR_RD_EN			:		STD_LOGIC;
SIGNAL	MACADDR_RD_EN_sig		:		STD_LOGIC;
SIGNAL	MACADDR_RD_EN_OVRN		:		STD_LOGIC;
SIGNAL	MACADDR_WR_EN			:		STD_LOGIC;

SIGNAL	TX_Status				:		STD_LOGIC_VECTOR(3 downto 0);
SIGNAL	RX_Status				:		STD_LOGIC_VECTOR(3 downto 0);

CONSTANT	RX_Stat_INIT			:		STD_LOGIC_VECTOR(3 downto 0)	:= X"0";
CONSTANT	RX_Stat_IDLE			:		STD_LOGIC_VECTOR(3 downto 0)	:= X"1";
CONSTANT	RX_Stat_SendAck		:		STD_LOGIC_VECTOR(3 downto 0)	:= X"2";
CONSTANT	RX_Stat_WFOR_IPHeader	:		STD_LOGIC_VECTOR(3 downto 0)	:= X"3";
CONSTANT	RX_Stat_WFOR_Deser		:		STD_LOGIC_VECTOR(3 downto 0)	:= X"4";
CONSTANT	RX_Stat_Validate		:		STD_LOGIC_VECTOR(3 downto 0)	:= X"5";
CONSTANT	RX_Stat_Check_DSTIP		:		STD_LOGIC_VECTOR(3 downto 0)	:= X"6";
CONSTANT	RX_Stat_Forward_Packet	:		STD_LOGIC_VECTOR(3 downto 0)	:= X"7";
CONSTANT	RX_Stat_DROP_Packet		:		STD_LOGIC_VECTOR(3 downto 0)	:= X"8";
CONSTANT	RX_Stat_ERR_HANDLE		:		STD_LOGIC_VECTOR(3 downto 0)	:= X"9";

TYPE RXFSM_StateType IS
(
	INIT,
	IDLE,
	SendAck,
	WFOR_IPHeader,
	WFOR_Deser,
	Validate,
	Check_DSTIP,
	Forward_Packet,
	DROP_Packet,
	wfor_out,
	watch_for_end,
	sig_eop,
	wfor_sduend,
	ERR_HANDLE
);

CONSTANT	TX_Stat_INIT				:		STD_LOGIC_VECTOR(3 downto 0)	:= X"0";
CONSTANT	TX_Stat_IDLE				:		STD_LOGIC_VECTOR(3 downto 0)	:= X"1";
CONSTANT	TX_Stat_SDUIn_SENDACK		:		STD_LOGIC_VECTOR(3 downto 0)	:= X"2";
CONSTANT	TX_Stat_IP_LOOKUP_N_CHKCALC	:		STD_LOGIC_VECTOR(3 downto 0)	:= X"3";
CONSTANT	TX_Stat_ARP_LOOKUP_DST		:		STD_LOGIC_VECTOR(3 downto 0)	:= X"4";
CONSTANT	TX_Stat_ARP_LOOKUP_DefGW		:		STD_LOGIC_VECTOR(3 downto 0)	:= X"5";
CONSTANT	TX_Stat_ARP_LOOKUP			:		STD_LOGIC_VECTOR(3 downto 0)	:= X"6";
CONSTANT	TX_Stat_EmitPCI_Ind			:		STD_LOGIC_VECTOR(3 downto 0)	:= X"7";
CONSTANT	TX_Stat_EmitPCI			:		STD_LOGIC_VECTOR(3 downto 0)	:= X"8";
CONSTANT	TX_Stat_Inject_DUMMY_PCI_ind	:		STD_LOGIC_VECTOR(3 downto 0)	:= X"9";
CONSTANT	TX_Stat_Inject_DUMMY_PCI		:		STD_LOGIC_VECTOR(3 downto 0)	:= X"a";
CONSTANT	TX_Stat_Sig_Error			:		STD_LOGIC_VECTOR(3 downto 0)	:= X"b";

TYPE TXFSM_StateType IS
(
	INIT,
	IDLE,
	SDUIn_SENDACK,
	IP_LOOKUP_N_CHKCALC,
	ARP_LOOKUP_DST,
	ARP_LOOKUP_DefGW,
	ARP_LOOKUP,
	EmitPCI_Ind,
	EmitPCI,
	Inject_DUMMY_PCI_ind,
	Inject_DUMMY_PCI,
	Sig_Error
);

TYPE CHKCalcFSM_StateType IS
(
	INIT,
	IDLE,
	CalcIPGR,
	Finished,
	AddCarry_1,
	AddCarry_2,
	WFOR_END
);

SIGNAL	RXFSM_State			:		RXFSM_StateType;
SIGNAL	TXFSM_State			:		TXFSM_StateType;
SIGNAL	CHKCalcFSM_State		:		CHKCalcFSM_StateType;

ATTRIBUTE ENUM_ENCODING			:		STRING;

CONSTANT	CHK_Pos_CNTRWidth		:		INTEGER	:=	INTEGER(CEIL(LOG2(REAL(IPPCILength/DataWidth))));
SIGNAL	CHK_Pos_CNTR			:		STD_LOGIC_VECTOR(CHK_Pos_CNTRWidth-1 downto 0);
SIGNAL	CHK_Pos_CNTR_vec		:		STD_LOGIC_VECTOR(CHK_Pos_CNTRWidth-1 downto 0) := STD_LOGIC_VECTOR(to_unsigned(IPPCILength/16 - 1,CHK_Pos_CNTRWidth));
SIGNAL	TX_CHK_reg			:		STD_LOGIC_VECTOR( 32-1 downto 0);
SIGNAL	TX_CHK_reg_temp		:		STD_LOGIC_VECTOR( 32-1 downto 0);
SIGNAL	Calck_CHK				:		STD_LOGIC;
SIGNAL	CHK_Ready				:		STD_LOGIC;

SIGNAL	TXFSM_ack				:		STD_LOGIC;
SIGNAL	SDU_IN_Ack_sig			:		STD_LOGIC;


--------------------------------
--Deserializer signals
--------------------------------
SIGNAL	DeSer_EOP				:		STD_LOGIC;

BEGIN

-------------------------
---Assigning static parts
-------------------------
EthType_Out	<=	EType_IP;
Status		<=	RX_Status & TX_Status;
-------------------------
--END OF Assigning static parts
-------------------------

WRRD_EN_rise	<=	WR_EN_rise or RD_EN_rise;

CFGAW_reg		:	aFlop								PORT MAP(D=>CFG_ADDR_WR,C=>CLK,CE=>CFG_CE,Q=>CFG_ADDR_WR_reg);
CFGAW_rise	:	aRise								PORT MAP(I => CFG_ADDR_WR_reg, C => CLK, Q => CFG_ADDR_WR_rise);
CFGA_reg		:	aRegister	GENERIC MAP(Size => CFGAddrWidth)	PORT MAP(D=>CFG_ADDR,C=>CLK,CE=>CFG_ADDR_WR_rise,Q=>CFG_ADDR_reg);
WREN_reg		:	aFlop								PORT MAP(D=>WR_EN,C=>CLK,CE=>CFG_CE,Q=>WR_EN_reg);
WREN_rise		:	aRise								PORT MAP(I => WR_EN_reg, C => CLK, Q => WR_EN_rise);
RDEN_reg		:	aFlop								PORT MAP(D=>RD_EN,C=>CLK,CE=>CFG_CE,Q=>RD_EN_reg);
RDEN_rise		:	aRise								PORT MAP(I => RD_EN_reg, C => CLK, Q => RD_EN_rise);
ADR_reg		:	aRegister	GENERIC MAP(Size => AddrWidth)	PORT MAP(D=>ADDR,C=>CLK,CE=>WRRD_EN_rise,Q=>ADDR_reg);
DIN_reg		:	aRegister	GENERIC MAP(Size => IPAddrSize)	PORT MAP(D=>DATA_IN,C=>CLK,CE=>WR_EN_rise,Q=>DATA_IN_reg);

IPA_reg		:	aRegister	GENERIC MAP(Size => IPAddrSize)	PORT MAP(D=>DATA_IN_reg,C=>CLK,CE=>WR_EN_Array(IPAddr_CFGAddr),Q=>IPAddr_reg);
DATA_Out_Array(IPAddr_CFGAddr)	<=	IPAddr_reg;

NM_reg		:	aRegister	GENERIC MAP(Size => IPAddrSize)	PORT MAP(D=>DATA_IN_reg,C=>CLK,CE=>WR_EN_Array(NetMask_CFGAddr),Q=>NetMask_reg);
DATA_Out_Array(NetMask_CFGAddr)	<=	NetMask_reg;

DFGW_reg		:	aRegister	GENERIC MAP(Size => IPAddrSize)	PORT MAP(D=>DATA_IN_reg,C=>CLK,CE=>WR_EN_Array(DefaultGW_CFGAddr),Q=>DefaultGW);
DATA_Out_Array(DefaultGW_CFGAddr)	<=	DefaultGW;

TTL_reg		:	aRegister	GENERIC MAP(Size => 8)			PORT MAP(D=>DATA_IN_reg(7 downto 0),C=>CLK,CE=>WR_EN_Array(DefaultTTL_CFGAddr),Q=>DefaultTTL);
DATA_Out_Array(DefaultTTL_CFGAddr)	<=	"000000000000000000000000" & DefaultTTL;

MTU_reg_inst	:	aRegister	GENERIC MAP(Size => 13)			PORT MAP(D=>DATA_IN_reg(12 downto 0),C=>CLK,CE=>WR_EN_Array(MTU_CFGAddr),Q=>MTU_reg);
DATA_Out_Array(MTU_CFGAddr)	<=	"0000000000000000000" & MTU_reg;


MACARD_reg	:	aRegister	GENERIC MAP(Size => MacAddrSize)	PORT MAP(D=>MACADDR_DATA_OUT,C=>CLK,CE=>MACADDR_RD_EN,Q=>MACADRR_read_reg);

MACAHi_reg	:	aRegister	GENERIC MAP(Size => IPAddrSize)	PORT MAP(D=>DATA_IN_reg,C=>CLK,CE=>WR_EN_Array(MACADRRHi_CFGAddr),Q=>MACADRRHi_reg);
DATA_Out_Array(MACADRRHi_CFGAddr)	<=	X"0000" & MACADRR_read_reg(47 downto 32);

MACALo_reg	:	aRegister	GENERIC MAP(Size => IPAddrSize)	PORT MAP(D=>DATA_IN_reg,C=>CLK,CE=>WR_EN_Array(MACADRRLo_CFGAddr),Q=>MACADRRLo_reg);
DATA_Out_Array(MACADRRLo_CFGAddr)	<=	MACADRR_read_reg(31 downto 0);

Vaddr_reg		:	aFlop								PORT MAP(D=>DATA_IN_reg(0),C=>CLK,CE=>WR_EN_Array(ValidAddr_CFGAddr),Q=>ValidAddr_reg);
VaddrO_reg	:	aFlop								PORT MAP(D=>IPCAM_ValidAddrOut,C=>CLK,CE=>IPCAM_DOUTV,Q=>ValidAddrOut_reg);
DATA_Out_Array(ValidAddr_CFGAddr)	<=	"0000000000000000000000000000000" & ValidAddrOut_reg;

IPCIPA_reg	:	aRegister	GENERIC MAP(Size => IPAddrSize)	PORT MAP(D=>IPCAM_IPAddrOUT,C=>CLK,CE=>IPCAM_DOUTV,Q=>IPCAM_IPARD_reg);
DATA_Out_Array(IPCAM_IPARD_CFGAddr)	<=	IPCAM_IPARD_reg;

IPCNM_reg		:	aRegister	GENERIC MAP(Size => IPAddrSize)	PORT MAP(D=>IPCAM_NetMaskOUT,C=>CLK,CE=>IPCAM_DOUTV,Q=>IPCAM_NMRD_reg);
DATA_Out_Array(IPCAM_NMRD_CFGAddr)	<=	IPCAM_NMRD_reg;

CAMIPA_reg	:	aRegister	GENERIC MAP(Size => IPAddrSize)	PORT MAP(D=>MiniCAM_IPAddrOUT,C=>CLK,CE=>MiniCAM_DOUTV,Q=>CAM_IPARD_reg);
DATA_Out_Array(CAM_IPARD_CFGAddr)	<=	CAM_IPARD_reg;



MUX_proc:PROCESS(clk)
BEGIN
	IF(RISING_EDGE(clk))THEN
		for i IN 0 to NumOfCFGRegs -1 loop
			IF(CFG_ADDR_reg = STD_LOGIC_VECTOR(to_unsigned(i,CFGAddrWidth)))THEN
				WR_EN_Array(i)	<=	WR_EN_rise;
				RD_En_Array(i)	<=	RD_EN_rise;
				DATA_OUT		<=	DATA_Out_Array(i);
			END IF;
		END loop;
	END IF;
END PROCESS MUX_proc;


IPCAM_WR_En	<=	WR_EN_Array(CAMWR_CFGAddr);
IPCAM_RD_En	<=	RD_EN_Array(CAMRD_CFGAddr);
IPCAM_IPaddrIN	<=	DstIPAddr_In_reg;
Inst_IPCAM: IPCAM 
GENERIC MAP(
	Elements		=>	NumOfIPAddresses
)
PORT MAP(
	CLK			=>	CLK,
	RST			=>	RST,
	CE			=>	CE,
	CFG_CE		=>	CFG_CE,
	WR_EN		=>	IPCAM_WR_En,
	RD_EN		=>	IPCAM_RD_En,
	ValidAddrIn	=>	ValidAddr_reg,
	IPAddrIN		=>	IPAddr_reg,
	NetMaskIN		=>	NetMask_reg,
	ADDR_In		=>	ADDR_reg(IPCAMAddrWidth-1 downto 0),
	CAM_IPaddrIN	=>	IPCAM_IPaddrIN, -- CAM IN
	CAM_SRCH		=>	IPCAM_SRCH, -- CAM IN
	Match		=>	IPCAM_Match, -- CAM OUT
	MatchV		=>	IPCAM_MatchV, -- CAM OUT
	ValidAddrOut	=>	IPCAM_ValidAddrOut,
	IPAddrOUT		=>	IPCAM_IPAddrOUT,
	NetMaskOUT	=>	IPCAM_NetMaskOUT,
	ADDR_Out		=>	IPCAM_ADDR_Out, --CAM OUT
	DOUTV		=>	IPCAM_DOUTV
);

MiniCAM_WR_En		<=	WR_EN_Array(CAMWR_CFGAddr) or WR_EN_Array(RXCAMWR_CFGAddr);
MiniCAM_RD_En		<=	RD_EN_Array(CAMRD_CFGAddr);
MiniCAM_IPaddrIN	<=	IP_RX_DstAddress;
Inst_MiniCAM: MiniCAM 
GENERIC MAP(
	DataWidth	=>	IPAddrSize,
	Elements	=>	2*NumOfIPAddresses,
	InitToFF	=>	false
)
PORT MAP(
	CLK		=>	CLK,
	RST		=>	RST,
	CE		=>	CE,
	CFG_CE	=>	CFG_CE,
	WR_EN	=>	MiniCAM_WR_En,
	RD_EN	=>	MiniCAM_RD_En,
	DIN		=>	IPAddr_reg,
	ADDR_In	=>	ADDR_reg,
	CAM_DIN	=>	MiniCAM_IPaddrIN, -- CAM IN
	CAM_SRCH	=>	MiniCAM_SRCH, -- CAM IN
	Match	=>	MiniCAM_Match, -- CAM OUT
	MatchV	=>	MiniCAM_MatchV, -- CAM OUT
	DOUT		=>	MiniCAM_IPAddrOUT,
	ADDR_Out	=>	MiniCAM_ADDR_Out, -- CAM OUT
	DOUTV	=>	MiniCAM_DOUTV
);

MACR_CDIFF: Connect_Diff GENERIC MAP	(DST_Width => MACA_Ram_ADDR_int'Length,SRC_WIDTH => ADDR_reg'Length) 
					PORT MAP		(DST => MACA_Ram_ADDR_int,SRC => ADDR_reg);
IPCA_CDIFF: Connect_Diff GENERIC MAP	(DST_Width => IPCAM_ADDR_Out_int'Length,SRC_WIDTH => IPCAM_ADDR_Out'Length) 
					PORT MAP		(DST => IPCAM_ADDR_Out_int,SRC => IPCAM_ADDR_Out);

MACADDR_RD_EN		<=	RD_EN_Array(MACADRR_CFGAddr);
MACADDR_RD_EN_sig	<=	MACADDR_RD_EN and MACADDR_RD_EN_OVRN;
with MACADDR_RD_EN_sig	SELECT MACADDR_RDADDR <= IPCAM_ADDR_Out_int	WHEN Lo, MACA_Ram_ADDR_int WHEN OTHERS;
MACADDR_DATA_IN	<=	MACADRRHi_reg(15 downto 0) & MACADRRLo_reg;
MACADDR_WR_EN		<=	WR_EN_Array(MACADRR_CFGAddr);

MACADDR_RAM: aRAM 
GENERIC MAP( Size => MacAddrSize ) 
PORT MAP(	D	=>	MACADDR_DATA_IN,
		WE	=>	MACADDR_WR_EN,
		WCLK	=>	CLK,
		A	=>	MACA_Ram_ADDR_int,
		RA	=>	MACADDR_RDADDR,
		DO	=>	MACADDR_DATA_OUT 
		);

Inst_Serializer: Serializer 
GENERIC MAP(
	DataWidth	=>	DataWidth,
	ToSer	=>	IPPCILengthDW
)
PORT MAP(
	CLK		=>	CLK,
	RST		=>	RST,
	CE		=>	CE,
	Start	=>	Ser_Start,
	Ser_Start	=>	PCI_IN_SOP_sig,
	Complete	=>	PCI_IN_EOP_sig,
	PIn		=>	TX_packet_register,
	SOut		=>	PCI_DIN,
	OuTV		=>	PCI_DINV_sig
);
PCI_IN_SOP	<=	PCI_IN_SOP_sig;
PCI_IN_EOP	<=	PCI_IN_EOP_sig;
PCI_DINV		<=	PCI_DINV_sig;


DeSer_EOP		<=	CTRL_OutV or CTRL_EOP;

Inst_DeSerializer: DeSerializer 
GENERIC MAP(
	DataWidth	=>	DataWidth,
	ToDeSer	=>	IPPCILengthDW
)
PORT MAP(
	CLK		=>	CLK,
	RST		=>	RST,
	CE		=>	CE,
	SIn		=>	ctrl_dout,
	Ser_DV	=>	ctrl_dv,
	Ser_SOP	=>	CTRL_SOP,
	Ser_EOP	=>	DeSer_EOP,
	Ser_ErrIn	=>	CTRL_ErrOut,
	POut		=>	RX_packet_register_sig,
	POuTV	=>	RX_reg_en_sig,
	POuT_err	=>	RX_reg_err
);
RX_reg_en	<=	RX_reg_en_sig;
RX_reg	:	aRegister	GENERIC MAP(Size =>	IPPCILength)	PORT MAP(D=>RX_packet_register_sig,C=>CLK,CE=>RX_reg_en,Q=>RX_packet_register);
-- CHK_TX_reg:	aRegister	GENERIC MAP(Size =>	IPPCILength)	PORT MAP(D=>TX_packet_register,C=>CLK,CE=>RX_reg_en,Q=>CHK_TX_packet_register);

IP_RX_Version		<=	RX_packet_register(159 downto 156);
IP_RX_IHL_octet	<=	"0000000000" & RX_packet_register(155 downto 152) & "00";
IP_RX_TotalLen		<=	RX_packet_register(143 downto 128);
IP_RX_Flags		<=	RX_packet_register(111 downto 109);
IP_RX_FragOffset	<=	RX_packet_register(108 downto 96);
IP_RX_TTL			<=	RX_packet_register(95 downto 88);
IP_RX_Protocol		<=	RX_packet_register(87 downto 80);
IP_RX_SrcAddress	<=	RX_packet_register(63 downto 32);
IP_RX_DstAddress	<=	RX_packet_register(31 downto 0);
-------------------------------------------------------------
TX_packet_register(159 downto 156)	<=	IP_TX_Version;
TX_packet_register(155 downto 152)	<=	IP_TX_IHL;
TX_packet_register(151 downto 144)	<=	IP_TX_TOS;
TX_packet_register(143 downto 128)	<=	IP_TX_TotalLen;
-------------------------------------------------------------
TX_packet_register(127 downto 112)	<=	IP_TX_Identification;
TX_packet_register(111 downto 109)	<=	IP_TX_Flags;
TX_packet_register(108 downto 96)	<=	IP_TX_FragOffset;
-------------------------------------------------------------
TX_packet_register(95 downto 88)	<=	IP_TX_TTL;
TX_packet_register(87 downto 80)	<=	IP_TX_Protocol;
TX_packet_register(79 downto 64)	<=	IP_TX_HCheckSum;
-------------------------------------------------------------
TX_packet_register(63 downto 32)	<=	IP_TX_SrcAddress;
-------------------------------------------------------------
TX_packet_register(31 downto 0)	<=	IP_TX_DstAddress;
-------------------------------------------------------------
IP_TX_Version			<=	X"4";
IP_TX_IHL				<=	X"5";
IP_TX_TOS				<=	X"00";
IP_TX_TotalLen			<=	Length_In_reg + 20;
-- IP_TX_Identification	<=	X"1988";
IP_TX_Flags			<=	"010";  -- 0 DF MF
IP_TX_FragOffset		<=	"0000000000000";
IP_TX_TTL				<=	DefaultTTL;
IP_TX_Protocol			<=	Prot_In_reg;
-- IP_TX_HCheckSum		<=	TX_CHK_reg; Set by TX FSM after cheksum calculation, 
IP_TX_SrcAddress		<=	SrcIPAddr_In_reg;
IP_TX_DstAddress		<=	DstIPAddr_In_reg;
-------------------------------------------------------------

Inst_IP_RX_Cheksum_Calc: IP_RX_Cheksum_Calc 
GENERIC MAP(
	DataWidth		=>	DataWidth
)
PORT MAP(
	CLK			=>	CLK,
	RST			=>	RST,
	CE			=>	CE,
	EType_In		=>	EthType_In,
	DIN			=>	PDU_DIN,
	DINV			=>	PDU_DINV,
	In_SOP		=>	PDU_In_SOP,
	In_EOP		=>	PDU_In_EOP,
	IN_ErrIn		=>	PDU_IN_ErrIn,
	DOUT			=>	RXCALC_DOUT,
	DOUTV		=>	RXCALC_DOUTV,
	Out_SOP		=>	RXCALC_Out_SOP,
	Out_EOP		=>	RXCALC_Out_EOP,
	Out_ErrOut	=>	RXCALC_Out_ErrOut,
	ChecksumError	=>	RXCALC_ChecksumError, --into ProtoLayer PDU_user IN inputs
	IPHeader		=>	RXCALC_IPHeader,
	OutV			=>	RXCALC_OutV
);

PDU_IN_USER_In_sig(USER_width-1 downto 3)
					<=	PDU_IN_USER_In(USER_width-1 downto 3);
pdu_in_user_in_sig(2)	<=	RXCALC_ChecksumError;
pdu_in_user_in_sig(1)	<=	RXCALC_IPHeader;
pdu_in_user_in_sig(0)	<=	RXCALC_OutV;

CTRL_ChecksumError		<=	CTLR_USER_Out(2);
CTRL_IPHeader			<=	CTLR_USER_Out(1);
CTRL_OutV				<=	CTLR_USER_Out(0);


PCI_IN_USER_In		<=	(OTHERS => Lo);

SDU_Out_SOP		<=	SDU_Out_SOP_sig;
SDU_OUT_ErrOut		<=	SDU_OUT_ErrOut_sig;
SDU_DOUTV			<=	SDU_DOUTV_sig AND SDU_DOUTV_OVRN;
SDU_OUT_EOP		<=	SDU_OUT_EOP_sig OR SDU_Out_EOP_OVR;
SDU_IN_ErrOut		<=	SDU_IN_ErrOut_sig;
IP_ProtoLayer: ProtoLayer
GENERIC MAP(
	DataWidth				=>	DataWidth,
	RX_SYNC_IN			=>	RX_SYNC_IN,
	RX_SYNC_OUT			=>	RX_SYNC_OUT,
	RX_CTRL_SYNC			=>	true,
	TX_CTRL_SYNC			=>	true, -- implicitly PCI_In IN SYNC mode !!!
	TX_SYNC_IN			=>	true, -- must be used IN SYNC IN Mode!!
	TX_SYNC_OUT			=>	TX_SYNC_OUT,
	TX_AUX_Q				=>	true,
	TX_AUX_widthDW			=>	2*MacAddrSize/DataWidth,
	RX_AUX_Q				=>	false,
	RX_AUX_widthDW			=>	1,
	MINSDUSize			=>	0,
	MAXSDUSize			=>	MTU,
	MaxSDUToQ				=>	PacketToQueue,
	MINPCISize			=>	IPPCILength/DataWidth,
	MAXPCISize			=>	IPPCILength/DataWidth,
	MaxPCIToQ				=>	PacketToQueue
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
	SDU_IN_Ack			=>	PL_SDU_In_ACK,
	SDU_IN_ErrOut			=>	SDU_IN_ErrOut_sig,
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
	PDU_DIN				=>	RXCALC_DOUT,
	PDU_DINV				=>	RXCALC_DOUTV,
	PDU_IN_SOP			=>	RXCALC_Out_SOP,
	PDU_IN_EOP			=>	RXCALC_Out_EOP,
	PDU_IN_Ind			=>	PDU_IN_Ind,
	PDU_IN_USER_In			=>	pdu_in_user_in_sig,
	PDU_IN_ErrIn			=>	RXCALC_Out_ErrOut,
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
	SDU_DOUTV				=>	SDU_DOUTV_sig,
	SDU_Out_SOP			=>	SDU_Out_SOP_sig,
	SDU_OUT_EOP			=>	SDU_OUT_EOP_sig,
	SDU_OUT_Ind			=>	SDU_OUT_Ind,
	SDU_OUT_USER_Out		=>	SDU_OUT_USER_Out,
	SDU_OUT_ErrOut			=>	SDU_OUT_ErrOut_sig,
	SDU_OUT_ErrIn			=>	SDU_OUT_ErrIn,
	SDU_OUT_Ack			=>	SDU_OUT_Ack,
	-------------------------------------------------------------
	TX_AUX_Out			=>	TX_AUX_Out, -- Used for DST MacAddr and Source Macaddrs
	TX_AUX_outV			=>	TX_AUX_outV,
	TX_AUX_in				=>	TX_AUX_in,
	RX_AUX_Out			=>	OPEN, --Not used
	RX_AUX_OutV			=>	OPEN, --Not used
	RX_AUX_in				=>	X"00" --Not used
);



IPRXFSM:PROCESS(	clk,
				rst,
				CE,
				RXFSM_State,
				CTRL_Ind,
				CTRL_ErrOut,
				CTRL_DV,
				CTRL_SOP,
				CTRL_OutV,
				CTRL_ChecksumError,
				CTRL_EOP,
				RX_reg_en,
				RX_reg_err,
				IP_RX_TTL,
				IP_RX_Version,
				IP_RX_Flags,
				IP_RX_FragOffset,
				MiniCAM_MatchV,
				MiniCAM_Match
				)
BEGIN
	IF(RISING_EDGE(clk))THEN
		IF(rst = Hi) THEN
			CTRL_Ack			<=	Lo;
			CTRL_FWD			<=	Lo;
			CTRL_Pause		<=	Lo;
			CTRL_DROP_ERR		<=	Lo;
			MiniCAM_SRCH		<=	Lo;
			SDU_DOUTV_OVRN		<=	Hi;
			SDU_Out_EOP_OVR	<=	Lo;
			IP_RX_PlenCNTR		<=	(others => Lo);
			IP_RX_Plen		<=	(others => Lo);
			RX_Status			<=	RX_Stat_INIT;
			RXFSM_State		<=	INIT;
		ELSIF(rst = Lo and CE = Hi) THEN
			CASE RXFSM_State IS
				WHEN IDLE =>
					CTRL_Ack			<=	Lo;
					CTRL_FWD			<=	Lo;
					CTRL_Pause		<=	Lo;
					CTRL_DROP_ERR		<=	Lo;
					MiniCAM_SRCH		<=	Lo;
					SDU_Out_EOP_OVR	<=	Lo;
					SDU_DOUTV_OVRN		<=	Hi;
					RX_Status			<=	RX_Stat_IDLE;
					IF(CTRL_Ind = Hi and CTRL_ErrOut = Lo) THEN
						RXFSM_State	<=	SendAck;
					ELSE
						RXFSM_State	<=	IDLE;
					END IF;
				WHEN SendAck =>
					CTRL_Ack	<=	Hi;
					RX_Status	<=	RX_Stat_SendAck;
					IF(CTRL_ErrOut = Hi) THEN
						RXFSM_State	<=	ERR_HANDLE;
					ELSE
						IF(CTRL_DV = Hi and CTRL_SOP = Hi) THEN
							RXFSM_State	<=	WFOR_IPHeader;
						ELSIF(CTRL_Ind = Hi and CTRL_DV = Lo)THEN
							RXFSM_State	<=	SendAck;
						ELSE
							RXFSM_State	<=	IDLE;
						END IF;
					END IF;
				WHEN WFOR_IPHeader =>
					RX_Status	<=	RX_Stat_WFOR_IPHeader;
					CTRL_Ack	<=	Lo;
					IF(CTRL_ErrOut = Lo) THEN
						IF(CTRL_OutV = Hi and CTRL_ChecksumError = Lo AND CTRL_EOP = Hi) THEN
							RXFSM_State	<=	IDLE;
						ELSIF(CTRL_OutV = Hi and CTRL_ChecksumError = Lo AND CTRL_EOP = Lo) THEN
							IF(RX_reg_en = Hi and RX_reg_err = Lo) THEN
								RXFSM_State	<=	Validate;
							ELSIF(RX_reg_err = Hi) THEN --Size mismatch
								RXFSM_State	<=	IDLE;
							ELSE
								CTRL_Pause	<=	Hi;
								RXFSM_State	<=	WFOR_Deser;
							END IF;
						ELSIF(CTRL_OutV = Hi and CTRL_ChecksumError = Hi) THEN
							RXFSM_State	<=	DROP_Packet;
						ELSE
							RXFSM_State	<=	WFOR_IPHeader;
						END IF;
					ELSE
						RXFSM_State	<=	IDLE;
					END IF;
				WHEN WFOR_Deser =>
					CTRL_Pause	<=	Hi;
					RX_Status		<=	RX_Stat_WFOR_Deser;
					IF(CTRL_ErrOut = Lo) THEN
						IF(RX_reg_en = Hi and RX_reg_err = Lo) THEN
							RXFSM_State	<=	Validate;
						ELSIF(RX_reg_err = Hi) THEN --Size mismatch
							RXFSM_State	<=	IDLE;
						ELSE
							RXFSM_State	<=	WFOR_Deser;
						END IF;
					ELSE
						RXFSM_State	<=	IDLE;
					END IF;
				WHEN Validate =>
					RX_Status		<=	RX_Stat_Validate;
					CTRL_Pause	<=	Hi;
					IF(IP_RX_TTL = X"00") THEN
						RXFSM_State	<=	DROP_Packet;
					ELSE
						IF(IP_RX_Version = X"4" and IP_RX_Flags(2) = '0' and IP_RX_Flags(0) = '0' and IP_RX_FragOffset = "0000000000000") THEN --MF = 0 and FO = 0 THEN it IS not a fragmented packet
							RXFSM_State	<=	Check_DSTIP;
						ELSE
							RXFSM_State	<=	DROP_Packet;
						END IF;
					END IF;
				WHEN Check_DSTIP =>
					MiniCAM_SRCH	<=	Hi;
					RX_Status		<=	RX_Stat_Check_DSTIP;
					IF(MiniCAM_MatchV = Hi and MiniCAM_Match = Hi)THEN
						RXFSM_State	<=	Forward_Packet;
					ELSIF(MiniCAM_MatchV = Hi and MiniCAM_Match = Lo)THEN
						RXFSM_State	<=	DROP_Packet;
					ELSE
						RXFSM_State	<=	Check_DSTIP;
					END IF;
				WHEN Forward_Packet =>
					IP_RX_PlenCNTR	<=	(others => Lo);
					IP_RX_Plen	<=	IP_RX_TotalLen-IP_RX_IHL_octet;
					DstIPAddr_Out	<=	IP_RX_DstAddress;
					SrcIPAddr_Out	<=	IP_RX_SrcAddress;
					Length_Out	<=	IP_RX_TotalLen-IP_RX_IHL_octet;
					Prot_Out		<=	IP_RX_Protocol;
					CTRL_FWD		<=	Hi;
					RX_Status		<=	RX_Stat_Forward_Packet;
					IF(SDU_OUT_ErrIn = Lo)THEN
						RXFSM_State	<=	WFOR_OUT;
					ELSE
						RXFSM_State	<=	IDLE;
					END IF;
				WHEN WFOR_OUT =>
					IF(SDU_OUT_ErrIn = Lo)THEN
						IF(SDU_Out_SOP_sig = Hi AND SDU_DOUTV_sig = Hi AND SDU_OUT_ErrOut_sig = Lo and SDU_OUT_EOP_sig = Lo)THEN
							IP_RX_PlenCNTR	<=	IP_RX_PlenCNTR + 1;
							RXFSM_State	<=	Watch_FOR_End;
						ELSIF(SDU_Out_SOP_sig = Hi AND SDU_DOUTV_sig = Hi AND SDU_OUT_ErrOut_sig = Lo and SDU_OUT_EOP_sig = Hi)THEN
							RXFSM_State	<=	IDLE;
						ELSE
							RXFSM_State	<=	WFOR_OUT;
						END IF;
					ELSE
						RXFSM_State	<=	IDLE;
					END IF;
				WHEN Watch_FOR_End =>
					IF(SDU_OUT_ErrIn = Lo AND SDU_OUT_ErrOut_sig = Lo)THEN
						IF(SDU_DOUTV_sig = Hi)THEN
							IP_RX_PlenCNTR	<=	IP_RX_PlenCNTR + 1;
							IF(SDU_OUT_EOP_sig = Hi AND SDU_DOUTV_sig = Hi)THEN
								RXFSM_State		<=	IDLE;
							ELSE
								IF(IP_RX_PlenCNTR = IP_RX_Plen - 2)THEN
									SDU_Out_EOP_OVR	<=	Hi;
									RXFSM_State		<=	Sig_EOP;
								ELSE
									RXFSM_State	<=	Watch_FOR_End;
								END IF;
							END IF;
						ELSE
							RXFSM_State	<=	Watch_FOR_End;
						END IF;
					ELSE
						RXFSM_State	<=	IDLE;
					END IF;
				WHEN Sig_EOP =>
					SDU_Out_EOP_OVR	<=	Lo;
					SDU_DOUTV_OVRN		<=	Lo;
					RXFSM_State		<=	WFOR_SDUEND;
				WHEN WFOR_SDUEND =>
					IF(SDU_DOUTV_sig = Hi)THEN
						RXFSM_State		<=	WFOR_SDUEND;
					ELSE
						RXFSM_State		<=	IDLE;
					END IF;
				WHEN DROP_Packet =>
					CTRL_DROP_ERR	<=	Hi;
					RX_Status		<=	RX_Stat_DROP_Packet;
					IF(CTRL_DV = Hi) THEN
						RXFSM_State	<=	DROP_Packet;
					ELSE
						RXFSM_State	<=	IDLE;
					END IF;
				WHEN ERR_HANDLE =>
					CTRL_Ack	<=	Lo;
					RX_Status	<=	RX_Stat_ERR_HANDLE;
					IF(CTRL_ErrOut = Hi) THEN
						RXFSM_State	<=	ERR_HANDLE;
					ELSE
						RXFSM_State	<=	IDLE;
					END IF;
				WHEN OTHERS => --INIT
				-- WHEN INIT =>
					CTRL_Ack			<=	Lo;
					CTRL_FWD			<=	Lo;
					CTRL_Pause		<=	Lo;
					CTRL_DROP_ERR		<=	Lo;
					MiniCAM_SRCH		<=	Lo;
					SDU_DOUTV_OVRN		<=	Hi;
					SDU_Out_EOP_OVR	<=	Lo;
					IP_RX_PlenCNTR		<=	(others => Lo);
					RX_Status			<=	RX_Stat_INIT;
					RXFSM_State		<=	IDLE;
			END CASE;
		END IF;
	END IF;
END PROCESS IPRXFSM;

StartOfSDUIn	<=	SDU_DINV and SDU_IN_SOP;
DIPIN_reg		:	aRegister	GENERIC MAP(Size => IPAddrSize)	PORT MAP(D=>DstIPAddr_In,C=>CLK,CE=>StartOfSDUIn,Q=>DstIPAddr_In_reg);
SIPIN_reg		:	aRegister	GENERIC MAP(Size => IPAddrSize)	PORT MAP(D=>SrcIPAddr_In,C=>CLK,CE=>StartOfSDUIn,Q=>SrcIPAddr_In_reg);
PROIN_reg		:	aRegister	GENERIC MAP(Size => 8)			PORT MAP(D=>Prot_In,C=>CLK,CE=>StartOfSDUIn,Q=>Prot_In_reg);
TLENIN_reg	:	aRegister	GENERIC MAP(Size => 16)			PORT MAP(D=>Length_In,C=>CLK,CE=>StartOfSDUIn,Q=>Length_In_reg);
DSTMAC_reg	:	aRegister	GENERIC MAP(Size => MacAddrSize)	PORT MAP(D=>ARP_DstMacAddr,C=>CLK,CE=>ARP_ResponseV,Q=>ARP_DstMacAddr_reg);

TX_AUX_in(2*MacAddrSize-1 downto MacAddrSize)	<=	ARP_DstMacAddr_reg;
TX_AUX_in(MacAddrSize-1 downto 0)				<=	SrcMacAddr_AUX_In;
DstMacAddr_Out								<=	TX_AUX_out(2*MacAddrSize-1 downto MacAddrSize);
SrcMacAddr_Out								<=	TX_AUX_out(MacAddrSize-1 downto 0);

SDU_IN_Ack_sig	<=	TXFSM_ack and PL_SDU_In_ACK;
SDUIA_reg		:	aFlop	PORT MAP(D=>SDU_IN_Ack_sig,C=>CLK,CE=>CE,Q=>SDU_IN_Ack);

-- Operation IN CASE OF SEND
-- 1. Determine local network destination ( IPCAM lookup)
-- 2. Get the DST hardware address from ARP module (ARP_Request)
-- 3. Initialize IP header and DSTHWaddr and SRCHWaddr (TX_AUXQ info)
-- 4. Start Send

IPTXFSM:PROCESS(	clk,
				rst,
				CE,
				TXFSM_State,
				SDU_IN_Ind,
				StartOfSDUIn,
				SDU_IN_ErrIn,
				IPCAM_MatchV,
				IPCAM_Match,
				ARP_ResponseErr,
				ARP_ResponseV,
				CHK_Ready,
				PCI_IN_Ack,
				PCI_DINV_sig,
				PCI_IN_SOP_sig,
				PCI_IN_ErrOut
				)
BEGIN
	IF(RISING_EDGE(clk))THEN
		IF(rst = Hi) THEN
			ARP_DSTIPAddr		<=	(OTHERS => Lo);
			SrcMacAddr_AUX_In	<=	(OTHERS => Lo);
			IP_TX_HCheckSum	<=	(OTHERS => Lo);
			IP_TX_Identification<=	(OTHERS => Lo);
			IPCAM_SRCH		<=	Lo;
			ARP_Request		<=	Lo;
			Calck_CHK			<=	Lo;
			MACADDR_RD_EN_OVRN	<=	Hi;
			PCI_IN_Ind		<=	Lo;
			Ser_Start			<=	Lo;
			PCI_IN_ErrIn		<=	Lo;
			TXFSM_ack			<=	Lo;
			TX_Status			<=	TX_Stat_INIT;
			TXFSM_State		<=	INIT;
		ELSIF(rst = Lo and CE = Hi) THEN
			CASE TXFSM_State IS
				WHEN IDLE =>
					PCI_IN_Ind		<=	Lo;
					Calck_CHK			<=	Lo;
					TXFSM_ack			<=	Lo;
					Ser_Start			<=	Lo;
					IP_TX_HCheckSum	<=	(OTHERS => Lo);
					TX_Status			<=	TX_Stat_IDLE;
					PCI_IN_ErrIn		<=	Lo;
					IF(SDU_IN_Ind = Hi)THEN
						TXFSM_State	<=	SDUIn_SENDACK;
					ELSE
						TXFSM_State	<=	IDLE;
					END IF;
				WHEN SDUIn_SENDACK =>
					TXFSM_ack			<=	Hi;
					TX_Status			<=	TX_Stat_SDUIn_SENDACK;
					IF(SDU_IN_Ind = Hi)THEN
						IF(StartOfSDUIn = Hi and SDU_IN_ErrIn = Lo AND SDU_IN_ErrOut_sig = Lo)THEN
							IP_TX_Identification	<=	IP_TX_Identification + 1; --Itt még ez nem szól bele az ellenőrző összeg számításba
							TXFSM_State			<=	IP_LOOKUP_N_CHKCALC;
						ELSIF(SDU_IN_ErrIn = Hi OR SDU_IN_ErrOut_sig = Hi)THEN
							TXFSM_State	<=	IDLE;
						ELSE
							TXFSM_State	<=	SDUIn_SENDACK;
						END IF;
					ELSE
						TXFSM_State	<=	IDLE;
					END IF;
				WHEN IP_LOOKUP_N_CHKCALC =>
					TXFSM_ack			<=	Lo;
					MACADDR_RD_EN_OVRN	<=	Lo;
					IPCAM_SRCH		<=	Hi;
					Calck_CHK			<=	Hi;
					TX_Status			<=	TX_Stat_IP_LOOKUP_N_CHKCALC;
					IF(IPCAM_MatchV = Hi and IPCAM_Match = Hi)THEN
						TXFSM_State	<=	ARP_LOOKUP_DST;
					ELSIF(IPCAM_MatchV = Hi and IPCAM_Match = Lo)THEN
						TXFSM_State	<=	ARP_LOOKUP_DefGW;
					ELSE
						TXFSM_State	<=	IP_LOOKUP_N_CHKCALC;
					END IF;
				WHEN ARP_LOOKUP_DST =>
					ARP_DSTIPAddr		<=	DstIPAddr_In_reg;
					SrcMacAddr_AUX_In	<=	MACADDR_DATA_OUT;
					TX_Status			<=	TX_Stat_ARP_LOOKUP_DST;
					TXFSM_State		<=	ARP_LOOKUP;
				WHEN ARP_LOOKUP_DefGW =>
					ARP_DSTIPAddr		<=	DefaultGW;
					SrcMacAddr_AUX_In	<=	MACADDR_DATA_OUT;
					TX_Status			<=	TX_Stat_ARP_LOOKUP_DefGW;
					TXFSM_State		<=	ARP_LOOKUP;
				WHEN ARP_LOOKUP =>
					MACADDR_RD_EN_OVRN	<=	Hi;
					ARP_Request		<=	Hi;
					IPCAM_SRCH		<=	Lo;
					TX_Status			<=	TX_Stat_ARP_LOOKUP;
					IF(ARP_ResponseErr = Hi) THEN
						TXFSM_State	<=	Inject_DUMMY_PCI_ind;
					ELSIF(ARP_ResponseErr = Lo and ARP_ResponseV = Hi)THEN
						IF(CHK_Ready = Hi)THEN
							TXFSM_State	<=	EmitPCI_Ind;
						ELSE
							TXFSM_State	<=	ARP_LOOKUP;
						END IF;
					ELSE
						TXFSM_State	<=	ARP_LOOKUP;
					END IF;
				WHEN EmitPCI_Ind =>
					ARP_Request		<=	Lo;
					IP_TX_HCheckSum	<=	TX_CHK_reg(15 downto 0);
					PCI_IN_Ind		<=	Hi;
					TX_Status			<=	TX_Stat_EmitPCI_Ind;
					IF(PCI_IN_Ack = Hi)THEN
						TXFSM_State			<=	EmitPCI;
					ELSE
						TXFSM_State			<=	EmitPCI_Ind;
					END IF;
				WHEN EmitPCI =>
					Ser_Start	<=	Hi;
					TX_Status	<=	TX_Stat_EmitPCI;
					IF(PCI_DINV_sig = Hi and PCI_IN_SOP_sig = Hi) THEN
						TXFSM_State	<=	IDLE;
					ELSE
						TXFSM_State	<=	EmitPCI;
					END IF;
				WHEN Inject_DUMMY_PCI_ind =>
					ARP_Request	<=	Lo;
					PCI_IN_Ind	<=	Hi;
					TX_Status		<=	TX_Stat_Inject_DUMMY_PCI_ind;
					IF(PCI_IN_Ack = Hi)THEN
						TXFSM_State	<=	Inject_DUMMY_PCI;
					ELSE
						TXFSM_State	<=	Inject_DUMMY_PCI_ind;
					END IF;
				WHEN Inject_DUMMY_PCI =>
					Ser_Start	<=	Hi;
					TX_Status	<=	TX_Stat_Inject_DUMMY_PCI;
					IF(PCI_DINV_sig = Hi and PCI_IN_SOP_sig = Hi) THEN
						TXFSM_State	<=	Sig_Error;
					ELSE
						TXFSM_State	<=	Inject_DUMMY_PCI;
					END IF;
				WHEN Sig_Error =>
					PCI_IN_ErrIn	<=	Hi;
					TX_Status		<=	TX_Stat_Sig_Error;
					IF(PCI_IN_ErrOut = Hi)THEN
						TXFSM_State	<=	IDLE;
					ELSE
						TXFSM_State	<=	Sig_Error;
					END IF;
				WHEN OTHERS => --INIT
				-- WHEN INIT =>
					ARP_DSTIPAddr		<=	(OTHERS => Lo);
					SrcMacAddr_AUX_In	<=	(OTHERS => Lo);
					IP_TX_HCheckSum	<=	(OTHERS => Lo);
					IPCAM_SRCH		<=	Lo;
					ARP_Request		<=	Lo;
					Calck_CHK			<=	Lo;
					MACADDR_RD_EN_OVRN	<=	Hi;
					PCI_IN_Ind		<=	Lo;
					Ser_Start			<=	Lo;
					PCI_IN_ErrIn		<=	Lo;
					TX_Status			<=	TX_Stat_INIT;
					TXFSM_State		<=	IDLE;
			END CASE;
		END IF;
	END IF;
END PROCESS IPTXFSM;

CHKCalcProc:PROCESS(	clk,
					rst,
					CE,
					CHKCalcFSM_State,
					Calck_CHK,
					TX_CHK_reg_temp,
					CHK_Pos_CNTR
					)
	variable	CHK_Pos	:	INTEGER := 0;
BEGIN
	IF(RISING_EDGE(clk))THEN
		IF(rst = Hi) THEN
			TX_CHK_reg		<=	(OTHERS => Lo);
			TX_CHK_reg_temp	<=	(OTHERS => Lo);
			CHK_Pos_CNTR		<=	(OTHERS => Lo);
			CHK_Ready			<=	Lo;
			CHKCalcFSM_State	<=	INIT;
		ELSIF(rst = Lo and CE = Hi) THEN
			CASE CHKCalcFSM_State IS
				WHEN IDLE =>
					TX_CHK_reg		<=	(OTHERS => Lo);
					TX_CHK_reg_temp	<=	(OTHERS => Lo);
					CHK_Pos_CNTR		<=	(OTHERS => Lo);
					CHK_Ready			<=	Lo;
					IF(Calck_CHK = Hi) THEN
						CHK_TX_packet_register	<=	TX_packet_register;
						CHKCalcFSM_State		<=	CalcIPGR;
					ELSE
						CHKCalcFSM_State		<=	IDLE;
					END IF;
				WHEN CalcIPGR =>
					CHK_TX_packet_register(IPPCILength-1 downto 16)	<=	CHK_TX_packet_register(IPPCILength-16-1 downto 0);
					TX_CHK_reg	<=	TX_CHK_reg + (X"0000" & CHK_TX_packet_register(IPPCILength-1 downto IPPCILength-16));
					CHK_Pos_CNTR	<=	CHK_Pos_CNTR + 1;
					IF(CHK_Pos_CNTR = CHK_Pos_CNTR_vec)THEN
						CHKCalcFSM_State	<=	AddCarry_1;
					ELSE
						CHKCalcFSM_State	<=	CalcIPGR;
					END IF;
				WHEN AddCarry_1 =>
					TX_CHK_reg_temp	<=	(X"0000" & TX_CHK_reg(15 downto 0)) + (X"0000" & TX_CHK_reg(31 downto 16));
					CHKCalcFSM_State	<=	AddCarry_2;
				WHEN AddCarry_2 =>
					IF(TX_CHK_reg_temp(16) = Hi)THEN
						TX_CHK_reg	<=	TX_CHK_reg_temp + 1;
					ELSE
						TX_CHK_reg	<=	TX_CHK_reg_temp;
					END IF;
					CHKCalcFSM_State	<=	Finished;
				WHEN Finished =>
					TX_CHK_reg		<=	NOT TX_CHK_reg;
					CHK_Ready			<=	Hi;
					CHKCalcFSM_State	<=	WFOR_END;
				WHEN WFOR_END =>
					IF(Calck_CHK = Hi) THEN
						CHKCalcFSM_State	<=	WFOR_END;
					ELSE
						CHKCalcFSM_State	<=	IDLE;
					END IF;
				WHEN OTHERS => --INIT
				-- WHEN INIT =>
					CHK_Ready			<=	Lo;
					TX_CHK_reg		<=	(OTHERS => Lo);
					TX_CHK_reg_temp	<=	(OTHERS => Lo);
					CHK_Pos_CNTR		<=	(OTHERS => Lo);
					CHK_Ready			<=	Lo;
					CHKCalcFSM_State	<=	IDLE;
			END CASE;
		END IF;
	END IF;
END PROCESS CHKCalcProc;

END ArchIPLayerBehav;


LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;


USE IEEE.math_real.ALL;
USE work.arch.aRegister;
USE work.arch.aFlop;
USE work.arch.aRise;
USE work.arch.aDelay;
USE work.ProtoLayerTypesAndDefs.ALL;

ENTITY IPCAM IS --IN ReadFirst Mode
generic(
	Elements			:		INTEGER	:=	DefNumOfIPAddr
);
PORT(
	CLK				: IN		STD_LOGIC;
	RST				: IN		STD_LOGIC;
	CE				: IN		STD_LOGIC;
	CFG_CE			: IN		STD_LOGIC;
	-----------------------------------------
	WR_EN			: IN		STD_LOGIC;
	RD_EN			: IN		STD_LOGIC;
	ValidAddrIn		: IN		STD_LOGIC;
	IPAddrIN			: IN		STD_LOGIC_VECTOR(IPAddrSize-1 downto 0);
	NetMaskIN			: IN		STD_LOGIC_VECTOR(IPAddrSize-1 downto 0);
	ADDR_In			: IN		STD_LOGIC_VECTOR(INTEGER(CEIL(LOG2(REAL(Elements))))-1 downto 0);
	CAM_IPaddrIN		: IN		STD_LOGIC_VECTOR(IPAddrSize-1 downto 0);
	CAM_SRCH			: IN		STD_LOGIC;
	Match			: OUT	STD_LOGIC;
	MatchV			: OUT	STD_LOGIC;
	ValidAddrOut		: OUT	STD_LOGIC;
	IPAddrOUT			: OUT	STD_LOGIC_VECTOR(IPAddrSize-1 downto 0);
	NetMaskOUT		: OUT	STD_LOGIC_VECTOR(IPAddrSize-1 downto 0);
	ADDR_Out			: OUT	STD_LOGIC_VECTOR(INTEGER(CEIL(LOG2(REAL(Elements))))-1 downto 0);
	DOUTV			: OUT	STD_LOGIC
	);
END IPCAM;

ARCHITECTURE ArchIPCAMBehav OF IPCAM IS

CONSTANT	AddrWidth			:	INTEGER	:=	INTEGER(CEIL(LOG2(REAL(Elements))));
CONSTANT	SRCH_Delay		:	INTEGER	:=	2;
CONSTANT	RES_Delay			:	INTEGER	:=	1;
CONSTANT	ArrayENum			:	INTEGER	:=	2**AddrWidth;
TYPE		IPADDRarray_type IS array (0 to ArrayENum-1) OF STD_LOGIC_VECTOR(IPAddrSize-1 downto 0); --+1 bit valid indicator
SIGNAL	IPADDRs			:	IPADDRarray_type;
SIGNAL	MASKs			:	IPADDRarray_type;
SIGNAL	NETs				:	IPADDRarray_type;
SIGNAL	Results			:	IPADDRarray_type;
SIGNAL	VALIDarray		:	STD_LOGIC_VECTOR(ArrayENum-1 downto 0);
SIGNAL	Match_vector		:	STD_LOGIC_VECTOR(ArrayENum-1 downto 0);
SIGNAL	Check_Match		:	STD_LOGIC;
SIGNAL	MatchV_sig		:	STD_LOGIC;
SIGNAL	Match_sig			:	STD_LOGIC;
SIGNAL	Addr_Out_sig		:	STD_LOGIC_VECTOR(ADDR_Out'Length-1 downto 0);

SIGNAL	CAM_SRCH_reg		:	STD_LOGIC;
SIGNAL	CAM_SRCH_rise		:	STD_LOGIC;
SIGNAL	CAM_SRCH_rise_delay	:	STD_LOGIC;
SIGNAL	Result_rise_delay	:	STD_LOGIC;
SIGNAL	CAM_IPaddrIN_reg	:	STD_LOGIC_VECTOR(IPAddrSize-1 downto 0);

BEGIN

	Match	<=	Match_sig;
	MatchV	<=	MatchV_sig;
	ADDR_Out	<=	Addr_Out_sig;
	
	CAMS_reg		: aFlop									PORT MAP(D=>CAM_SRCH,C=>CLK,CE=>CE,Q=>CAM_SRCH_reg);
	CAMS_rise		: aRise									PORT MAP(I => CAM_SRCH_reg, C => CLK, Q => CAM_SRCH_rise);
	CAMIPIn_reg	: aRegister	GENERIC MAP(Size => IPAddrSize)	PORT MAP(D=>CAM_IPaddrIN,C=>CLK,CE=>CAM_SRCH_rise,Q=>CAM_IPaddrIN_reg);
	CAMS_delay	: aDelay		GENERIC MAP(Length => SRCH_Delay)	PORT MAP(I=>CAM_SRCH_rise,C => CLK,CE => CE,Q => CAM_SRCH_rise_delay);
	RESR_delay	: aDelay		GENERIC MAP(Length => RES_Delay)	PORT MAP(I=>CAM_SRCH_rise,C => CLK,CE => CE,Q => Result_rise_delay);

	WR_PROC:PROCESS(	clk,
					rst,
					CFG_CE,
					WR_EN,
					RD_En
					)
	BEGIN
		IF(RISING_EDGE(clk))THEN
			IF(rst = Hi) THEN
				for i IN 0 to ArrayENum-1 loop
					IPADDRs	(i)	<=	(OTHERS => Lo); --ALL zeros
					MASKs	(i)	<=	(OTHERS => Lo); --ALL zeros
					NETs		(i)	<=	(OTHERS => Lo); --ALL zeros
				END loop;
				VALIDarray	<=	(OTHERS => Lo); --ALL zeros
			ELSIF(rst = Lo and CFG_CE = Hi) THEN
				IF(WR_EN = Hi) THEN
					IPADDRs	(to_integer(unsigned(ADDR_In)))	<=	IPAddrIN;
					MASKs	(to_integer(unsigned(ADDR_In)))	<=	NetMaskIN;
					NETs		(to_integer(unsigned(ADDR_In)))	<=	IPAddrIN and NetMaskIN;
					VALIDarray(to_integer(unsigned(ADDR_In)))	<=	ValidAddrIn;
				ELSIF(WR_EN = Lo and RD_EN = Hi) THEN
					IPAddrOUT		<=	IPADDRs	(to_integer(unsigned(ADDR_In)));
					NetMaskOUT	<=	MASKs	(to_integer(unsigned(ADDR_In)));
					ValidAddrOut	<=	VALIDarray(to_integer(unsigned(ADDR_In)));
					DOUTV		<=	Hi;
				ELSE
					DOUTV	<=	Lo;
				END IF;
			END IF;
		END IF;
	END PROCESS WR_PROC;
	RESULT_PROC:PROCESS(	clk,
						rst,
						CE,
						Result_rise_delay
						)
	BEGIN
		IF(RISING_EDGE(clk))THEN
			IF(rst = Hi) THEN
				for i IN 0 to ArrayENum-1 loop
					Results(i)	<=	(OTHERS => Lo); --ALL zeros
				END loop;
			ELSIF(rst = Lo and CE= Hi) THEN
				IF(Result_rise_delay = Hi) THEN
					for i IN 0 to ArrayENum-1 loop
						Results(i)	<=	CAM_IPaddrIN_reg and MASKs(i); --ALL zeros
					END loop;
				END IF;
			END IF;
		END IF;
	END PROCESS RESULT_PROC;
	FIND_PROC:PROCESS(	clk,
					rst,
					CE,
					CAM_SRCH_rise_delay
					)
	BEGIN
		IF(RISING_EDGE(clk))THEN
			IF(rst = Hi) THEN
				Check_Match	<=	Lo;
			ELSIF(rst = Lo and CE = Hi) THEN
				IF(CAM_SRCH_rise_delay = Hi) THEN
					Check_Match	<=	Hi;
					for i IN 0 to ArrayENum-1 loop
						IF( Results(i) = NETs(i) and VALIDarray(i) = Hi) THEN
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
	
	Match_Proc:PROCESS(	clk,
					rst,
					CE) 
	BEGIN
		IF(RISING_EDGE(clk))THEN
			IF(rst = Hi) THEN
				MatchV_sig	<=	Lo;
				Match_sig		<=	Lo;
				Addr_Out_sig	<=	(OTHERS => Lo);
			ELSIF(rst = Lo and CE = Hi) THEN
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
					Match_sig		<=	Lo;
					MatchV_sig	<=	Lo;
				END IF;
			END IF;
		END IF;
	END PROCESS Match_Proc;

END ArchIPCAMBehav;



LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;


USE IEEE.math_real.ALL;
USE work.arch.aRegister;
USE work.arch.aFlop;
USE work.arch.aRise;
USE work.arch.aDelay;
USE work.arch.aPipe;
USE work.ProtoLayerTypesAndDefs.ALL;

ENTITY IP_RX_Cheksum_Calc IS
generic(
	DataWidth			:		INTEGER	:=	DefDataWidth
);
PORT(
	CLK				: IN		STD_LOGIC;
	RST				: IN		STD_LOGIC;
	CE				: IN		STD_LOGIC;
	-----------------------------------------
	EType_In			: IN		STD_LOGIC_VECTOR( EtherTypeSize-1 downto 0);
	-----------------------------------------
	DIN				: IN		STD_LOGIC_VECTOR( DataWidth-1 downto 0);
	DINV				: IN		STD_LOGIC;
	In_SOP			: IN		STD_LOGIC;
	In_EOP			: IN		STD_LOGIC;
	IN_ErrIn			: IN		STD_LOGIC;
	-----------------------------------------
	DOUT				: OUT	STD_LOGIC_VECTOR( DataWidth-1 downto 0);
	DOUTV			: OUT	STD_LOGIC;
	Out_SOP			: OUT	STD_LOGIC;
	Out_EOP			: OUT	STD_LOGIC;
	Out_ErrOut		: OUT	STD_LOGIC;
	-----------------------------------------
	ChecksumError		: OUT	STD_LOGIC; --info transferred IN Protolayer PDU_IN_USER_In SIGNAL
	IPHeader			: OUT	STD_LOGIC; --info transferred IN Protolayer PDU_IN_USER_In SIGNAL
	OutV				: OUT	STD_LOGIC
);
END  IP_RX_Cheksum_Calc;

ARCHITECTURE ArchIP_RX_Cheksum_CalcBehav OF IP_RX_Cheksum_Calc IS
-- TASK: Determine IHL, Extract RX header checksum, Sum One's complement OF DATA IN OF length OF IHL * 32 bit, For purposes OF
-- computing the checksum, the value OF the checksum field IS zero, SIGNAL OUT about the results
-- IHL position: 			DW 0 Byte 0 Bits 4 to 7
-- Header Cheksum position	DW 2 W 1 => W 5
CONSTANT	Input_delay	:		INTEGER	:=	2;
CONSTANT	TH_delay		:		INTEGER	:=	4;
CONSTANT	OUT_delay		:		INTEGER	:=	TH_delay-2;

SIGNAL	DINV_reg		:		STD_LOGIC;
SIGNAL	DINV_d		:		STD_LOGIC;
SIGNAL	IN_ErrIn_reg	:		STD_LOGIC;
SIGNAL	IN_ErrIn_sig	:		STD_LOGIC;
SIGNAL	IN_ErrIn_OVR	:		STD_LOGIC;
SIGNAL	IN_ErrIn_d	:		STD_LOGIC;
SIGNAL	In_SOP_reg	:		STD_LOGIC;
SIGNAL	In_SOP_rise_sig:		STD_LOGIC;
SIGNAL	In_SOP_rise	:		STD_LOGIC;
SIGNAL	In_EOP_reg	:		STD_LOGIC;
SIGNAL	In_EOP_rise	:		STD_LOGIC;
SIGNAL	In_EOP_rise_sig:		STD_LOGIC;
SIGNAL	DIN_reg		:		STD_LOGIC_VECTOR( DataWidth-1 downto 0);
SIGNAL	DIN_d		:		STD_LOGIC_VECTOR( DataWidth-1 downto 0);
SIGNAL	DIN_d_DW		:		STD_LOGIC_VECTOR( 2*DataWidth-1 downto 0);
SIGNAL	DIN_d_DW_Hi	:		STD_LOGIC_VECTOR( DataWidth-1 downto 0);
SIGNAL	DIN_d_DW_Lo	:		STD_LOGIC_VECTOR( DataWidth-1 downto 0);
SIGNAL	DW_valid		:		STD_LOGIC;
SIGNAL	DW_valid_CNTR	:		STD_LOGIC_VECTOR(0 downto 0);
SIGNAL	EType_In_reg	:		STD_LOGIC_VECTOR(EtherTypeSize-1 downto 0);
SIGNAL	EType_In_check	:		STD_LOGIC_VECTOR(EtherTypeSize-1 downto 0);
SIGNAL	IPHeader_sig	:		STD_LOGIC;
SIGNAL	ETypeInValid	:		STD_LOGIC;
SIGNAL	ETypeInValid_d	:		STD_LOGIC;
SIGNAL	OuTV_sig		:		STD_LOGIC;

SIGNAL	CalcCheksum		:		STD_LOGIC_VECTOR(31 downto 0);
SIGNAL	CalcCheksum_temp	:		STD_LOGIC_VECTOR(31 downto 0);
SIGNAL	ExtrCheksum		:		STD_LOGIC_VECTOR(15 downto 0);
SIGNAL	ExtrIHLDW			:		STD_LOGIC_VECTOR(4 downto 0);

SIGNAL	EXCntr		:		STD_LOGIC_VECTOR(4 downto 0);
CONSTANT	CHKDWPos		:		INTEGER	:=	5;
CONSTANT	CHKDWPos_vec	:		STD_LOGIC_VECTOR(4 downto 0)	:=	STD_LOGIC_VECTOR(to_unsigned(CHKDWPos,5));

TYPE DW_valid_StateType IS
(
	INIT,
	IDLE,
	IPGR
);
TYPE CHKEX_StateType IS
(
	INIT,
	IDLE,
	IPGR,
	Check_CHK_PH2,
	Check_CHK_PH3,
	Check_CHK_PH4,
	WFOREND,
	MALFORMED_PACKET
);
ATTRIBUTE ENUM_ENCODING	:	STRING;
SIGNAL	DW_valid_State	:		DW_valid_StateType;
SIGNAL	CHKEX_State	:		CHKEX_StateType;

BEGIN

DINV_reg_inst	: aFlop										PORT MAP( D => DINV,C => CLK,CE => CE,Q => DINV_reg);
DINV_d_inst	: aDelay		GENERIC MAP(Length => Input_delay)		PORT MAP( I => DINV_reg,C => CLK,CE => CE,Q => DINV_d);

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
DIn_reg3_inst	: aRegister	GENERIC MAP( Size => DataWidth)		PORT MAP( D => DIN_d,C => CLK,CE => CE,Q => DIN_d_DW_Hi);

DIN_d_DW_Lo	<=	DIN_d;
DIN_d_DW		<=	DIN_d_DW_Hi & DIN_d_DW_Lo;

ETIn_reg_inst	: aRegister	GENERIC MAP( Size => EtherTypeSize)	PORT MAP( D => EType_In,C => CLK,CE => CE,Q => EType_In_reg);

EType_In_check	<=	EType_In_reg XOR EType_IP;
with EType_In_check SELECT
ETypeInValid	<=	Hi WHEN X"0000" , Lo WHEN OTHERS;

ETIV_d_inst	: aDelay		GENERIC MAP(Length => Input_delay)		PORT MAP( I => ETypeInValid,C => CLK,CE => CE,Q => ETypeInValid_d);

DW_valid_proc:PROCESS(	clk,
					rst,
					CE,
					DW_valid_State,
					DINV_d,
					In_SOP_rise,
					IN_ErrIn_d,
					In_EOP_rise
					)
BEGIN
	IF(RISING_EDGE(clk))THEN
		IF(rst = Hi) THEN
			DW_valid_CNTR(0)	<=	Lo;
			DW_valid_State		<=	INIT;
		ELSIF(rst = Lo and CE = Hi) THEN
			CASE DW_valid_State IS
				WHEN IDLE =>
					IF(DINV_d = Hi and In_SOP_rise = Hi and IN_ErrIn_d = Lo) THEN
						DW_valid_CNTR	<=	"1";
						DW_valid_State	<=	IPGR;
					ELSE
						DW_valid_CNTR	<=	"0";
						DW_valid_State	<=	IDLE;
					END IF;
				WHEN IPGR =>
					IF(IN_ErrIn_d = Hi) THEN
						DW_valid_State	<=	IDLE;
					ELSIF(IN_ErrIn_d = Lo and DINV_d = Hi) THEN
						DW_valid_CNTR	<=	DW_valid_CNTR + 1;
						IF(In_EOP_rise = Hi) THEN
							DW_valid_State	<=	IDLE;
						END IF;
					END IF;
				-- WHEN OTHERS => --INIT
				WHEN INIT =>
					DW_valid_CNTR(0)	<=	Lo;
					DW_valid_State		<=	IDLE;
			END CASE;
		END IF;
	END IF;
END PROCESS DW_valid_proc;
DW_valid	<=	DW_valid_CNTR(0);

IHL_extract:PROCESS(	clk,
					rst,
					CE,
					DINV_d,
					In_SOP_rise,
					IN_ErrIn_d,
					DIN_d
					)
BEGIN
	IF(RISING_EDGE(clk))THEN
		IF(rst = Hi) THEN
			ExtrIHLDW	<=	STD_LOGIC_VECTOR(to_unsigned(10-1,ExtrIHLDW'Length));
		ELSIF(rst = Lo and CE = Hi) THEN
			IF(DINV_d = Hi and In_SOP_rise = Hi and IN_ErrIn_d = Lo) THEN
				IF(DIN_d(3 downto 0) < "0101") THEN
					ExtrIHLDW	<=	"01010";
				ELSE
					ExtrIHLDW	<=	DIN_d(3 downto 0) & Lo;
				END IF;
			END IF;
		END IF;
	END IF;
END PROCESS IHL_extract;

CHK_extract:PROCESS(clk,rst,ce,CHKEX_State,DINV_d,In_SOP_rise,IN_ErrIn_d,In_EOP_rise,DW_valid,CalcCheksum_temp,CalcCheksum)
BEGIN
	IF(RISING_EDGE(clk))THEN
		IF(rst = Hi) THEN
			EXCntr			<=	STD_LOGIC_VECTOR(to_unsigned(0,EXCntr'Length));
			CalcCheksum		<=	(OTHERS => Lo);
			CalcCheksum_temp	<=	(OTHERS => Lo);
			ExtrCheksum		<=	(OTHERS => Lo);
			ChecksumError		<=	Lo;
			IN_ErrIn_OVR		<=	Lo;
			IPHeader_sig		<=	Lo;
			OuTV_sig			<=	Lo;
			CHKEX_State		<=	INIT;
		ELSIF(rst = Lo and CE = Hi) THEN
			CASE	CHKEX_State IS
				WHEN IDLE =>
					ChecksumError		<=	Lo;
					OuTV_sig			<=	Lo;
					IPHeader_sig		<=	Lo;
					IN_ErrIn_OVR		<=	Lo;
					CalcCheksum		<=	(OTHERS => Lo);
					CalcCheksum_temp	<=	(OTHERS => Lo);
					EXCntr			<=	STD_LOGIC_VECTOR(to_unsigned(0,EXCntr'Length));
					IF(DINV_d = Hi and In_SOP_rise = Hi and IN_ErrIn_d = Lo) THEN
						IF(ETypeInValid_d = Hi)THEN
							CHKEX_State	<=	IPGR;
						ELSE
							-- IN_ErrIn_OVR	<=	Hi;
							CHKEX_State	<=	MALFORMED_PACKET;
						END IF;
					ELSE
						CHKEX_State	<=	IDLE;
					END IF;
				WHEN	IPGR =>
					IPHeader_sig	<=	Hi;
					IF(IN_ErrIn_d = Hi)THEN
						CHKEX_State	<=	IDLE;
					ELSIF(IN_ErrIn_d = Lo and DINV_d = Hi)THEN
						IF(In_EOP_rise = Hi and DW_valid = Lo) THEN
							CHKEX_State	<=	MALFORMED_PACKET;
						ELSIF(DW_valid = Hi) THEN
							EXCntr		<=	EXCntr + 1;
							CalcCheksum	<=	CalcCheksum + (X"0000" & DIN_d_DW);
							IF(EXCntr = ExtrIHLDW - 1)THEN
								CHKEX_State	<=	Check_CHK_PH2;
							ELSE
								CHKEX_State	<=	IPGR;
							END IF;
						END IF;
					END IF;
				WHEN Check_CHK_PH2 =>
					CalcCheksum_temp	<=	(X"0000" & CalcCheksum(31 DOWNTO 16)) + (X"0000" & CalcCheksum(15 DOWNTO 0));
					CHKEX_State		<=	Check_CHK_PH3;
				WHEN Check_CHK_PH3 =>
					IF(CalcCheksum_temp(16) = Hi)THEN
						CalcCheksum	<=	CalcCheksum_temp + 1;
					ELSE
						CalcCheksum	<=	CalcCheksum_temp;
					END IF;
					CHKEX_State		<=	Check_CHK_PH4;
				WHEN Check_CHK_PH4 =>
					IPHeader_sig		<=	Lo;
					OuTV_sig			<=	Hi;
					IF(CalcCheksum(15 downto 0) = X"FFFF") THEN
						ChecksumError	<=	Lo;
					ELSE
						ChecksumError	<=	Hi;
					END IF;
					IF((In_EOP_rise = Hi and DINV_d = Hi) or IN_ErrIn_d = Hi) THEN
						CHKEX_State	<=	IDLE;
					ELSE
						CHKEX_State	<=	WFOREND;
					END IF;
				WHEN WFOREND =>
					ChecksumError	<=	Lo;
					OuTV_sig		<=	Lo;
					IPHeader_sig	<=	Lo;
					IN_ErrIn_OVR	<=	Lo;
					CalcCheksum	<=	(OTHERS => Lo);
					EXCntr		<=	STD_LOGIC_VECTOR(to_unsigned(0,EXCntr'Length));
					IF((In_EOP_rise = Hi and DINV_d = Hi) or IN_ErrIn_d = Hi) THEN
						CHKEX_State	<=	IDLE;
					ELSIF(DINV_d = Hi and In_SOP_rise = Hi and IN_ErrIn_d = Lo) THEN
						CHKEX_State	<=	IPGR;
					ELSE
						CHKEX_State	<=	WFOREND;
					END IF;
				WHEN MALFORMED_PACKET =>
					IN_ErrIn_OVR	<=	Hi;
					CHKEX_State	<=	IDLE;
				-- WHEN OTHERS => --INIT
				WHEN INIT =>
					EXCntr		<=	STD_LOGIC_VECTOR(to_unsigned(0,EXCntr'Length));
					CalcCheksum	<=	(OTHERS => Lo);
					ExtrCheksum	<=	(OTHERS => Lo);
					ChecksumError	<=	Lo;
					IN_ErrIn_OVR	<=	Lo;
					IPHeader_sig	<=	Lo;
					OuTV_sig		<=	Lo;
					CHKEX_State	<=	IDLE;
			END CASE;
		END IF;
	END IF;
END PROCESS CHK_extract;

DINTPD		: aPipe		GENERIC MAP( Size => DataWidth, Length => TH_delay)
													PORT MAP( I => DIN_d, C => CLK, CE => CE, Q => DOUT);
DINVTPD		: aDelay		GENERIC MAP(Length => TH_delay)	PORT MAP( I => DINV_d,C => CLK,CE => CE,Q => DOUTV);
SOPTPD		: aDelay		GENERIC MAP(Length => TH_delay)	PORT MAP( I => In_SOP_rise,C => CLK,CE => CE,Q => Out_SOP);
EOPTPD		: aDelay		GENERIC MAP(Length => TH_delay)	PORT MAP( I => In_EOP_rise,C => CLK,CE => CE,Q => Out_EOP);
Out_ErrOut	<=	IN_ErrIn_d;
-- ERROTPD		: aDelay		GENERIC MAP(Length => TH_delay)	PORT MAP(I=>IN_ErrIn_d,C => CLK,CE => CE,Q => Out_ErrOut);
IPHOD		: aDelay		GENERIC MAP(Length => OUT_delay)	PORT MAP( I => IPHeader_sig,C => CLK,CE => CE,Q => IPHeader);
OUTVOD		: aDelay		GENERIC MAP(Length => OUT_delay-1)	PORT MAP( I => OuTV_sig,C => CLK,CE => CE,Q => OuTV);




END ArchIP_RX_Cheksum_CalcBehav;

 