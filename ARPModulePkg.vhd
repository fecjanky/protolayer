--
-- ARPModulePkg.vhd
-- ============
--
-- (C) Ferenc Janky, BME TMIT
--   file name:	ARPModulePkg.vhd
--   PACKAGE:		ARPModulePkg
--


-------------------------------------------------------
---------------ARP Packet structure--------------------
-------------------------------------------------------
---|0 | 1| 2| 3| 4| 5| 6| 7| 8| 9|10|11|12|13|14|15|16|
------------------------------------------------------|
--0|			Hardware Address Space	ar$hrd	    |
---|--------------------------------------------------|
--1|			Protocol Adress Space	ar$pro	    |
---|--------------------------------------------------|
--2|	B.len HWAddr ar$hln   |	B.len ProtoAddr ar$pln  |
---|--------------------------------------------------|
--3|		opcode (ares_op$REQUEST | ares_op$REPLY)    |
---|--------------------------------------------------|
--.|		ar$sha HWaddress OF sender, n=ar$hln	    |
---|--------------------------------------------------|
--.|		ar$spa Protoaddress OF sender, n=ar$pln	    |
---|--------------------------------------------------|
--.|		ar$tha HWaddress OF target, n=ar$hln	    |
---|--------------------------------------------------|
--.|		ar$tpa Protoaddress OF target, n=ar$pln	    |
---|--------------------------------------------------|

---There are no padding bytes between addresses. The packet data
-- should be viewed as a byte stream IN which only 3 byte pairs are
-- defined to be words (ar$hrd, ar$pro and ar$op) which are sent
-- most significant byte first

--ares_op$REQUEST 	= 0x0001
--ares_op$REPLY	= 0x0002

--IN CASE OF Ehternet
--ether_type$ADDRESS_RESOLUTION	= 0x0806
--ar$hrd = ares_hrd$Ethernet		= 0x0001
--ar$hln						= 6 (6 byte = 48 bit)
--IN CASE OF IPv4
--ar$pro						= 0x0800 --shares numbering space with EtherType
--ar$pln						= 4

LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

USE work.ProtoLayerTypesAndDefs.ALL;

PACKAGE ARPModulePkg IS

	COMPONENT ARPModule IS
	GENERIC(
		DataWidth			:		INTEGER	:=	DefDataWidth;
		TX_SYNC_OUT		:		BOOLEAN	:=	true;
		RX_SYNC_IN		:		BOOLEAN	:=	true;
		NumOfAddresses		:		INTEGER	:=	DefNumOfIPAddr; --Maximum 16, for each IP a MAC addr must be defined and vice-versa
		CLK_freq			:		REAL		:=	125.0; --Clock frequency IN MHz
		TimeOUT			:		REAL		:=	500.0; --timeout IN ms
		RetryCnt			:		INTEGER	:=	3	--retry count
	);
	PORT(
		CLK				: IN		STD_LOGIC;
		RST				: IN		STD_LOGIC;
		CE				: IN		STD_LOGIC;
		CFG_CE			: IN		STD_LOGIC;
		-----------------------------------
		DST_MacAddr_Out	: OUT	STD_LOGIC_VECTOR(MacAddrSize-1 DOWNTO 0);
		SRC_MacAddr_Out	: OUT	STD_LOGIC_VECTOR(MacAddrSize-1 DOWNTO 0);
		EType_Out			: OUT	STD_LOGIC_VECTOR(EtherTypeSize-1 DOWNTO 0);
		PDU_DOUT			: OUT	STD_LOGIC_VECTOR(DataWidth-1 DOWNTO 0);
		PDU_DOUTV			: OUT	STD_LOGIC;
		PDU_Out_SOP		: OUT	STD_LOGIC;
		PDU_Out_EOP		: OUT	STD_LOGIC;
		PDU_Out_Ind		: OUT	STD_LOGIC;
		PDU_Out_ErrOut		: OUT	STD_LOGIC;
		PDU_Out_Ack		: IN		STD_LOGIC;
		PDU_Out_ErrIn		: IN		STD_LOGIC;
		-----------------------------------
		DST_MacAddr_In		: IN		STD_LOGIC_VECTOR(MacAddrSize-1 DOWNTO 0);
		SRC_MacAddr_In		: IN		STD_LOGIC_VECTOR(MacAddrSize-1 DOWNTO 0);
		EType_In			: IN		STD_LOGIC_VECTOR(EtherTypeSize-1 DOWNTO 0);
		PDU_DIN			: IN		STD_LOGIC_VECTOR(DataWidth-1 DOWNTO 0);
		PDU_DINV			: IN		STD_LOGIC;
		PDU_In_SOP		: IN		STD_LOGIC;
		PDU_In_EOP		: IN		STD_LOGIC;
		PDU_In_Ind		: IN		STD_LOGIC;
		PDU_In_ErrIn		: IN		STD_LOGIC;
		PDU_In_Ack		: OUT	STD_LOGIC;
		PDU_In_ErrOut		: OUT	STD_LOGIC;
		-----------------------------------
		ARP_ReqUest		: IN		STD_LOGIC;
		ARP_DST_IP_addr	: IN		STD_LOGIC_VECTOR(IPAddrSize-1 DOWNTO 0);
		ARP_DST_MAC_addr	: OUT	STD_LOGIC_VECTOR(MACAddrSize-1 DOWNTO 0);
		ARP_RESPONSEV		: OUT	STD_LOGIC;
		ARP_RESPONSE_ERR	: OUT	STD_LOGIC;
		-----------------------------------
		-----------------------------------
		--Management IF
		-----------------------------------
		IPADDR_WR_EN		: IN		STD_LOGIC;
		MACADDR_WR_EN		: IN		STD_LOGIC;
		IPADDR_RD_EN		: IN		STD_LOGIC;
		MACADDR_RD_EN		: IN		STD_LOGIC;
		ADDR				: IN		STD_LOGIC_VECTOR(INTEGER(CEIL(LOG2(REAL(NumOfAddresses))))-1 DOWNTO 0); --NumOfAddresses	<= NumOfAddresses!!!
		ADDR_DATA_IN		: IN		STD_LOGIC_VECTOR( MACAddrSize-1 DOWNTO 0);	--Shared with IP ADDR
		IPADDR_DATA_OUT	: OUT	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);	--Shared with IP ADDR
		MACADDR_DATA_OUT	: OUT	STD_LOGIC_VECTOR( MACAddrSize-1 DOWNTO 0);	--Shared with IP ADDR
		IPADDR_DV			: OUT	STD_LOGIC;
		MACADDR_DV		: OUT	STD_LOGIC;
		-----------------------------------
		--Debug
		-----------------------------------
		StatusVec			: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
	END COMPONENT ARPModule;
	
END ARPModulePkg;




LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

LIBRARY work;
USE work.ProtoLayerTypesAndDefs.ALL;
USE work.ProtoModulePkg.MiniCAM;
USE work.ProtoModulePkg.Serializer;
USE work.ProtoModulePkg.DeSerializer;
USE work.ProtoModulePkg.PDUQueue;
USE work.arch.aRam;
USE work.arch.aRegister;
USE work.arch.aRise;
USE work.arch.aFlop;

