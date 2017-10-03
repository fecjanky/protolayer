--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:	16:34:05 04/30/2013
-- Design Name:	
-- Module Name:	D:/Users/fjanky/VHDL/code/ProtoLayer/Simulation/New/ProtoLayer/EndArbitrator_test.vhd
-- Project Name:  GPlanar_test
-- Target Device:  
-- Tool versions:  
-- Description:	
-- 
-- VHDL Test Bench Created by ISE for module: End_Arbitrator_2
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
use work.ProtoModulePkg.End_Arbitrator_2;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY EndArbitrator_test IS
END EndArbitrator_test;
 
ARCHITECTURE behavior OF EndArbitrator_test IS 
 
	 -- Component Declaration for the Unit Under Test (UUT)
 
	--Inputs
	signal CLK : std_logic := '0';
	signal RST : std_logic := '0';
	signal CE : std_logic := '0';
	signal In_0_Data : std_logic_vector(7 downto 0) := (others => '0');
	signal In_0_DataV : std_logic := '0';
	signal In_0_SOP : std_logic := '0';
	signal In_0_EOP : std_logic := '0';
	signal In_0_ErrIn : std_logic := '0';
	signal In_0_Ind : std_logic := '0';
	signal In_1_Data : std_logic_vector(7 downto 0) := (others => '0');
	signal In_1_DataV : std_logic := '0';
	signal In_1_SOP : std_logic := '0';
	signal In_1_EOP : std_logic := '0';
	signal In_1_ErrIn : std_logic := '0';
	signal In_1_Ind : std_logic := '0';
	signal In_Data : std_logic_vector(7 downto 0) := (others => '0');
	signal In_DataV : std_logic := '0';
	signal In_SOP : std_logic := '0';
	signal In_EOP : std_logic := '0';
	signal In_ErrIn : std_logic := '0';

 	--Outputs
	signal In_0_Ack : std_logic;
	signal Out_0_Data : std_logic_vector(7 downto 0);
	signal Out_0_DataV : std_logic;
	signal Out_0_SOP : std_logic;
	signal Out_0_EOP : std_logic;
	signal Out_0_ErrOut : std_logic;
	signal In_1_Ack : std_logic;
	signal Out_1_Data : std_logic_vector(7 downto 0);
	signal Out_1_DataV : std_logic;
	signal Out_1_SOP : std_logic;
	signal Out_1_EOP : std_logic;
	signal Out_1_ErrOut : std_logic;
	signal Out_Data : std_logic_vector(7 downto 0);
	signal Out_DataV : std_logic;

	-- Clock period definitions
	constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
	uut: End_Arbitrator_2 
	GENERIC MAP(DataWidth	=>	8)
	PORT MAP (
			 CLK => CLK,
			 RST => RST,
			 CE => CE,
			 In_0_Data => In_0_Data,
			 In_0_DataV => In_0_DataV,
			 In_0_SOP => In_0_SOP,
			 In_0_EOP => In_0_EOP,
			 In_0_ErrIn => In_0_ErrIn,
			 In_0_Ind => In_0_Ind,
			 In_0_Ack => In_0_Ack,
			 Out_0_Data => Out_0_Data,
			 Out_0_DataV => Out_0_DataV,
			 Out_0_SOP => Out_0_SOP,
			 Out_0_EOP => Out_0_EOP,
			 Out_0_ErrOut => Out_0_ErrOut,
			 In_1_Data => In_1_Data,
			 In_1_DataV => In_1_DataV,
			 In_1_SOP => In_1_SOP,
			 In_1_EOP => In_1_EOP,
			 In_1_ErrIn => In_1_ErrIn,
			 In_1_Ind => In_1_Ind,
			 In_1_Ack => In_1_Ack,
			 Out_1_Data => Out_1_Data,
			 Out_1_DataV => Out_1_DataV,
			 Out_1_SOP => Out_1_SOP,
			 Out_1_EOP => Out_1_EOP,
			 Out_1_ErrOut => Out_1_ErrOut,
			 Out_Data => Out_Data,
			 Out_DataV => Out_DataV,
			 In_Data => In_Data,
			 In_DataV => In_DataV,
			 In_SOP => In_SOP,
			 In_EOP => In_EOP,
			 In_ErrIn => In_ErrIn
		  );

		
	-- Clock process definitions
	CLK_process :process
	begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
	end process;
 
	RSTer:Resetter Port Map(CLK => CLK, RST => RST, CE => CE);
	-- Stimulus process
	stim_proc: process
	begin		
		-- hold reset state for 100 ns.
		
		WAIT_CLK(CLK_period,20);
		Emit_PDU_SYNC(CLK_PERIOD,64,1,In_0_Ack,In_0_Ind,In_0_Data,In_0_DataV,In_0_SOP,In_0_EOP);
		Emit_PDU_SYNC(CLK_PERIOD,64,1,In_0_Ack,In_0_Ind,In_0_Data,In_0_DataV,In_0_SOP,In_0_EOP);
		Emit_PDU_SYNC(CLK_PERIOD,64,1,In_0_Ack,In_0_Ind,In_0_Data,In_0_DataV,In_0_SOP,In_0_EOP);
		Emit_PDU_SYNC(CLK_PERIOD,64,1,In_1_Ack,In_1_Ind,In_1_Data,In_1_DataV,In_1_SOP,In_1_EOP);
		Emit_PDU(CLK_PERIOD,64,In_Data,In_DataV,In_SOP,In_EOP);

		wait;
	end process;

END;
