--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:07:56 04/12/2013
-- Design Name:   
-- Module Name:   G:/VHDL/Simulation/New/EthernetModule/DeSer_test.vhd
-- Project Name:  EthernetModule
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DeSerializer
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

use work.ProtoLayerTypesAndDefs.all;
use work.ProtoModulePkg.all;
use work.Simulation.all;

ENTITY DeSer_test IS
END DeSer_test;
 
ARCHITECTURE behavior OF DeSer_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal CE : std_logic := '0';
   signal SIn : std_logic_vector(7 downto 0) := (others => '0');
   signal Ser_DV : std_logic := '0';
   signal Ser_SOP : std_logic := '0';
   signal Ser_EOP : std_logic := '0';

	--Outputs
   signal POut : std_logic_vector(arp_ETHIP_len-1 downto 0);
   signal POuTV : std_logic;
   signal POuT_err : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
   constant	arp_ETHIP_lenDW		:		integer	:=	arp_ETHIP_len/DefDataWidth;
   
   signal ack				: std_logic ;
   signal ind				: std_logic	:=	'0' ;
   signal OUTACK_SET		: std_logic := '0';
   signal OUTACK_RST		: std_logic := '0';
   signal OUTACK_delay		: integer := 1;
   signal OUTACK_width   	: integer := 1;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
	uut: DeSerializer 
	generic map(
		DataWidth	=>	DefDataWidth,
		ToDeSer	=>	arp_ETHIP_lenDW
	)
	PORT MAP(
		CLK => CLK,
		RST => RST,
		CE => CE,
		SIn => SIn,
		Ser_DV => Ser_DV,
		Ser_SOP => Ser_SOP,
		Ser_EOP => Ser_EOP,
		POut => POut,
		POuTV => POuTV,
		POuT_err => POuT_err
	   );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '1';
		wait for CLK_period/2;
		CLK <= '0';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
	begin		
	 -- hold reset state for 100 ns.
		Init_Module(CLK_period,5,5,RST,CE);
		WAIT_CLK(CLK_period,10);
		Emit_PDU(CLK_period,arp_ETHIP_lenDW-1,Sin,Ser_DV,Ser_SOP,Ser_EOP);
		WAIT_CLK(CLK_period,10);
		Emit_PDU(CLK_period,arp_ETHIP_lenDW+10,Sin,Ser_DV,Ser_SOP,Ser_EOP);
		WAIT_CLK(CLK_period,10);
		Emit_PDU(CLK_period,arp_ETHIP_lenDW-10,Sin,Ser_DV,Ser_SOP,Ser_EOP);
		WAIT_CLK(CLK_period,10);
		Emit_ARP_PDU(CLK_period,ares_op_REQ,X"665544332211",X"AC100003",X"FFFFFFFFFFFF",X"AC100002",Sin,Ser_DV,Ser_SOP,Ser_EOP);
		WAIT_CLK(CLK_period,10);
		Emit_ARP_PDU(CLK_period,ares_op_REP,X"665544332211",X"AC100003",X"001122334455",X"AC100002",Sin,Ser_DV,Ser_SOP,Ser_EOP);
	 -- insert stimulus here 

		wait;
	end process;

END;