ENTITY ARPModule IS
GENERIC(
	DataWidth			:		INTEGER	:=	DefDataWidth;
	TX_SYNC_OUT		:		BOOLEAN	:=	true;
	RX_SYNC_IN		:		BOOLEAN	:=	true;
	NumOfAddresses		:		INTEGER	:=	DefNumOfIPAddr; --Maximum 16, for each IP a MAC addr must be defined and vice-versa
	CLK_freq			:		REAL		:=	125.0; --Clock frequency IN MHz
	TimeOUT			:		REAL		:=	500.0; --timeout IN ms
	RetryCnt			:		INTEGER	:=	3	--retry count
);
PORT(
	CLK				: IN		STD_LOGIC;
	RST				: IN		STD_LOGIC;
	CE				: IN		STD_LOGIC;
	CFG_CE			: IN		STD_LOGIC;
	-----------------------------------
	DST_MacAddr_Out	: OUT	STD_LOGIC_VECTOR(MacAddrSize-1 DOWNTO 0);
	SRC_MacAddr_Out	: OUT	STD_LOGIC_VECTOR(MacAddrSize-1 DOWNTO 0);
	EType_Out			: OUT	STD_LOGIC_VECTOR(EtherTypeSize-1 DOWNTO 0);
	PDU_DOUT			: OUT	STD_LOGIC_VECTOR(DataWidth-1 DOWNTO 0);
	PDU_DOUTV			: OUT	STD_LOGIC;
	PDU_Out_SOP		: OUT	STD_LOGIC;
	PDU_Out_EOP		: OUT	STD_LOGIC;
	PDU_Out_Ind		: OUT	STD_LOGIC;
	PDU_Out_ErrOut		: OUT	STD_LOGIC;
	PDU_Out_Ack		: IN		STD_LOGIC;
	PDU_Out_ErrIn		: IN		STD_LOGIC;
	-----------------------------------
	DST_MacAddr_In		: IN		STD_LOGIC_VECTOR(MacAddrSize-1 DOWNTO 0);
	SRC_MacAddr_In		: IN		STD_LOGIC_VECTOR(MacAddrSize-1 DOWNTO 0);
	EType_In			: IN		STD_LOGIC_VECTOR(EtherTypeSize-1 DOWNTO 0);
	PDU_DIN			: IN		STD_LOGIC_VECTOR(DataWidth-1 DOWNTO 0);
	PDU_DINV			: IN		STD_LOGIC;
	PDU_In_SOP		: IN		STD_LOGIC;
	PDU_In_EOP		: IN		STD_LOGIC;
	PDU_In_Ind		: IN		STD_LOGIC;
	PDU_In_ErrIn		: IN		STD_LOGIC;
	PDU_In_Ack		: OUT	STD_LOGIC;
	PDU_In_ErrOut		: OUT	STD_LOGIC;
	-----------------------------------
	ARP_ReqUest		: IN		STD_LOGIC;
	ARP_DST_IP_addr	: IN		STD_LOGIC_VECTOR(IPAddrSize-1 DOWNTO 0);
	ARP_DST_MAC_addr	: OUT	STD_LOGIC_VECTOR(MACAddrSize-1 DOWNTO 0);
	ARP_RESPONSEV		: OUT	STD_LOGIC;
	ARP_RESPONSE_ERR	: OUT	STD_LOGIC;
	-----------------------------------
	-----------------------------------
	--Management IF
	-----------------------------------
	IPADDR_WR_EN		: IN		STD_LOGIC;
	MACADDR_WR_EN		: IN		STD_LOGIC;
	IPADDR_RD_EN		: IN		STD_LOGIC;
	MACADDR_RD_EN		: IN		STD_LOGIC;
	ADDR				: IN		STD_LOGIC_VECTOR(INTEGER(CEIL(LOG2(REAL(NumOfAddresses))))-1 DOWNTO 0); --NumOfAddresses	<= NumOfAddresses!!!
	ADDR_DATA_IN		: IN		STD_LOGIC_VECTOR( MACAddrSize-1 DOWNTO 0);	--Shared with IP ADDR
	IPADDR_DATA_OUT	: OUT	STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);	--Shared with IP ADDR
	MACADDR_DATA_OUT	: OUT	STD_LOGIC_VECTOR( MACAddrSize-1 DOWNTO 0);	--Shared with IP ADDR
	IPADDR_DV			: OUT	STD_LOGIC;
	MACADDR_DV		: OUT	STD_LOGIC;
	-----------------------------------
	--Debug
	-----------------------------------
	StatusVec			: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0)
);
END ARPModule;

ARCHITECTURE ArchARPModuleBehav OF ARPModule IS

CONSTANT	addrWidth				:		INTEGER								:=	INTEGER(CEIL(LOG2(REAL(NumOfAddresses))));

CONSTANT	mul_factor			:		REAL									:=	1000.0; --[Tout] = ms & [fclk] = MHz
CONSTANT	TimerWidth			:		INTEGER								:=	INTEGER(CEIL(LOG2(TimeOUT*CLK_freq*mul_factor)));
CONSTANT	RetryWidth			:		INTEGER								:=	INTEGER(CEIL(LOG2(REAL(RetryCnt+1))));
CONSTANT	RetryCnt_vec			:		STD_LOGIC_VECTOR( RetryWidth-1 DOWNTO 0)	:=	STD_LOGIC_VECTOR(to_unsigned(RetryCnt,RetryWidth));
CONSTANT	arp_ETHIP_lenDW		:		INTEGER								:=	arp_ETHIP_len/DataWidth;

CONSTANT	RX_Stat_INIT			:		STD_LOGIC_VECTOR( 3 DOWNTO 0)	:=	X"0";
CONSTANT	RX_Stat_IDLE			:		STD_LOGIC_VECTOR( 3 DOWNTO 0)	:=	X"1";
CONSTANT	RX_Stat_Reception_Start	:		STD_LOGIC_VECTOR( 3 DOWNTO 0)	:=	X"2";
CONSTANT	RX_Stat_Reception_IPGR	:		STD_LOGIC_VECTOR( 3 DOWNTO 0)	:=	X"4";
CONSTANT	RX_Stat_DeSer_IPGR		:		STD_LOGIC_VECTOR( 3 DOWNTO 0)	:=	X"5";
CONSTANT	RX_Stat_Validate_Part_1	:		STD_LOGIC_VECTOR( 3 DOWNTO 0)	:=	X"6";
CONSTANT	RX_Stat_Validate_Part_2	:		STD_LOGIC_VECTOR( 3 DOWNTO 0)	:=	X"7";
CONSTANT	RX_Stat_Validate_Part_3	:		STD_LOGIC_VECTOR( 3 DOWNTO 0)	:=	X"8";
CONSTANT	RX_Stat_Process_ARP		:		STD_LOGIC_VECTOR( 3 DOWNTO 0)	:=	X"9";
CONSTANT	RX_Stat_Process_Request	:		STD_LOGIC_VECTOR( 3 DOWNTO 0)	:=	X"A";
CONSTANT	RX_Stat_Process_Reply	:		STD_LOGIC_VECTOR( 3 DOWNTO 0)	:=	X"B";
CONSTANT	RX_Stat_SetRespAddress	:		STD_LOGIC_VECTOR( 3 DOWNTO 0)	:=	X"C";
CONSTANT	RX_Stat_WaitForTXPart	:		STD_LOGIC_VECTOR( 3 DOWNTO 0)	:=	X"D";
CONSTANT	RX_Stat_WaitForSend		:		STD_LOGIC_VECTOR( 3 DOWNTO 0)	:=	X"E";
CONSTANT	RX_Stat_NotifyTXPart	:		STD_LOGIC_VECTOR( 3 DOWNTO 0)	:=	X"F";


CONSTANT	TX_Stat_INIT					:		STD_LOGIC_VECTOR( 3 DOWNTO 0)	:=	X"0";
CONSTANT	TX_Stat_IDLE					:		STD_LOGIC_VECTOR( 3 DOWNTO 0)	:=	X"1";
CONSTANT	TX_Stat_Send_Request_Init		:		STD_LOGIC_VECTOR( 3 DOWNTO 0)	:=	X"2";
CONSTANT	TX_Stat_Wait_For_Ack			:		STD_LOGIC_VECTOR( 3 DOWNTO 0)	:=	X"3";
CONSTANT	TX_Stat_Send_Request_WFORS		:		STD_LOGIC_VECTOR( 3 DOWNTO 0)	:=	X"4";
CONSTANT	TX_Stat_Send_Request			:		STD_LOGIC_VECTOR( 3 DOWNTO 0)	:=	X"5";
CONSTANT	TX_Stat_Request_Sent			:		STD_LOGIC_VECTOR( 3 DOWNTO 0)	:=	X"6";
CONSTANT	TX_Stat_AR_Complete				:		STD_LOGIC_VECTOR( 3 DOWNTO 0)	:=	X"7";
CONSTANT	TX_Stat_NO_Response				:		STD_LOGIC_VECTOR( 3 DOWNTO 0)	:=	X"8";
CONSTANT	TX_Stat_Send_Response_Init		:		STD_LOGIC_VECTOR( 3 DOWNTO 0)	:=	X"9";
CONSTANT	TX_Stat_Wait_For_Ack_Response		:		STD_LOGIC_VECTOR( 3 DOWNTO 0)	:=	X"A";
CONSTANT	TX_Stat_Send_Response_WFORS		:		STD_LOGIC_VECTOR( 3 DOWNTO 0)	:=	X"B";
CONSTANT	TX_Stat_Send_Response			:		STD_LOGIC_VECTOR( 3 DOWNTO 0)	:=	X"C";
CONSTANT	TX_Stat_Send_Request_Init_WFORData	:		STD_LOGIC_VECTOR( 3 DOWNTO 0)	:=	X"D";

