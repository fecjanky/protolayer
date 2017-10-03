--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:44:48 11/29/2012
-- Design Name:   
-- Module Name:   E:/docs/univ/2012_2013_I/dipterv_1/VHDL/Simulation/eth_layer_test_2.vhd
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_misc.ALL;
use IEEE.math_real.ALL;
use IEEE.numeric_std.ALL;
--USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

Library UNISIM;
use UNISIM.vcomponents.all;

library work;
use work.TypesAndDefinitonsPkg.all;
use work.EthernetLayerPkg.all;
 
ENTITY eth_layer_test_2 IS
END eth_layer_test_2;
 
ARCHITECTURE behavior OF eth_layer_test_2 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)

    

   --Inputs
   signal CLK : std_logic := '0';
   signal CE : std_logic := '0';
   signal RST : std_logic := '0';
   signal WR_EN : std_logic := '0';
   signal RD_EN : std_logic := '0';
   signal ADDR : std_logic_vector(1 downto 0) := (others => '0');
   signal ADDR_DATA_IN : std_logic_vector(47 downto 0) := (others => '0');
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
   signal PDU_IN_ErrOut : std_logic;
   signal PDU_IN_Ack : std_logic;
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
	TX_SYNC_OUT				=> '0',
	NumOfMacAddresses			=> 3
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

      wait for CLK_period*10;

	CE <= Hi;
	RST <= Hi;
	PDU_IN_ErrIn <= Lo;
    wait for CLK_period*10;
	RST <= Lo;
	wait for CLK_period*10;
	-- Init MAC address test	
	WR_EN <= Hi;
	ADDR <= STD_LOGIC_VECTOR(TO_UNSIGNED(0,2));
	ADDR_DATA_IN <= x"50E5493904A2";
	wait for CLK_period;
	ADDR <= STD_LOGIC_VECTOR(TO_UNSIGNED(1,2));
	ADDR_DATA_IN <= x"000117F3F786";
	wait for CLK_period;
	WR_EN <= Lo;
	wait for CLK_period;
	RD_EN <= Hi;
	ADDR <= STD_LOGIC_VECTOR(TO_UNSIGNED(0,2));
	wait for CLK_period;
	ADDR <= STD_LOGIC_VECTOR(TO_UNSIGNED(1,2));
	wait for CLK_period;
	RD_EN <= Lo;
	wait for CLK_period;
	
	
	--TX test 1
	DstMacAddr_In <= x"FFFFFFFFFFFF";
	SrcMacAddr_In <= x"001122334455";
	EthType_In <= x"8000";
	SDU_IN_DINV <= Hi;
	SDU_IN_SOP  <= Hi;
     wait for CLK_period;
	SDU_IN_SOP  <= Lo;
	for i in 1  to  63 loop
	SDU_IN_DIN <= STD_LOGIC_VECTOR(TO_UNSIGNED(i,8));
	wait for CLK_period;
	end loop;
	SDU_IN_DINV <= Lo;
	SDU_IN_EOP  <= Hi;
	wait for CLK_period;
	SDU_IN_EOP  <= Lo;
	wait for CLK_period*10;
	--TX test 2
	DstMacAddr_In <= x"000117F3F786";
	SrcMacAddr_In <= x"50E5493904A2";
	EthType_In <= x"8000";
	SDU_IN_DINV <= Hi;
	SDU_IN_SOP  <= Hi;
     wait for CLK_period;
	SDU_IN_SOP  <= Lo;
	for i in 1  to  63 loop
	SDU_IN_DIN <= STD_LOGIC_VECTOR(TO_UNSIGNED(i,8));
	wait for CLK_period;
	end loop;
	SDU_IN_DINV <= Lo;
	SDU_IN_EOP  <= Hi;
	wait for CLK_period;
	SDU_IN_EOP  <= Lo;
	wait for CLK_period*10;
	
	
	
	--RX test 1 ( drop frame)
	PDU_DINV <= Hi;
	PDU_IN_SOP <= Hi;
	PDU_DIN <= x"00";
	wait for CLK_period;  
	PDU_IN_SOP <= Lo;
	PDU_DIN <= x"E5";
	wait for CLK_period;  
	PDU_DIN <= x"17";
	wait for CLK_period;  
	PDU_DIN <= x"39";
	wait for CLK_period;  
	PDU_DIN <= x"F7";
	wait for CLK_period;  
	PDU_DIN <= x"A2";
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
	PDU_DIN <= STD_LOGIC_VECTOR(TO_UNSIGNED(i,8));
	wait for CLK_period;
	end loop;
	PDU_DINV <= Lo;
	PDU_IN_EOP <= Hi;
	wait for CLK_period;
	PDU_IN_EOP <= Lo;
	wait for CLK_period * 10;
	--RX test 2 ( Broadcast)
	PDU_DINV <= Hi;
	PDU_IN_SOP <= Hi;
	PDU_DIN <= x"FF";
	wait for CLK_period;  
	PDU_IN_SOP <= Lo;
	PDU_DIN <= x"FF";
	wait for CLK_period;  
	PDU_DIN <= x"FF";
	wait for CLK_period;  
	PDU_DIN <= x"FF";
	wait for CLK_period;  
	PDU_DIN <= x"FF";
	wait for CLK_period;  
	PDU_DIN <= x"FF";
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
	PDU_DIN <= STD_LOGIC_VECTOR(TO_UNSIGNED(i,8));
	wait for CLK_period;
	end loop;
	PDU_DINV <= Lo;
	PDU_IN_EOP <= Hi;
	wait for CLK_period;
	PDU_IN_EOP <= Lo;
	wait for CLK_period * 10;
	--ADDR_DATA_IN <= x"50E5493904A2";
	--RX test 3 ( unicast 1)
	PDU_DINV <= Hi;
	PDU_IN_SOP <= Hi;
	PDU_DIN <= x"50";
	wait for CLK_period;  
	PDU_IN_SOP <= Lo;
	PDU_DIN <= x"E5";
	wait for CLK_period;  
	PDU_DIN <= x"49";
	wait for CLK_period;  
	PDU_DIN <= x"39";
	wait for CLK_period;  
	PDU_DIN <= x"04";
	wait for CLK_period;  
	PDU_DIN <= x"A2";
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
	PDU_DIN <= STD_LOGIC_VECTOR(TO_UNSIGNED(i,8));
	wait for CLK_period;
	end loop;
	PDU_DINV <= Lo;
	PDU_IN_EOP <= Hi;
	wait for CLK_period;
	PDU_IN_EOP <= Lo;
	wait for CLK_period * 10;
	--ADDR_DATA_IN <= x"000117F3F786";
	--RX test 4 ( unicast 2)
	PDU_DINV <= Hi;
	PDU_IN_SOP <= Hi;
	PDU_DIN <= x"00";
	wait for CLK_period;  
	PDU_IN_SOP <= Lo;
	PDU_DIN <= x"01";
	wait for CLK_period;  
	PDU_DIN <= x"17";
	wait for CLK_period;  
	PDU_DIN <= x"F3";
	wait for CLK_period;  
	PDU_DIN <= x"F7";
	wait for CLK_period;  
	PDU_DIN <= x"86";
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
	PDU_DIN <= STD_LOGIC_VECTOR(TO_UNSIGNED(i,8));
	wait for CLK_period;
	end loop;
	PDU_DINV <= Lo;
	PDU_IN_EOP <= Hi;
	wait for CLK_period;
	PDU_IN_EOP <= Lo;
	wait for CLK_period * 10;
	
     wait;
   end process;

END;
