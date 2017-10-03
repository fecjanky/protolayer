--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:18:45 04/11/2013
-- Design Name:   
-- Module Name:   D:/VHDL/Simulation/New/EthernetModule/EtherModule_Test.vhd
-- Project Name:  EthernetModule
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: EthernetLayer
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
 
use work.EthernetLayerPkg.EthernetLayer;
use work.Simulation.all;
use work.ProtoLayerTypesAndDefs.all;


ENTITY EtherModule_Test IS
END EtherModule_Test;
 
ARCHITECTURE behavior OF EtherModule_Test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    

   --Inputs
   signal CLK : std_logic := '0';
   signal CE : std_logic := '0';
   signal RST : std_logic := '0';
   signal WR_EN : std_logic := '0';
   signal RD_EN : std_logic := '0';
   signal ADDR : std_logic_vector(0 downto 0) := (others => '0');
   signal ADDR_DATA_IN : std_logic_vector(47 downto 0) := (others => '0');
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
   signal ADDR_DATA_OUT : std_logic_vector(47 downto 0);
   signal ADDR_DV : std_logic;
   signal DstMacAddr_Out : std_logic_vector(47 downto 0);
   signal SrcMacAddr_Out : std_logic_vector(47 downto 0);
   signal EthType_Out : std_logic_vector(15 downto 0);
   signal SDU_IN_Ack : std_logic;
   signal SDU_IN_ErrOut : std_logic;
   signal PDU_DOUT : std_logic_vector(7 downto 0);
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
   
   signal RX_AUX_In : std_logic_vector(2*MacAddrSize-1 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
	uut: EthernetLayer 
	generic map(
		DataWidth			=>		DefDataWidth,
		RX_SYNC_IN		=>		false,
		RX_SYNC_OUT		=>		false,
		TX_SYNC_IN		=>		false,
		TX_SYNC_OUT		=>		false,
		MINSDUSize		=>		DefMinSDUSize,
		MAXSDUSize		=>		DefMaxSDUSize,
		MaxSDUToQ			=>		DefPDUToQ,
		MINPCISize		=>		DefPCISize,
		MAXPCISize		=>		DefPCISize,
		MaxPCIToQ			=>		DefPDUToQ,
		NumOfMacAddresses	=>		DefNumOfMacAddr
	)
	PORT MAP (
		CLK => CLK,
		CE => CE,
		RST => RST,
		WR_EN => WR_EN,
		RD_EN => RD_EN,
		ADDR => ADDR,
		ADDR_DATA_IN => ADDR_DATA_IN,
		ADDR_DATA_OUT => ADDR_DATA_OUT,
		ADDR_DV => ADDR_DV,
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
		SDU_OUT_Ack => SDU_OUT_Ack
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
	Init_Module(CLK_period,5,5,RST,CE);
	WAIT_CLK(CLK_period,10);
	WR_CAM(CLK_period,0,X"001122334455",WR_EN,ADDR,ADDR_DATA_IN);
	WAIT_CLK(CLK_period,10);
	DstMacAddr_In	<=	X"FFFFFFFFFFFF";
	SrcMacAddr_In	<=	X"001122334455";
	EthType_In	<=	X"8021";
	Emit_PDU(CLK_period,64,SDU_DIN,SDU_DINV,SDU_IN_SOP,SDU_IN_EOP);
	WAIT_CLK(CLK_period,10);
	DstMacAddr_In	<=	X"332211001122";
	SrcMacAddr_In	<=	X"665544332211";
	EthType_In	<=	X"1010";
	Emit_PDU(CLK_period,64,SDU_DIN,SDU_DINV,SDU_IN_SOP,SDU_IN_EOP);
	WAIT_CLK(CLK_period,10);
	RX_AUX_In	<=	X"FFFFFFFFFFFF013344556677";
	Emit_ETHFrame(CLK_period,X"FFFFFFFFFFFF",X"013344556677",X"8021",64,PDU_DIN,PDU_DINV,PDU_IN_SOP,PDU_IN_EOP);
	WAIT_CLK(CLK_period,10);
	RX_AUX_In	<=	X"001122334455013344556677";
	Emit_ETHFrame(CLK_period,X"001122334455",X"013344556677",X"8021",64,PDU_DIN,PDU_DINV,PDU_IN_SOP,PDU_IN_EOP);
	WAIT_CLK(CLK_period,10);
	RX_AUX_In	<=	X"013344556677665544332211";
	Emit_ETHFrame(CLK_period,X"013344556677",X"665544332211",X"8021",64,PDU_DIN,PDU_DINV,PDU_IN_SOP,PDU_IN_EOP);
	RX_AUX_In	<=	X"FFFFFFFFFFFF013344556677";
	WAIT_CLK(CLK_period,40);
	RX_AUX_In	<=	X"001122334455013344556677";
	Emit_ETHFrame(CLK_period,X"001122334455",X"013344556677",X"8021",64,PDU_DIN,PDU_DINV,PDU_IN_SOP,PDU_IN_EOP);

	 -- insert stimulus here 

	wait;
	end process;

END;
