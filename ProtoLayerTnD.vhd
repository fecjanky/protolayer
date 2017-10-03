--
-- ProtoLayerTnD.vhd
-- ============
--
-- (C) Ferenc Janky, BME TMIT
--   file name:	ProtoLayerTnD.vhd
--   PACKAGE:		ProtoLayerTypesAndDefs
--
-- RegExp for replacing ENTITY description to instantiation:
----------------------------------
-- for PORT:
-- Find:
-- \t(.*)\t\t.*:.*;
-- Replace:
-- \t\1\t\t=>\t\1,
---------------------------
-- for generic:
--find: 
--\t(.*)\t\t.*:.*:=(.*);
--replace:
--\t\1\t\t=>\t\2,
-- ====================================================================
-- 					FSM template
-- ====================================================================
-- TYPE FSM_StateType IS
-- (
	-- INIT,
	-- IDLE
-- );
-- ATTRIBUTE	ENUM_ENCODING	:	STRING;

-- SIGNAL	FSM_State			:	FSM_StateType;
--
-- FSM_proc:PROCESS(clk,rst,CE,FSM_State)
-- BEGIN
	-- IF(RISING_EDGE(clk))THEN
		-- IF(rst = Hi) THEN
			-- FSM_State	<=	INIT;
		-- ELSIF(rst = Lo AND CE = Hi) THEN
			-- CASE FSM_State IS
				-- WHEN IDLE =>
				-- -- WHEN OTHERS => --INIT
				-- WHEN INIT =>
					-- FSM_State	<=	IDLE;
			-- END CASE;
		-- END IF;
	-- END IF;
-- END PROCESS FSM_proc;
-- ====================================================================
-- 					END OF FSM template
-- ====================================================================
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.MATH_REAL.ALL;

