--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:	14:18:31 04/26/2013
-- Design Name:	
-- Module Name:	D:/Users/fjanky/VHDL/code/ProtoLayer/Simulation/New/IPLayer/IPRXCheck_test.vhd
-- Project Name:  IPLayer
-- Target Device:  
-- Tool versions:  
-- Description:	
-- 
-- VHDL Test Bench Created by ISE for module: IP_RX_Cheksum_Calc
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
use work.IPLayerPkg.IP_RX_Cheksum_Calc;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY IPRXCheck_test IS
END IPRXCheck_test;
 
ARCHITECTURE behavior OF IPRXCheck_test IS 
 
	 -- Component Declaration for the Unit Under Test (UUT)
	 

	--Inputs
	signal CLK : std_logic := '0';
	signal RST : std_logic := '0';
	signal CE : std_logic := '0';
	signal DIN : std_logic_vector(7 downto 0) := (others => '0');
	signal DINV : std_logic := '0';
	signal In_SOP : std_logic := '0';
	signal In_EOP : std_logic := '0';
	signal IN_ErrIn : std_logic := '0';
	signal EType_In : std_logic_vector( EtherTypeSize-1 downto 0) := (others => '0');
 	--Outputs
	signal DOUT : std_logic_vector(7 downto 0);
	signal DOUTV : std_logic;
	signal Out_SOP : std_logic;
	signal Out_EOP : std_logic;
	signal Out_ErrOut : std_logic;
	signal ChecksumError : std_logic;
	signal IPHeader : std_logic;
	signal OutV : std_logic;

	-- Clock period definitions
	constant CLK_period : time := 10 ns;
	
	signal Options		:		std_logic_vector( 44*8-1 downto 0) := (others => Lo);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
	uut: IP_RX_Cheksum_Calc PORT MAP (
			 CLK => CLK,
			 RST => RST,
			 CE => CE,
			 EType_In => EType_In,
			 DIN => DIN,
			 DINV => DINV,
			 In_SOP => In_SOP,
			 In_EOP => In_EOP,
			 IN_ErrIn => IN_ErrIn,
			 DOUT => DOUT,
			 DOUTV => DOUTV,
			 Out_SOP => Out_SOP,
			 Out_EOP => Out_EOP,
			 Out_ErrOut => Out_ErrOut,
			 ChecksumError => ChecksumError,
			 IPHeader => IPHeader,
			 OutV => OutV
		  );
INITTER:Resetter PORT MAP(CLK=>CLK,RST =>RST,CE=>CE);
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
		-- insert stimulus here 
		WAIT_CLK(CLK_period,20);
		EType_In	<= X"0800";
Emit_IP_PDU(	CLK_period,
			"0101",--IHL
			X"00",--constant	TOS			: in		std_logic_vector( 07 downto 0);
			X"0000",--		constant	Identification	: in		std_logic_vector( 15 downto 0);
			"010",--		constant	Flags		: in		std_logic_vector( 02 downto 0);
			"0000000000000",--		constant	FragmentOFFS	: in		std_logic_vector( 12 downto 0);
			X"40",--		constant	TTL			: in		std_logic_vector( 07 downto 0);
			X"10",--		constant	Protocol		: in		std_logic_vector( 07 downto 0);
			X"ac100001",--		constant	SRCAddr		: in		std_logic_vector( IPAddrSize-1 downto 0);
			X"ac100002",--		constant	DSTAddr		: in		std_logic_vector( IPAddrSize-1 downto 0);
			Options,--		constant	Options		: in		std_logic_vector( 44*8-1 downto 0);
			64,--		constant	Plength		: in		integer;
			DIN,--		SIGNAL 	DO			: OUT 	STD_LOGIC_VECTOR( 7 downto 0);
			DINV,--		SIGNAL 	DV			: OUT 	STD_LOGIC;
			In_SOP,--		SIGNAL 	SOP			: OUT 	STD_LOGIC;
			In_EOP --,		SIGNAL 	EOP			: OUT 	STD_LOGIC
			);
			WAIT_CLK(CLK_period,1);
			EType_In	<= X"0900";
Emit_IP_PDU(	CLK_period,
			"0101",--IHL
			X"00",--constant	TOS			: in		std_logic_vector( 07 downto 0);
			X"0000",--		constant	Identification	: in		std_logic_vector( 15 downto 0);
			"010",--		constant	Flags		: in		std_logic_vector( 02 downto 0);
			"0000000000000",--		constant	FragmentOFFS	: in		std_logic_vector( 12 downto 0);
			X"40",--		constant	TTL			: in		std_logic_vector( 07 downto 0);
			X"10",--		constant	Protocol		: in		std_logic_vector( 07 downto 0);
			X"ac100010",--		constant	SRCAddr		: in		std_logic_vector( IPAddrSize-1 downto 0);
			X"ac100011",--		constant	DSTAddr		: in		std_logic_vector( IPAddrSize-1 downto 0);
			Options,--		constant	Options		: in		std_logic_vector( 44*8-1 downto 0);
			64,--		constant	Plength		: in		integer;
			DIN,--		SIGNAL 	DO			: OUT 	STD_LOGIC_VECTOR( 7 downto 0);
			DINV,--		SIGNAL 	DV			: OUT 	STD_LOGIC;
			In_SOP,--		SIGNAL 	SOP			: OUT 	STD_LOGIC;
			In_EOP --,		SIGNAL 	EOP			: OUT 	STD_LOGIC
			);
			EType_In	<= X"0800";
Emit_IP_PDU(	CLK_period,
			"0101",--IHL
			X"00",--constant	TOS			: in		std_logic_vector( 07 downto 0);
			X"0000",--		constant	Identification	: in		std_logic_vector( 15 downto 0);
			"010",--		constant	Flags		: in		std_logic_vector( 02 downto 0);
			"0000000000000",--		constant	FragmentOFFS	: in		std_logic_vector( 12 downto 0);
			X"40",--		constant	TTL			: in		std_logic_vector( 07 downto 0);
			X"10",--		constant	Protocol		: in		std_logic_vector( 07 downto 0);
			X"ac100010",--		constant	SRCAddr		: in		std_logic_vector( IPAddrSize-1 downto 0);
			X"ac100011",--		constant	DSTAddr		: in		std_logic_vector( IPAddrSize-1 downto 0);
			Options,--		constant	Options		: in		std_logic_vector( 44*8-1 downto 0);
			64,--		constant	Plength		: in		integer;
			DIN,--		SIGNAL 	DO			: OUT 	STD_LOGIC_VECTOR( 7 downto 0);
			DINV,--		SIGNAL 	DV			: OUT 	STD_LOGIC;
			In_SOP,--		SIGNAL 	SOP			: OUT 	STD_LOGIC;
			In_EOP --,		SIGNAL 	EOP			: OUT 	STD_LOGIC
			);
		wait;
	end process;

END;
