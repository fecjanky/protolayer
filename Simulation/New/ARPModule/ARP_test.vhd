--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:46:02 04/19/2013
-- Design Name:   
-- Module Name:   D:/Users/fjanky/ISE/ARPModule/ARP_test.vhd
-- Project Name:  ARPModule
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ARPModule
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
use work.ARPModulePkg.ArpModule;
use work.ProtoLayerTypesAndDefs.all;
use work.Simulation.all;


ENTITY ARP_test IS
END ARP_test;
 
ARCHITECTURE behavior OF ARP_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 


   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal CE : std_logic := '0';
   signal PDU_Out_Ack : std_logic := '0';
   signal PDU_Out_ErrIn : std_logic := '0';
   signal DST_MacAddr_In : std_logic_vector(47 downto 0) := (others => '0');
   signal SRC_MacAddr_In : std_logic_vector(47 downto 0) := (others => '0');
   signal EType_In : std_logic_vector(15 downto 0) := (others => '0');
   signal PDU_DIN : std_logic_vector(7 downto 0) := (others => '0');
   signal PDU_DINV : std_logic := '0';
   signal PDU_In_SOP : std_logic := '0';
   signal PDU_In_EOP : std_logic := '0';
   signal PDU_In_Ind : std_logic := '0';
   signal PDU_In_ErrIn : std_logic := '0';
   signal ARP_ReqUest : std_logic := '0';
   signal ARP_DST_IP_addr : std_logic_vector(31 downto 0) := (others => '0');
   signal IPADDR_WR_EN : std_logic := '0';
   signal MACADDR_WR_EN : std_logic := '0';
   signal IPADDR_RD_EN : std_logic := '0';
   signal MACADDR_RD_EN : std_logic := '0';
   signal ADDR : std_logic_vector(0 downto 0) := (others => '0');
   signal ADDR_DATA_IN : std_logic_vector(47 downto 0) := (others => '0');

	--Outputs
   signal DST_MacAddr_Out : std_logic_vector(47 downto 0);
   signal SRC_MacAddr_Out : std_logic_vector(47 downto 0);
   signal EType_Out : std_logic_vector(15 downto 0);
   signal PDU_DOUT : std_logic_vector(7 downto 0);
   signal PDU_DOUTV : std_logic;
   signal PDU_Out_SOP : std_logic;
   signal PDU_Out_EOP : std_logic;
   signal PDU_Out_Ind : std_logic;
   signal PDU_Out_ErrOut : std_logic;
   signal PDU_In_Ack : std_logic;
   signal PDU_In_ErrOut : std_logic;
   signal ARP_DST_MAC_addr : std_logic_vector(47 downto 0);
   signal ARP_RESPONSEV : std_logic;
   signal ARP_RESPONSE_ERR : std_logic;
   signal IPADDR_DATA_OUT : std_logic_vector(31 downto 0);
   signal MACADDR_DATA_OUT : std_logic_vector(47 downto 0);
   signal IPADDR_DV : std_logic;
   signal MACADDR_DV : std_logic;

   
   signal OUTACK_SET		: std_logic := '0';
   signal OUTACK_RST		: std_logic := '0';
   signal OUTACK_delay		: integer := 1;
   signal OUTACK_width   	: integer := 1;
   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
	uut: ARPModule 
	GENERIC MAP(
		DataWidth			=>	DefDataWidth,
		TX_SYNC_OUT		=>	true,
		RX_SYNC_IN		=>	false,
		NumOfAddresses		=>	DefNumOfIPAddr, --Maximum 16, for each IP a MAC addr must be defined and vice-versa
		CLK_freq			=>	125.0, --Clock frequency in MHz
		TimeOUT			=>	0.001, --timeout in ms
		RetryCnt			=>	2	--retry count
	)
   PORT MAP (
		CLK => CLK,
		RST => RST,
		CE => CE,
		CFG_CE => CE,
		DST_MacAddr_Out => DST_MacAddr_Out,
		SRC_MacAddr_Out => SRC_MacAddr_Out,
		EType_Out => EType_Out,
		PDU_DOUT => PDU_DOUT,
		PDU_DOUTV => PDU_DOUTV,
		PDU_Out_SOP => PDU_Out_SOP,
		PDU_Out_EOP => PDU_Out_EOP,
		PDU_Out_Ind => PDU_Out_Ind,
		PDU_Out_ErrOut => PDU_Out_ErrOut,
		PDU_Out_Ack => PDU_Out_Ack,
		PDU_Out_ErrIn => PDU_Out_ErrIn,
		DST_MacAddr_In => DST_MacAddr_In,
		SRC_MacAddr_In => SRC_MacAddr_In,
		EType_In => EType_In,
		PDU_DIN => PDU_DIN,
		PDU_DINV => PDU_DINV,
		PDU_In_SOP => PDU_In_SOP,
		PDU_In_EOP => PDU_In_EOP,
		PDU_In_Ind => PDU_In_Ind,
		PDU_In_ErrIn => PDU_In_ErrIn,
		PDU_In_Ack => PDU_In_Ack,
		PDU_In_ErrOut => PDU_In_ErrOut,
		ARP_ReqUest => ARP_ReqUest,
		ARP_DST_IP_addr => ARP_DST_IP_addr,
		ARP_DST_MAC_addr => ARP_DST_MAC_addr,
		ARP_RESPONSEV => ARP_RESPONSEV,
		ARP_RESPONSE_ERR => ARP_RESPONSE_ERR,
		IPADDR_WR_EN => IPADDR_WR_EN,
		MACADDR_WR_EN => MACADDR_WR_EN,
		IPADDR_RD_EN => IPADDR_RD_EN,
		MACADDR_RD_EN => MACADDR_RD_EN,
		ADDR => ADDR,
		ADDR_DATA_IN => ADDR_DATA_IN,
		IPADDR_DATA_OUT => IPADDR_DATA_OUT,
		MACADDR_DATA_OUT => MACADDR_DATA_OUT,
		IPADDR_DV => IPADDR_DV,
		MACADDR_DV => MACADDR_DV
	   );

   -- Clock process definitions
   CLK_process :process
	begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
	end process;
 

   -- Stimulus process
	stim_proc: process
	begin		
	 -- hold reset state for 100 ns.
		-- Init_Module(CLK_period,5,5,RST,CE);
	 -- insert stimulus here 
	-------WRITE IP addresses
		WAIT_CLK(CLK_period,20);
		WR_CAM(CLK_period,0,X"AC100002",IPADDR_WR_EN,ADDR,ADDR_DATA_IN(IpAddrSize-1 downto 0));
		WAIT_CLK(CLK_period,2);
		WR_CAM(CLK_period,0,X"001122334455",MACADDR_WR_EN,ADDR,ADDR_DATA_IN);
		
		WAIT_CLK(CLK_period,10);
		EType_In	<=	EType_ARP;
		-- Emit_ARP_PDU_Sync(CLK_period,ares_op_REQ,X"665544332211",X"AC100003",X"FFFFFFFFFFFF",X"AC100002",PDU_In_Ack,PDU_In_Ind,PDU_DIN,PDU_DINV,PDU_In_SOP,PDU_In_EOP);
		Emit_ARP_PDU(CLK_period,ares_op_REQ,X"665544332211",X"AC100003",X"FFFFFFFFFFFF",X"AC100002",PDU_DIN,PDU_DINV,PDU_In_SOP,PDU_In_EOP);
		WAIT_CLK(CLK_period,12);
		-- Emit_ARP_PDU_Sync(CLK_period,ares_op_REQ,X"665544332211",X"AC100003",X"FFFFFFFFFFFF",X"AC100002",PDU_In_Ack,PDU_In_Ind,PDU_DIN,PDU_DINV,PDU_In_SOP,PDU_In_EOP);
		EType_In	<=	X"1234";
		Emit_ARP_PDU(CLK_period,ares_op_REQ,X"665544332211",X"AC100003",X"FFFFFFFFFFFF",X"AC100002",PDU_DIN,PDU_DINV,PDU_In_SOP,PDU_In_EOP);
		WAIT_CLK(CLK_period,20);
		EType_In			<=	EType_ARP;
		ARP_DST_IP_addr	<=	X"AC100003";
		ARP_ReqUest		<=	Hi;
		WAIT_CLK(CLK_period,50);
		-- Emit_ARP_PDU_Sync(CLK_period,ares_op_REP,X"665544332211",X"AC100003",X"001122334455",X"AC100002",PDU_In_Ack,PDU_In_Ind,PDU_DIN,PDU_DINV,PDU_In_SOP,PDU_In_EOP);
		Emit_ARP_PDU(CLK_period,ares_op_REP,X"665544332211",X"AC100003",X"001122334455",X"AC100002",PDU_DIN,PDU_DINV,PDU_In_SOP,PDU_In_EOP);
		WAIT_FOR(CLK_period,Hi,ARP_RESPONSEV);
		ARP_ReqUest		<=	Lo;
		-- Emit_ARP_PDU_Sync(CLK_period,ares_op_REQ,X"665544332211",X"AC100003",X"FFFFFFFFFFFF",X"AC100002",PDU_In_Ack,PDU_In_Ind,PDU_DIN,PDU_DINV,PDU_In_SOP,PDU_In_EOP);
		Emit_ARP_PDU(CLK_period,ares_op_REQ,X"665544332211",X"AC100003",X"FFFFFFFFFFFF",X"AC100002",PDU_DIN,PDU_DINV,PDU_In_SOP,PDU_In_EOP);
		ARP_DST_IP_addr	<=	X"AC100003";
		ARP_ReqUest		<=	Hi;
		WAIT_CLK(CLK_period,50);
		-- Emit_ARP_PDU_Sync(CLK_period,ares_op_REP,X"665544332211",X"AC100003",X"001122334455",X"AC100002",PDU_In_Ack,PDU_In_Ind,PDU_DIN,PDU_DINV,PDU_In_SOP,PDU_In_EOP);
		Emit_ARP_PDU(CLK_period,ares_op_REQ,X"665544332211",X"AC100003",X"FFFFFFFFFFFF",X"AC100002",PDU_DIN,PDU_DINV,PDU_In_SOP,PDU_In_EOP);
		WAIT_CLK(CLK_period,50);	
		Emit_ARP_PDU(CLK_period,ares_op_REP,X"665544332211",X"AC100003",X"001122334455",X"AC100002",PDU_DIN,PDU_DINV,PDU_In_SOP,PDU_In_EOP);

		wait;
	end process;
	
	OUT_Acker: Acker PORT MAP(
	clk => clk,
	set => OUTACK_SET,
	rst => OUTACK_RST,
	I => PDU_Out_Ind,
	delay => OUTACK_delay,
	resp_width => OUTACK_width,
	Q => PDU_Out_Ack);
	
	Inst_Resetter: Resetter PORT MAP(
		CLK => CLK,
		RST => RST,
		CE => CE 
	);


END;
