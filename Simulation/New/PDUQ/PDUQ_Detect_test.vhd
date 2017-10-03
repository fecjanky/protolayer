					--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:11:28 04/02/2013
-- Design Name:   
-- Module Name:   C:/ferenc.janky/ISE/PDU_queue/PDUQ_Detect_test.vhd
-- Project Name:  PDU_queue
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PDUQueue
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
library work;
use work.TypesAndDefinitonsPkg.all;
use work.PDUQueuePkg.all;

ENTITY PDUQ_Detect_test IS
END PDUQ_Detect_test;
 
ARCHITECTURE behavior OF PDUQ_Detect_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PDUQueue
    PORT(
	    CLK : IN  std_logic;
	    CE_In : IN  std_logic;
	    CE_Out : IN  std_logic;
	    RST : IN  std_logic;
	    DIN : IN  std_logic_vector(7 downto 0);
	    DINV : IN  std_logic;
	    In_SOP : IN  std_logic;
	    In_EOP : IN  std_logic;
	    In_Ind : IN  std_logic;
	    In_ErrIn : IN  std_logic;
	    In_Ack : OUT  std_logic;
	    In_ErrOut : OUT  std_logic;
	    DOUT : OUT  std_logic_vector(7 downto 0);
	    DOUTV : OUT  std_logic;
	    Out_SOP : OUT  std_logic;
	    Out_EOP : OUT  std_logic;
	    Out_Ind : OUT  std_logic;
	    Out_ErrOut : OUT  std_logic;
	    Out_Ack : IN  std_logic;
	    Out_ErrIn : IN  std_logic;
	    CTRL_DOUT : OUT  std_logic_vector(7 downto 0);
	    CTRL_DV : OUT  std_logic;
	    CTRL_ErrOut : OUT  std_logic;
	    CTRL_Ind : OUT  std_logic;
	    CTRL_Ack : IN  std_logic;
	    CTRL_FWD : IN  std_logic;
	    CTRL_Pause : IN  std_logic;
	    CTRL_DROP : IN  std_logic;
	    CTRL_MULTIINQ : OUT  std_logic
	   );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal CE_In : std_logic := '0';
   signal CE_Out : std_logic := '0';
   signal RST : std_logic := '0';
   signal DIN : std_logic_vector(7 downto 0) := (others => '0');
   signal DINV : std_logic := '0';
   signal In_SOP : std_logic := '0';
   signal In_EOP : std_logic := '0';
   signal In_Ind : std_logic := '0';
   signal In_ErrIn : std_logic := '0';
   signal Out_Ack : std_logic := '0';
   signal Out_ErrIn : std_logic := '0';
   signal CTRL_Ack : std_logic := '0';
   signal CTRL_FWD : std_logic := '0';
   signal CTRL_Pause : std_logic := '0';
   signal CTRL_DROP : std_logic := '0';

	--Outputs
   signal In_Ack : std_logic;
   signal In_ErrOut : std_logic;
   signal DOUT : std_logic_vector(7 downto 0);
   signal DOUTV : std_logic;
   signal Out_SOP : std_logic;
   signal Out_EOP : std_logic;
   signal Out_Ind : std_logic;
   signal Out_ErrOut : std_logic;
   signal CTRL_DOUT : std_logic_vector(7 downto 0);
   signal CTRL_DV : std_logic;
   signal CTRL_ErrOut : std_logic;
   signal CTRL_Ind : std_logic;
   signal CTRL_MULTIINQ : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: PDUQueue PORT MAP (
		CLK => CLK,
		CE_In => CE_In,
		CE_Out => CE_Out,
		RST => RST,
		DIN => DIN,
		DINV => DINV,
		In_SOP => In_SOP,
		In_EOP => In_EOP,
		In_Ind => In_Ind,
		In_ErrIn => In_ErrIn,
		In_Ack => In_Ack,
		In_ErrOut => In_ErrOut,
		DOUT => DOUT,
		DOUTV => DOUTV,
		Out_SOP => Out_SOP,
		Out_EOP => Out_EOP,
		Out_Ind => Out_Ind,
		Out_ErrOut => Out_ErrOut,
		Out_Ack => Out_Ack,
		Out_ErrIn => Out_ErrIn,
		CTRL_DOUT => CTRL_DOUT,
		CTRL_DV => CTRL_DV,
		CTRL_ErrOut => CTRL_ErrOut,
		CTRL_Ind => CTRL_Ind,
		CTRL_Ack => CTRL_Ack,
		CTRL_FWD => CTRL_FWD,
		CTRL_Pause => CTRL_Pause,
		CTRL_DROP => CTRL_DROP,
		CTRL_MULTIINQ => CTRL_MULTIINQ
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
		RST 		<= Lo;
		wait for 100 ns;	
		RST 		<= Hi;
		CE_In 	<= Hi;
		wait for CLK_period*10;
		RST 		<= Lo;
		-- insert stimulus here 

		wait;
	end process;

END;
