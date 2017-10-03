--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:14:10 04/03/2013
-- Design Name:   
-- Module Name:   C:/ferenc.janky/ISE/PDU_queue/PDUQ_Detect_test_2.vhd
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Library UNISIM;
use UNISIM.vcomponents.all;

library work;
use work.TypesAndDefinitonsPkg.all;
use work.PDUQueuePkg.all;
use work.Simulation.all;

ENTITY PDUQ_Detect_test_2 IS
END PDUQ_Detect_test_2;
 
ARCHITECTURE behavior OF PDUQ_Detect_test_2 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
     

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
   signal CTRL_DROP_ERR : std_logic := '0';

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
   signal CTRL_SOP : std_logic;
   signal CTRL_EOP : std_logic;
   signal CTRL_ErrOut : std_logic;
   signal CTRL_Ind : std_logic;
   
   --simulation aux signals
   signal CTRL_FWD_SET		: std_logic := '0';
   signal CTRL_FWD_RST		: std_logic := '0';
   signal CTRL_FWD_delay		: integer := 1;
   signal CTRL_FWD_width   	: integer := 1;

   signal CTRL_DROP_SET		: std_logic := '0';
   signal CTRL_DROP_RST		: std_logic := '0';
   signal CTRL_DROP_delay	: integer := 1;
   signal CTRL_DROP_width   	: integer := 1;


   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PDUQueue 
   
   generic map(
--		DataWidth					:		integer 	:= 	8;
--		SYNC_IN					:		boolean 	:= 	false;
		SYNC_OUT					=> false
--		SYNC_CTRL					:		boolean 	:= 	false;
--		MINPDUSize				:		integer	:=	64;
--		MAXPDUSize				:		integer	:=	1500;
--		MaxPDUToQ					:		integer	:= 	30
	)
   
   PORT MAP (
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
          CTRL_SOP => CTRL_SOP,
          CTRL_EOP => CTRL_EOP,
          CTRL_ErrOut => CTRL_ErrOut,
          CTRL_Ind => CTRL_Ind,
          CTRL_Ack => CTRL_Ack,
          CTRL_FWD => CTRL_FWD,
          CTRL_Pause => CTRL_Pause,
          CTRL_DROP_ERR => CTRL_DROP_ERR
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
		CE_In	<= Hi;
		CE_Out	<= Hi;
		wait for 100 ns;	
		RST 		<= Hi;
		CE_In 	<= Hi;
--		CTRL_FWD	<= Hi;
		wait for CLK_period*10;
		RST 		<= Lo;
		-- insert stimulus here
		CTRL_DROP_rst <= Hi;
		--normal op test (header removal)
		wait for CLK_period*10;
		CTRL_FWD_delay <= 10;		
		Emit_PDU(128,CLK_PERIOD,DIN,DINV,In_SOP,In_EOP);
		--just control test (no forwarding)
		CTRL_FWD_rst <= Hi;
		Emit_PDU(64,CLK_PERIOD,DIN,DINV,In_SOP,In_EOP);
		--pass through test		
		CTRL_FWD_rst <= Lo;
		CTRL_FWD_set <= Hi;		
		wait for CLK_period;
		Emit_PDU(256,CLK_PERIOD,DIN,DINV,In_SOP,In_EOP);		
		CTRL_FWD_set <= Lo;
		--drop test
		CTRL_FWD_rst <= Hi;
		CTRL_DROP_rst <= Lo;
		CTRL_DROP_delay <= 15;
		Emit_PDU(64,CLK_PERIOD,DIN,DINV,In_SOP,In_EOP);
		--normal op test (header removal) after drop
		CTRL_DROP_rst  <= Hi;
		CTRL_FWD_rst 	<= Lo;
		CTRL_FWD_delay <= 20;
		wait for CLK_period*10;	
		Emit_PDU(64,CLK_PERIOD,DIN,DINV,In_SOP,In_EOP);
		wait;
	end process;
	
	
CTRL_FWD_Acker: Acker PORT MAP(
	clk => clk,
	set => CTRL_FWD_SET,
	rst => CTRL_FWD_RST,
	I => CTRL_SOP,
	delay => CTRL_FWD_delay,
	resp_width => CTRL_FWD_width,
	Q => CTRL_FWD
);

CTRL_DROpper: Acker PORT MAP(
	clk => clk,
	set => CTRL_DROP_SET,
	rst => CTRL_DROP_RST,
	I => CTRL_SOP,
	delay => CTRL_DROP_delay,
	resp_width => CTRL_DROP_width,
	Q => CTRL_DROP_ERR
);

	
--	CTRL_SOP_rise <= not(CTRL_SOP_prev) and CTRL_SOP;	
--	fwd_process:process(clk)
--	begin
--		if(rising_edge(clk)) then
--			CTRL_SOP_prev <= CTRL_SOP;
--			if(CTRL_SOP_rise = Hi and first_pdu = Hi) then
--				CTRL_FWD_delay <= (others => Lo);
--			else
--				CTRL_FWD_delay <= CTRL_FWD_delay + 1;
--			end if;
--			if(CTRL_FWD_delay = X"07")then
--				CTRL_FWD <= Hi;
--				first_pdu <= Lo;
--			elsif( first_pdu = Lo) then
--				CTRL_FWD <= Hi;
--			else
--				CTRL_FWD <= Lo;
--			end if;
--			
--			
--		end if;		
--	end process;

END;
