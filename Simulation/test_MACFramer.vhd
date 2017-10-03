--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:52:41 09/29/2012
-- Design Name:   
-- Module Name:   D:/docs/univ/MSC/2012_2013_I/diplomaterv_I/ISE/test/test_MACFramer.vhd
-- Project Name:  test
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MACFramer
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
 
ENTITY test_MACFramer IS
END test_MACFramer;
 
ARCHITECTURE behavior OF test_MACFramer IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MACFramer
    PORT(
         CLK : IN  std_logic;
         CE : IN  std_logic;
         RST : IN  std_logic;
         RXD : IN  std_logic_vector(7 downto 0);
         RXDV : IN  std_logic;
         SOF : IN  std_logic;
         EOF : IN  std_logic;
         TXD : OUT  std_logic_vector(7 downto 0);
         TXDV : OUT  std_logic;
         TX_REQ : OUT  std_logic;
         TX_READY : IN  std_logic;
         TX_EOF : OUT  std_logic;
         UP_PDUIn : IN  std_logic_vector(7 downto 0);
         UP_DSTMacIn : IN  std_logic_vector(47 downto 0);
         UP_SRCMacIn : IN  std_logic_vector(47 downto 0);
         UP_ETypeIn  : IN  std_logic_vector(15 downto 0);
         UP_FCSInPresent : IN  std_logic;
         UP_FCSIn : IN  std_logic_vector(31 downto 0);
         UP_TXReq : IN  std_logic;
         UP_TXAck : OUT  std_logic;
         UP_DVIn : IN  std_logic;
         UP_PDUOut : OUT  std_logic_vector(7 downto 0);
         UP_DSTMacOut : OUT  std_logic_vector(47 downto 0);
         UP_SRCMacOut : OUT  std_logic_vector(47 downto 0);
         UP_ETypeOut  : OUT  std_logic_vector(15 downto 0);
         UP_FCSOutPresent : OUT  std_logic;
         UP_RCPTStatus : OUT  std_logic_vector(0 downto 0);
         UP_RXInd : OUT  std_logic;
         UP_RXAck : IN  std_logic;
         UP_DVOut : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal CE : std_logic := '0';
   signal RST : std_logic := '0';
   signal RXD : std_logic_vector(7 downto 0) := (others => '0');
   signal RXDV : std_logic := '0';
   signal SOF : std_logic := '0';
   signal EOF : std_logic := '0';
   signal TX_READY : std_logic := '0';
   signal UP_PDUIn : std_logic_vector(7 downto 0) := (others => '0');
   signal UP_DSTMacIn : std_logic_vector(47 downto 0) := (others => '0');
   signal UP_SRCMacIn : std_logic_vector(47 downto 0) := (others => '0');
   signal UP_ETypeIn  :  std_logic_vector(15 downto 0):= (others => '0');
   signal UP_FCSInPresent : std_logic := '0';
   signal UP_FCSIn : std_logic_vector(31 downto 0) := (others => '0');
   signal UP_TXReq : std_logic := '0';
   signal UP_DVIn : std_logic := '0';
   signal UP_RXAck : std_logic := '0';

 	--Outputs
   signal TXD : std_logic_vector(7 downto 0);
   signal TXDV : std_logic;
   signal TX_REQ : std_logic;
   signal TX_EOF : std_logic;
   signal UP_TXAck : std_logic;
   signal UP_PDUOut : std_logic_vector(7 downto 0);
   signal UP_DSTMacOut : std_logic_vector(47 downto 0);
   signal UP_SRCMacOut : std_logic_vector(47 downto 0);
   signal UP_ETypeOut  :  std_logic_vector(15 downto 0);
   signal UP_FCSOutPresent : std_logic;
   signal UP_RCPTStatus : std_logic_vector(0 downto 0);
   signal UP_RXInd : std_logic;
   signal UP_DVOut : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MACFramer PORT MAP (
          CLK => CLK,
          CE => CE,
          RST => RST,
          RXD => RXD,
          RXDV => RXDV,
          SOF => SOF,
          EOF => EOF,
          TXD => TXD,
          TXDV => TXDV,
          TX_REQ => TX_REQ,
          TX_READY => TX_READY,
          TX_EOF => TX_EOF,
          UP_PDUIn => UP_PDUIn,
          UP_DSTMacIn => UP_DSTMacIn,
          UP_SRCMacIn => UP_SRCMacIn,
          UP_ETypeIn => UP_ETypeIn,
          UP_FCSInPresent => UP_FCSInPresent,
          UP_FCSIn => UP_FCSIn,
          UP_TXReq => UP_TXReq,
          UP_TXAck => UP_TXAck,
          UP_DVIn => UP_DVIn,
          UP_PDUOut => UP_PDUOut,
          UP_DSTMacOut => UP_DSTMacOut,
          UP_SRCMacOut => UP_SRCMacOut,
          UP_ETypeOut => UP_ETypeOut,
          UP_FCSOutPresent => UP_FCSOutPresent,
          UP_RCPTStatus => UP_RCPTStatus,
          UP_RXInd => UP_RXInd,
          UP_RXAck => UP_RXAck,
          UP_DVOut => UP_DVOut
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
      CE<='1';
      wait for CLK_period*10;
      
      rst <= '1';
	
      wait for CLK_period;
      rst <= '0';
      -- insert stimulus here 
      wait for CLK_period*10;
      
      SOF <= '1';
      RXDV <= '1';
      RXD <= x"11";
      wait for CLK_period;
      SOF <= '0';
      RXD <= x"22";
      wait for CLK_period;
      RXD <= x"33";
      wait for CLK_period;
      RXD <= x"44";
      wait for CLK_period;
      RXD <= x"55";
      wait for CLK_period;
      RXD <= x"66";
      wait for CLK_period;
      RXD <= x"33";
      wait for CLK_period;
      RXD <= x"44";
      wait for CLK_period;
      RXD <= x"55";
      wait for CLK_period;
      RXD <= x"66";
      wait for CLK_period;
      RXD <= x"11";
      wait for CLK_period;
      RXD <= x"22";
      wait for CLK_period;
      RXD <= x"80";
      wait for CLK_period;
      RXD <= x"21";
      for I in 0 to 100 loop
      wait for CLK_period;
      RXD <= conv_std_logic_vector(I,8);
      end loop;      
      wait for CLK_period;
      RXDV<='0';
      EOF<='1';
      wait for CLK_period;
      EOF<='0';
      wait;
   end process;

END;