PACKAGE ProtoLayerTypesAndDefs IS

	function maximum(
		left,right : INTEGER)-- inputs
		return INTEGER;

	function maximum(
		left,right : unsigned)-- inputs
		return unsigned;
		
	function absolute( val : INTEGER) return INTEGER;
	---------------------
	--Global CONSTANTs
	---------------------
	CONSTANT	Hi					:		STD_LOGIC					:=	'1';
	CONSTANT	Lo					:		STD_LOGIC					:=	'0';
	CONSTANT	Low					:		STD_LOGIC					:=	'0';
	---------------------
	--END OF Global CONSTANTs
	---------------------
	
	---------------------
	--ProtoModule CONSTANTs
	---------------------
	CONSTANT	FIFO_Width			:		INTEGER					:=	18;
	CONSTANT	FIFO_real_Width		:		INTEGER					:=	16;
	CONSTANT	DefDataWidth			:		INTEGER					:=	8;
	CONSTANT	FIFO_parity_Width		:		INTEGER					:=	FIFO_Width - FIFO_real_Width;
	CONSTANT	AUX_signals			:		INTEGER					:=	4;--SOP,EOP,DV,Error
	CONSTANT	USER_width			:		INTEGER					:=	FIFO_Width-DefDataWidth-AUX_signals;--SOP,EOP,DV,Error
	
	CONSTANT	DefMinPDUSize			:		INTEGER					:=	64;
	CONSTANT	DefMaxPDUSize			:		INTEGER					:=	1500;
	CONSTANT	DefPDUToQ				:		INTEGER					:=	30;
	
	CONSTANT	PDUQ_INPUT_DELAY		:		INTEGER					:=	2;

	CONSTANT	DefMinSDUSize			:		INTEGER					:=	64;
	CONSTANT	DefMaxSDUSize			:		INTEGER					:=	1500;
	CONSTANT	DefPCISize			:		INTEGER					:=	64;
	
	CONSTANT	DefToSer				:		INTEGER					:=	14;
	CONSTANT	DefToDeSer			:		INTEGER					:=	14;
	
	CONSTANT	DefCAMElems			:		INTEGER					:=	2;
	
	CONSTANT	DefAuxWidth			:		INTEGER					:=	6;
	---------------------
	--END OF ProtoModule CONSTANTs
	---------------------
	
	---------------------
	--Ethernet CONSTANTs
	---------------------
	CONSTANT	Eth_BroadcastAddr		:		STD_LOGIC_VECTOR(47 DOWNTO 0)	:=	X"ffffffffffff";
	CONSTANT	MacAddrSize			:		INTEGER					:=	48;
	CONSTANT	EtherTypeSize			:		INTEGER					:=	16;
	CONSTANT	MacPCILength			:		INTEGER					:=	( 2*MacAddrSize+EtherTypeSize);
	CONSTANT	DefNumOfMacAddr		:		INTEGER					:=	2;
	CONSTANT	EThDefMTU				:		INTEGER					:=	1500; --byte
	CONSTANT	EThMinPDUSize			:		INTEGER					:=	64-4; --byte 60 without CRC
	---------------------
	--END OF Ethernet CONSTANTs
	---------------------
	---------------------
	--IP CONSTANTs
	---------------------
	CONSTANT	EType_IP				:		STD_LOGIC_VECTOR(15 DOWNTO 0)	:=	X"0800";
	CONSTANT	NumOfCFGRegs			:		INTEGER	:=	16;
	CONSTANT	IPLengthSize			:		INTEGER	:=	16;
	CONSTANT	IPAddrSize			:		INTEGER	:=	32;
	CONSTANT	DefNumOfIPAddr			:		INTEGER	:=	2;
	CONSTANT	IP_ProtSize			:		INTEGER	:=	8;
	CONSTANT	DefTTL				:		INTEGER	:=	128;
	CONSTANT	IPPCILength			:		INTEGER	:=	160; --bit 8bit * 32* 5 = 8*4*5
	CONSTANT	IPDefMTU				:		INTEGER	:=	EThDefMTU-20;
	---------------------
	--END OF IP CONSTANTs
	---------------------
	---------------------
	--ARP CONSTANTs
	---------------------
	CONSTANT	EType_ARP				:		STD_LOGIC_VECTOR( 15 DOWNTO 0)	:=	X"0806";
	CONSTANT	ares_hrd_Eth			:		STD_LOGIC_VECTOR( 15 DOWNTO 0)	:=	X"0001";
	CONSTANT	ares_prd_IP			:		STD_LOGIC_VECTOR( 15 DOWNTO 0)	:=	X"0800";
	CONSTANT	ar_hlen_Eth			:		STD_LOGIC_VECTOR( 07 DOWNTO 0)	:=	X"06";
	CONSTANT	ar_plen_IP			:		STD_LOGIC_VECTOR( 07 DOWNTO 0)	:=	X"04";
	CONSTANT	ar_hplen_EthIP			:		STD_LOGIC_VECTOR( 15 DOWNTO 0)	:=	ar_hlen_Eth & ar_plen_IP;
	CONSTANT	ares_op_REQ			:		STD_LOGIC_VECTOR( 15 DOWNTO 0)	:=	X"0001";
	CONSTANT	ares_op_REP			:		STD_LOGIC_VECTOR( 15 DOWNTO 0)	:=	X"0002";
	CONSTANT	arp_ETHIP_len			:		INTEGER						:=	64+2*MacAddrSize+2*IPAddrSize;
	CONSTANT	arp_Field_len			:		INTEGER						:=	16;
	---------------------
	--END OF ARP CONSTANTs
	---------------------
	---------------------
	--UDP CONSTANTs
	---------------------
	CONSTANT	IPProt_UDP			:		STD_LOGIC_VECTOR( 7 DOWNTO 0)	:=	X"11";
	CONSTANT	DefNumOfUDPPorts		:		INTEGER					:=	16;
	CONSTANT	UDPPortSize			:		INTEGER					:=	16;
	CONSTANT	UDPLengthSize			:		INTEGER					:=	16;
	CONSTANT	UDPCHKSize			:		INTEGER					:=	16;
	CONSTANT	UDPPCILength			:		INTEGER					:=	64; --bit 8bit * 32* 5 = 8*4*5
	CONSTANT	UDPPseudoLength		:		INTEGER					:=	2*IPAddrSize+8+8+16; --bit 8bit * 32* 5 = 8*4*5 SRCAddr+DstAddr+X"00"+UDP_Proto+UDP_Length
	---------------------
	--END OF UDP CONSTANTs
	---------------------
								
	---------------------
	--SNMP CONSTANTs
	---------------------
	CONSTANT	SNMPNumOFCFGRegs		:		INTEGER											:=	8;
	CONSTANT	SNMPAddrWidth			:		INTEGER											:=	INTEGER(CEIL(LOG2(REAL(maximum(2,SNMPNumOFCFGRegs)))));
	CONSTANT	SNMPDataWidth			:		INTEGER											:=	32;
	CONSTANT	DefSNMPUDPTrapPort		:		STD_LOGIC_VECTOR( UDPPortSize	-1	DOWNTO 0)				:=	X"00a2"; --162
	CONSTANT	CharSize				:		INTEGER											:=	8;
	CONSTANT	ETHString				:		STD_LOGIC_VECTOR( 3*CharSize	-1	DOWNTO 0)				:=	X"657468";
	CONSTANT	NULLTerminator			:		STD_LOGIC_VECTOR( CharSize	-1	DOWNTO 0)				:=	X"00";
	CONSTANT	ifIndexBaseOidSize		:		INTEGER											:=	9*8;
	CONSTANT	ifIndexVarOidSize		:		INTEGER											:=	8;
	CONSTANT	ifIndexOidSize			:		INTEGER											:=	ifIndexBaseOidSize + ifIndexVarOidSize;
	CONSTANT	ifDescrBaseOidSize		:		INTEGER											:=	9*8;
	CONSTANT	ifDescrVarOidSize		:		INTEGER											:=	8;
	CONSTANT	ifDescrOidSize			:		INTEGER											:=	ifDescrBaseOidSize + ifDescrVarOidSize;
	CONSTANT	ifIndexBaseOid			:		STD_LOGIC_VECTOR( ifIndexBaseOidSize		-1	DOWNTO 0)	:=	X"2b0601020102020101"; --1.3.6.1.2.1.2.2.1.1.X - ifIndex http://www.alvestrand.no/objectid/1.3.6.1.2.1.2.2.1.1.html
	CONSTANT	ifDescrBaseOid			:		STD_LOGIC_VECTOR( ifDescrBaseOidSize		-1	DOWNTO 0)	:=	X"2b0601020102020102"; --1.3.6.1.2.1.2.2.1.2.X - ifDescr http://www.alvestrand.no/objectid/1.3.6.1.2.1.2.2.1.2.html
	
	CONSTANT	SNMPVersionLength		:		INTEGER											:=	8;
	CONSTANT	SNMPGenTrapColdStart	:		STD_LOGIC_VECTOR( 7		DOWNTO 0)	:=	X"00";
	CONSTANT	SNMPGenTrapWarmStart	:		STD_LOGIC_VECTOR( 7		DOWNTO 0)	:=	X"01";
	CONSTANT	SNMPGenTrapLinkDown		:		STD_LOGIC_VECTOR( 7		DOWNTO 0)	:=	X"02";
	CONSTANT	SNMPGenTrapLinkUp		:		STD_LOGIC_VECTOR( 7		DOWNTO 0)	:=	X"03";
	CONSTANT	SNMPGenTrapESpecific	:		STD_LOGIC_VECTOR( 7		DOWNTO 0)	:=	X"06";

	CONSTANT	ASN1NullVal			:		STD_LOGIC_VECTOR( 16-1	DOWNTO 0)	:=	X"0500";
	CONSTANT	BERTYPELength			:		INTEGER											:=	8;
	CONSTANT	BERLengthLength		:		INTEGER											:=	8;
	CONSTANT	BERTYPE_INTEGER		:		STD_LOGIC_VECTOR( 8	-1	DOWNTO 0)	:=	"00000010";
	CONSTANT	BERTYPE_SEQUENCE		:		STD_LOGIC_VECTOR( 8	-1	DOWNTO 0)	:=	"00110000";
	CONSTANT	BERTYPE_OID			:		STD_LOGIC_VECTOR( 8	-1	DOWNTO 0)	:=	"00000110";
	CONSTANT	BERTYPE_OCTETSTRING		:		STD_LOGIC_VECTOR( 8	-1	DOWNTO 0)	:=	"00000100"; 
	CONSTANT	BERTYPE_SNMPTRAPPDU		:		STD_LOGIC_VECTOR( 8	-1	DOWNTO 0)	:=	"10100100"; -- Context Specific = 10 | Constructed = 1 | class tag = 4 0100
	CONSTANT	BERTYPE_IPAddress		:		STD_LOGIC_VECTOR( 8	-1	DOWNTO 0)	:=	"01000000"; 
	CONSTANT	BERTYPE_TIMETICK		:		STD_LOGIC_VECTOR( 8	-1	DOWNTO 0)	:=	"01000011";
	CONSTANT	BERTYPE_IA5String		:		STD_LOGIC_VECTOR( 8	-1	DOWNTO 0)	:=	"00010110";
	CONSTANT	TIMETICKLength			:		INTEGER						:=	4*8;
	
	-- EXperimental OID Base 1.3.6.1.3 - experimental

	---------------------
	--END OF SNMP CONSTANTs
	---------------------

	--source:http://vhdl.org/vhdlsynth/vhdl/minmax.vhd

		
	COMPONENT Connect_Diff IS
	GENERIC(
		DST_Width	:	INTEGER	:=	1;
		SRC_Width	:	INTEGER	:=	1
		);
	PORT(	
		DST		: OUT	STD_LOGIC_VECTOR;
		SRC		: IN		STD_LOGIC_VECTOR
	);
	END COMPONENT Connect_Diff;
		
