--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, AND functions 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;
USE IEEE.MATH_REAL.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

use work.ProtoLayerTypesAndDefs.all;

package Simulation is
	component Acker
	port(
		clk			: in		std_logic;
		set			: in		std_logic;
		rst			: in		std_logic;
		I			: in		std_logic;
		delay		: in		integer;
		resp_width	: in		integer;
		Q			: out	std_logic
	);
	end component Acker;
	
	component Resetter is
	generic(
			RST_hold		:		integer	:=	5;
			RST_CE_diff	:		integer	:=	5
	);
	port(
		CLK				: in		std_logic;
		RST				: out	std_logic;
		CE				: out	std_logic
	);
	end component Resetter;
		
	PROCEDURE Init_Module(	constant	CLK_period	:	IN	time;
						constant	RST_hold		:	In	integer;
						constant	RST_CE_diff	:	In	integer;
						Signal	RST			:	OUT	std_logic;
						Signal	CE			:	OUT	std_logic
					);

	PROCEDURE Emit_PDU(	constant CLK_period : IN 	time;
					CONSTANT Plength	: IN		INTEGER;
					SIGNAL DO			: OUT 	STD_LOGIC_VECTOR;
					SIGNAL DV			: OUT 	STD_LOGIC;
					SIGNAL SOP		: OUT 	STD_LOGIC;
					SIGNAL EOP		: OUT 	STD_LOGIC
					);

	PROCEDURE Emit_ETHFrame(	constant CLK_period : IN 	time;
						CONSTANT DSTAddr	: IN		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
						CONSTANT SRCAddr	: IN		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
						CONSTANT ETHType	: IN		STD_LOGIC_VECTOR(EtherTypeSize-1 downto 0);
						CONSTANT Plength	: in		integer;
						SIGNAL DO			: OUT 	STD_LOGIC_VECTOR;
						SIGNAL DV			: OUT 	STD_LOGIC;
						SIGNAL SOP		: OUT 	STD_LOGIC;
						SIGNAL EOP		: OUT 	STD_LOGIC
						);
						
	PROCEDURE Emit_PDU_SYNC(	constant 	CLK_period 	: IN 	time;
						CONSTANT 	Plength		: IN		INTEGER;
						constant 	STRDelay 		: IN 	INTEGER;
						SIGNAL	Ack			: IN		std_logic;
						SIGNAL	Ind			: Out	std_logic;
						SIGNAL 	DO			: OUT 	STD_LOGIC_VECTOR;
						SIGNAL 	DV			: OUT 	STD_LOGIC;
						SIGNAL 	SOP			: OUT 	STD_LOGIC;
						SIGNAL 	EOP			: OUT 	STD_LOGIC
						);
						

	PROCEDURE WAIT_CLK(	constant 	CLK_period 	: IN 	time;
					CONSTANT 	Wlength		: IN		INTEGER
					);
					
	PROCEDURE WR_CAM(	constant 	CLK_period 	: IN 	time;
					constant	WRADDR		: IN		integer;
					constant	WRDATA		: IN		STD_LOGIC_VECTOR;
					SIGNAL	WR_EN		: OUT	std_logic;
					SIGNAL	ADDR			: OUT	STD_LOGIC_VECTOR;
					signal	DO			: OUT	STD_LOGIC_VECTOR
					);

					
	PROCEDURE	Emit_ARP_PDU_Sync(	constant	CLK_period 	: IN		time;
							constant	OPcode		: in		STD_LOGIC_VECTOR(arp_Field_len-1 downto 0);
							constant	HWAOS 		: in		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
							constant	PRAOS 		: in		STD_LOGIC_VECTOR(IPAddrSize-1 downto 0);
							constant	HWAOT 		: in		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
							constant	PRAOT 		: in		STD_LOGIC_VECTOR(IPAddrSize-1 downto 0);
							SIGNAL	Ack			: IN		std_logic;
							SIGNAL	Ind			: Out	std_logic;
							SIGNAL 	DO			: OUT 	STD_LOGIC_VECTOR(7 downto 0);
							SIGNAL 	DV			: OUT 	STD_LOGIC;
							SIGNAL 	SOP			: OUT 	STD_LOGIC;
							SIGNAL 	EOP			: OUT 	STD_LOGIC
							);
	PROCEDURE	Emit_ARP_PDU(	constant	CLK_period 	: IN		time;
						constant	OPcode		: in		STD_LOGIC_VECTOR(arp_Field_len-1 downto 0);
						constant	HWAOS 		: in		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
						constant	PRAOS 		: in		STD_LOGIC_VECTOR(IPAddrSize-1 downto 0);
						constant	HWAOT 		: in		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
						constant	PRAOT 		: in		STD_LOGIC_VECTOR(IPAddrSize-1 downto 0);
						SIGNAL 	DO			: OUT 	STD_LOGIC_VECTOR(7 downto 0);
						SIGNAL 	DV			: OUT 	STD_LOGIC;
						SIGNAL 	SOP			: OUT 	STD_LOGIC;
						SIGNAL 	EOP			: OUT 	STD_LOGIC
							);
	PROCEDURE	Emit_ETH_ARP_PDU(	constant	CLK_period 	: IN		time;
							CONSTANT	DSTAddr		: IN		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
							CONSTANT	SRCAddr		: IN		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
							constant	OPcode		: in		STD_LOGIC_VECTOR(arp_Field_len-1 downto 0);
							constant	PRAOS 		: in		STD_LOGIC_VECTOR(IPAddrSize-1 downto 0);
							constant	PRAOT 		: in		STD_LOGIC_VECTOR(IPAddrSize-1 downto 0);
							SIGNAL	DO			: OUT 	STD_LOGIC_VECTOR(7 downto 0);
							SIGNAL	DV			: OUT 	STD_LOGIC;
							SIGNAL	SOP			: OUT 	STD_LOGIC;
							SIGNAL	EOP			: OUT 	STD_LOGIC
							);
							
	PROCEDURE	Emit_ETH_IP_PDU(	constant	CLK_period 	: IN		time;
							CONSTANT	ETH_DSTAddr	: IN		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
							CONSTANT	ETH_SRCAddr	: IN		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
							constant	IHL			: in		STD_LOGIC_VECTOR( 03 downto 0);
							constant	TOS			: in		STD_LOGIC_VECTOR( 07 downto 0);
							constant	Identification	: in		STD_LOGIC_VECTOR( 15 downto 0);
							constant	Flags		: in		STD_LOGIC_VECTOR( 02 downto 0);
							constant	FragmentOFFS	: in		STD_LOGIC_VECTOR( 12 downto 0);
							constant	TTL			: in		STD_LOGIC_VECTOR( 07 downto 0);
							constant	Protocol		: in		STD_LOGIC_VECTOR( 07 downto 0);
							constant	SRCAddr		: in		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
							constant	DSTAddr		: in		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
							constant	Options		: in		STD_LOGIC_VECTOR( 44*8-1 downto 0);
							constant	Plength		: in		integer;
							SIGNAL	DO			: OUT 	STD_LOGIC_VECTOR(7 downto 0);
							SIGNAL	DV			: OUT 	STD_LOGIC;
							SIGNAL	SOP			: OUT 	STD_LOGIC;
							SIGNAL	SOP_Dummy		: OUT 	STD_LOGIC;
							SIGNAL	EOP			: OUT 	STD_LOGIC
							);

	PROCEDURE	Emit_IP_PDU(	constant	CLK_period	: IN		time;
						constant	IHL			: in		STD_LOGIC_VECTOR( 03 downto 0);
						constant	TOS			: in		STD_LOGIC_VECTOR( 07 downto 0);
						constant	Identification	: in		STD_LOGIC_VECTOR( 15 downto 0);
						constant	Flags		: in		STD_LOGIC_VECTOR( 02 downto 0);
						constant	FragmentOFFS	: in		STD_LOGIC_VECTOR( 12 downto 0);
						constant	TTL			: in		STD_LOGIC_VECTOR( 07 downto 0);
						constant	Protocol		: in		STD_LOGIC_VECTOR( 07 downto 0);
						constant	SRCAddr		: in		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
						constant	DSTAddr		: in		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
						constant	Options		: in		STD_LOGIC_VECTOR( 44*8-1 downto 0);
						constant	Plength		: in		integer;
						SIGNAL 	DO			: OUT 	STD_LOGIC_VECTOR( 7 downto 0);
						SIGNAL 	DV			: OUT 	STD_LOGIC;
						SIGNAL 	SOP			: OUT 	STD_LOGIC;
						SIGNAL 	EOP			: OUT 	STD_LOGIC
						);
	PROCEDURE	Emit_UDP_PDU(	constant	CLK_period	: IN		TIME;
						constant	IP_SRCAddr	: in		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
						constant	IP_DSTAddr	: in		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
						constant	DSTPort		: in		STD_LOGIC_VECTOR( UDPPortSize-1 downto 0);
						constant	SRCPort		: in		STD_LOGIC_VECTOR( UDPPortSize-1 downto 0);
						constant	Plength		: in		INTEGER;
						SIGNAL	SRCIpAddr_Out	: out	STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
						SIGNAL	DSTIpAddr_Out	: out	STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
						SIGNAL	Proto_Out		: out	STD_LOGIC_VECTOR( IP_ProtSize-1 downto 0);
						SIGNAL	Length_Out	: out	STD_LOGIC_VECTOR( IPLengthSize-1 downto 0);
						SIGNAL 	DO			: OUT 	STD_LOGIC_VECTOR( 7 downto 0);
						SIGNAL 	DV			: OUT 	STD_LOGIC;
						SIGNAL 	SOP			: OUT 	STD_LOGIC;
						SIGNAL 	EOP			: OUT 	STD_LOGIC
						) ;
	PROCEDURE	Emit_UDP_PDU_SYNC
					(	constant	CLK_period	: IN		TIME;
						constant	IP_SRCAddr	: in		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
						constant	IP_DSTAddr	: in		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
						constant	DSTPort		: in		STD_LOGIC_VECTOR( UDPPortSize-1 downto 0);
						constant	SRCPort		: in		STD_LOGIC_VECTOR( UDPPortSize-1 downto 0);
						constant	Plength		: in		INTEGER;
						SIGNAL	SRCIpAddr_Out	: out	STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
						SIGNAL	DSTIpAddr_Out	: out	STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
						SIGNAL	Proto_Out		: out	STD_LOGIC_VECTOR( IP_ProtSize-1 downto 0);
						SIGNAL	Length_Out	: out	STD_LOGIC_VECTOR( IPLengthSize-1 downto 0);
						SIGNAL 	DO			: OUT 	STD_LOGIC_VECTOR( 7 downto 0);
						SIGNAL 	DV			: OUT 	STD_LOGIC;
						SIGNAL 	SOP			: OUT 	STD_LOGIC;
						SIGNAL 	EOP			: OUT 	STD_LOGIC;
						SIGNAL	Ind			: Out	std_logic;
						SIGNAL	Ack			: IN		std_logic
						) ;

	PROCEDURE WAIT_FOR(	constant	CLK_period 	: IN		time;
					constant	ToWait		: IN		std_logic;
					signal 	WFSig		: IN		std_logic
				);

	PROCEDURE CFG_WRITE(	constant	CLK_period 	: IN		time;
						constant	CFG_Addr		: IN		integer;
						constant	Addr			: IN		integer;
						constant	Data			: in		STD_LOGIC_VECTOR;
						signal	CFGA_out		: out	STD_LOGIC_VECTOR;
						signal	CFGA_wr		: out	std_logic;
						signal	Addr_out		: out	STD_LOGIC_VECTOR;
						signal	Data_out		: out	STD_LOGIC_VECTOR;
						signal	wr_en		: out	std_logic
					);
					
	PROCEDURE CFG_READ	(	constant	CLK_period 	: IN		time;
						constant	CFG_Addr		: IN		integer;
						constant	Addr			: IN		integer;
						signal	CFGA_out		: out	STD_LOGIC_VECTOR;
						signal	CFGA_wr		: out	std_logic;
						signal	Addr_out		: out	STD_LOGIC_VECTOR;
						signal	rd_en		: out	std_logic
					);
					
	PROCEDURE ARP_Emulator(	constant	CLK_PERIOD	: IN		time;
						constant	Delay		: IN		integer;
						constant	Succ			: IN		boolean;
						constant	ReplyAddr		: IN		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
						signal	ARP_Request	: IN		std_logic;
						signal	ARP_DSTIPAddr	: IN		STD_LOGIC_VECTOR(IPAddrSize-1 downto 0);
						signal	ARP_ResponseV	: Out	std_logic;
						signal	ARP_ResponseEr	: Out	std_logic;
						signal	ARP_DSTMacAddr	: Out	STD_LOGIC_VECTOR(MacAddrSize-1 downto 0)
					);