---------------------
--Timer SIGNALs
---------------------
SIGNAL	Timer				:		STD_LOGIC_VECTOR( TimerWidth-1 DOWNTO 0); --always the leftmost bit!
SIGNAL	TimeOUT_sig			:		STD_LOGIC;
SIGNAL	Timer_start			:		STD_LOGIC;
SIGNAL	Retry_CNTR			:		STD_LOGIC_VECTOR( RetryWidth-1 DOWNTO 0);
---------------------
--MacAddr Memory SIGNALs
---------------------
SIGNAL	MACADDR_RD_EN_sig		:		STD_LOGIC;
SIGNAL	MACADDR_RD_EN_OVRN		:		STD_LOGIC;
SIGNAL	MACADDR_RDADDR			:		STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL	Target_ADDR_Out_int		:		STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL	ADDR_int				:		STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL	MACADDR_DATA_OUT_sig	:		STD_LOGIC_VECTOR( MacAddrSize-1 DOWNTO 0);

SIGNAL	Req_IPAddr			:		STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
SIGNAL	SRCH_TargetIP			:		STD_LOGIC;
SIGNAL	Target_Match			:		STD_LOGIC;
SIGNAL	Target_MatchV			:		STD_LOGIC;
SIGNAL	Target_ADDR_Out		:		STD_LOGIC_VECTOR( addrWidth-1 DOWNTO 0);

---------------------
--RXQ SIGNALs
---------------------
SIGNAL	RXQ_DOUT				:		STD_LOGIC_VECTOR( DataWidth-1 DOWNTO 0);
SIGNAL	RXQ_DOUTV				:		STD_LOGIC;
SIGNAL	RXQ_Out_SOP			:		STD_LOGIC;
SIGNAL	RXQ_Out_EOP			:		STD_LOGIC;
SIGNAL	RXQ_Out_Ind			:		STD_LOGIC;
SIGNAL	RXQ_Out_Ack			:		STD_LOGIC;
SIGNAL	RXQ_Out_ErrIn			:		STD_LOGIC;
SIGNAL	RXQ_Out_ErrOut			:		STD_LOGIC;

SIGNAL	InValidEType_sig		:		STD_LOGIC;
SIGNAL	InValidEType_reg		:		STD_LOGIC;
SIGNAL	InValidEType_Rise		:		STD_LOGIC;
SIGNAL	StartOfPDUIn			:		STD_LOGIC;
SIGNAL	PDU_In_ErrIn_sig		:		STD_LOGIC;
---------------------
--FSM SIGNALs
---------------------
TYPE RX_State_Type IS
(
	INIT,
	IDLE,
	Reception_Start,
	Reception_IPGR,
	DeSer_IPGR,
	Validate_Part_1,
	Validate_Part_2,
	Validate_Part_3,
	Process_ARP,
	Process_Request,
	Process_Reply,
	SetRespAddress,
	WaitForTXPart,
	WaitForSend,
	NotifyTXPart
);

TYPE TX_State_Type IS
(
	INIT,
	IDLE,
	Send_Request_Init_WFORData,
	Send_Request_Init,
	Wait_For_Ack,
	Send_Request_WFORS,
	Send_Request,
	Request_Sent,
	Send_Request_WFORACK,
	AR_Complete,
	NO_Response
);

TYPE TX_Resp_State_Type IS
(
	INIT,
	IDLE,
	Send_Response_Init,
	Wait_For_Ack_Response,
	Send_Response_WFORS,
	Send_Response,
	WFOR_SendResp
);
ATTRIBUTE ENUM_ENCODING : STRING;

SIGNAL	RX_State				:		RX_State_Type;
SIGNAL	TX_State				:		TX_State_Type;
SIGNAL	TX_State_Resp			:		TX_Resp_State_Type;
SIGNAL 	RX_Status				:		STD_LOGIC_VECTOR( 3 DOWNTO 0);
SIGNAL 	TX_Status				:		STD_LOGIC_VECTOR( 3 DOWNTO 0);
	
SIGNAL	SendResponse			:		STD_LOGIC;
SIGNAL	ARP_ReqUest_Rise		:		STD_LOGIC;
SIGNAL	Request_Pending		:		STD_LOGIC;
SIGNAL	Valid_Response			:		STD_LOGIC;
SIGNAL	ResponseSent			:		STD_LOGIC;
SIGNAL	RespDataValid			:		STD_LOGIC;
	
	
SIGNAL	ar_TX_OPCODE			:		STD_LOGIC_VECTOR( arp_Field_len-1 DOWNTO 0);
SIGNAL	ar_TX_HWAOS			:		STD_LOGIC_VECTOR( MacAddrSize-1 DOWNTO 0);
SIGNAL	ar_TX_PRAOS			:		STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
SIGNAL	ar_TX_HWAOT			:		STD_LOGIC_VECTOR( MacAddrSize-1 DOWNTO 0);
SIGNAL	ar_TX_PRAOT			:		STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
	
SIGNAL	ar_TX_OPCODE_Resp		:		STD_LOGIC_VECTOR( arp_Field_len-1 DOWNTO 0);
SIGNAL	ar_TX_HWAOS_Resp		:		STD_LOGIC_VECTOR( MacAddrSize-1 DOWNTO 0);
SIGNAL	ar_TX_PRAOS_Resp		:		STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
SIGNAL	ar_TX_HWAOT_Resp		:		STD_LOGIC_VECTOR( MacAddrSize-1 DOWNTO 0);
SIGNAL	ar_TX_PRAOT_Resp		:		STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
	
SIGNAL	ar_RX_hrd				:		STD_LOGIC_VECTOR( arp_Field_len-1 DOWNTO 0);
SIGNAL	ar_RX_pro				:		STD_LOGIC_VECTOR( arp_Field_len-1 DOWNTO 0);
SIGNAL	ar_RX_hln_pln			:		STD_LOGIC_VECTOR( arp_Field_len-1 DOWNTO 0);
SIGNAL	ar_RX_OPCODE			:		STD_LOGIC_VECTOR( arp_Field_len-1 DOWNTO 0);
SIGNAL	ar_RX_HWAOS			:		STD_LOGIC_VECTOR( MacAddrSize-1 DOWNTO 0);
SIGNAL	ar_RX_PRAOS			:		STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
SIGNAL	ar_RX_HWAOT			:		STD_LOGIC_VECTOR( MacAddrSize-1 DOWNTO 0);
SIGNAL	ar_RX_PRAOT			:		STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
	
SIGNAL	Def_MacAddr			:		STD_LOGIC_VECTOR( MacAddrSize-1 DOWNTO 0);
SIGNAL	Def_IpAddr			:		STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
SIGNAL	Resp_IpAddr			:		STD_LOGIC_VECTOR( IPAddrSize-1 DOWNTO 0);
SIGNAL	Resp_MacAddr			:		STD_LOGIC_VECTOR( MacAddrSize-1 DOWNTO 0);

SIGNAL	DST_MacAddr_Out_Req		:		STD_LOGIC_VECTOR( MacAddrSize-1 DOWNTO 0);
SIGNAL	SRC_MacAddr_Out_Req		:		STD_LOGIC_VECTOR( MacAddrSize-1 DOWNTO 0);
SIGNAL	DST_MacAddr_Out_Resp	:		STD_LOGIC_VECTOR( MacAddrSize-1 DOWNTO 0);
SIGNAL	SRC_MacAddr_Out_Resp	:		STD_LOGIC_VECTOR( MacAddrSize-1 DOWNTO 0);

---------------------
--Serializer SIGNALs
---------------------
SIGNAL	TX_packet_register		:		STD_LOGIC_VECTOR( arp_ETHIP_len-1 DOWNTO 0);
SIGNAL	TX_packet_register_Resp	:		STD_LOGIC_VECTOR( arp_ETHIP_len-1 DOWNTO 0);
SIGNAL	RX_reg_en				:		STD_LOGIC;
SIGNAL	RX_reg_en_sig			:		STD_LOGIC;
SIGNAL	RX_reg_err			:		STD_LOGIC;
SIGNAL	RX_packet_register		:		STD_LOGIC_VECTOR( arp_ETHIP_len-1 DOWNTO 0);
SIGNAL	RX_packet_register_sig	:		STD_LOGIC_VECTOR( arp_ETHIP_len-1 DOWNTO 0);

SIGNAL	Ser_Start_Req			:		STD_LOGIC;
SIGNAL	PDU_Out_SOP_Req		:		STD_LOGIC;
SIGNAL	PDU_Out_EOP_Req		:		STD_LOGIC;
SIGNAL	PDU_DOUT_Req			:		STD_LOGIC_VECTOR( 7 DOWNTO 0);
SIGNAL	PDU_DOUTV_Req			:		STD_LOGIC;
SIGNAL	PDU_Out_ErrIn_Req		:		STD_LOGIC;
SIGNAL	PDU_Out_Ack_Req		:		STD_LOGIC;
SIGNAL	PDU_Out_Ind_Req		:		STD_LOGIC;

