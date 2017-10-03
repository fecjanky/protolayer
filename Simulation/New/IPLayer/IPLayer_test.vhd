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

use work.ProtoLayerTypesAndDefs.all;
use work.Simulation.all;
use work.IPLayerPkg.IPLayer;

ENTITY IPLayer_test IS
END IPLayer_test;

ARCHITECTURE behavior OF IPLayer_test IS 
 
	 -- Component Declaration for the Unit Under Test (UUT)
 

	--Inputs
	signal CLK : std_logic := '0';
	signal RST : std_logic := '0';
	signal CE : std_logic := '0';
	signal CFG_CE : std_logic := '0';
	signal WR_EN : std_logic := '0';
	signal RD_EN : std_logic := '0';
	signal CFG_ADDR_WR : std_logic := '0';
	signal CFG_ADDR : std_logic_vector(3 downto 0) := (others => '0');
	signal ADDR : std_logic_vector(2 downto 0) := (others => '0');
	signal DATA_IN : std_logic_vector(31 downto 0) := (others => '0');
	signal ARP_ResponseV : std_logic := '0';
	signal ARP_ResponseErr : std_logic := '0';
	signal ARP_DstMacAddr : std_logic_vector(47 downto 0) := (others => '0');
	signal DstIPAddr_In : std_logic_vector(31 downto 0) := (others => '0');
	signal SrcIPAddr_In : std_logic_vector(31 downto 0) := (others => '0');
	signal Prot_In : std_logic_vector(7 downto 0) := (others => '0');
	signal Length_In : std_logic_vector( 15 downto 0) := (others => '0');
	signal DstMacAddr_In : std_logic_vector(47 downto 0) := (others => '0');
	signal SrcMacAddr_In : std_logic_vector(47 downto 0) := (others => '0');
	signal EthType_In : std_logic_vector(15 downto 0) := (others => '0');
	signal SDU_DIN : std_logic_vector(7 downto 0) := (others => '0');
	signal SDU_DINV : std_logic := '0';
	signal SDU_IN_SOP : std_logic := '0';
	signal SDU_IN_EOP : std_logic := '0';
	signal SDU_IN_Ind : std_logic := '0';
	signal SDU_IN_ErrIn : std_logic := '0';
	signal SDU_IN_USER_In : std_logic_vector(5 downto 0) := (others => '0');
	signal PDU_Out_Ack : std_logic := '0';
	signal PDU_Out_ErrIn : std_logic := '0';
	signal PDU_DIN : std_logic_vector(7 downto 0) := (others => '0');
	signal PDU_DINV : std_logic := '0';
	signal PDU_IN_SOP : std_logic := '0';
	signal PDU_IN_EOP : std_logic := '0';
	signal PDU_IN_Ind : std_logic := '0';
	signal PDU_IN_USER_In : std_logic_vector(5 downto 0) := (others => '0');
	signal PDU_IN_ErrIn : std_logic := '0';
	signal SDU_OUT_ErrIn : std_logic := '0';
	signal SDU_OUT_Ack : std_logic := '0';

 	--Outputs
	signal DATA_OUT : std_logic_vector(31 downto 0);
	signal DOUTV : std_logic;
	signal ARP_Request : std_logic;
	signal ARP_DSTIPAddr : std_logic_vector(31 downto 0);
	signal DstIPAddr_Out : std_logic_vector(31 downto 0);
	signal SrcIPAddr_Out : std_logic_vector(31 downto 0);
	signal Prot_Out : std_logic_vector(7 downto 0);
	signal Length_Out : std_logic_vector( 15 downto 0) := (others => '0');
	signal DstMacAddr_Out : std_logic_vector(47 downto 0);
	signal SrcMacAddr_Out : std_logic_vector(47 downto 0);
	signal EthType_Out : std_logic_vector(15 downto 0);
	signal SDU_IN_Ack : std_logic;
	signal SDU_IN_ErrOut : std_logic;
	signal PDU_DOUT : std_logic_vector(7 downto 0);
	signal Status : std_logic_vector(7 downto 0);
	signal PDU_DOUTV : std_logic;
	signal PDU_Out_SOP : std_logic;
	signal PDU_Out_EOP : std_logic;
	signal PDU_Out_Ind : std_logic;
	signal PDU_Out_ErrOut : std_logic;
	signal PDU_Out_USER_Out : std_logic_vector(5 downto 0);
	signal PDU_IN_ErrOut : std_logic;
	signal PDU_IN_Ack : std_logic;
	signal SDU_DOUT : std_logic_vector(7 downto 0);
	signal SDU_DOUTV : std_logic;
	signal SDU_Out_SOP : std_logic;
	signal SDU_OUT_EOP : std_logic;
	signal SDU_OUT_Ind : std_logic;
	signal SDU_OUT_USER_Out : std_logic_vector(5 downto 0);
	signal SDU_OUT_ErrOut : std_logic;

	signal OUTACK_SET		: std_logic := '0';
	signal OUTACK_RST		: std_logic := '0';
	signal OUTACK_delay		: integer := 1;
	signal OUTACK_width   	: integer := 1;

	-- Clock period definitions
	constant CLK_period : time := 10 ns;
	signal Options		:		std_logic_vector( 44*8-1 downto 0) := (others => Lo);

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
	uut: IPLayer 
	generic MAP(
		DataWidth			=>		DefDataWidth,
		RX_SYNC_IN		=>		false,
		RX_SYNC_OUT		=>		false,
		TX_SYNC_OUT		=>		false,
		NumOfIPAddresses	=>		4,
		PacketToQueue		=>		DefPDUToQ,
		TTL				=>		DefTTL,
		MTU				=>		IPDefMTU
	)
	PORT MAP (
			 CLK => CLK,
			 RST => RST,
			 CE => CE,
			 CFG_CE => CFG_CE,
			 WR_EN => WR_EN,
			 RD_EN => RD_EN,
			 CFG_ADDR_WR => CFG_ADDR_WR,
			 CFG_ADDR => CFG_ADDR,
			 ADDR => ADDR,
			 DATA_IN => DATA_IN,
			 DATA_OUT => DATA_OUT,
			 DOUTV => DOUTV,
			 ARP_Request => ARP_Request,
			 ARP_DSTIPAddr => ARP_DSTIPAddr,
			 ARP_ResponseV => ARP_ResponseV,
			 ARP_ResponseErr => ARP_ResponseErr,
			 ARP_DstMacAddr => ARP_DstMacAddr,
			 DstIPAddr_In => DstIPAddr_In,
			 SrcIPAddr_In => SrcIPAddr_In,
			 Prot_In => Prot_In,
			 Length_In => Length_In,
			 DstIPAddr_Out => DstIPAddr_Out,
			 SrcIPAddr_Out => SrcIPAddr_Out,
			 Prot_Out => Prot_Out,
			 Length_Out => Length_Out,
			 DstMacAddr_In => DstMacAddr_In,
			 SrcMacAddr_In => SrcMacAddr_In,
			 EthType_In => EthType_In,
			 DstMacAddr_Out => DstMacAddr_Out,
			 SrcMacAddr_Out => SrcMacAddr_Out,
			 EthType_Out => EthType_Out,
			 SDU_DIN => SDU_DIN,
			 SDU_DINV => SDU_DINV,
			 SDU_IN_SOP => SDU_IN_SOP,
			 SDU_IN_EOP => SDU_IN_EOP,
			 SDU_IN_Ind => SDU_IN_Ind,
			 SDU_IN_ErrIn => SDU_IN_ErrIn,
			 SDU_IN_USER_In => SDU_IN_USER_In,
			 SDU_IN_Ack => SDU_IN_Ack,
			 SDU_IN_ErrOut => SDU_IN_ErrOut,
			 PDU_DOUT => PDU_DOUT,
			 PDU_DOUTV => PDU_DOUTV,
			 PDU_Out_SOP => PDU_Out_SOP,
			 PDU_Out_EOP => PDU_Out_EOP,
			 PDU_Out_Ind => PDU_Out_Ind,
			 PDU_Out_ErrOut => PDU_Out_ErrOut,
			 PDU_Out_USER_Out => PDU_Out_USER_Out,
			 PDU_Out_Ack => PDU_Out_Ack,
			 PDU_Out_ErrIn => PDU_Out_ErrIn,
			 PDU_DIN => PDU_DIN,
			 PDU_DINV => PDU_DINV,
			 PDU_IN_SOP => PDU_IN_SOP,
			 PDU_IN_EOP => PDU_IN_EOP,
			 PDU_IN_Ind => PDU_IN_Ind,
			 PDU_IN_USER_In => PDU_IN_USER_In,
			 PDU_IN_ErrIn => PDU_IN_ErrIn,
			 PDU_IN_ErrOut => PDU_IN_ErrOut,
			 PDU_IN_Ack => PDU_IN_Ack,
			 SDU_DOUT => SDU_DOUT,
			 SDU_DOUTV => SDU_DOUTV,
			 SDU_Out_SOP => SDU_Out_SOP,
			 SDU_OUT_EOP => SDU_OUT_EOP,
			 SDU_OUT_Ind => SDU_OUT_Ind,
			 SDU_OUT_USER_Out => SDU_OUT_USER_Out,
			 SDU_OUT_ErrOut => SDU_OUT_ErrOut,
			 SDU_OUT_ErrIn => SDU_OUT_ErrIn,
			 SDU_OUT_Ack => SDU_OUT_Ack,
			 Status => Status
		  );
		PDU_DIN		<=	PDU_DOUT;
		PDU_DINV		<=	PDU_DOUTV;
		PDU_IN_SOP	<=	PDU_Out_SOP;
		PDU_IN_EOP	<=	PDU_Out_EOP;
		PDU_IN_Ind	<=	PDU_Out_Ind;
		PDU_IN_ErrIn	<=	PDU_Out_ErrOut;
		PDU_Out_Ack	<=	PDU_IN_Ack;
		PDU_Out_ErrIn	<=	PDU_IN_ErrOut;
		EthType_In	<=	EthType_Out;
		
	-- Clock process definitions
	CLK_process :process
	begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
	end process;
 
	CFG_CE	<=	CE;
	-- Stimulus process
	stim_proc: process
	BEGIN
		WAIT_CLK(CLK_period,20);

		CFG_WRITE(CLK_period,0,0,X"0a0a000b",CFG_ADDR,CFG_ADDR_WR,ADDR,DATA_IN,WR_EN);
		CFG_WRITE(CLK_period,1,0,X"FF000000",CFG_ADDR,CFG_ADDR_WR,ADDR,DATA_IN,WR_EN);
		CFG_WRITE(CLK_period,9,0,X"00000001",CFG_ADDR,CFG_ADDR_WR,ADDR,DATA_IN,WR_EN);
		CFG_WRITE(CLK_period,2,0,X"0a0a000b" or X"00FFFFFF",CFG_ADDR,CFG_ADDR_WR,ADDR,DATA_IN,WR_EN);
		CFG_WRITE(CLK_period,7,0,X"0aFFFFFE",CFG_ADDR,CFG_ADDR_WR,ADDR,DATA_IN,WR_EN);
		CFG_WRITE(CLK_period,0,4,X"0a0a000b" or X"00FFFFFF",CFG_ADDR,CFG_ADDR_WR,ADDR,DATA_IN,WR_EN);
		CFG_WRITE(CLK_period,11,4,X"0a0a000b" or X"00FFFFFF",CFG_ADDR,CFG_ADDR_WR,ADDR,DATA_IN,WR_EN);
		CFG_WRITE(CLK_period,12,0,X"00000011",CFG_ADDR,CFG_ADDR_WR,ADDR,DATA_IN,WR_EN);
		CFG_WRITE(CLK_period,13,0,X"22334455",CFG_ADDR,CFG_ADDR_WR,ADDR,DATA_IN,WR_EN);
		CFG_WRITE(CLK_period,14,0,X"22334455",CFG_ADDR,CFG_ADDR_WR,ADDR,DATA_IN,WR_EN);
		CFG_WRITE(CLK_period, 8,0,X"00000040",CFG_ADDR,CFG_ADDR_WR,ADDR,DATA_IN,WR_EN);
		CFG_READ(CLK_period,14,0,CFG_ADDR,CFG_ADDR_WR,ADDR,RD_EN);
		CFG_READ(CLK_period,12,0,CFG_ADDR,CFG_ADDR_WR,ADDR,RD_EN);
		CFG_READ(CLK_period,13,0,CFG_ADDR,CFG_ADDR_WR,ADDR,RD_EN);
		WAIT_CLK(CLK_period,10);
		DstMacAddr_In	<= X"001122334455";
		SrcMacAddr_In	<= X"66778899AABB";
		DstIPAddr_In	<= X"0aFFFFFF";
		SrcIPAddr_In	<= X"0a0a000b";
		Prot_In		<= X"11";
		Length_In		<= X"0008";
		Emit_PDU_SYNC(CLK_PERIOD,8,1,SDU_In_Ack,SDU_In_Ind,SDU_DIN,SDU_DINV,SDU_In_SOP,SDU_In_EOP);
		WAIT_CLK(CLK_period,10);
		ARP_EMulator(CLK_PERIOD,1,true,X"334455667788",ARP_Request,ARP_DSTIPAddr,ARP_ResponseV,ARP_ResponseErr,ARP_DstMacAddr);
		WAIT_CLK(CLK_period,10);
		Length_In		<= X"0020";
		Emit_PDU_SYNC(CLK_PERIOD,16,1,SDU_In_Ack,SDU_In_Ind,SDU_DIN,SDU_DINV,SDU_In_SOP,SDU_In_EOP);
		ARP_EMulator(CLK_PERIOD,1,false,X"334455667788",ARP_Request,ARP_DSTIPAddr,ARP_ResponseV,ARP_ResponseErr,ARP_DstMacAddr);
		WAIT_CLK(CLK_period,10);
		Emit_PDU_SYNC(CLK_PERIOD,16,1,SDU_In_Ack,SDU_In_Ind,SDU_DIN,SDU_DINV,SDU_In_SOP,SDU_In_EOP);
		ARP_EMulator(CLK_PERIOD,1,true,X"334455667788",ARP_Request,ARP_DSTIPAddr,ARP_ResponseV,ARP_ResponseErr,ARP_DstMacAddr);

		-- Emit_IP_PDU(	CLK_period,
			-- "0101",--IHL
			-- X"00",--constant	TOS			: in		std_logic_vector( 07 downto 0);
			-- X"0000",--		constant	Identification	: in		std_logic_vector( 15 downto 0);
			-- "010",--		constant	Flags		: in		std_logic_vector( 02 downto 0);
			-- "0000000000000",--		constant	FragmentOFFS	: in		std_logic_vector( 12 downto 0);
			-- X"40",--		constant	TTL			: in		std_logic_vector( 07 downto 0);
			-- X"10",--		constant	Protocol		: in		std_logic_vector( 07 downto 0);
			-- X"ac100001",--		constant	SRCAddr		: in		std_logic_vector( IPAddrSize-1 downto 0);
			-- X"ac100002",--		constant	DSTAddr		: in		std_logic_vector( IPAddrSize-1 downto 0);
			-- Options,--		constant	Options		: in		std_logic_vector( 44*8-1 downto 0);
			-- 64,--		constant	Plength		: in		integer;
			-- PDU_DIN,--		SIGNAL 	DO			: OUT 	STD_LOGIC_VECTOR( 7 downto 0);
			-- PDU_DINV,--		SIGNAL 	DV			: OUT 	STD_LOGIC;
			-- PDU_In_SOP,--		SIGNAL 	SOP			: OUT 	STD_LOGIC;
			-- PDU_In_EOP --,		SIGNAL 	EOP			: OUT 	STD_LOGIC
			-- );
		-- WAIT_CLK(CLK_period,1);
		-- Emit_IP_PDU(	CLK_period,
			-- "0101",--IHL
			-- X"00",--constant	TOS			: in		std_logic_vector( 07 downto 0);
			-- X"0000",--		constant	Identification	: in		std_logic_vector( 15 downto 0);
			-- "010",--		constant	Flags		: in		std_logic_vector( 02 downto 0);
			-- "0000000000000",--		constant	FragmentOFFS	: in		std_logic_vector( 12 downto 0);
			-- X"40",--		constant	TTL			: in		std_logic_vector( 07 downto 0);
			-- X"10",--		constant	Protocol		: in		std_logic_vector( 07 downto 0);
			-- X"ac100001",--		constant	SRCAddr		: in		std_logic_vector( IPAddrSize-1 downto 0);
			-- X"0a0a000b",--		constant	DSTAddr		: in		std_logic_vector( IPAddrSize-1 downto 0);
			-- Options,--		constant	Options		: in		std_logic_vector( 44*8-1 downto 0);
			-- 64,--		constant	Plength		: in		integer;
			-- PDU_DIN,--		SIGNAL 	DO			: OUT 	STD_LOGIC_VECTOR( 7 downto 0);
			-- PDU_DINV,--		SIGNAL 	DV			: OUT 	STD_LOGIC;
			-- PDU_In_SOP,--		SIGNAL 	SOP			: OUT 	STD_LOGIC;
			-- PDU_In_EOP --,		SIGNAL 	EOP			: OUT 	STD_LOGIC
			-- );

		-- WAIT_CLK(CLK_period,20);
		-- DstIPAddr_In	<=	X"0a0a11cd";
		-- SrcIPAddr_In	<=	X"0a0a000b";
		-- Prot_In		<=	X"FE";
		-- Length_In		<=	X"0040";
		-- Emit_PDU_SYNC(CLK_PERIOD,148,1,SDU_In_Ack,SDU_In_Ind,SDU_DIN,SDU_DINV,SDU_In_SOP,SDU_In_EOP);
		-- -- Emit_PDU(CLK_PERIOD,64,SDU_DIN,SDU_DINV,SDU_In_SOP,SDU_In_EOP);
		ARP_EMulator(CLK_PERIOD,1,false,X"334455667788",ARP_Request,ARP_DSTIPAddr,ARP_ResponseV,ARP_ResponseErr,ARP_DstMacAddr);
		-- WAIT_CLK(CLK_period,1);
		-- DstIPAddr_In	<=	X"bb0a11cd";
		-- SrcIPAddr_In	<=	X"0a0a000b";
		-- Prot_In		<=	X"FE";
		-- Length_In		<=	X"0040";
		
		-- Emit_PDU_SYNC(CLK_PERIOD,148,1,SDU_In_Ack,SDU_In_Ind,SDU_DIN,SDU_DINV,SDU_In_SOP,SDU_In_EOP);
		-- -- insert stimulus here 
		
		ARP_EMulator(CLK_PERIOD,1,false,X"224455667788",ARP_Request,ARP_DSTIPAddr,ARP_ResponseV,ARP_ResponseErr,ARP_DstMacAddr);
		
		wait;
	end process;

OUT_Acker: Acker PORT MAP(
	clk => clk,
	set => OUTACK_SET,
	rst => OUTACK_RST,
	I => PDU_Out_Ind,
	delay => OUTACK_delay,
	resp_width => OUTACK_width,
	Q => PDU_Out_Ack
);
RSTer: Resetter PORT MAP(CLK,RST,CE);
END;
