--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:31:10 10/13/2012
-- Design Name:   
-- Module Name:   D:/docs/univ/MSC/2012_2013_I/diplomaterv_I/ISE/VHDL/PQ_test.vhd
-- Project Name:  PQUEUE
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PacketQueue
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

use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
ENTITY PQ_test IS
END PQ_test;
 
ARCHITECTURE behavior OF PQ_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PacketQueue
    generic
     (
     DataWidth                     :         integer := 8;
     SYNC_IN                       :         std_logic := '0';
     SYNC_OUT                      :         std_logic := '0';
     SYNC_CTRL                     :         std_logic := '0'
     );
    PORT(
         CLK : IN  std_logic;
         CE : IN  std_logic;
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
         CTRL_ErrIn : IN  std_logic;
          CTRL_Pause                    : in      std_logic;
         CTRL_FWD : IN  std_logic;
         CTRL_DROP : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal CE : std_logic := '0';
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
   signal CTRL_ErrIn : std_logic := '0';
   signal CTRL_Pause : std_logic := '0';
   signal CTRL_FWD : std_logic := '0';
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

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PacketQueue 
   generic map(
     DataWidth                    => 8,
     SYNC_IN                       => '0',
     SYNC_OUT                 =>'0',
     SYNC_CTRL             => '0'
   )
   PORT MAP (
          CLK => CLK,
          CE => CE,
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
          CTRL_ErrIn => CTRL_ErrIn,
          CTRL_Pause =>CTRL_Pause,
          CTRL_FWD => CTRL_FWD,
          CTRL_DROP => CTRL_DROP
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

      -- insert stimulus here 
      RST<='1';
      wait for CLK_period;
      RST<='0';
      wait for CLK_period*5;
      CE <= '1';
      wait for CLK_period*5;
      wait for CLK_period;
      In_SOP <='1';
      DINV <=  '1';
      DIN <= conv_std_logic_vector(64,8);
      for i in 63 downto 0 loop
      wait for CLK_period;
      DIN <= conv_std_logic_vector(i,8);
      end loop;
      wait for CLK_period;
      DINV <=  '0';
      wait for CLK_period*5;
      wait for CLK_period;
      In_SOP <='1';
      DINV <=  '1';
      DIN <= conv_std_logic_vector(64,8);
      for i in 63 downto 0 loop
      wait for CLK_period;
      DIN <= conv_std_logic_vector(i,8);
      end loop;
      wait for CLK_period;
      DINV <=  '0';     
      
      wait;
   end process;
    
   CTRL_FWD_proc:process(CTRL_Ind)
   begin
      if(rising_edge(CTRL_Ind)) then
          --CTRL_DROP<='1';
          CTRL_FWD <= '1';
      elsif(falling_edge(CTRL_Ind)) then
          --CTRL_DROP<='0';
          CTRL_FWD <= '0';
      else
          --CTRL_DROP <= CTRL_DROP;
          CTRL_FWD <= CTRL_FWD;
      end if;     
  
  
   end process CTRL_FWD_proc;

END;