end Simulation;



package body Simulation is
---- PROCEDURE Example
--  PROCEDURE <PROCEDURE_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <PROCEDURE_name>;
PROCEDURE	Emit_UDP_PDU(	constant	CLK_period	: IN		TIME;
					constant	IP_SRCAddr	: in		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
					constant	IP_DSTAddr	: in		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
					constant	DSTPort		: in		STD_LOGIC_VECTOR( UDPPortSize-1 downto 0);
					constant	SRCPort		: in		STD_LOGIC_VECTOR( UDPPortSize-1 downto 0);
					constant	Plength		: in		INTEGER;
					SIGNAL	SRCIpAddr_Out	: out	STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
					SIGNAL	DSTIpAddr_Out	: out	STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
					SIGNAL	Proto_Out		: out	STD_LOGIC_VECTOR( IP_ProtSize-1 downto 0);
					SIGNAL	Length_Out	: out	STD_LOGIC_VECTOR( IPLengthSize-1 downto 0);
					SIGNAL 	DO			: OUT 	STD_LOGIC_VECTOR( 7 downto 0);
					SIGNAL 	DV			: OUT 	STD_LOGIC;
					SIGNAL 	SOP			: OUT 	STD_LOGIC;
					SIGNAL 	EOP			: OUT 	STD_LOGIC
					) IS
		CONSTANT	W_Plength					:		INTEGER			:=	2*INTEGER(CEIL(REAL(Plength)/2.0));
		CONSTANT	PREGLen					:		INTEGER			:=	UDPPseudoLength+UDPPCILength+W_Plength*8;
		CONSTANT	UDP_Length				:		STD_LOGIC_VECTOR	:=	STD_LOGIC_VECTOR(TO_UNSIGNED(Plength + 8,UDPLengthSize));
		VARIABLE	Packet_Register			:		STD_LOGIC_VECTOR(PREGLen-1 DOWNTO 0);
		VARIABLE	Temp_CHK					:		STD_LOGIC_VECTOR(UDPCHKSize-1 DOWNTO 0);
		
					
	BEGIN
					Packet_Register												:=	(others => '0');
					Temp_CHK														:=	(others => '0');
					Packet_Register(PREGLen-0*IPAddrSize-1	DOWNTO PREGLen - 1*IPAddrSize)	:=	IP_SRCAddr;
					Packet_Register(PREGLen-1*IPAddrSize-1	DOWNTO PREGLen - 2*IPAddrSize)	:=	IP_DSTAddr;
					Packet_Register(PREGLen-2*IPAddrSize-1	DOWNTO PREGLen - 3*IPAddrSize)	:=	X"00" & IPProt_UDP & UDP_Length;
					Packet_Register(PREGLen-3*IPAddrSize-1	DOWNTO PREGLen - 4*IPAddrSize)	:=	SRCPort & DSTPort;
					Packet_Register(PREGLen-4*IPAddrSize-1	DOWNTO PREGLen - 5*IPAddrSize)	:=	UDP_Length & X"0000";
					FOR i IN 0 TO Plength-1 LOOP
						Packet_Register(PREGLen-5*IPAddrSize-(i*8)-1	DOWNTO PREGLen-5*IPAddrSize-((i+1)*8))	:=	STD_LOGIC_VECTOR(TO_UNSIGNED(i,8));
					END LOOP;
					FOR i IN 0 TO PREGLen/16-1 LOOP
						Temp_CHK	:=	Temp_CHK + Packet_Register(PREGLen-(i*16)-1 DOWNTO PREGLen-((i+1)*16));
					END LOOP;
					Packet_Register(PREGLen-4*IPAddrSize-1	DOWNTO PREGLen - 5*IPAddrSize)	:=	UDP_Length & NOT Temp_CHK;
					
					SRCIpAddr_Out	<=	IP_SRCAddr;
					DSTIpAddr_Out	<=	IP_DSTAddr;
					Proto_Out		<=	IPProt_UDP;
					Length_Out	<=	UDP_Length;
					
					DV	<=	Hi;
					SOP	<=	Hi;
					-- DO	<=	Packet_Register(PREGLen-5*IPAddrSize-1	DOWNTO PREGLen - 5*IPAddrSize-8);
					DO	<=	Packet_Register(PREGLen-3*IPAddrSize-1	DOWNTO PREGLen - 3*IPAddrSize-8);
					WAIT_CLK(CLK_PERIOD,1);
					SOP	<=	Lo;
					FOR i IN 1 TO UDPPCILength/8+Plength-2 LOOP
						-- DO	<=	Packet_Register(PREGLen-5*IPAddrSize-(i*8)-1	DOWNTO PREGLen-5*IPAddrSize-((i+1)*8));
						DO	<=	Packet_Register(PREGLen-3*IPAddrSize-(i*8)-1	DOWNTO PREGLen - 3*IPAddrSize-((i+1)*8));
						WAIT_CLK(CLK_PERIOD,1);
					END LOOP;
					EOP	<=	Hi;
					DO	<=	Packet_Register(PREGLen-3*IPAddrSize-((UDPPCILength/8+Plength-1)*8)-1	DOWNTO PREGLen-3*IPAddrSize-((UDPPCILength/8+Plength)*8));
					WAIT_CLK(CLK_PERIOD,1);
					EOP	<=	Lo;
					DV	<=	Lo;
	END Emit_UDP_PDU;
	
	PROCEDURE	Emit_UDP_PDU_SYNC
					(	constant	CLK_period	: IN		TIME;
						constant	IP_SRCAddr	: in		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
						constant	IP_DSTAddr	: in		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
						constant	DSTPort		: in		STD_LOGIC_VECTOR( UDPPortSize-1 downto 0);
						constant	SRCPort		: in		STD_LOGIC_VECTOR( UDPPortSize-1 downto 0);
						constant	Plength		: in		INTEGER;
						SIGNAL	SRCIpAddr_Out	: out	STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
						SIGNAL	DSTIpAddr_Out	: out	STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
						SIGNAL	Proto_Out		: out	STD_LOGIC_VECTOR( IP_ProtSize-1 downto 0);
						SIGNAL	Length_Out	: out	STD_LOGIC_VECTOR( IPLengthSize-1 downto 0);
						SIGNAL 	DO			: OUT 	STD_LOGIC_VECTOR( 7 downto 0);
						SIGNAL 	DV			: OUT 	STD_LOGIC;
						SIGNAL 	SOP			: OUT 	STD_LOGIC;
						SIGNAL 	EOP			: OUT 	STD_LOGIC;
						SIGNAL	Ind			: Out	std_logic;
						SIGNAL	Ack			: IN		std_logic
						) IS
	BEGIN
	
		Ind	<=	Hi;
		WAIT_FOR(CLK_PERIOD,Hi,ACK);
		Emit_UDP_PDU(CLK_PERIOD,IP_SRCAddr,IP_DSTAddr,DSTPort,SRCPort,Plength,SRCIpAddr_Out,DSTIpAddr_Out,Proto_Out,Length_Out,DO,DV,SOP,EOP);
		Ind	<=	Lo;
	END Emit_UDP_PDU_SYNC;
	
					
