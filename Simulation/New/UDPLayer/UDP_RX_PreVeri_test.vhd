--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:	15:22:28 05/07/2013
-- Design Name:	
-- Module Name:	D:/Users/fjanky/VHDL/code/ProtoLayer/Simulation/New/UDPLayer/UDP_RX_PreVeri_test.vhd
-- Project Name:  UDPLayer
-- Target Device:  
-- Tool versions:  
-- Description:	
-- 
-- VHDL Test Bench Created by ISE for module: UDP_RX_PreVerifier
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic AND
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;
USE IEEE.numeric_std.ALL;
library UNISIM;  
use UNISIM.Vcomponents.all;

use work.ProtoLayerTypesAndDefs.all;
use work.Simulation.all;
use work.UDPLayerPkg.UDP_RX_PreVerifier;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY UDP_RX_PreVeri_test IS
END UDP_RX_PreVeri_test;
 
ARCHITECTURE behavior OF UDP_RX_PreVeri_test IS 
 
	-- Component Declaration for the Unit Under Test (UUT)
 
	

	--Inputs
	signal CLK : std_logic := '0';
	signal RST : std_logic := '0';
	signal CE : std_logic := '0';
	signal IP_DstIPAddr_In : std_logic_vector(31 downto 0) := (others	=>	'0');
	signal IP_SrcIPAddr_In : std_logic_vector(31 downto 0) := (others	=>	'0');
	signal IP_Proto_In : std_logic_vector(7 downto 0) := (others	=>	'0');
	signal IP_Length_In : std_logic_vector(15 downto 0) := (others	=>	'0');
	signal DIN : std_logic_vector(7 downto 0) := (others	=>	'0');
	signal DINV : std_logic := '0';
	signal In_SOP : std_logic := '0';
	signal In_EOP : std_logic := '0';
	signal In_Ind : std_logic := '0';
	signal In_ErrIn : std_logic := '0';
	signal Out_Ack : std_logic := '0';
	signal Out_ErrIn : std_logic := '0';

 	--Outputs
	signal DstIPAddr_out : std_logic_vector(31 downto 0);
	signal SrcIPAddr_out : std_logic_vector(31 downto 0);
	signal In_Ack : std_logic;
	signal In_ErrOut : std_logic;
	signal DOUT : std_logic_vector(7 downto 0);
	signal DOUTV : std_logic;
	signal Out_SOP : std_logic;
	signal Out_EOP : std_logic;
	signal Out_Ind : std_logic;
	signal Out_ErrOut : std_logic;

	-- Clock period definitions
	constant CLK_period : time := 8 ns;

	signal OUTACK_SET		: std_logic := '0';
	signal OUTACK_RST		: std_logic := '0';
	signal OUTACK_delay		: integer := 1;
	signal OUTACK_width		: integer := 1;
	
	signal In_ErrIn_SET		: std_logic := '0';
	signal In_ErrIn_RST		: std_logic := '0';
	signal In_ErrIn_delay	: integer := 1;
	signal In_ErrIn_width	: integer := 1;
	
	signal Out_ErrIn_SET	: std_logic := '0';
	signal Out_ErrIn_RST	: std_logic := '0';
	signal Out_ErrIn_delay	: integer := 1;
	signal Out_ErrIn_width	: integer := 1;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
	uut: UDP_RX_PreVerifier 
	GENERIC MAP(
		DataWidth				=>	DefDataWidth,
		SYNC_IN				=>	true
	)
	PORT MAP (
			CLK				=>	CLK,
			RST				=>	RST,
			CE				=>	CE,
			IP_DstIPAddr_In	=>	IP_DstIPAddr_In,
			IP_SrcIPAddr_In	=>	IP_SrcIPAddr_In,
			IP_Proto_In		=>	IP_Proto_In,
			IP_Length_In		=>	IP_Length_In,
			DstIPAddr_out		=>	DstIPAddr_out,
			SrcIPAddr_out		=>	SrcIPAddr_out,
			DIN				=>	DIN,
			DINV				=>	DINV,
			In_SOP			=>	In_SOP,
			In_EOP			=>	In_EOP,
			In_Ind			=>	In_Ind,
			In_ErrIn			=>	In_ErrIn,
			In_Ack			=>	In_Ack,
			In_ErrOut			=>	In_ErrOut,
			DOUT				=>	DOUT,
			DOUTV			=>	DOUTV,
			Out_SOP			=>	Out_SOP,
			Out_EOP			=>	Out_EOP,
			Out_Ind			=>	Out_Ind,
			Out_ErrOut		=>	Out_ErrOut,
			Out_Ack			=>	Out_Ack,
			Out_ErrIn			=>	Out_ErrIn
		 );

	-- Clock process definitions
	CLK_process :process
	begin
		CLK <= '1';
		wait for CLK_period/2;
		CLK <= '0';
		wait for CLK_period/2;
	end process;
 
	RSTer	: Resetter PORT MAP(CLK,RST,CE);
	OUT_Acker	: Acker 
	PORT MAP(
		clk			=>	clk,
		set			=>	OUTACK_SET,
		rst			=>	OUTACK_RST,
		I			=>	Out_Ind,
		delay		=>	OUTACK_delay,
		resp_width	=>	OUTACK_width,
		Q			=>	Out_Ack
	);
	In_ErrIn_Acker	: Acker 
	PORT MAP(
		clk			=>	clk,
		set			=>	In_ErrIn_SET,
		rst			=>	In_ErrIn_RST,
		I			=>	In_SOP,
		delay		=>	In_ErrIn_delay,
		resp_width	=>	In_ErrIn_width,
		Q			=>	In_ErrIn
	);
	Out_ErrIn_Acker	: Acker 
	PORT MAP(
		clk			=>	clk,
		set			=>	Out_ErrIn_SET,
		rst			=>	Out_ErrIn_RST,
		I			=>	Out_SOP,
		delay		=>	Out_ErrIn_delay,
		resp_width	=>	Out_ErrIn_width,
		Q			=>	Out_ErrIn
	);

	-- Stimulus process
	stim_proc: process
	begin		
		-- hold reset state for 100 ns.
		In_ErrIn_RST	<=	Hi;
		Out_ErrIn_RST	<=	Hi;
		OUTACK_RST	<=	Hi;
		WAIT_CLK(CLK_period,20);
		OUTACK_RST	<=	Lo;
		-- Emit_UDP_PDU(CLK_period,X"0a0a000a",X"0a0a000b",X"1988",X"0521",64,IP_SrcIPAddr_In,IP_DstIPAddr_In,IP_Proto_In,IP_Length_In,DIN,DINV,In_SOP,In_EOP);
		Emit_UDP_PDU_SYNC(CLK_period,X"0a0a000a",X"0a0a000b",X"1988",X"0521",32,IP_SrcIPAddr_In,IP_DstIPAddr_In,IP_Proto_In,IP_Length_In,DIN,DINV,In_SOP,In_EOP,In_Ind,In_Ack);
		WAIT_CLK(CLK_period,1);
		-- Emit_UDP_PDU(CLK_period,X"0a0a000a",X"0a0a000b",X"1988",X"0521",64,IP_SrcIPAddr_In,IP_DstIPAddr_In,IP_Proto_In,IP_Length_In,DIN,DINV,In_SOP,In_EOP);
		Emit_UDP_PDU_SYNC(CLK_period,X"0a0ae00c",X"0a0abb0b",X"1988",X"0521",17,IP_SrcIPAddr_In,IP_DstIPAddr_In,IP_Proto_In,IP_Length_In,DIN,DINV,In_SOP,In_EOP,In_Ind,In_Ack);
		WAIT_CLK(CLK_period,1);
		Emit_UDP_PDU(CLK_period,X"0a0a000a",X"0a0a000b",X"1988",X"0521",16,IP_SrcIPAddr_In,IP_DstIPAddr_In,IP_Proto_In,IP_Length_In,DIN,DINV,In_SOP,In_EOP);
		WAIT_CLK(CLK_period,1);
		Emit_UDP_PDU_SYNC(CLK_period,X"0a0a000a",X"0a0a000b",X"1988",X"0521",21,IP_SrcIPAddr_In,IP_DstIPAddr_In,IP_Proto_In,IP_Length_In,DIN,DINV,In_SOP,In_EOP,In_Ind,In_Ack);
		WAIT_CLK(CLK_period,10);
		
		IP_Proto_In	<=	X"22";
		Emit_PDU_SYNC(CLK_PERIOD,64,1,In_Ack,In_Ind,DIN,DINV,In_SOP,In_EOP);
		WAIT_CLK(CLK_period,10);
		Emit_UDP_PDU_SYNC(CLK_period,X"0a0a000a",X"0a0a000b",X"1988",X"0521",21,IP_SrcIPAddr_In,IP_DstIPAddr_In,IP_Proto_In,IP_Length_In,DIN,DINV,In_SOP,In_EOP,In_Ind,In_Ack);
		
		-- In_ErrIn_RST	<=	Lo;
		-- In_ErrIn_SET	<=	Hi;
		-- WAIT_CLK(CLK_period,2);
		-- Emit_UDP_PDU_SYNC(CLK_period,X"0a0a000a",X"0a0a000b",X"1988",X"0521",21,IP_SrcIPAddr_In,IP_DstIPAddr_In,IP_Proto_In,IP_Length_In,DIN,DINV,In_SOP,In_EOP,In_Ind,In_Ack);
		-- WAIT_CLK(CLK_period,2);
		-- In_ErrIn_RST	<=	Lo;
		-- -- In_ErrIn_delay	<=	0;
		-- Emit_UDP_PDU_SYNC(CLK_period,X"0a0a000a",X"0a0a000b",X"1988",X"0521",21,IP_SrcIPAddr_In,IP_DstIPAddr_In,IP_Proto_In,IP_Length_In,DIN,DINV,In_SOP,In_EOP,In_Ind,In_Ack);
		-- WAIT_CLK(CLK_period,2);
		-- In_ErrIn_delay	<=	1;
		-- Emit_UDP_PDU_SYNC(CLK_period,X"0a0a000a",X"0a0a000b",X"1988",X"0521",21,IP_SrcIPAddr_In,IP_DstIPAddr_In,IP_Proto_In,IP_Length_In,DIN,DINV,In_SOP,In_EOP,In_Ind,In_Ack);
		-- WAIT_CLK(CLK_period,2);
		-- In_ErrIn_delay	<=	2;
		-- Emit_UDP_PDU_SYNC(CLK_period,X"0a0a000a",X"0a0a000b",X"1988",X"0521",21,IP_SrcIPAddr_In,IP_DstIPAddr_In,IP_Proto_In,IP_Length_In,DIN,DINV,In_SOP,In_EOP,In_Ind,In_Ack);
		-- WAIT_CLK(CLK_period,2);
		Emit_PDU_SYNC(CLK_PERIOD,64,1,In_Ack,In_Ind,DIN,DINV,In_SOP,In_EOP);
		wait;
	end process;

END;
