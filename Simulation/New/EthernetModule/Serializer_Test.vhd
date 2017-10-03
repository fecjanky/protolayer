--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:38:32 04/10/2013
-- Design Name:   
-- Module Name:   D:/VHDL/Simulation/New/EthernetModule/Serializer_Test.vhd
-- Project Name:  EthernetModule
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Serializer
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
library work;
use work.ProtoModulePkg.Serializer;
use work.Simulation.all;
use work.ProtoLayerTypesAndDefs.all;

ENTITY Serializer_Test IS
END Serializer_Test;
 
ARCHITECTURE behavior OF Serializer_Test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal CE : std_logic := '0';
   signal Start : std_logic := '0';
   signal PIn : std_logic_vector(14*8-1 downto 0) := (others => '0');

 	--Outputs
   signal Complete : std_logic;
   signal Ser_Start : std_logic;
   signal SOut : std_logic_vector(7 downto 0);
   signal OuTV : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Serializer 
   generic map(
	DataWidth			=>	8,
	ToSer			=>	14
	-- DataWidth*ToSer			:		integer	:=	ToSer*DataWidth
	)

   PORT MAP (
          CLK => CLK,
          RST => RST,
          CE => CE,
          Start => Start,
		Ser_Start => Ser_Start,
          Complete => Complete,
          PIn => PIn,
          SOut => SOut,
          OuTV => OuTV
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
		Init_Module(CLK_period,5,5,RST,CE);
		WAIT_CLK(CLK_period,5);
		PIn	<=	X"ffffffffffff0011223344558021";
		Start<=	Hi;
		WAIT_CLK(CLK_period,1);
		Start<=	Lo;
      -- insert stimulus here 

		wait;
	end process;

END;