PROCEDURE	Emit_ETH_ARP_PDU(	constant	CLK_period 	: IN		time;
						CONSTANT	DSTAddr		: IN		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
						CONSTANT	SRCAddr		: IN		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
						constant	OPcode		: in		STD_LOGIC_VECTOR(arp_Field_len-1 downto 0);
						constant	PRAOS 		: in		STD_LOGIC_VECTOR(IPAddrSize-1 downto 0);
						constant	PRAOT 		: in		STD_LOGIC_VECTOR(IPAddrSize-1 downto 0);
						SIGNAL	DO			: OUT 	STD_LOGIC_VECTOR(7 downto 0);
						SIGNAL	DV			: OUT 	STD_LOGIC;
						SIGNAL	SOP			: OUT 	STD_LOGIC;
						SIGNAL	EOP			: OUT 	STD_LOGIC
						) IS
BEGIN
	DV	<=	Hi;
	SOP	<=	Hi;
	for i in MacAddrSize/DO'Length - 1 downto 0 loop
		DO	<=	DSTAddr(i*DO'Length+DO'Length-1 downto i*DO'Length);
		WAIT_CLK(CLK_PERIOD,1);
		SOP	<=	Lo;
	end loop;
	for i in MacAddrSize/DO'Length - 1 downto 0 loop
		DO	<=	SRCAddr(i*DO'Length+DO'Length-1 downto i*DO'Length);
		WAIT_CLK(CLK_PERIOD,1);
	end loop;
	for i in EtherTypeSize/DO'Length - 1 downto 0 loop
		DO	<=	EType_ARP(i*DO'Length+DO'Length-1 downto i*DO'Length);
		WAIT_CLK(CLK_PERIOD,1);
	end loop;
	DO	<=	ares_hrd_Eth(15 downto 8);
	WAIT_CLK(CLK_PERIOD,1);
	SOP	<=	Lo;
	DO	<=	ares_hrd_Eth(7 downto 0);
	WAIT_CLK(CLK_PERIOD,1);
	DO	<=	ares_prd_IP(15 downto 8);
	WAIT_CLK(CLK_PERIOD,1);
	DO	<=	ares_prd_IP(7 downto 0);
	WAIT_CLK(CLK_PERIOD,1);
	DO	<=	ar_hlen_Eth;
	WAIT_CLK(CLK_PERIOD,1);
	DO	<=	ar_plen_IP;
	WAIT_CLK(CLK_PERIOD,1);
	DO	<=	OPcode(15 downto 8);
	WAIT_CLK(CLK_PERIOD,1);
	DO	<=	OPcode(7 downto 0);
	WAIT_CLK(CLK_PERIOD,1);
	for i in 0 to MacAddrSize/8-1 loop
	DO	<=	SRCAddr(MacAddrSize-1-i*8 downto MacAddrSize-(i+1)*8);
	WAIT_CLK(CLK_PERIOD,1);
	end loop;
	for i in 0 to IPAddrSize/8 -1 loop
	DO	<=	PRAOS(IPAddrSize-1-i*8 downto IPAddrSize-(i+1)*8);
	WAIT_CLK(CLK_PERIOD,1);
	end loop;
	for i in 0 to MacAddrSize/8-1 loop
	DO	<=	DSTAddr(MacAddrSize-1-i*8 downto MacAddrSize-(i+1)*8);
	WAIT_CLK(CLK_PERIOD,1);
	end loop;
	for i in 0 to IPAddrSize/8 -2 loop
	DO	<=	PRAOT(IPAddrSize-1-i*8 downto IPAddrSize-(i+1)*8);
	WAIT_CLK(CLK_PERIOD,1);
	end loop;
	EOP	<=	Hi;
	DO	<=	PRAOT(7 downto 0);
	WAIT_CLK(CLK_PERIOD,1);
	EOP	<=	Lo;
	DV	<=	Lo;
END Emit_ETH_ARP_PDU;

PROCEDURE CFG_WRITE(	constant	CLK_period 	: IN		time;
					constant	CFG_Addr		: IN		integer;
					constant	Addr			: IN		integer;
					constant	Data			: in		STD_LOGIC_VECTOR;
					signal	CFGA_out		: out	STD_LOGIC_VECTOR;
					signal	CFGA_wr		: out	std_logic;
					signal	Addr_out		: out	STD_LOGIC_VECTOR;
					signal	Data_out		: out	STD_LOGIC_VECTOR;
					signal	wr_en		: out	std_logic
				) IS
BEGIN
	CFGA_out		<=	STD_LOGIC_VECTOR(to_unsigned(CFG_Addr,CFGA_out'Length));
	CFGA_wr		<=	Hi;
	WAIT_CLK(CLK_period,1);
	CFGA_wr		<=	Lo;
	WAIT_CLK(CLK_period,1);
	Addr_out		<=	STD_LOGIC_VECTOR(to_unsigned(Addr,Addr_out'Length));
	Data_out		<=	Data;
	WR_EN		<=	Hi;
	WAIT_CLK(CLK_period,1);
	WR_EN		<=	Lo;
	WAIT_CLK(CLK_period,1);
END CFG_WRITE;

PROCEDURE CFG_READ	(	constant	CLK_period 	: IN		time;
					constant	CFG_Addr		: IN		integer;
					constant	Addr			: IN		integer;
					signal	CFGA_out		: out	STD_LOGIC_VECTOR;
					signal	CFGA_wr		: out	std_logic;
					signal	Addr_out		: out	STD_LOGIC_VECTOR;
					signal	rd_en		: out	std_logic
				)IS
BEGIN
	CFGA_out		<=	STD_LOGIC_VECTOR(to_unsigned(CFG_Addr,CFGA_out'Length));
	CFGA_wr		<=	Hi;
	WAIT_CLK(CLK_period,1);
	CFGA_wr		<=	Lo;
	WAIT_CLK(CLK_period,1);
	Addr_out		<=	STD_LOGIC_VECTOR(to_unsigned(Addr,Addr_out'Length));
	rd_en		<=	Hi;
	WAIT_CLK(CLK_period,1);
	rd_en		<=	Lo;
	WAIT_CLK(CLK_period,1);
END CFG_READ;

	PROCEDURE Emit_PDU( constant CLK_period : IN 	time;
					CONSTANT Plength	: IN		INTEGER;
					SIGNAL DO			: OUT 	STD_LOGIC_VECTOR;
					SIGNAL DV			: OUT 	STD_LOGIC;
					SIGNAL SOP		: OUT 	STD_LOGIC;
					SIGNAL EOP		: OUT 	STD_LOGIC
					) IS
	BEGIN
		SOP 	<= 	'1';
		EOP 	<= 	'0';
		DV	<=	'1';
		DO	<=	STD_LOGIC_VECTOR(to_unsigned(0,DO'Length));
		wait for CLK_period;
		SOP 	<= 	'0';	
		FOR i IN 1 to Plength-2 LOOP
			DO	<= STD_LOGIC_VECTOR(to_unsigned(i,DO'length));
			wait for CLK_period;
		END LOOP;
		EOP 	<= 	'1';
		DO	<= STD_LOGIC_VECTOR(to_unsigned(Plength-1,DO'length));
		wait for CLK_period;
		EOP 	<= 	'0';
		DV	<=	'0';
		wait for CLK_period*10;
		
	END Emit_PDU;
 
	
	PROCEDURE Emit_PDU_SYNC( constant 	CLK_period 	: IN 	time;
						CONSTANT 	Plength		: IN		INTEGER;
						constant 	STRDelay 		: IN 	INTEGER;
						SIGNAL	Ack			: IN		std_logic;
						SIGNAL	Ind			: Out	std_logic;
						SIGNAL 	DO			: OUT 	STD_LOGIC_VECTOR;
						SIGNAL 	DV			: OUT 	STD_LOGIC;
						SIGNAL 	SOP			: OUT 	STD_LOGIC;
						SIGNAL 	EOP			: OUT 	STD_LOGIC
						) IS
	BEGIN
		
		Ind	<= '1';
		WAIT_FOR(CLK_PERIOD,Hi,Ack);
		wait for STRDelay*CLK_period;
		Emit_PDU(CLK_PERIOD,Plength,DO,DV,SOP,EOP);
		Ind	<= '0';
	end Emit_PDU_SYNC;
	
	
	
PROCEDURE Init_Module(	constant	CLK_period	:	IN	time;
					constant	RST_hold		:	In	integer;
					constant	RST_CE_diff	:	In	integer;
					Signal	RST			:	OUT	std_logic;
					Signal	CE			:	OUT	std_logic
				)IS
	BEGIN
		if(RST_CE_diff < 0) then
			CE	<=	'1';
			wait for	(-1*RST_CE_diff)*CLK_period;
			RST	<=	'1';
			wait for	RST_hold*CLK_period;
			RST	<=	'0';
		else
			RST	<=	'1';			
			wait for	RST_CE_diff*CLK_period;
			CE	<=	'1';
			if(RST_hold - RST_CE_diff < 0) then
				wait for	(-1*(RST_hold-RST_CE_diff))*CLK_period;
			else
				wait for	(RST_hold-RST_CE_diff)*CLK_period;
			end if;			
			RST	<=	'0';
		end if;		
		wait for	CLK_period*10;
	END Init_Module;
	
	
PROCEDURE WAIT_CLK(	constant 	CLK_period 	: IN 	time;
				CONSTANT 	Wlength		: IN		INTEGER
			) IS
	BEGIN
		wait for CLK_period*Wlength;	
	END WAIT_CLK;

PROCEDURE WAIT_FOR(	constant	CLK_period 	: IN		time;
				constant	ToWait		: IN		std_logic;
				signal 	WFSig		: IN		std_logic
			) IS
	BEGIN
		loop
			WAIT_CLK(CLK_PERIOD,1);
			exit when WFSig = ToWait;
		end loop;
		
	END WAIT_FOR;

	
	
PROCEDURE WR_CAM(	constant 	CLK_period 	: IN 	time;
				constant	WRADDR		: IN		integer;
				constant	WRDATA		: IN		STD_LOGIC_VECTOR;
				SIGNAL	WR_EN		: OUT	std_logic;
				SIGNAL	ADDR			: OUT	STD_LOGIC_VECTOR;
				signal	DO			: OUT	STD_LOGIC_VECTOR
				) IS
	BEGIN
		DO		<=	WRDATA;
		ADDR		<=	STD_LOGIC_VECTOR(to_unsigned(WRADDR,ADDR'Length));
		WR_EN	<=	'1';
		wait for CLK_PERIOD;
		WR_EN	<=	'0';
	END WR_CAM;

PROCEDURE Emit_ETHFrame(	constant CLK_period : IN 	time;
					CONSTANT DSTAddr	: IN		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
					CONSTANT SRCAddr	: IN		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
					CONSTANT ETHType	: IN		STD_LOGIC_VECTOR(EtherTypeSize-1 downto 0);
					CONSTANT Plength	: in		integer;
					SIGNAL DO			: OUT 	STD_LOGIC_VECTOR;
					SIGNAL DV			: OUT 	STD_LOGIC;
					SIGNAL SOP		: OUT 	STD_LOGIC;
					SIGNAL EOP		: OUT 	STD_LOGIC
					) IS
	BEGIN
		DV	<=	Hi;
		SOP	<=	Hi;
		for i in MacAddrSize/DO'Length - 1 downto 0 loop
			DO	<=	DSTAddr(i*DO'Length+DO'Length-1 downto i*DO'Length);
			WAIT_CLK(CLK_PERIOD,1);
			SOP	<=	Lo;
		end loop;
		for i in MacAddrSize/DO'Length - 1 downto 0 loop
			DO	<=	SRCAddr(i*DO'Length+DO'Length-1 downto i*DO'Length);
			WAIT_CLK(CLK_PERIOD,1);
		end loop;
		for i in EtherTypeSize/DO'Length - 1 downto 0 loop
			DO	<=	ETHType(i*DO'Length+DO'Length-1 downto i*DO'Length);
			WAIT_CLK(CLK_PERIOD,1);
		end loop;
		Emit_PDU(CLK_period,Plength,DO,DV,SOP,EOP);
		
	ENd;
	
	
	
	
				
PROCEDURE	Emit_ARP_PDU_Sync(	constant	CLK_period 	: IN		time;
						constant	OPcode		: in		STD_LOGIC_VECTOR(arp_Field_len-1 downto 0);
						constant	HWAOS 		: in		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
						constant	PRAOS 		: in		STD_LOGIC_VECTOR(IPAddrSize-1 downto 0);
						constant	HWAOT 		: in		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
						constant	PRAOT 		: in		STD_LOGIC_VECTOR(IPAddrSize-1 downto 0);
						SIGNAL	Ack			: IN		std_logic;
						SIGNAL	Ind			: Out	std_logic;
						SIGNAL 	DO			: OUT 	STD_LOGIC_VECTOR(7 downto 0);
						SIGNAL 	DV			: OUT 	STD_LOGIC;
						SIGNAL 	SOP			: OUT 	STD_LOGIC;
						SIGNAL 	EOP			: OUT 	STD_LOGIC
						) IS
	BEGIN
		Ind	<= '1';
		loop
			WAIT_CLK(CLK_PERIOD,1);
			exit when Ack = Hi;
		end loop;
		Ind	<= '0' after CLK_PERIOD;
		Emit_ARP_PDU(CLK_period,OPcode,HWAOS,PRAOS,HWAOT,PRAOT,DO,DV,SOP,EOP);
	End;
	
PROCEDURE	Emit_ARP_PDU(	constant	CLK_period 	: IN		time;
					constant	OPcode		: in		STD_LOGIC_VECTOR(arp_Field_len-1 downto 0);
					constant	HWAOS 		: in		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
					constant	PRAOS 		: in		STD_LOGIC_VECTOR(IPAddrSize-1 downto 0);
					constant	HWAOT 		: in		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
					constant	PRAOT 		: in		STD_LOGIC_VECTOR(IPAddrSize-1 downto 0);
					SIGNAL 	DO			: OUT 	STD_LOGIC_VECTOR(7 downto 0);
					SIGNAL 	DV			: OUT 	STD_LOGIC;
					SIGNAL 	SOP			: OUT 	STD_LOGIC;
					SIGNAL 	EOP			: OUT 	STD_LOGIC
					) IS
	BEGIN
		DV	<=	Hi;
		SOP	<=	Hi;
		DO	<=	ares_hrd_Eth(15 downto 8);
		WAIT_CLK(CLK_PERIOD,1);
		SOP	<=	Lo;
		DO	<=	ares_hrd_Eth(7 downto 0);
		WAIT_CLK(CLK_PERIOD,1);
		DO	<=	ares_prd_IP(15 downto 8);
		WAIT_CLK(CLK_PERIOD,1);
		DO	<=	ares_prd_IP(7 downto 0);
		WAIT_CLK(CLK_PERIOD,1);
		DO	<=	ar_hlen_Eth;
		WAIT_CLK(CLK_PERIOD,1);
		DO	<=	ar_plen_IP;
		WAIT_CLK(CLK_PERIOD,1);
		DO	<=	OPcode(15 downto 8);
		WAIT_CLK(CLK_PERIOD,1);
		DO	<=	OPcode(7 downto 0);
		WAIT_CLK(CLK_PERIOD,1);
		for i in 0 to MacAddrSize/8-1 loop
		DO	<=	HWAOS(MacAddrSize-1-i*8 downto MacAddrSize-(i+1)*8);
		WAIT_CLK(CLK_PERIOD,1);
		end loop;
		for i in 0 to IPAddrSize/8 -1 loop
		DO	<=	PRAOS(IPAddrSize-1-i*8 downto IPAddrSize-(i+1)*8);
		WAIT_CLK(CLK_PERIOD,1);
		end loop;
		for i in 0 to MacAddrSize/8-1 loop
		DO	<=	HWAOT(MacAddrSize-1-i*8 downto MacAddrSize-(i+1)*8);
		WAIT_CLK(CLK_PERIOD,1);
		end loop;
		for i in 0 to IPAddrSize/8 -2 loop
		DO	<=	PRAOT(IPAddrSize-1-i*8 downto IPAddrSize-(i+1)*8);
		WAIT_CLK(CLK_PERIOD,1);
		end loop;
		EOP	<=	Hi;
		DO	<=	PRAOT(7 downto 0);
		WAIT_CLK(CLK_PERIOD,1);
		EOP	<=	Lo;
		DV	<=	Lo;
	End;


	
PROCEDURE	Emit_IP_PDU(	constant	CLK_period	: IN		time;
					constant	IHL			: in		STD_LOGIC_VECTOR( 03 downto 0);
					constant	TOS			: in		STD_LOGIC_VECTOR( 07 downto 0);
					constant	Identification	: in		STD_LOGIC_VECTOR( 15 downto 0);
					constant	Flags		: in		STD_LOGIC_VECTOR( 02 downto 0);
					constant	FragmentOFFS	: in		STD_LOGIC_VECTOR( 12 downto 0);
					constant	TTL			: in		STD_LOGIC_VECTOR( 07 downto 0);
					constant	Protocol		: in		STD_LOGIC_VECTOR( 07 downto 0);
					constant	SRCAddr		: in		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
					constant	DSTAddr		: in		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
					constant	Options		: in		STD_LOGIC_VECTOR( 44*8-1 downto 0);
					constant	Plength		: in		integer;
					SIGNAL 	DO			: OUT 	STD_LOGIC_VECTOR( 7 downto 0);
					SIGNAL 	DV			: OUT 	STD_LOGIC;
					SIGNAL 	SOP			: OUT 	STD_LOGIC;
					SIGNAL 	EOP			: OUT 	STD_LOGIC
					) IS
	
	variable TotalLength	:		STD_LOGIC_VECTOR(15 downto 0)		:= (others => Lo);
	variable IPHeader		:		STD_LOGIC_VECTOR(64*8-1 downto 0)	:= (others => Lo);
	variable HChecksum		:		STD_LOGIC_VECTOR(15 downto 0)		:= (others => Lo);
	variable IHL_int		:		integer						:= 5;
	variable TotalLength_int	:		integer						:= 6;--min 1 byte payload
	
	BEGIN
		HChecksum						:=	(others => Lo);
		IHL_int						:=	to_integer(unsigned(IHL));
		IHL_int						:=	maximum(IHL_int,5);
		TotalLength					:=	STD_LOGIC_VECTOR(to_unsigned(IHL_int*4 + Plength,16));
		TotalLength_int				:=	to_integer(unsigned(TotalLength));
		IPHeader(64*8-1 downto 63*8)		:=	"0100" & IHL;--Version & IHL;
		IPHeader(63*8-1 downto 62*8)		:=	TOS;--Type of service
		IPHeader(62*8-1 downto 60*8)		:=	TotalLength;--TotalLength Hi
		IPHeader(60*8-1 downto 58*8)		:=	Identification;--Ident
		IPHeader(58*8-1 downto 58*8-3)	:=	Flags;--Flags 
		IPHeader(58*8-4 downto 56*8)		:=	FragmentOFFS; --Frag Offset
		IPHeader(56*8-1 downto 55*8)		:=	TTL; --TTL
		IPHeader(55*8-1 downto 54*8)		:=	Protocol; --Protocol
		IPHeader(54*8-1 downto 52*8)		:=	(others => Lo);-- HChecksum(15 downto 0); --HChecksum 
		IPHeader(52*8-1 downto 48*8)		:=	SRCAddr;	--source address
		IPHeader(48*8-1 downto 44*8)		:=	DSTAddr;	--destination address
		IPHeader(44*8-1 downto    0)		:=	Options;
		for i in 0 to IHL_int*2-1 loop
			HChecksum					:=	HChecksum + IPHeader((32-i)*16-1 downto (31-i)*16);
		end loop;
		HChecksum						:=	NOT HChecksum;
		IPHeader(54*8-1 downto 52*8)		:=	HChecksum;
		
		DV	<=	Hi;
		SOP	<=	Hi;
		DO	<=	IPHeader(64*8-1 downto 63*8);
		WAIT_CLK(CLK_PERIOD,1);
		SOP	<=	Lo;
		for i in 1 to IHL_int*4-1 loop
			DO	<=	IPHeader((64-i)*8-1 downto (63-i)*8);
			WAIT_CLK(CLK_PERIOD,1);
		end loop;
		
		for i in 0 to Plength - 2 loop
			DO	<=	STD_LOGIC_VECTOR(to_unsigned(i,8));
			WAIT_CLK(CLK_PERIOD,1);
		end loop;
		EOP	<=	Hi;
		DO	<=	STD_LOGIC_VECTOR(to_unsigned(21,8));
		WAIT_CLK(CLK_PERIOD,1);
		EOP	<=	Lo;
		DV	<=	Lo;
	End;
	
	PROCEDURE	Emit_ETH_IP_PDU(	constant	CLK_period 	: IN		time;
							CONSTANT	ETH_DSTAddr	: IN		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
							CONSTANT	ETH_SRCAddr	: IN		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
							constant	IHL			: in		STD_LOGIC_VECTOR( 03 downto 0);
							constant	TOS			: in		STD_LOGIC_VECTOR( 07 downto 0);
							constant	Identification	: in		STD_LOGIC_VECTOR( 15 downto 0);
							constant	Flags		: in		STD_LOGIC_VECTOR( 02 downto 0);
							constant	FragmentOFFS	: in		STD_LOGIC_VECTOR( 12 downto 0);
							constant	TTL			: in		STD_LOGIC_VECTOR( 07 downto 0);
							constant	Protocol		: in		STD_LOGIC_VECTOR( 07 downto 0);
							constant	SRCAddr		: in		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
							constant	DSTAddr		: in		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
							constant	Options		: in		STD_LOGIC_VECTOR( 44*8-1 downto 0);
							constant	Plength		: in		integer;
							SIGNAL	DO			: OUT 	STD_LOGIC_VECTOR(7 downto 0);
							SIGNAL	DV			: OUT 	STD_LOGIC;
							SIGNAL	SOP			: OUT 	STD_LOGIC;
							SIGNAL	SOP_Dummy		: OUT 	STD_LOGIC;
							SIGNAL	EOP			: OUT 	STD_LOGIC
							) IS
			variable	SOP_OVRN	:	std_logic	:=	Hi;
			variable	SOP_P	:	std_logic	:=	Lo;
	BEGIN

		DV	<=	Hi;
		SOP	<=	Hi;
		EOP	<=	Lo;
		for i in MacAddrSize/DO'Length - 1 downto 0 loop
			DO	<=	ETH_DSTAddr(i*DO'Length+DO'Length-1 downto i*DO'Length);
			WAIT_CLK(CLK_PERIOD,1);
			SOP	<=	Lo;
		end loop;
		for i in MacAddrSize/DO'Length - 1 downto 0 loop
			DO	<=	ETH_SRCAddr(i*DO'Length+DO'Length-1 downto i*DO'Length);
			WAIT_CLK(CLK_PERIOD,1);
		end loop;
		for i in EtherTypeSize/DO'Length - 1 downto 0 loop
			DO	<=	EType_IP(i*DO'Length+DO'Length-1 downto i*DO'Length);
			WAIT_CLK(CLK_PERIOD,1);
		end loop;
		
		Emit_IP_PDU(	CLK_period,
			IHL,--IHL
			TOS,--constant	TOS			: in		STD_LOGIC_VECTOR( 07 downto 0);
			Identification,--		constant	Identification	: in		STD_LOGIC_VECTOR( 15 downto 0);
			Flags,--		constant	Flags		: in		STD_LOGIC_VECTOR( 02 downto 0);
			FragmentOFFS,--		constant	FragmentOFFS	: in		STD_LOGIC_VECTOR( 12 downto 0);
			TTL,--		constant	TTL			: in		STD_LOGIC_VECTOR( 07 downto 0);
			Protocol,--		constant	Protocol		: in		STD_LOGIC_VECTOR( 07 downto 0);
			SRCAddr,--		constant	SRCAddr		: in		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
			DSTAddr,--		constant	DSTAddr		: in		STD_LOGIC_VECTOR( IPAddrSize-1 downto 0);
			Options,--		constant	Options		: in		STD_LOGIC_VECTOR( 44*8-1 downto 0);
			Plength,--		constant	Plength		: in		integer;
			DO,--		SIGNAL 	DO			: OUT 	STD_LOGIC_VECTOR( 7 downto 0);
			DV,--		SIGNAL 	DV			: OUT 	STD_LOGIC;
			SOP_Dummy,--		SIGNAL 	SOP			: OUT 	STD_LOGIC;
			EOP --,		SIGNAL 	EOP			: OUT 	STD_LOGIC
			);

	
	end Emit_ETH_IP_PDU;

	PROCEDURE ARP_Emulator(	constant	CLK_PERIOD	: IN		time;
						constant	Delay		: IN		integer;
						constant	Succ			: IN		boolean;
						constant	ReplyAddr		: IN		STD_LOGIC_VECTOR(MacAddrSize-1 downto 0);
						signal	ARP_Request	: IN		std_logic;
						signal	ARP_DSTIPAddr	: IN		STD_LOGIC_VECTOR(IPAddrSize-1 downto 0);
						signal	ARP_ResponseV	: Out	std_logic;
						signal	ARP_ResponseEr	: Out	std_logic;
						signal	ARP_DSTMacAddr	: Out	STD_LOGIC_VECTOR(MacAddrSize-1 downto 0)
					) IS
	BEGIN
		WAIT_FOR(CLK_PERIOD,Hi,ARP_Request);
		ARP_ResponseV		<=	Lo;
		ARP_ResponseEr		<=	Lo;
		ARP_DSTMacAddr		<=	(others => Lo);
		WAIT_CLK(CLK_period,Delay);
		if(Succ)then
			ARP_DSTMacAddr		<=	ReplyAddr;
			ARP_ResponseV		<=	Hi;
		else
			ARP_ResponseEr		<=	Hi;
		end if;
		WAIT_FOR(CLK_PERIOD,Lo,ARP_Request);
		ARP_ResponseV		<=	Lo;
		ARP_ResponseEr		<=	Lo;
		ARP_DSTMacAddr		<=	(others => Lo);
	end ARP_Emulator;
end Simulation;


--library work;
-- use work.Simulation.all;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;
use IEEE.math_real.ALL;

use work.ProtoLayerTypesAndDefs.all;


Entity Resetter is
generic(
		RST_hold		:		integer	:=	5;
		RST_CE_diff	:		integer	:=	5
);
port(
	CLK				: in		std_logic;
	RST				: out	std_logic;
	CE				: out	std_logic
);
end Resetter;

architecture behavResetter of Resetter is
constant	CNTRWidth			:	integer	:=	integer(ceil(log2(real(maximum(absolute(RST_hold),absolute(RST_CE_diff))))));
constant	RST_hold_vec		:	STD_LOGIC_VECTOR(CNTRWidth-1 downto 0)	:=	STD_LOGIC_VECTOR(to_unsigned(absolute(RST_hold),CNTRWidth));
constant	RST_CE_diff_vec	:	STD_LOGIC_VECTOR(CNTRWidth-1 downto 0)	:=	STD_LOGIC_VECTOR(to_unsigned(absolute(RST_CE_diff),CNTRWidth));
signal	CNTR				:	STD_LOGIC_VECTOR(CNTRWidth-1 downto 0)	:=	(others => Lo);
signal	RST_CE_Part		:	std_logic;
signal	Init				:	std_logic	:=	Hi;
begin

ce_diff_pos:
if(RST_CE_diff >= 0) generate
	process(clk)
	begin
		if(rising_edge(clk))then
			if(Init = Hi)then
				CNTR			<=	(others => Lo);
				Init			<=	Lo;
				RST			<=	Hi;
				CE			<=	Lo;
				RST_CE_Part	<=	Lo;
			else
				if(RST_CE_Part = Lo) then
					if(CNTR = RST_hold_vec) then
						RST			<=	Lo;
						-- CE			<=	Hi;
						CNTR			<=	(others => Lo);
						RST_CE_Part	<=	Hi;
					else
						CNTR	<=	CNTR + 1;
					end if;
				else
					if(CNTR = RST_CE_diff_vec) then
						-- RST			<=	Lo;
						CE			<=	Hi;
						-- CsNTR			<=	(others => Lo);
						RST_CE_Part	<=	Hi;
					else
						CNTR	<=	CNTR + 1;
					end if;
				end if;
			end if;
		end if;
	end process;
end generate;
ce_diff_neg:
if(RST_CE_diff < 0) generate
	process(clk)
	begin
		if(rising_edge(clk))then
			if(Init = Hi)then
				CNTR			<=	(others => Lo);
				Init			<=	Lo;
				RST			<=	Lo;
				CE			<=	Hi;
				RST_CE_Part	<=	Lo;
			else
				if(RST_CE_Part = Lo) then
					if(CNTR = RST_CE_diff_vec) then
						RST			<=	Hi;
						CNTR			<=	(others => Lo);
						RST_CE_Part	<=	Hi;
					else
						CNTR	<=	CNTR + 1;
					end if;
				else
					if(CNTR = RST_hold_vec) then
						RST			<=	Lo;
						CE			<=	Hi;
						-- CsNTR			<=	(others => Lo);
						RST_CE_Part	<=	Hi;
					else
						CNTR	<=	CNTR + 1;
					end if;
				end if;
			end if;
		end if;
	end process;
end generate;

end behavResetter;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;


Entity Acker is
port(
	clk			: in		std_logic;
	set			: in		std_logic;
	rst			: in		std_logic;
	I			: in		std_logic;
	delay		: in		integer;
	resp_width	: in		integer;
	Q			: out	std_logic
);
end  Acker;

Architecture behavioral of Acker is

signal 	delay_cnt		:	integer := 0;
signal 	act_delay		:	integer := 0;
signal 	resp_cnt		:	integer := 0;
signal 	act_respw		:	integer := 0;
signal 	I_prev		:	std_logic	:= '0';
signal 	I_rise		:	std_logic	:= '0';
signal	Q_sig		:	std_logic	:= '0';
signal	IPGR			:	std_logic	:= '0';
begin

I_rise	<=	not(I_prev) AND I;
Q		<=	Q_sig;
process(rst,set,clk,I_rise,delay_cnt,resp_cnt)
begin
	if(rst = '1') then
		Q_sig	<= '0';
		act_delay	<= delay;
		act_respw <= resp_width;
		IPGR		<=	'0';
	elsif(rst = '0' AND set = '1') then
		Q_sig	<= '1';
		act_delay	<= delay;
		act_respw <= resp_width;
		IPGR		<=	'0';
	else
		if(rising_edge(clk)) then
			I_prev <= I;
			if(I_rise = '1') then
				delay_cnt <= 0;
				act_delay	<= delay;
				act_respw <= resp_width;
				IPGR		<=	'1';
			else
				IF(IPGR = '1')THEN
					if(delay_cnt = act_delay) then
						if(resp_cnt = act_respw) then
							IPGR		<=	'0';
							Q_sig 	<=	'0';
						else
							Q_sig 	<=	'1';
							resp_cnt 	<= resp_cnt + 1;
						end if;
					else
						delay_cnt <= delay_cnt + 1;
						resp_cnt	<=	0;
					end if;
				end if;
			end if;
			

		end if;
	end if;
end process;



end;


