--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:	14:48:51 04/08/2013
-- Design Name:	
-- Module Name:	C:/ferenc.janky/ISE/proto_tx/Proto_TX_test_2.vhd
-- Project Name:  proto_tx
-- Target Device:  
-- Tool versions:  
-- Description:	
-- 
-- VHDL Test Bench Created by ISE for module: ProtoModule_TXPart
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
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;
USE IEEE.numeric_std.ALL;

library work;
use work.PDUQueuePkg.all;
use work.TypesAndDefinitonsPkg.all;
use work.Simulation.all;
use work.ProtoModulePkg.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Proto_TX_test_2 IS
END Proto_TX_test_2;
 
ARCHITECTURE behavior OF Proto_TX_test_2 IS 
 
	 -- Component Declaration for the Unit Under Test (UUT)
  

	--Inputs
	signal CLK : std_logic := '0';
	signal CE : std_logic := '0';
	signal RST : std_logic := '0';
	signal PCI_DIN : std_logic_vector(7 downto 0) := (others => '0');
	signal PCI_DINV : std_logic := '0';
	signal PCI_SOP : std_logic := '0';
	signal PCI_EOP : std_logic := '0';
	signal PCI_Ind : std_logic := '0';
	signal PCI_ErrIn : std_logic := '0';
	signal PCI_USER_In : std_logic_vector(5 downto 0) := (others => '0');
	signal SDU_DIN : std_logic_vector(7 downto 0) := (others => '0');
	signal SDU_DINV : std_logic := '0';
	signal SDU_SOP : std_logic := '0';
	signal SDU_EOP : std_logic := '0';
	signal SDU_Ind : std_logic := '0';
	signal SDU_ErrIn : std_logic := '0';
	signal SDU_USER_In : std_logic_vector(5 downto 0) := (others => '0');
	signal Out_Ack : std_logic := '0';
	signal Out_ErrIn : std_logic := '0';

 	--Outputs
	signal PCI_Ack : std_logic;
	signal PCI_ErrOut : std_logic;
	signal SDU_Ack : std_logic;
	signal SDU_ErrOut : std_logic;
	signal DOUT : std_logic_vector(7 downto 0);
	signal DOUTV : std_logic;
	signal Out_SOP : std_logic;
	signal Out_EOP : std_logic;
	signal Out_Ind : std_logic;
	signal Out_ErrOut : std_logic;
	signal USER_Out : std_logic_vector(5 downto 0);

	-- Clock period definitions
	constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
	uut: ProtoModule_TXPart 
	-- GENERIC MAP(
		-- -- DataWidth				:		integer	:=	DataWidth;
		-- -- SYNC_IN_SDU			:		boolean	:=	false;
		-- -- SYNC_IN_PCI			:		boolean	:=	false;
		-- -- SYNC_OUT				:		boolean	:=	false;
		-- -- MINSDUSize			:		integer	:=	DefMinSDUSize;
		-- -- MAXSDUSize			:		integer	:=	DefMaxSDUSize;
		-- -- MaxSDUToQ				:		integer	:=	DefPDUToQ;
		-- -- MINPCISize			:		integer	:=	DefPCISize;
		-- -- MAXPCISize			:		integer	:=	DefPCISize;
		-- -- MaxPCIToQ				:		integer	:=	DefPDUToQ
	-- )
	PORT MAP (
			 CLK => CLK,
			 CE => CE,
			 RST => RST,
			 PCI_DIN => PCI_DIN,
			 PCI_DINV => PCI_DINV,
			 PCI_SOP => PCI_SOP,
			 PCI_EOP => PCI_EOP,
			 PCI_Ind => PCI_Ind,
			 PCI_ErrIn => PCI_ErrIn,
			 PCI_USER_In => PCI_USER_In,
			 PCI_Ack => PCI_Ack,
			 PCI_ErrOut => PCI_ErrOut,
			 SDU_DIN => SDU_DIN,
			 SDU_DINV => SDU_DINV,
			 SDU_SOP => SDU_SOP,
			 SDU_EOP => SDU_EOP,
			 SDU_Ind => SDU_Ind,
			 SDU_ErrIn => SDU_ErrIn,
			 SDU_USER_In => SDU_USER_In,
			 SDU_Ack => SDU_Ack,
			 SDU_ErrOut => SDU_ErrOut,
			 DOUT => DOUT,
			 DOUTV => DOUTV,
			 Out_SOP => Out_SOP,
			 Out_EOP => Out_EOP,
			 Out_Ind => Out_Ind,
			 Out_ErrOut => Out_ErrOut,
			 USER_Out => USER_Out,
			 Out_Ack => Out_Ack,
			 Out_ErrIn => Out_ErrIn
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
	Init_Module(CLK_period,5,3,RST,CE);
	Emit_PDU(CLK_period,65,PCI_DIN,PCI_DINV,PCI_SOP,PCI_EOP);
	Emit_PDU(CLK_period,127,SDU_DIN,SDU_DINV,SDU_SOP,SDU_EOP);
	
	Emit_PDU(CLK_period,32,PCI_DIN,PCI_DINV,PCI_SOP,PCI_EOP);
	Emit_PDU(CLK_period,64,SDU_DIN,SDU_DINV,SDU_SOP,SDU_EOP);
	
	PCI_USER_In(0)<= Hi; --Just PCI ASM test
	Emit_PDU(CLK_period,128,PCI_DIN,PCI_DINV,PCI_SOP,PCI_EOP);
	PCI_USER_In(0)<= Lo;
	
		-- insert stimulus here 

		wait;
	end process;

END;