END PACKAGE ProtoLayerTypesAndDefs;


-- ============================
PACKAGE BODY ProtoLayerTypesAndDefs IS
-- ============================
	
	function absolute(
		val : INTEGER)
		return INTEGER IS
	BEGIN
		IF val < 0 THEN return -1*val;
		ELSE return val;
		END IF;
	END function absolute;
--BEGIN
-- functions here
--
--source:http://vhdl.org/vhdlsynth/vhdl/minmax.vhd
 function maximum (
    left,right : INTEGER)-- inputs
    return INTEGER IS
  BEGIN  -- function max
    IF LEFT > RIGHT THEN return LEFT;
    ELSE return RIGHT;
    END IF;
  END function maximum;
 
 function maximum (
    left,right : unsigned)-- inputs
    return unsigned IS
  BEGIN  -- function max
    IF LEFT > RIGHT THEN return LEFT;
    ELSE return RIGHT;
    END IF;
  END function maximum;
  
END PACKAGE BODY ProtoLayerTypesAndDefs;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Connect_Diff IS
GENERIC(
	DST_Width	:	INTEGER	:=	1;
	SRC_Width	:	INTEGER	:=	1
	);
PORT(	
	DST		: OUT	STD_LOGIC_VECTOR;
	SRC		: IN		STD_LOGIC_VECTOR
);
END  Connect_Diff;
ARCHITECTURE BehavConnect_Diff OF Connect_Diff IS
BEGIN
	sig_connect_lt:
	IF( SRC_Width<DST_Width) generate
		DST(SRC_Width-1 DOWNTO 0)		<=	SRC;
		DST(DST_Width-1 DOWNTO SRC_Width)	<=	(OTHERS => '0');
	END generate;
	sig_connect_eq:
	IF( SRC_Width=DST_Width) generate
		DST	<=	SRC;
	END generate;
	sig_connect_gt:
	IF( SRC_Width>DST_Width) generate
		DST	<=	SRC(DST_Width-1 DOWNTO 0);
	END generate;
END BehavConnect_Diff;

