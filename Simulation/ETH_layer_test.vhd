--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:12:45 11/21/2012
-- Design Name:   
-- Module Name:   E:/docs/univ/2012_2013_I/dipterv_1/ISE/EtherLayer/ETH_layer_test.vhd
-- Project Name:  EtherLayer
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
 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Library UNISIM;
use UNISIM.vcomponents.all;

library work;
use work.TypesAndDefinitonsPkg.all;
 
ENTITY ETH_layer_test IS
END ETH_layer_test;
 
ARCHITECTURE behavior OF ETH_layer_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT EthernetLayer
    generic
	(
	DataWidth				:		integer 	:= 	 8;
	RX_SYNC_IN				:		std_logic := 	'0';
	RX_SYNC_OUT				:		std_logic := 	'1';	
	TX_SYNC_IN				:		std_logic := 	'0';
	TX_SYNC_OUT				:		std_logic := 	'1';
	MINSDUSize				:		integer	:=	64;
	MAXSDUSize				:		integer	:=	1500;
	MaxSDUToQ				:		integer	:= 	30;
	MINPCISize				:		integer	:=	64;
	MAXPCISize				:		integer	:=	64;
	MaxPCIToQ				:		integer	:= 	30

	);
	
	PORT(
         CLK : IN  std_logic;
         CE : IN  std_logic;
         RST : IN  std_logic;
         DstMacAddr_In : IN  std_logic_vector(47 downto 0);
         SrcMacAddr_In : IN  std_logic_vector(47 downto 0);
         EthType_In : IN  std_logic_vector(15 downto 0);
         DstMacAddr_Out : OUT  std_logic_vector(47 downto 0);
         SrcMacAddr_Out : OUT  std_logic_vector(47 downto 0);
         EthType_Out : OUT  std_logic_vector(15 downto 0);
         SDU_IN_DIN : IN  std_logic_vector(7 downto 0);
         SDU_IN_DINV : IN  std_logic;
         SDU_IN_SOP : IN  std_logic;
         SDU_IN_EOP : IN  std_logic;
         SDU_IN_Ind : IN  std_logic;
         SDU_IN_ErrIn : IN  std_logic;
         SDU_IN_Ack : OUT  std_logic;
         SDU_IN_ErrOut : OUT  std_logic;
         PDU_DOUT : OUT  std_logic_vector(7 downto 0);
         PDU_DOUTV : OUT  std_logic;
         PDU_Out_SOP : OUT  std_logic;
         PDU_Out_EOP : OUT  std_logic;
         PDU_Out_Ind : OUT  std_logic;
         PDU_Out_ErrOut : OUT  std_logic;
         PDU_Out_Ack : IN  std_logic;
         PDU_Out_ErrIn : IN  std_logic;
         PDU_DIN : IN  std_logic_vector(7 downto 0);
         PDU_DINV : IN  std_logic;
         PDU_IN_SOP : IN  std_logic;
         PDU_IN_EOP : IN  std_logic;
         PDU_IN_Ind : IN  std_logic;
         PDU_IN_ErrOut : OUT  std_logic;
         PDU_IN_Ack : OUT  std_logic;
         PDU_IN_ErrIn : IN  std_logic;
         SDU_DOUT : OUT  std_logic_vector(7 downto 0);
         SDU_DOUTV : OUT  std_logic;
         SDU_Out_SOP : OUT  std_logic;
         SDU_OUT_EOP : OUT  std_logic;
         SDU_OUT_Ind : OUT  std_logic;
         SDU_OUT_ErrIn : IN  std_logic;
         SDU_OUT_Ack : IN  std_logic;
         SDU_OUT_ErrOut : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal CE : std_logic := '0';
   signal RST : std_logic := '0';
   signal DstMacAddr_In : std_logic_vector(47 downto 0) := (others => '0');
   signal SrcMacAddr_In : std_logic_vector(47 downto 0) := (others => '0');
   signal EthType_In : std_logic_vector(15 downto 0) := (others => '0');
   signal SDU_IN_DIN : std_logic_vector(7 downto 0) := (others => '0');
   signal SDU_IN_DINV : std_logic := '0';
   signal SDU_IN_SOP : std_logic := '0';
   signal SDU_IN_EOP : std_logic := '0';
   signal SDU_IN_Ind : std_logic := '0';
   signal SDU_IN_ErrIn : std_logic := '0';
   signal PDU_Out_Ack : std_logic := '0';
   signal PDU_Out_ErrIn : std_logic := '0';
   signal PDU_DIN : std_logic_vector(7 downto 0) := (others => '0');
   signal PDU_DINV : std_logic := '0';
   signal PDU_IN_SOP : std_logic := '0';
   signal PDU_IN_EOP : std_logic := '0';
   signal PDU_IN_Ind : std_logic := '0';
   signal PDU_IN_ErrOut : std_logic := '0';
   signal SDU_OUT_ErrIn : std_logic := '0';
   signal SDU_OUT_Ack : std_logic := '0';

 	--Outputs
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
   signal PDU_IN_Ack : std_logic;
   signal PDU_IN_ErrIn : std_logic;
   signal SDU_DOUT : std_logic_vector(7 downto 0);
   signal SDU_DOUTV : std_logic;
   signal SDU_Out_SOP : std_logic;
   signal SDU_OUT_EOP : std_logic;
   signal SDU_OUT_Ind : std_logic;
   signal SDU_OUT_ErrOut : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: EthernetLayer 
   generic map
	(
	--DataWidth				:		integer 	:= 	 8;
	RX_SYNC_IN				=> '0',
	RX_SYNC_OUT				=> '0',	
	TX_SYNC_IN				=> '0',
	TX_SYNC_OUT				=> '0'
--	MINSDUSize				:		integer	:=	64;
--	MAXSDUSize				:		integer	:=	1500;
--	MaxSDUToQ				:		integer	:= 	30;
--	MINPCISize				:		integer	:=	64;
--	MAXPCISize				:		integer	:=	64;
--	MaxPCIToQ				:		integer	:= 	30

	)
   
   PORT MAP (
          CLK => CLK,
          CE => CE,
          RST => RST,
          DstMacAddr_In => DstMacAddr_In,
          SrcMacAddr_In => SrcMacAddr_In,
          EthType_In => EthType_In,
          DstMacAddr_Out => DstMacAddr_Out,
          SrcMacAddr_Out => SrcMacAddr_Out,
          EthType_Out => EthType_Out,
          SDU_IN_DIN => SDU_IN_DIN,
          SDU_IN_DINV => SDU_IN_DINV,
          SDU_IN_SOP => SDU_IN_SOP,
          SDU_IN_EOP => SDU_IN_EOP,
          SDU_IN_Ind => SDU_IN_Ind,
          SDU_IN_ErrIn => SDU_IN_ErrIn,
          SDU_IN_Ack => SDU_IN_Ack,
          SDU_IN_ErrOut => SDU_IN_ErrOut,
          PDU_DOUT => PDU_DOUT,
          PDU_DOUTV => PDU_DOUTV,
          PDU_Out_SOP => PDU_Out_SOP,
          PDU_Out_EOP => PDU_Out_EOP,
          PDU_Out_Ind => PDU_Out_Ind,
          PDU_Out_ErrOut => PDU_Out_ErrOut,
          PDU_Out_Ack => PDU_Out_Ack,
          PDU_Out_ErrIn => PDU_Out_ErrIn,
          PDU_DIN => PDU_DIN,
          PDU_DINV => PDU_DINV,
          PDU_IN_SOP => PDU_IN_SOP,
          PDU_IN_EOP => PDU_IN_EOP,
          PDU_IN_Ind => PDU_IN_Ind,
          PDU_IN_ErrOut => PDU_IN_ErrOut,
          PDU_IN_Ack => PDU_IN_Ack,
          PDU_IN_ErrIn => PDU_IN_ErrIn,
          SDU_DOUT => SDU_DOUT,
          SDU_DOUTV => SDU_DOUTV,
          SDU_Out_SOP => SDU_Out_SOP,
          SDU_OUT_EOP => SDU_OUT_EOP,
          SDU_OUT_Ind => SDU_OUT_Ind,
          SDU_OUT_ErrIn => SDU_OUT_ErrIn,
          SDU_OUT_Ack => SDU_OUT_Ack,
          SDU_OUT_ErrOut => SDU_OUT_ErrOut
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
	wait for 100 ns;	
	CE <= Hi;
	RST <= Hi;
	PDU_IN_ErrIn <= Lo;
    wait for CLK_period*10;
	RST <= Lo;
	wait for CLK_period*10;
	DstMacAddr_In <= x"FFFFFFFFFFFF";
	SrcMacAddr_In <= x"001122334455";
	EthType_In <= x"8000";
	SDU_IN_DINV <= Hi;
	SDU_IN_SOP  <= Hi;
    wait for CLK_period;
	SDU_IN_SOP  <= Lo;
	for i in 1  to  63 loop
	SDU_IN_DIN <= conv_std_logic_vector(i,8);
	wait for CLK_period;
	end loop;
	SDU_IN_DINV <= Lo;
	SDU_IN_EOP  <= Hi;
	wait for CLK_period;
	SDU_IN_EOP  <= Lo;
	wait for CLK_period*10;
	
	--RX test
	PDU_DINV <= Hi;
	PDU_IN_SOP <= Hi;
	PDU_DIN <= x"00";
	wait for CLK_period;  
	PDU_IN_SOP <= Lo;
	PDU_DIN <= x"00";
	wait for CLK_period;  
	PDU_DIN <= x"00";
	wait for CLK_period;  
	PDU_DIN <= x"00";
	wait for CLK_period;  
	PDU_DIN <= x"00";
	wait for CLK_period;  
	PDU_DIN <= x"00";
	wait for CLK_period;
	for i in 0 to 5 loop
	PDU_DIN <= x"12";
	wait for CLK_period;  
	end loop;
	PDU_DIN <= x"80";
	wait for CLK_period;
	PDU_DIN <= x"00";
	wait for CLK_period; 	
	for i in 0 to 63 loop
	PDU_DIN <= conv_std_logic_vector(i,8);
	wait for CLK_period;
	end loop;
	PDU_DINV <= Lo;
	PDU_IN_EOP <= Hi;
	wait for CLK_period;
	PDU_IN_EOP <= Lo;
    wait;
   end process;

END;
