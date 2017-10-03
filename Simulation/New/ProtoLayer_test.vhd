-- TestBench Template 

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;
USE IEEE.numeric_std.ALL;

library work;
use work.ProtoModulePkg.all;
use work.ProtoLayerTypesAndDefs.all;
use work.Simulation.all;

  ENTITY testbench IS
END testbench;

ARCHITECTURE behavior OF testbench IS 

constant CLK_period : time := 10 ns;
  -- Component Declaration
signal	CLK					:		std_logic	:=	'0';
signal	CE					:		std_logic	:=	'0';
signal	RST					:		std_logic	:=	'0';
	------------------------------------------------------------
signal	PCI_DIN				:		std_logic_vector(DataWidth-1 downto 0)	:=	(others => '0');
signal	PCI_DINV				:		std_logic	:=	'0';
signal	PCI_IN_SOP			:		std_logic	:=	'0';
signal	PCI_IN_EOP			:		std_logic	:=	'0';
signal	PCI_IN_Ind			:		std_logic	:=	'0';
signal	PCI_IN_ErrIn			:		std_logic	:=	'0';
signal	PCI_IN_USER_In			:		std_logic_vector(USER_width-1 downto 0)	:=	(others => '0');
signal	PCI_IN_Ack			:		std_logic	:=	'0';
signal	PCI_IN_ErrOut			:		std_logic	:=	'0';
	-------------------------------------------------------------
signal	SDU_DIN				:		std_logic_vector(DataWidth-1 downto 0)	:=	(others => '0');
signal	SDU_DINV				:		std_logic	:=	'0';
signal	SDU_IN_SOP			:		std_logic	:=	'0';
signal	SDU_IN_EOP			:		std_logic	:=	'0';
signal	SDU_IN_Ind			:		std_logic	:=	'0';
signal	SDU_IN_ErrIn			:		std_logic	:=	'0';
signal	SDU_IN_USER_In			:		std_logic_vector(USER_width-1 downto 0)	:=	(others => '0');
signal	SDU_IN_Ack			:		std_logic	:=	'0';
signal	SDU_IN_ErrOut			:		std_logic	:=	'0';
	-------------------------------------------------------------
signal	PDU_DOUT				:		std_logic_vector(DataWidth-1 downto 0)	:=	(others => '0');
signal	PDU_DOUTV				:		std_logic	:=	'0';
signal	PDU_Out_SOP			:		std_logic	:=	'0';
signal	PDU_Out_EOP			:		std_logic	:=	'0';
signal	PDU_Out_Ind			:		std_logic	:=	'0';
signal	PDU_Out_ErrOut			:		std_logic	:=	'0';
signal	PDU_Out_USER_Out		:		std_logic_vector(USER_width-1 downto 0)	:=	(others => '0');
signal	PDU_Out_Ack			:		std_logic	:=	'0';
signal	PDU_Out_ErrIn			:		std_logic	:=	'0';
	-------------------------------------------------------------
signal	PDU_DIN				:		std_logic_vector(DataWidth-1 downto 0)	:=	(others => '0');
signal	PDU_DINV				:		std_logic	:=	'0';
signal	PDU_IN_SOP			:		std_logic	:=	'0';
signal	PDU_IN_EOP			:		std_logic	:=	'0';
signal	PDU_IN_Ind			:		std_logic	:=	'0';
signal	PDU_IN_USER_In			:		std_logic_vector(USER_width-1 downto 0)	:=	(others => '0');
signal	PDU_IN_ErrIn			:		std_logic	:=	'0';
signal	PDU_IN_ErrOut			:		std_logic	:=	'0';
signal	PDU_IN_Ack			:		std_logic	:=	'0';
	-------------------------------------------------------------
signal	CTRL_DOUT				:		std_logic_vector(DataWidth-1 downto 0)	:=	(others => '0');
signal	CTRL_DV				:		std_logic	:=	'0';
signal	CTRL_ErrOut			:		std_logic	:=	'0';
signal	CTRL_Ind				:		std_logic	:=	'0';
signal	CTLR_USER_Out			:		std_logic_vector(USER_width-1 downto 0)	:=	(others => '0');
signal	CTRL_Ack				:		std_logic	:=	'0';
signal	CTRL_FWD				:		std_logic	:=	'0';
signal	CTRL_Pause			:		std_logic	:=	'0';
signal	CTRL_DROP_ERR			:		std_logic	:=	'0';
	-------------------------------------------------------------
signal	SDU_DOUT				:		std_logic_vector(DataWidth-1 downto 0)	:=	(others => '0');
signal	SDU_DOUTV				:		std_logic	:=	'0';
signal	SDU_Out_SOP			:		std_logic	:=	'0';
signal	SDU_OUT_EOP			:		std_logic	:=	'0';
signal	SDU_OUT_Ind			:		std_logic	:=	'0';
signal	SDU_OUT_USER_Out		:		std_logic_vector(USER_width-1 downto 0)	:=	(others => '0');
signal	SDU_OUT_ErrOut			:		std_logic	:=	'0';
signal	SDU_OUT_ErrIn			:		std_logic	:=	'0';
signal	SDU_OUT_Ack			:		std_logic	:=	'0';

          

  BEGIN

  -- Component Instantiation
          uut:ProtoLayer 