SIGNAL	Ser_Start_Resp			:		STD_LOGIC;
SIGNAL	PDU_Out_SOP_Resp		:		STD_LOGIC;
SIGNAL	PDU_Out_EOP_Resp		:		STD_LOGIC;
SIGNAL	PDU_DOUT_Resp			:		STD_LOGIC_VECTOR( 7 DOWNTO 0);
SIGNAL	PDU_DOUTV_Resp			:		STD_LOGIC;
SIGNAL	PDU_Out_ErrIn_Resp		:		STD_LOGIC;
SIGNAL	PDU_Out_Ack_Resp		:		STD_LOGIC;
SIGNAL	PDU_Out_Ind_Resp		:		STD_LOGIC;

---------------------
--OUT MUX SIGNALs
---------------------
TYPE OutMux_StateType IS
(
	INIT,
	IDLE,
	Grant_Req,
	WFOR_Req_Start,
	Req_IPGR,
	Grant_Resp,
	WFOR_Resp_Start,
	Resp_IPGR
);

SIGNAL	OutMux_FSMState		:		OutMux_StateType;


BEGIN

	StatusVec(3 DOWNTO 0)	<=	RX_Status;
	StatusVec(7 DOWNTO 4)	<=	TX_Status;
	---------------------------
	--The timer part
	---------------------------
	TO_Rise		:	aRise	PORT MAP (I => Timer(TimerWidth-1), C => CLK, Q => TimeOUT_sig);
	Timer_proc:PROCESS(	clk,
					Timer_start,
					Timer
					)
	BEGIN
		IF(RISING_EDGE(clk))THEN
			IF(Timer_start = Hi) THEN
				Timer	<=	Timer + 1;
			ELSE
				Timer		<=	(OTHERS => Lo);
			END IF;
		END IF;
	END PROCESS Timer_proc;
	---------------------------
	--END OF The timer part
	---------------------------
	-------------------------
	---Assigning static parts
	-------------------------
	EType_Out				<=	EType_ARP;
	
	ar_TX_OPCODE	<=	ares_op_REQ;
	TX_packet_register(arp_ETHIP_len-1
							DOWNTO
								arp_ETHIP_len-arp_Field_len)				<=	ares_hrd_Eth;--ar$hrd part
	TX_packet_register(arp_ETHIP_len-arp_Field_len-1
							DOWNTO 
								arp_ETHIP_len-2*arp_Field_len)			<=	ares_prd_IP;--ar$pro
	TX_packet_register(arp_ETHIP_len-2*arp_Field_len-1
							DOWNTO 
								arp_ETHIP_len-3*arp_Field_len)			<=	ar_hlen_Eth & ar_plen_IP;--ar$hln  & ar$pln 
	TX_packet_register(arp_ETHIP_len-3*arp_Field_len-1
							DOWNTO 
								arp_ETHIP_len-4*arp_Field_len)			<=	ar_TX_OPCODE;--OPCODE Request
	TX_packet_register(arp_ETHIP_len-4*arp_Field_len-1
							DOWNTO 
								arp_ETHIP_len-4*arp_Field_len - MACAddrSize)	<=	ar_TX_HWAOS;--ar$sha HWaddress OF sender
	TX_packet_register(2*IPAddrSize + MacAddrSize-1
							DOWNTO 
								IPAddrSize + MacAddrSize)				<=	ar_TX_PRAOS;--ar$spa Protoaddress OF sender,
	TX_packet_register(IPAddrSize + MacAddrSize-1
							DOWNTO 
								IPAddrSize)							<=	ar_TX_HWAOT;--ar$tha HWaddress OF target
	TX_packet_register(IPAddrSize-1
							DOWNTO 
								0)									<=	ar_TX_PRAOT;--ar$tpa Protoaddress OF target
								
	ar_TX_OPCODE_Resp	<=	ares_op_REP;
	TX_packet_register_Resp(arp_ETHIP_len-1
							DOWNTO
								arp_ETHIP_len-arp_Field_len)				<=	ares_hrd_Eth;--ar$hrd part
	TX_packet_register_Resp(arp_ETHIP_len-arp_Field_len-1
							DOWNTO 
								arp_ETHIP_len-2*arp_Field_len)			<=	ares_prd_IP;--ar$pro
	TX_packet_register_Resp(arp_ETHIP_len-2*arp_Field_len-1
							DOWNTO 
								arp_ETHIP_len-3*arp_Field_len)			<=	ar_hlen_Eth & ar_plen_IP;--ar$hln  & ar$pln 
	TX_packet_register_Resp(arp_ETHIP_len-3*arp_Field_len-1
							DOWNTO 
								arp_ETHIP_len-4*arp_Field_len)			<=	ar_TX_OPCODE_Resp;--OPCODE REPLY
	TX_packet_register_Resp(arp_ETHIP_len-4*arp_Field_len-1
							DOWNTO 
								arp_ETHIP_len-4*arp_Field_len - MACAddrSize)	<=	ar_TX_HWAOS_Resp;--ar$sha HWaddress OF sender
	TX_packet_register_Resp(2*IPAddrSize + MacAddrSize-1
							DOWNTO 
								IPAddrSize + MacAddrSize)				<=	ar_TX_PRAOS_Resp;--ar$spa Protoaddress OF sender,
	TX_packet_register_Resp(IPAddrSize + MacAddrSize-1
							DOWNTO 
								IPAddrSize)							<=	ar_TX_HWAOT_Resp;--ar$tha HWaddress OF target
	TX_packet_register_Resp(IPAddrSize-1
							DOWNTO 
								0)									<=	ar_TX_PRAOT_Resp;--ar$tpa Protoaddress OF target

	ar_RX_hrd		<=	RX_packet_register(arp_ETHIP_len-1
										DOWNTO
											arp_ETHIP_len-arp_Field_len);--ar$hrd part
	ar_RX_pro		<=	RX_packet_register(arp_ETHIP_len-arp_Field_len-1
										DOWNTO 
											arp_ETHIP_len-2*arp_Field_len);--ar$pro
	ar_RX_hln_pln	<=		RX_packet_register(arp_ETHIP_len-2*arp_Field_len-1
										DOWNTO 
											arp_ETHIP_len-3*arp_Field_len);--ar$hln  & ar$pln 
	ar_RX_OPCODE	<=		RX_packet_register(arp_ETHIP_len-3*arp_Field_len-1
										DOWNTO 
											arp_ETHIP_len-4*arp_Field_len);--OPCODE
	ar_RX_HWAOS	<=		RX_packet_register(arp_ETHIP_len-4*arp_Field_len-1
										DOWNTO 
											arp_ETHIP_len-4*arp_Field_len - MACAddrSize);--ar$sha HWaddress OF sender
	ar_RX_PRAOS	<=		RX_packet_register(2*IPAddrSize + MacAddrSize-1
										DOWNTO 
											IPAddrSize + MacAddrSize);--ar$spa Protoaddress OF sender,
	ar_RX_HWAOT	<=		RX_packet_register(IPAddrSize + MacAddrSize-1
										DOWNTO 
											IPAddrSize);--ar$tha HWaddress OF target
	ar_RX_PRAOT	<=		RX_packet_register(IPAddrSize-1
										DOWNTO 
											0);--ar$tpa Protoaddress OF target
		-------------------------
	--END OF Assigning static parts
	-------------------------
	
	IPADDR_CAM: MiniCAM 
	GENERIC MAP(
		DataWidth	=>	IPAddrSize,
		Elements	=>	NumOfAddresses
	)
	PORT MAP(
		CLK		=>	CLK,
		RST		=>	RST,
		CE		=>	CE,
		CFG_CE	=>	CFG_CE,
		WR_EN	=>	IPADDR_WR_EN,
		RD_EN	=>	IPADDR_RD_EN,
		DIN		=>	ADDR_DATA_IN(IPAddrSize-1 DOWNTO 0),
		ADDR_In	=>	ADDR,
		CAM_DIN	=>	ar_RX_PRAOT,
		CAM_SRCH	=>	SRCH_TargetIP,
		Match	=>	Target_Match,
		MatchV	=>	Target_MatchV,
		DOUT		=>	IPADDR_DATA_OUT,
		ADDR_Out	=>	Target_ADDR_Out,
		DOUTV	=>	IPADDR_DV
	);
	
	Inst_Req_Serializer: Serializer 
	GENERIC MAP(
		DataWidth	=>	DataWidth,
		ToSer	=>	arp_ETHIP_lenDW
	)
	PORT MAP(
		CLK		=>	CLK,
		RST		=>	RST,
		CE		=>	CE,
		Start	=>	Ser_Start_Req,
		Ser_Start	=>	PDU_Out_SOP_Req,
		Complete	=>	PDU_Out_EOP_Req,
		PIn		=>	TX_packet_register,
		SOut		=>	PDU_DOUT_Req,
		OuTV		=>	PDU_DOUTV_Req
	);
	-- PDU_DOUTV		<=	PDU_DOUTV_sig;
	-- PDU_Out_SOP	<=	PDU_Out_SOP_sig;
	
	Inst_Resp_Serializer: Serializer 
	GENERIC MAP(
		DataWidth	=>	DataWidth,
		ToSer	=>	arp_ETHIP_lenDW
	)
	PORT MAP(
		CLK		=>	CLK,
		RST		=>	RST,
		CE		=>	CE,
		Start	=>	Ser_Start_Resp,
		Ser_Start	=>	PDU_Out_SOP_Resp,
		Complete	=>	PDU_Out_EOP_Resp,
		PIn		=>	TX_packet_register_Resp,
		SOut		=>	PDU_DOUT_Resp,
		OuTV		=>	PDU_DOUTV_Resp
	);
	-- PDU_DOUTV		<=	PDU_DOUTV_sig;
	-- PDU_Out_SOP	<=	PDU_Out_SOP_sig;
	
	Inst_DeSerializer: DeSerializer 
	GENERIC MAP(
		DataWidth	=>	DataWidth,
		ToDeSer	=>	arp_ETHIP_lenDW
	)
	PORT MAP(
		CLK		=>	CLK,
		RST		=>	RST,
		CE		=>	CE,
		SIn		=>	RXQ_DOUT,
		Ser_DV	=>	RXQ_DOUTV,
		Ser_SOP	=>	RXQ_Out_SOP,
		Ser_EOP	=>	RXQ_Out_EOP,
		Ser_ErrIn	=>	RXQ_Out_ErrOut,
		POut		=>	RX_packet_register_sig,
		POuTV	=>	RX_reg_en_sig,
		POuT_err	=>	RX_reg_err
	);
	RX_reg_en	<=	RX_reg_en_sig;
	RX_reg	:	aRegister	GENERIC MAP(Size =>	arp_ETHIP_len)	PORT MAP(D=>RX_packet_register_sig,C=>CLK,CE=>RX_reg_en,Q=>RX_packet_register);
	
	MACADDR_RD_EN_sig	<=	MACADDR_RD_EN and MACADDR_RD_EN_OVRN;
	AINT_CDIFF: Connect_Diff GENERIC MAP	(DST_Width => ADDR_int'Length,SRC_WIDTH => ADDR'Length) 
					PORT MAP		(DST => ADDR_int,SRC => ADDR);
	TAOUT_CDIFF: Connect_Diff GENERIC MAP	(DST_Width => Target_ADDR_Out_int'Length,SRC_WIDTH => Target_ADDR_Out'Length) 
					PORT MAP		(DST => Target_ADDR_Out_int,SRC => Target_ADDR_Out);

	with MACADDR_RD_EN_sig	SELECT MACADDR_RDADDR <= Target_ADDR_Out_int	WHEN Lo, ADDR_int WHEN OTHERS;

	MACADDR_RAM: aRAM 
	GENERIC MAP( Size => MacAddrSize ) 
	PORT MAP(	D	=>	ADDR_DATA_IN,
			WE	=>	MACADDR_WR_EN,
			WCLK	=>	CLK,
			A	=>	ADDR_int,
			RA	=>	MACADDR_RDADDR,
			DO	=>	MACADDR_DATA_OUT_sig 
			);
	MACADDR_DATA_OUT	<=	MACADDR_DATA_OUT_sig;
	
	DefIPAddr_proc:PROCESS(	clk,
						rst,
						CFG_CE,
						IPADDR_WR_EN,
						ADDR_int
						)
	BEGIN
		IF(RISING_EDGE(clk))THEN
			IF(rst = Hi) THEN
				Def_IPAddr	<=	(OTHERS => Lo);
			ELSE
				IF(CFG_CE = Hi)THEN
					IF(IPADDR_WR_EN = Hi and ADDR_int = STD_LOGIC_VECTOR(to_unsigned(0,ADDR_int'Length))) THEN
						Def_IPAddr	<=	ADDR_DATA_IN(IPAddrSize-1 DOWNTO 0);
					END IF;
				END IF;
			END IF;
		END IF;
	END PROCESS DefIPAddr_proc;

	DefMacAddr_proc:PROCESS(	clk,
						rst,
						CFG_CE,
						MACADDR_WR_EN,
						ADDR_int
						)
	BEGIN
		IF(RISING_EDGE(clk))THEN
			IF(rst = Hi) THEN
				Def_MacAddr	<=	X"001122334455";
			ELSE
				IF(CFG_CE = Hi)THEN
					IF(MACADDR_WR_EN = Hi and ADDR_int = STD_LOGIC_VECTOR(to_unsigned(0,ADDR_int'Length))) THEN
						Def_MacAddr	<=	ADDR_DATA_IN;
					END IF;
				END IF;
			END IF;
		END IF;
	END PROCESS DefMacAddr_proc;
	
	with EType_In SELECT InValidEType_sig <= Lo WHEN EType_ARP, Hi WHEN OTHERS;
	StartOfPDUIn	<=	PDU_DINV and PDU_In_SOP;
	IVETYP_reg	:	aFlop	PORT MAP (D => InValidEType_sig, C => CLK, CE => StartOfPDUIn, Q => InValidEType_reg);
	IVETYP_rise	:	aRise	PORT MAP (I => InValidEType_reg, C => CLK, Q => InValidEType_Rise);

	PDU_In_ErrIn_sig	<=	PDU_In_ErrIn or InValidEType_Rise; --This guarantes that there will be only ARP PDUs IN the queue;
	RX_Queue: PDUQueue --IN pass-through mode!
	GENERIC MAP
	(
		DataWidth		=>	DataWidth,
		SYNC_IN		=>	RX_SYNC_IN,
		SYNC_OUT		=>	true, -- must be true
		SYNC_CTRL		=>	false, --Don't care, it's IN passthrough mode
		MINPDUSize	=>	arp_ETHIP_len,
		MAXPDUSize	=>	arp_ETHIP_len,
		MaxPDUToQ		=>	DefPDUToQ
	)
	PORT MAP
	(
		CLK			=>	CLK,
		CE_In		=>	CE,
		CE_Out		=>	CE,
		RST			=>	RST,
		DIN			=>	PDU_DIN,
		DINV			=>	PDU_DINV,
		In_SOP		=>	PDU_In_SOP,
		In_EOP		=>	PDU_In_EOP,
		In_Ind		=>	PDU_In_Ind,
		In_ErrIn		=>	PDU_In_ErrIn_sig,
		In_Ack		=>	PDU_In_Ack,
		In_ErrOut		=>	PDU_In_ErrOut,
		DOUT			=>	RXQ_DOUT,
		DOUTV		=>	RXQ_DOUTV,
		Out_SOP		=>	RXQ_Out_SOP,
		Out_EOP		=>	RXQ_Out_EOP,
		Out_Ind		=>	RXQ_Out_Ind,
		Out_ErrOut	=>	RXQ_Out_ErrOut,
		Out_Ack		=>	RXQ_Out_Ack,
		Out_ErrIn		=>	RXQ_Out_ErrIn,
		CTRL_DOUT		=>	OPEN,
		CTRL_DV		=>	OPEN,
		CTRL_ErrOut	=>	OPEN,
		CTRL_Ind		=>	OPEN,
		CTRL_Ack		=>	Lo,
		CTRL_FWD		=>	Hi,
		CTRL_Pause	=>	Lo,
		CTRL_DROP_ERR	=>	Lo,
		USER_IN		=>	STD_LOGIC_VECTOR(to_unsigned(0,USER_width)),
		USER_Out		=>	OPEN,
		USER_Out_CTRL	=>	OPEN
	);

	RX_FSM:PROCESS(	clk,
					RST,
					CE,
					RX_State,
					RXQ_Out_Ind,
					RXQ_Out_ErrOut,
					EType_In,
					RXQ_Out_SOP,
					RXQ_DOUTV,
					RX_reg_en,
					RX_reg_err,
					ar_RX_hrd,
					ar_RX_pro,
					ar_RX_hln_pln,
					ar_RX_OPCODE,
					Request_Pending,
					Target_MatchV,
					Target_Match,
					ResponseSent,
					ar_RX_PRAOS
					)
	BEGIN
		IF(RISING_EDGE(clk))THEN
			IF(RST = Hi) THEN
				MACADDR_RD_EN_OVRN	<=	Hi;
				Valid_Response		<=	Lo;
				SRCH_TargetIP		<=	Lo;
				RXQ_Out_Ack		<=	Lo;
				RXQ_Out_ErrIn		<=	Lo;
				SendResponse		<=	Lo;
				RespDataValid		<=	Lo;
				RX_Status			<=	RX_Stat_INIT;
				RX_State			<=	INIT;
			ELSE
				IF(CE = Hi) THEN
					CASE RX_State IS
						WHEN IDLE =>
							RX_Status			<=	RX_Stat_IDLE;
							SRCH_TargetIP		<=	Lo;
							MACADDR_RD_EN_OVRN	<=	Hi;
							RXQ_Out_ErrIn		<=	Lo;
							RXQ_Out_Ack		<=	Lo;
							Valid_Response		<=	Lo;
							SendResponse		<=	Lo;
							RespDataValid		<=	Lo;
							IF(RXQ_Out_Ind = Hi) THEN
								RX_State	<=	Reception_Start;
							ELSE
								RX_State	<=	IDLE;
							END IF;
						WHEN	Reception_Start =>
							RX_Status		<=	RX_Stat_Reception_Start;
							RXQ_Out_Ack	<=	Hi;
							IF(RXQ_Out_ErrOut = Lo) THEN
								IF(RXQ_Out_SOP = Hi and RXQ_DOUTV = Hi) THEN
									RX_State	<=	Reception_IPGR;
								ELSE
									RX_State	<=	Reception_Start;
								END IF;
							ELSE
								RX_State	<=	IDLE;
							END IF;
						WHEN Reception_IPGR =>
							RX_Status		<=	RX_Stat_Reception_IPGR;
							RXQ_Out_Ack	<=	Lo;
							IF(RXQ_Out_ErrOut = Lo) THEN
								IF(RX_reg_en = Lo and RX_reg_err = Lo) THEN
									RX_State	<=	DeSer_IPGR;
								ELSE
									RX_State	<=	Reception_IPGR;
								END IF;
							ELSE
								RX_State	<=	IDLE;
							END IF;
						WHEN DeSer_IPGR =>
							RX_Status	<=	RX_Stat_DeSer_IPGR;
							IF(RXQ_Out_ErrOut = Lo) THEN
								IF(RX_reg_en = Hi and RX_reg_err = Lo) THEN
									RX_State	<=	Validate_Part_1;
								ELSIF(RX_reg_err = Hi) THEN --Size mismatch
									RX_State	<=	IDLE;
								ELSE
									RX_State	<=	DeSer_IPGR;
								END IF;
							ELSE
								RX_State	<=	IDLE;
							END IF;
						-- WHEN Validate => --ezt még szét lehet bontani több fázisra akár
						WHEN Validate_Part_1 => --ezt még szét lehet bontani több fázisra akár
							RX_Status	<=	RX_Stat_Validate_Part_1;
							IF(ar_RX_hrd = ares_hrd_Eth)THEN
								RX_State	<=	Validate_Part_2;
							ELSE
								RX_State	<=	IDLE;
							END IF;
						WHEN Validate_Part_2 => --ezt még szét lehet bontani több fázisra akár
							RX_Status	<=	RX_Stat_Validate_Part_2;
							IF(ar_RX_pro = ares_prd_IP)THEN
								RX_State	<=	Validate_Part_3;
							ELSE
								RX_State	<=	IDLE;
							END IF;
						WHEN Validate_Part_3 => --ezt még szét lehet bontani több fázisra akár
							RX_Status	<=	RX_Stat_Validate_Part_3;
							IF(ar_RX_hln_pln = ar_hplen_EthIP)THEN
								RX_State	<=	Process_ARP;
							ELSE
								RX_State	<=	IDLE;
							END IF;
						WHEN Process_ARP =>
							RX_Status	<=	RX_Stat_Process_ARP;
							IF(ar_RX_OPCODE = ares_op_REQ) THEN
								RX_State	<=	Process_Request;
							ELSIF(ar_RX_OPCODE = ares_op_REP and Request_Pending = Hi) THEN
								RX_State	<=	Process_Reply;
							ELSE
								RX_State	<=	IDLE;
							END IF;
						WHEN Process_Request =>
							RX_Status			<=	RX_Stat_Process_Request;
							MACADDR_RD_EN_OVRN	<=	Lo; --wait for result
							SRCH_TargetIP		<=	Hi;
							IF(Target_MatchV = Hi and Target_Match = Hi)THEN
								RX_State	<=	SetRespAddress;
							ELSIF(Target_MatchV = Hi and Target_Match = Lo)THEN
								RX_State	<=	IDLE;
							ELSE
								RX_State	<=	Process_Request;
							END IF;
						WHEN SetRespAddress =>
							RX_Status			<=	RX_Stat_SetRespAddress;
							Resp_IpAddr		<=	ar_RX_PRAOT;
							Resp_MacAddr		<=	MACADDR_DATA_OUT_sig;
							SRCH_TargetIP		<=	Lo;
							MACADDR_RD_EN_OVRN	<=	Hi; --wait for result
							SendResponse		<=	Hi;
							IF(ResponseSent = Lo)THEN
								RX_State		<=	WaitForTXPart;
							ELSE
								RX_State		<=	WaitForSend;
							END IF;
						WHEN WaitForTXPart =>
							RX_Status	<=	RX_Stat_WaitForTXPart;
							IF(ResponseSent = Lo)THEN
								RX_State		<=	WaitForTXPart;
							ELSE
								RX_State		<=	WaitForSend;
							END IF;
						WHEN	WaitForSend =>
							RX_Status			<=	RX_Stat_WaitForSend;
							RespDataValid		<=	Hi;
							IF(ResponseSent = Lo)THEN
								RX_State		<=	IDLE;
							ELSE
								RX_State	<=	WaitForSend;
							END IF;
						WHEN Process_Reply =>
							RX_Status		<=	RX_Stat_Process_Reply;
							SRCH_TargetIP	<=	Lo; 
							IF(ar_RX_PRAOS = ar_TX_PRAOT) THEN
								RX_State	<=	NotifyTXPart;
							ELSE
								RX_State	<=	IDLE;
							END IF;
						WHEN NotifyTXPart =>
							RX_Status			<=	RX_Stat_NotifyTXPart;
							Valid_Response		<=	Hi;
							RX_State			<=	IDLE;
						WHEN OTHERS => --INIT
						-- WHEN INIT =>
							RX_Status			<=	RX_Stat_INIT;
							MACADDR_RD_EN_OVRN	<=	Hi;
							Valid_Response		<=	Lo;
							SRCH_TargetIP		<=	Lo;
							RXQ_Out_Ack		<=	Lo;
							RXQ_Out_ErrIn		<=	Lo;
							SendResponse		<=	Lo;
							RespDataValid		<=	Lo;
							RX_State			<=	IDLE;
					END CASE;
				END IF;
			END IF;
		END IF;
	END PROCESS RX_FSM;
	
	
	AR_Rise	:	aRise	PORT MAP (I => ARP_ReqUest, C => CLK, Q => ARP_ReqUest_Rise);
	TIP_reg	:	aRegister	GENERIC MAP(Size =>	IPAddrSize)	PORT MAP(D=>ARP_DST_IP_addr,C=>CLK,CE=>ARP_ReqUest_Rise,Q=>Req_IPAddr);
	
	TX_FSM:PROCESS(	clk,RST,CE,TX_State,ARP_ReqUest,PDU_Out_ErrIn_Req,PDU_Out_Ack_Req,PDU_DOUTV_Req,PDU_Out_SOP_Req,Valid_Response,TimeOUT_sig,Retry_CNTR)
	BEGIN
		IF(RISING_EDGE(clk))THEN
			IF(RST = Hi) THEN
				ARP_RESPONSEV		<=	Lo;
				ARP_RESPONSE_ERR	<=	Lo;
				ARP_DST_MAC_addr	<=	(OTHERS => Lo);
				PDU_Out_Ind_Req	<=	Lo;
				Ser_Start_Req		<=	Lo;
				Request_Pending	<=	Lo;
				Timer_start		<=	Lo;
				TX_Status			<=	TX_Stat_INIT;
				TX_State			<=	INIT;
			ELSE
				IF(CE = Hi) THEN
					CASE TX_State IS
						WHEN IDLE =>
							ARP_RESPONSEV		<=	Lo;
							ARP_RESPONSE_ERR	<=	Lo;
							ARP_DST_MAC_addr	<=	(OTHERS => Lo);
							PDU_Out_Ind_Req	<=	Lo;
							Ser_Start_Req		<=	Lo;
							Request_Pending	<=	Lo;
							Timer_start		<=	Lo;
							TX_Status			<=	TX_Stat_INIT;
							TX_Status			<=	TX_Stat_IDLE;
							IF(ARP_ReqUest = Hi) THEN
								TX_State	<=	Send_Request_Init_WFORData;
							ELSE
								TX_State	<=	IDLE;
							END IF;
						WHEN	Send_Request_Init_WFORData =>
							TX_Status	<=	TX_Stat_Send_Request_Init_WFORData;
							IF(ARP_ReqUest = Hi) THEN
								TX_State	<=	Send_Request_Init;
							ELSE
								TX_State	<=	IDLE;
							END IF;
						WHEN Send_Request_Init =>
							TX_Status			<=	TX_Stat_Send_Request_Init;
							Retry_CNTR		<=	(OTHERS => Lo);
							Request_Pending	<=	Hi;
							ar_TX_HWAOT		<=	Eth_BroadcastAddr;
							ar_TX_PRAOT		<=	Req_IPAddr;
							ar_TX_HWAOS		<=	Def_MacAddr;
							ar_TX_PRAOS		<=	Def_IpAddr;
							DST_MacAddr_Out_Req	<=	Eth_BroadcastAddr;
							SRC_MacAddr_Out_Req	<=	Def_MacAddr;
							IF(ARP_ReqUest = Hi)THEN
								TX_State	<=	Wait_For_Ack;
							ELSE
								TX_State	<=	IDLE;
							END IF;
						WHEN Wait_For_Ack =>
							PDU_Out_Ind_Req	<=	Hi;
							TX_Status			<=	TX_Stat_Wait_For_Ack;
							IF(PDU_Out_ErrIn_Req = Lo and ARP_ReqUest = Hi)THEN
								IF(PDU_Out_Ack_Req = Hi) THEN
									IF(PDU_DOUTV_Req = Lo) THEN
										TX_State	<=	Send_Request;
									ELSE
										TX_State	<=	Send_Request_WFORS;
									END IF;
								ELSE
									TX_State	<=	Wait_For_Ack;
								END IF;
							ELSE
								TX_State	<=	IDLE;
							END IF;
						WHEN Send_Request_WFORS =>
							TX_Status		<=	TX_Stat_Send_Request_WFORS;
							IF(PDU_DOUTV_Req = Lo) THEN
								TX_State	<=	Send_Request;
							ELSE
								TX_State	<=	Send_Request_WFORS;
							END IF;
						WHEN Send_Request =>
							Ser_Start_Req	<=	Hi;
							TX_Status		<=	TX_Stat_Send_Request;
							IF(ARP_ReqUest = Hi) THEN
								IF(PDU_DOUTV_Req = Hi and PDU_Out_SOP_Req = Hi)THEN
									TX_State	<=	Request_Sent;
								ELSE
									TX_State	<=	Send_Request;
								END IF;
							ELSE
								TX_State	<=	IDLE;
							END IF;
						WHEN	Request_Sent =>
							Timer_start		<=	Hi;
							PDU_Out_Ind_Req	<=	Lo;
							Ser_Start_Req		<=	Lo;
							TX_Status			<=	TX_Stat_Request_Sent;
							IF(ARP_ReqUest = Hi) THEN
								IF(Valid_Response = Hi) THEN
									TX_State	<=	AR_Complete;
								ELSIF(Valid_Response = Lo and TimeOUT_sig = Hi) THEN
									IF(Retry_CNTR = RetryCnt_vec) THEN
										TX_State	<=	NO_Response;
									ELSE
										Retry_CNTR	<=	Retry_CNTR + 1;
										TX_State		<=	Send_Request_WFORACK;
									END IF;
								ELSE
									TX_State	<=	Request_Sent;
								END IF;
							ELSE
								TX_State	<=	IDLE;
							END IF;
						WHEN Send_Request_WFORACK =>
							PDU_Out_Ind_Req	<=	Hi;
							Timer_start		<=	Lo;
							IF(ARP_ReqUest = Hi) THEN
								IF(Valid_Response = Hi) THEN
									TX_State	<=	AR_Complete;
								ELSE
									IF(PDU_Out_Ack_Req = Hi and PDU_Out_ErrIn_Req = Lo)THEN
										TX_State	<=	Send_Request;
									ELSE
										TX_State	<=	Send_Request_WFORACK;
									END IF;
								END IF;
							ELSE
								TX_State	<=	IDLE;
							END IF;
						WHEN AR_Complete =>
							ARP_RESPONSEV		<=	Hi;
							ARP_DST_MAC_addr	<=	ar_RX_HWAOS;
							TX_Status			<=	TX_Stat_AR_Complete;
							IF(ARP_ReqUest = Lo) THEN
								TX_State	<=	IDLE;
							ELSE
								TX_State	<=	AR_Complete;
							END IF;
						WHEN NO_Response =>
							ARP_RESPONSE_ERR	<=	Hi;
							TX_Status			<=	TX_Stat_NO_Response;
							IF(ARP_ReqUest = Lo) THEN
								TX_State			<=	IDLE;
							ELSE
								TX_State			<=	NO_Response;
							END IF;
							-- IF(TX_SYNC_OUT) THEN --magnóóka :) <3
						WHEN OTHERS => --INIT
						-- WHEN INIT =>
							ARP_RESPONSEV		<=	Lo;
							ARP_RESPONSE_ERR	<=	Lo;
							ARP_DST_MAC_addr	<=	(OTHERS => Lo);
							PDU_Out_Ind_Req	<=	Lo;
							Ser_Start_Req		<=	Lo;
							Request_Pending	<=	Lo;
							Timer_start		<=	Lo;
							TX_Status			<=	TX_Stat_INIT;
							TX_State			<=	IDLE;
					END CASE;
				END IF;
			END IF;
		END IF;
	END PROCESS TX_FSM;
	
	TX_Resp_FSM:PROCESS(	clk,
						RST,
						CE,
						TX_State_Resp,
						SendResponse,
						PDU_DOUTV_Resp,
						PDU_Out_ErrIn_Resp,
						PDU_Out_SOP_Resp,
						PDU_Out_Ack_Resp
						)
	BEGIN
		IF(RISING_EDGE(clk))THEN
			IF(RST = Hi) THEN
				PDU_Out_Ind_Resp		<=	Lo;
				Ser_Start_Resp			<=	Lo;
				TX_State_Resp			<=	INIT;
			ELSE
				IF(CE = Hi) THEN
					CASE TX_State_Resp IS
						WHEN IDLE =>
							ResponseSent			<=	Lo;
							PDU_Out_Ind_Resp		<=	Lo;
							Ser_Start_Resp			<=	Lo;
							IF(SendResponse = Hi) THEN
								TX_State_Resp	<=	Send_Response_Init;
							ELSE
								TX_State_Resp	<=	IDLE;
							END IF;
						WHEN Send_Response_Init =>
							ResponseSent			<=	Hi;
							ar_TX_HWAOT_Resp		<=	ar_RX_HWAOS;
							ar_TX_PRAOT_Resp		<=	ar_RX_PRAOS;
							ar_TX_HWAOS_Resp		<=	Resp_MacAddr;
							ar_TX_PRAOS_Resp		<=	Resp_IpAddr;
							DST_MacAddr_Out_Resp	<=	ar_RX_HWAOS;
							SRC_MacAddr_Out_Resp	<=	Resp_MacAddr;
							IF(RespDataValid = Hi) THEN
								TX_State_Resp	<=	Wait_For_Ack_Response;
							ELSE
								TX_State_Resp	<=	Send_Response_Init;
							END IF;
						WHEN Wait_For_Ack_Response =>
							PDU_Out_Ind_Resp	<=	Hi;
							IF(PDU_Out_ErrIn_Resp = Lo) THEN
								IF(PDU_Out_Ack_Resp = Hi) THEN
									IF(PDU_DOUTV_Resp = Lo) THEN
										TX_State_Resp	<=	Send_Response;
									ELSE
										TX_State_Resp	<=	Send_Response_WFORS;
									END IF;
								ELSE
									TX_State_Resp	<=	Wait_For_Ack_Response;
								END IF;
							ELSE
								TX_State_Resp	<=	IDLE;
							END IF;
						WHEN Send_Response_WFORS =>
							IF(PDU_DOUTV_Resp = Lo) THEN
								TX_State_Resp	<=	Send_Response;
							ELSE
								TX_State_Resp	<=	Send_Response_WFORS;
							END IF;
						WHEN Send_Response =>
							Ser_Start_Resp	<=	Hi;
							IF(PDU_DOUTV_Resp = Hi and PDU_Out_SOP_Resp = Hi) THEN
								TX_State_Resp	<=	WFOR_SendResp;
							ELSE
								TX_State_Resp	<=	Send_Response;
							END IF;
						WHEN WFOR_SendResp =>
							ResponseSent	<=	Lo;
							Ser_Start_Resp	<=	Lo;
							IF(SendResponse = Hi) THEN
								TX_State_Resp	<=	WFOR_SendResp;
							ELSE
								TX_State_Resp	<=	IDLE;
							END IF;
						WHEN OTHERS => --INIT
						-- WHEN INIT =>
							PDU_Out_Ind_Resp		<=	Lo;
							Ser_Start_Resp		<=	Lo;
							TX_State_Resp		<=	IDLE;
					END CASE;
				END IF;
			END IF;
		END IF;
	END PROCESS TX_Resp_FSM;
	
	OutMuxFSM_proc:PROCESS(clk,rst,CE,OutMux_FSMState)
	BEGIN
		IF(RISING_EDGE(clk))THEN
			IF(rst = Hi) THEN
				DST_MacAddr_Out	<=	(OTHERS => Lo);
				SRC_MacAddr_Out	<=	(OTHERS => Lo);
				PDU_DOUT			<=	(OTHERS => Lo);
				PDU_DOUTV			<=	Lo;
				PDU_Out_SOP		<=	Lo;
				PDU_Out_EOP		<=	Lo;
				PDU_Out_Ind		<=	Lo;
				PDU_Out_Ack_Req	<=	Lo;
				PDU_Out_ErrIn_Req	<=	Lo;
				PDU_Out_Ack_Resp	<=	Lo;
				PDU_Out_ErrIn_Resp	<=	Lo;
				OutMux_FSMState	<=	INIT;
			ELSIF(rst = Lo AND CE = Hi) THEN
				CASE OutMux_FSMState IS
					WHEN IDLE =>
						DST_MacAddr_Out	<=	(OTHERS => Lo);
						SRC_MacAddr_Out	<=	(OTHERS => Lo);
						PDU_DOUT			<=	(OTHERS => Lo);
						PDU_DOUTV			<=	Lo;
						PDU_Out_SOP		<=	Lo;
						PDU_Out_EOP		<=	Lo;
						PDU_Out_Ind		<=	Lo;
						PDU_Out_ErrOut		<=	Lo;
						PDU_Out_Ack_Req	<=	Lo;
						PDU_Out_ErrIn_Req	<=	Lo;
						PDU_Out_Ack_Resp	<=	Lo;
						PDU_Out_ErrIn_Resp	<=	Lo;
						IF(PDU_Out_Ind_Req = Hi)THEN
							OutMux_FSMState	<=	Grant_Req;
						ELSIF(PDU_Out_Ind_Req = Lo AND PDU_Out_Ind_Resp = Hi)THEN
							OutMux_FSMState	<=	Grant_Resp;
						ELSE
							OutMux_FSMState	<=	IDLE;
						END IF;
					WHEN Grant_Req =>
						PDU_Out_ErrIn_Req	<=	PDU_Out_ErrIn;
						IF(PDU_Out_Ind_Req = Hi)THEN
							IF(TX_SYNC_OUT)THEN
								PDU_Out_Ind	<=	PDU_Out_Ind_Req;
								IF(PDU_Out_Ind_Req = Hi AND PDU_Out_Ack = Hi)THEN
									OutMux_FSMState	<=	WFOR_Req_Start;
								ELSE
									OutMux_FSMState	<=	Grant_Req;
								END IF;
							ELSE
								OutMux_FSMState	<=	WFOR_Req_Start;
							END IF;
						ELSE
							OutMux_FSMState	<=	IDLE;
						END IF;
					WHEN WFOR_Req_Start =>
						PDU_Out_ErrIn_Req	<=	PDU_Out_ErrIn;
						PDU_Out_Ack_Req	<=	Hi;
						DST_MacAddr_Out	<=	DST_MacAddr_Out_Req;
						SRC_MacAddr_Out	<=	SRC_MacAddr_Out_Req;
						PDU_DOUT			<=	PDU_DOUT_Req;
						PDU_DOUTV			<=	PDU_DOUTV_Req;
						PDU_Out_SOP		<=	PDU_Out_SOP_Req;
						PDU_Out_EOP		<=	PDU_Out_EOP_Req;
						IF(PDU_Out_Ind_Req = Hi AND PDU_Out_SOP_Req = Hi AND PDU_DOUTV_Req = Hi)THEN
							OutMux_FSMState	<=	Req_IPGR;
						ELSIF(PDU_Out_Ind_Req = Lo)THEN
							OutMux_FSMState	<=	IDLE;
						ELSE
							OutMux_FSMState	<=	WFOR_Req_Start;
						END IF;
					WHEN Req_IPGR =>
						PDU_Out_ErrIn_Req	<=	PDU_Out_ErrIn;
						PDU_Out_Ack_Req	<=	Lo;
						DST_MacAddr_Out	<=	DST_MacAddr_Out_Req;
						SRC_MacAddr_Out	<=	SRC_MacAddr_Out_Req;
						PDU_DOUT			<=	PDU_DOUT_Req;
						PDU_DOUTV			<=	PDU_DOUTV_Req;
						PDU_Out_SOP		<=	PDU_Out_SOP_Req;
						PDU_Out_EOP		<=	PDU_Out_EOP_Req;
						IF((PDU_Out_EOP_Req = Hi AND PDU_DOUTV_Req = Hi) OR PDU_Out_ErrIn = Hi)THEN
							OutMux_FSMState	<=	IDLE;
						ELSE
							OutMux_FSMState	<=	Req_IPGR;
						END IF;
					WHEN Grant_Resp =>
						PDU_Out_ErrIn_Resp	<=	PDU_Out_ErrIn;
						IF(PDU_Out_Ind_Resp = Hi)THEN
							IF(TX_SYNC_OUT)THEN
								PDU_Out_Ind	<=	PDU_Out_Ind_Resp;
								IF(PDU_Out_Ind_Resp = Hi AND PDU_Out_Ack = Hi)THEN
									OutMux_FSMState	<=	WFOR_Resp_Start;
								ELSE
									OutMux_FSMState	<=	Grant_Resp;
								END IF;
							ELSE
								OutMux_FSMState	<=	WFOR_Resp_Start;
							END IF;
						ELSE
							OutMux_FSMState	<=	IDLE;
						END IF;
					WHEN WFOR_Resp_Start =>
						PDU_Out_ErrIn_Resp	<=	PDU_Out_ErrIn;
						PDU_Out_Ack_Resp	<=	Hi;
						DST_MacAddr_Out	<=	DST_MacAddr_Out_Resp;
						SRC_MacAddr_Out	<=	SRC_MacAddr_Out_Resp;
						PDU_DOUT			<=	PDU_DOUT_Resp;
						PDU_DOUTV			<=	PDU_DOUTV_Resp;
						PDU_Out_SOP		<=	PDU_Out_SOP_Resp;
						PDU_Out_EOP		<=	PDU_Out_EOP_Resp;
						IF(PDU_Out_Ind_Resp = Hi AND PDU_Out_SOP_Resp = Hi AND PDU_DOUTV_Resp = Hi)THEN
							OutMux_FSMState	<=	Resp_IPGR;
						ELSIF(PDU_Out_Ind_Resp = Lo)THEN
							OutMux_FSMState	<=	IDLE;
						ELSE
							OutMux_FSMState	<=	WFOR_Resp_Start;
						END IF;
					WHEN Resp_IPGR =>
						PDU_Out_ErrIn_Resp	<=	PDU_Out_ErrIn;
						PDU_Out_Ack_Resp	<=	Lo;
						DST_MacAddr_Out	<=	DST_MacAddr_Out_Resp;
						SRC_MacAddr_Out	<=	SRC_MacAddr_Out_Resp;
						PDU_DOUT			<=	PDU_DOUT_Resp;
						PDU_DOUTV			<=	PDU_DOUTV_Resp;
						PDU_Out_SOP		<=	PDU_Out_SOP_Resp;
						PDU_Out_EOP		<=	PDU_Out_EOP_Resp;
						IF((PDU_Out_EOP_Resp = Hi AND PDU_DOUTV_Resp = Hi) OR PDU_Out_ErrIn = Hi)THEN
							OutMux_FSMState	<=	IDLE;
						ELSE
							OutMux_FSMState	<=	Resp_IPGR;
						END IF;
					-- WHEN OTHERS => --INIT
					WHEN INIT =>
						OutMux_FSMState	<=	IDLE;
				END CASE;
			END IF;
		END IF;
	END PROCESS OutMuxFSM_proc;
	
END ArchARPModuleBehav;
