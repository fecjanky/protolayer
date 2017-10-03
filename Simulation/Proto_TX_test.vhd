--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:29:04 04/05/2013
-- Design Name:   
-- Module Name:   C:/ferenc.janky/ISE/proto_tx/Proto_TX_test.vhd
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
use work.Simulation.all;
use work.ProtoModulePkg.ProtoModule_TXPart;
use work.TypesAndDefinitonsPkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Proto_TX_test IS
END Proto_TX_test;
 
ARCHITECTURE behavior OF Proto_TX_test IS 
 
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
   signal SDU_DIN : std_logic_vector(7 downto 0) := (others => '0');
   signal SDU_DINV : std_logic := '0';
   signal SDU_SOP : std_logic := '0';
   signal SDU_EOP : std_logic := '0';
   signal SDU_Ind : std_logic := '0';
   signal SDU_ErrIn : std_logic := '0';
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

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ProtoModule_TXPart 
--   generic map	(
--		DataWidth				:		integer 	:= 	 8;
--		SYNC_IN_SDU			:		boolean	:=	false;
--		SYNC_IN_PCI			:		boolean	:=	false;
--		SYNC_OUT				:		boolean	:=	false;
--		MINSDUSize			:		integer	:=	64;
--		MAXSDUSize			:		integer	:=	1500;
--		MaxSDUToQ				:		integer	:= 	30;
--		MINPCISize			:		integer	:=	64;
--		MAXPCISize			:		integer	:=	64;
--		MaxPCIToQ				:		integer	:= 	30
--	)   
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
          PCI_Ack => PCI_Ack,
          PCI_ErrOut => PCI_ErrOut,
          SDU_DIN => SDU_DIN,
          SDU_DINV => SDU_DINV,
          SDU_SOP => SDU_SOP,
          SDU_EOP => SDU_EOP,
          SDU_Ind => SDU_Ind,
          SDU_ErrIn => SDU_ErrIn,
          SDU_Ack => SDU_Ack,
          SDU_ErrOut => SDU_ErrOut,
          DOUT => DOUT,
          DOUTV => DOUTV,
          Out_SOP => Out_SOP,
          Out_EOP => Out_EOP,
          Out_Ind => Out_Ind,
          Out_ErrOut => Out_ErrOut,
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
	RST <= Hi;
     wait for 100 ns;	
	CE	<= Hi;
	wait for CLK_period*10;
	RST <= Lo;
	wait for CLK_period*10;
      -- insert stimulus here 
	Emit_PDU(64,CLK_period,SDU_DIN,SDU_DINV,SDU_SOP,SDU_EOP);
	Emit_PDU(64,CLK_period,PCI_DIN,PCI_DINV,PCI_SOP,PCI_EOP);
     wait;
   end process;

END;