-- generic map(
	-- DataWidth			=>	,
	-- RX_SYNC_IN		=>	,
	-- RX_SYNC_OUT		=>	,
	-- RX_CTRL_SYNC		=>	,
	-- TX_CTRL_SYNC		=>	,
	-- TX_SYNC_IN		=>	,
	-- TX_SYNC_OUT		=>	,
	-- MINSDUSize		=>	,
	-- MAXSDUSize		=>	,
	-- MaxSDUToQ			=>	,
	-- MINPCISize		=>	,
	-- MAXPCISize		=>	,
	-- MaxPCIToQ			=>	
-- )
PORT MAP(
	CLK				=>	CLK				,
	CE				=>	CE				,
	RST				=>	RST				,
	------------------------------------------------------------
	PCI_DIN			=>	PCI_DIN			,
	PCI_DINV			=>	PCI_DINV			,
	PCI_IN_SOP		=>	PCI_IN_SOP		,
	PCI_IN_EOP		=>	PCI_IN_EOP		,
	PCI_IN_Ind		=>	PCI_IN_Ind		,
	PCI_IN_ErrIn		=>	PCI_IN_ErrIn		,
	PCI_IN_USER_In		=>	PCI_IN_USER_In		,
	PCI_IN_Ack		=>	PCI_IN_Ack		,
	PCI_IN_ErrOut		=>	PCI_IN_ErrOut		,
	-------------------------------------------------------------
	SDU_DIN			=>	SDU_DIN			,
	SDU_DINV			=>	SDU_DINV			,
	SDU_IN_SOP		=>	SDU_IN_SOP		,
	SDU_IN_EOP		=>	SDU_IN_EOP		,
	SDU_IN_Ind		=>	SDU_IN_Ind		,
	SDU_IN_ErrIn		=>	SDU_IN_ErrIn		,
	SDU_IN_USER_In		=>	SDU_IN_USER_In		,
	SDU_IN_Ack		=>	SDU_IN_Ack		,
	SDU_IN_ErrOut		=>	SDU_IN_ErrOut		,
	-------------------------------------------------------------
	PDU_DOUT			=>	PDU_DOUT			,
	PDU_DOUTV			=>	PDU_DOUTV			,
	PDU_Out_SOP		=>	PDU_Out_SOP		,
	PDU_Out_EOP		=>	PDU_Out_EOP		,
	PDU_Out_Ind		=>	PDU_Out_Ind		,
	PDU_Out_ErrOut		=>	PDU_Out_ErrOut		,
	PDU_Out_USER_Out	=>	PDU_Out_USER_Out	,
	PDU_Out_Ack		=>	PDU_Out_Ack		,
	PDU_Out_ErrIn		=>	PDU_Out_ErrIn		,
	-------------------------------------------------------------
	PDU_DIN			=>	PDU_DIN			,
	PDU_DINV			=>	PDU_DINV			,
	PDU_IN_SOP		=>	PDU_IN_SOP		,
	PDU_IN_EOP		=>	PDU_IN_EOP		,
	PDU_IN_Ind		=>	PDU_IN_Ind		,
	PDU_IN_USER_In		=>	PDU_IN_USER_In		,
	PDU_IN_ErrIn		=>	PDU_IN_ErrIn		,
	PDU_IN_ErrOut		=>	PDU_IN_ErrOut		,
	PDU_IN_Ack		=>	PDU_IN_Ack		,
	-------------------------------------------------------------
	CTRL_DOUT			=>	CTRL_DOUT			,
	CTRL_DV			=>	CTRL_DV			,
	CTRL_ErrOut		=>	CTRL_ErrOut		,
	CTRL_Ind			=>	CTRL_Ind			,
	CTLR_USER_Out		=>	CTLR_USER_Out		,
	CTRL_Ack			=>	CTRL_Ack			,
	CTRL_FWD			=>	CTRL_FWD			,
	CTRL_Pause		=>	CTRL_Pause		,
	CTRL_DROP_ERR		=>	CTRL_DROP_ERR		,
	-------------------------------------------------------------
	SDU_DOUT			=>	SDU_DOUT			,
	SDU_DOUTV			=>	SDU_DOUTV			,
	SDU_Out_SOP		=>	SDU_Out_SOP		,
	SDU_OUT_EOP		=>	SDU_OUT_EOP		,
	SDU_OUT_Ind		=>	SDU_OUT_Ind		,
	SDU_OUT_USER_Out	=>	SDU_OUT_USER_Out	,
	SDU_OUT_ErrOut		=>	SDU_OUT_ErrOut		,
	SDU_OUT_ErrIn		=>	SDU_OUT_ErrIn		,
	SDU_OUT_Ack		=>	SDU_OUT_Ack
);



   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '1';
		wait for CLK_period/2;
		CLK <= '0';
		wait for CLK_period/2;
   end process;

	--  Test Bench Statements
	stim_proc : PROCESS
	BEGIN
		Init_Module(CLK_period,5,-1,RST,CE);
		
		Emit_PDU(CLK_period,128,SDU_DIN,SDU_DINV,SDU_IN_SOP,SDU_IN_EOP);
		Emit_PDU(CLK_period,128,PCI_DIN,PCI_DINV,PCI_IN_SOP,PCI_IN_EOP);
		
		wait; -- will wait forever
	END PROCESS stim_proc;
	--  End Test Bench 

END;
