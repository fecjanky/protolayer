-- TestBench Template 

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;
USE IEEE.numeric_std.ALL;


use work.ProtoModulePkg.all;
use work.ProtoLayerTypesAndDefs.all;
use work.Simulation.all;
use work.arch.aRise;
ENTITY testbench IS
END testbench;

ARCHITECTURE behavior OF testbench IS 

constant CLK_period : time := 10 ns;
  -- Component Declaration
signal	CLK					:		std_logic	:=	'0';
signal	CE					:		std_logic	:=	'0';
signal	RST					:		std_logic	:=	'0';
	------------------------------------------------------------
signal	PCI_DIN				:		std_logic_vector(DefDataWidth-1 downto 0)	:=	(others => '0');
signal	PCI_DINV				:		std_logic	:=	'0';
signal	PCI_IN_SOP			:		std_logic	:=	'0';
signal	PCI_IN_EOP			:		std_logic	:=	'0';
signal	PCI_IN_Ind			:		std_logic	:=	'0';
signal	PCI_IN_ErrIn			:		std_logic	:=	'0';
signal	PCI_IN_USER_In			:		std_logic_vector(USER_width-1 downto 0)	:=	(others => '0');
signal	PCI_IN_Ack			:		std_logic	:=	'0';
signal	PCI_IN_ErrOut			:		std_logic	:=	'0';
	-------------------------------------------------------------
signal	SDU_DIN				:		std_logic_vector(DefDataWidth-1 downto 0)	:=	(others => '0');
signal	SDU_DINV				:		std_logic	:=	'0';
signal	SDU_IN_SOP			:		std_logic	:=	'0';
signal	SDU_IN_EOP			:		std_logic	:=	'0';
signal	SDU_IN_Ind			:		std_logic	:=	'0';
signal	SDU_IN_ErrIn			:		std_logic	:=	'0';
signal	SDU_IN_USER_In			:		std_logic_vector(USER_width-1 downto 0)	:=	(others => '0');
signal	SDU_IN_Ack			:		std_logic	:=	'0';
signal	SDU_IN_ErrOut			:		std_logic	:=	'0';
	-------------------------------------------------------------
signal	PDU_DOUT				:		std_logic_vector(DefDataWidth-1 downto 0)	:=	(others => '0');
signal	PDU_DOUTV				:		std_logic	:=	'0';
signal	PDU_Out_SOP			:		std_logic	:=	'0';
signal	PDU_Out_EOP			:		std_logic	:=	'0';
signal	PDU_Out_Ind			:		std_logic	:=	'0';
signal	PDU_Out_ErrOut			:		std_logic	:=	'0';
signal	PDU_Out_USER_Out		:		std_logic_vector(USER_width-1 downto 0)	:=	(others => '0');
signal	PDU_Out_Ack			:		std_logic	:=	'0';
signal	PDU_Out_ErrIn			:		std_logic	:=	'0';
	-------------------------------------------------------------
signal	PDU_DIN				:		std_logic_vector(DefDataWidth-1 downto 0)	:=	(others => '0');
signal	PDU_DINV				:		std_logic	:=	'0';
signal	PDU_IN_SOP			:		std_logic	:=	'0';
signal	PDU_IN_EOP			:		std_logic	:=	'0';
signal	PDU_IN_Ind			:		std_logic	:=	'0';
signal	PDU_IN_USER_In			:		std_logic_vector(USER_width-1 downto 0)	:=	(others => '0');
signal	PDU_IN_ErrIn			:		std_logic	:=	'0';
signal	PDU_IN_ErrOut			:		std_logic	:=	'0';
signal	PDU_IN_Ack			:		std_logic	:=	'0';
	-------------------------------------------------------------
signal	CTRL_DOUT				:		std_logic_vector(DefDataWidth-1 downto 0)	:=	(others => '0');
signal	CTRL_DV				:		std_logic	:=	'0';
signal	CTRL_ErrOut			:		std_logic	:=	'0';
signal	CTRL_Ind				:		std_logic	:=	'0';
signal	CTLR_USER_Out			:		std_logic_vector(USER_width-1 downto 0)	:=	(others => '0');
signal	CTRL_Ack				:		std_logic	:=	'0';
signal	CTRL_FWD				:		std_logic	:=	'0';
signal	CTRL_Pause			:		std_logic	:=	'0';
signal	CTRL_DROP_ERR			:		std_logic	:=	'0';
	-------------------------------------------------------------
signal	SDU_DOUT				:		std_logic_vector(DefDataWidth-1 downto 0)	:=	(others => '0');
signal	SDU_DOUTV				:		std_logic	:=	'0';
signal	SDU_Out_SOP			:		std_logic	:=	'0';
signal	SDU_OUT_EOP			:		std_logic	:=	'0';
signal	SDU_OUT_Ind			:		std_logic	:=	'0';
signal	SDU_OUT_USER_Out		:		std_logic_vector(USER_width-1 downto 0)	:=	(others => '0');
signal	SDU_OUT_ErrOut			:		std_logic	:=	'0';
signal	SDU_OUT_ErrIn			:		std_logic	:=	'0';
signal	SDU_OUT_Ack			:		std_logic	:=	'0';
constant	TX_AUX_widthDW			:		integer	:=	(2*IPAddrSize+IPLengthSize)/DefDataWidth;
constant	RX_AUX_widthDW			:		integer	:=	2*IPAddrSize/DefDataWidth;
signal	TX_AUX_Out			:		std_logic_vector(TX_AUX_widthDW*DefDataWidth-1 downto 0);
signal	TX_AUX_outV			:		std_logic;
signal	TX_AUX_in				:		std_logic_vector(TX_AUX_widthDW*DefDataWidth-1 downto 0);
signal	RX_AUX_Out			:		std_logic_vector(RX_AUX_widthDW*DefDataWidth-1 downto 0);
signal	RX_AUX_OutV			:		std_logic;
signal	RX_AUX_in				:		std_logic_vector(RX_AUX_widthDW*DefDataWidth-1 downto 0);

--simulation aux signals
signal	RX_AUX_OutV_Rise		: std_logic := '0';
signal	CTRL_FWD_SET			: std_logic := '0';
signal	CTRL_FWD_RST			: std_logic := '0';
signal	CTRL_FWD_delay			: integer := 1;
signal	CTRL_FWD_width			: integer := 1;

signal	CTRL_ACK_SET			: std_logic := '0';
signal	CTRL_ACK_RST			: std_logic := '0';
signal	CTRL_ACK_delay			: integer := 1;
signal	CTRL_ACK_width			: integer := 1;

signal	CTRL_DROP_SET			: std_logic := '0';
signal	CTRL_DROP_RST			: std_logic := '0';
signal	CTRL_DROP_delay		: integer := 1;
signal	CTRL_DROP_width		: integer := 1;

signal	OUTACK_SET			: std_logic := '0';
signal	OUTACK_RST			: std_logic := '0';
signal	OUTACK_delay			: integer := 1;
signal	OUTACK_width			: integer := 1;

signal	CTRL_PAUSE_SET			: std_logic := '0';
signal	CTRL_PAUSE_RST			: std_logic := '0';
signal	CTRL_PAUSE_delay		: integer := 4;
signal	CTRL_PAUSE_width		: integer := 40;

signal	PDU_ErrIn_SET			: std_logic := '0';
signal	PDU_ErrIn_RST			: std_logic := '0';
signal	PDU_ErrIn_delay		: integer := 1;
signal	PDU_ErrIn_width		: integer := 5;
signal	PDU_SOF				: std_logic := '0';

signal	PCI_ErrIn_SET			: std_logic := '0';
signal	PCI_ErrIn_RST			: std_logic := '0';
signal	PCI_ErrIn_delay		: integer := 1;
signal	PCI_ErrIn_width		: integer := 5;
signal	PCI_SOF				: std_logic := '0';

signal	CTRL_SOF				: std_logic := '0';
signal	CTRL_SOP				: std_logic := '0';
signal	CTRL_EOP				: std_logic := '0';


BEGIN

  -- Component Instantiation
          uut:ProtoLayer 
	generic map(
		DataWidth				=>	DefDataWidth,
		RX_SYNC_IN			=>	FALSE,
		RX_SYNC_OUT			=>	FALSE,
		RX_CTRL_SYNC			=>	false,
		TX_CTRL_SYNC			=>	FALSE, -- PCI_In in SYNC mode !!!
		TX_SYNC_IN			=>	false, 
		TX_SYNC_OUT			=>	false,
		TX_AUX_Q				=>	true,
		TX_AUX_widthDW			=>	TX_AUX_widthDW, --SRCIP,DSTIP & Length
		RX_AUX_Q				=>	true,
		RX_AUX_widthDW			=>	RX_AUX_widthDW, --SRCIP & DSTIP
		MINSDUSize			=>	1,
		MAXSDUSize			=>	DefMaxSDUSize,
		MaxSDUToQ				=>	DefPDUToQ,
		MINPCISize			=>	UDPPCILength,
		MAXPCISize			=>	UDPPCILength,
		MaxPCIToQ				=>	DefPDUToQ
	)
PORT MAP(
	CLK				=>	CLK,
	CE				=>	CE,
	RST				=>	RST,
	------------------------------------------------------------
	PCI_DIN			=>	PCI_DIN,
	PCI_DINV			=>	PCI_DINV,
	PCI_IN_SOP		=>	PCI_IN_SOP,
	PCI_IN_EOP		=>	PCI_IN_EOP,
	PCI_IN_Ind		=>	PCI_IN_Ind,
	PCI_IN_ErrIn		=>	PCI_IN_ErrIn,
	PCI_IN_USER_In		=>	PCI_IN_USER_In,
	PCI_IN_Ack		=>	PCI_IN_Ack,
	PCI_IN_ErrOut		=>	PCI_IN_ErrOut,
	-------------------------------------------------------------
	SDU_DIN			=>	SDU_DIN,
	SDU_DINV			=>	SDU_DINV,
	SDU_IN_SOP		=>	SDU_IN_SOP,
	SDU_IN_EOP		=>	SDU_IN_EOP,
	SDU_IN_Ind		=>	SDU_IN_Ind,
	SDU_IN_ErrIn		=>	SDU_IN_ErrIn,
	SDU_IN_USER_In		=>	SDU_IN_USER_In,
	SDU_IN_Ack		=>	SDU_IN_Ack,
	SDU_IN_ErrOut		=>	SDU_IN_ErrOut,
	-------------------------------------------------------------
	PDU_DOUT			=>	PDU_DOUT,
	PDU_DOUTV			=>	PDU_DOUTV,
	PDU_Out_SOP		=>	PDU_Out_SOP,
	PDU_Out_EOP		=>	PDU_Out_EOP,
	PDU_Out_Ind		=>	PDU_Out_Ind,
	PDU_Out_ErrOut		=>	PDU_Out_ErrOut,
	PDU_Out_USER_Out	=>	PDU_Out_USER_Out,
	PDU_Out_Ack		=>	PDU_Out_Ack,
	PDU_Out_ErrIn		=>	PDU_Out_ErrIn,
	-------------------------------------------------------------
	PDU_DIN			=>	PDU_DIN,
	PDU_DINV			=>	PDU_DINV,
	PDU_IN_SOP		=>	PDU_IN_SOP,
	PDU_IN_EOP		=>	PDU_IN_EOP,
	PDU_IN_Ind		=>	PDU_IN_Ind,
	PDU_IN_USER_In		=>	PDU_IN_USER_In,
	PDU_IN_ErrIn		=>	PDU_IN_ErrIn,
	PDU_IN_ErrOut		=>	PDU_IN_ErrOut,
	PDU_IN_Ack		=>	PDU_IN_Ack,
	-------------------------------------------------------------
	CTRL_DOUT			=>	CTRL_DOUT,
	CTRL_DV			=>	CTRL_DV,
	CTRL_SOP			=>	CTRL_SOP,
	CTRL_EOP			=>	CTRL_EOP,
	CTRL_ErrOut		=>	CTRL_ErrOut,
	CTRL_Ind			=>	CTRL_Ind,
	CTLR_USER_Out		=>	CTLR_USER_Out,
	CTRL_Ack			=>	CTRL_Ack,
	CTRL_FWD			=>	CTRL_FWD,
	CTRL_Pause		=>	CTRL_Pause,
	CTRL_DROP_ERR		=>	CTRL_DROP_ERR,
	-------------------------------------------------------------
	SDU_DOUT			=>	SDU_DOUT,
	SDU_DOUTV			=>	SDU_DOUTV,
	SDU_Out_SOP		=>	SDU_Out_SOP,
	SDU_OUT_EOP		=>	SDU_OUT_EOP,
	SDU_OUT_Ind		=>	SDU_OUT_Ind,
	SDU_OUT_USER_Out	=>	SDU_OUT_USER_Out,
	SDU_OUT_ErrOut		=>	SDU_OUT_ErrOut,
	SDU_OUT_ErrIn		=>	SDU_OUT_ErrIn,
	SDU_OUT_Ack		=>	SDU_OUT_Ack,
	TX_AUX_in			=>	TX_AUX_in,
	TX_AUX_Out		=>	TX_AUX_Out,
	TX_AUX_OutV		=>	TX_AUX_OutV,
	RX_AUX_in			=>	RX_AUX_in,
	RX_AUX_Out		=>	RX_AUX_Out,
	RX_AUX_OutV		=>	RX_AUX_OutV
	
	
);

CTRL_SOF <= CTRL_SOP and CTRL_DV;

S_rise	: aRise	port map(I => RX_AUX_OutV, C => CLK, Q => RX_AUX_OutV_Rise);

CTRL_FWD_Acker: Acker PORT MAP(
	clk => clk,
	set => CTRL_FWD_SET,
	rst => CTRL_FWD_RST,
	I => RX_AUX_OutV_Rise,
	delay => CTRL_FWD_delay,
	resp_width => CTRL_FWD_width,
	Q => CTRL_FWD
);
CTRL_DROpper: Acker PORT MAP(
	clk => clk,
	set => CTRL_DROP_SET,
	rst => CTRL_DROP_RST,
	I => CTRL_SOF,
	delay => CTRL_DROP_delay,
	resp_width => CTRL_DROP_width,
	Q => CTRL_DROP_ERR
);
CTRL_PAUSER: Acker  PORT MAP(
	clk => clk,
	set => CTRL_PAUSE_SET,
	rst => CTRL_PAUSE_RST,
	I => CTRL_SOF,
	delay => CTRL_PAUSE_delay,
	resp_width => CTRL_PAUSE_width,
	Q => CTRL_PAUSE
);

PDU_SOF	<=	PDU_DINV and PDU_IN_SOP;

PDU_ErrInner: Acker  PORT MAP(
	clk => clk,
	set => PDU_ErrIn_SET,
	rst => PDU_ErrIn_RST,
	I => PDU_SOF,
	delay => PDU_ErrIn_delay,
	resp_width => PDU_ErrIn_width,
	Q => PDU_IN_ErrIn
	);

PCI_SOF	<=	PCI_DINV and PCI_IN_SOP;
PCI_ErrInner: Acker  PORT MAP(
	clk => clk,
	set => PCI_ErrIn_SET,
	rst => PCI_ErrIn_RST,
	I => PCI_SOF,
	delay => PCI_ErrIn_delay,
	resp_width => PCI_ErrIn_width,
	Q => PCI_IN_ErrIn
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
		-- CTRL_PAUSE_RST		<=	Hi;
		CTRL_DROP_RST		<=	Hi;
		PCI_ErrIn_RST		<=	Hi;
		PDU_ErrIn_RST		<=	Hi;
		
		Emit_PDU(CLK_period,128,SDU_DIN,SDU_DINV,SDU_IN_SOP,SDU_IN_EOP);
		TX_AUX_in	<=	X"0a0a000a0a0a000b0080";
		Emit_PDU(CLK_period,128,PCI_DIN,PCI_DINV,PCI_IN_SOP,PCI_IN_EOP);

		Emit_PDU(CLK_period,32,SDU_DIN,SDU_DINV,SDU_IN_SOP,SDU_IN_EOP);
		TX_AUX_in	<=	X"0b0b000c0b0b000d0040";
		Emit_PDU(CLK_period,32,PCI_DIN,PCI_DINV,PCI_IN_SOP,PCI_IN_EOP);
		
		
		Emit_PDU(CLK_period,32,SDU_DIN,SDU_DINV,SDU_IN_SOP,SDU_IN_EOP);
		TX_AUX_in		<=	X"0a0a000a0a0a000b0080";
		PCI_ErrIn_RST		<=	Lo;
		PCI_ErrIn_SET		<=	Hi;
		Emit_PDU(CLK_period,32,PCI_DIN,PCI_DINV,PCI_IN_SOP,PCI_IN_EOP);
		PCI_ErrIn_SET	<=	Lo;
		PCI_ErrIn_RST	<=	Hi;
		PCI_ErrIn_delay<=	1;
		Emit_PDU(CLK_period,32,SDU_DIN,SDU_DINV,SDU_IN_SOP,SDU_IN_EOP);
		TX_AUX_in		<=	X"0a0a000a0a0a000b0080";
		PCI_ErrIn_RST	<=	Lo;
		Emit_PDU(CLK_period,32,PCI_DIN,PCI_DINV,PCI_IN_SOP,PCI_IN_EOP);

		
		Emit_PDU(CLK_period,32,SDU_DIN,SDU_DINV,SDU_IN_SOP,SDU_IN_EOP);
		TX_AUX_in		<=	X"0a0a000a0a0a000b0080";
		PCI_ErrIn_delay<=	2;
		Emit_PDU(CLK_period,32,PCI_DIN,PCI_DINV,PCI_IN_SOP,PCI_IN_EOP);

		
		Emit_PDU(CLK_period,32,SDU_DIN,SDU_DINV,SDU_IN_SOP,SDU_IN_EOP);
		TX_AUX_in		<=	X"0b0b000c0b0b000d0040";
		PCI_ErrIn_delay<=	3;
		Emit_PDU(CLK_period,32,PCI_DIN,PCI_DINV,PCI_IN_SOP,PCI_IN_EOP);

		
		PDU_ErrIn_delay	<=	1;
		PDU_ErrIn_width	<=	3;
		PDU_ErrIn_RST		<=	Hi;
		RX_AUX_in	<=	X"0b0b000c0b0b000d";
		Emit_PDU(CLK_period,64,PDU_DIN,PDU_DINV,PDU_IN_SOP,PDU_IN_EOP);
		WAIT_CLK(CLK_period,10);

		RX_AUX_in	<=	X"0a0a000a0a0a000b";
		Emit_PDU(CLK_period,64,PDU_DIN,PDU_DINV,PDU_IN_SOP,PDU_IN_EOP);
		WAIT_CLK(CLK_period,10);
		
		PDU_ErrIn_RST		<=	Lo;
		PDU_ErrIn_SET		<=	Hi;
		RX_AUX_in	<=	X"0a0a000a0a0a000b";
		Emit_PDU(CLK_period,64,PDU_DIN,PDU_DINV,PDU_IN_SOP,PDU_IN_EOP);
		WAIT_CLK(CLK_period,10);
		
		PDU_ErrIn_RST		<=	Hi;
		PDU_ErrIn_SET		<=	Lo;
		WAIT_CLK(CLK_period,1);
		PDU_ErrIn_RST		<=	Lo;
		PDU_ErrIn_delay	<=	0;
		RX_AUX_in		<=	X"0b0b000c0b0b000d";
		Emit_PDU(CLK_period,64,PDU_DIN,PDU_DINV,PDU_IN_SOP,PDU_IN_EOP);
		WAIT_CLK(CLK_period,10);
		
		RX_AUX_in			<=	X"0a0a000a0a0a000b";
		PDU_ErrIn_delay	<=	1;
		Emit_PDU(CLK_period,64,PDU_DIN,PDU_DINV,PDU_IN_SOP,PDU_IN_EOP);
		WAIT_CLK(CLK_period,10);
		
		PDU_ErrIn_RST		<=	Hi;
		RX_AUX_in	<=	X"0a0a000a0a0a000b";
		Emit_PDU(CLK_period,64,PDU_DIN,PDU_DINV,PDU_IN_SOP,PDU_IN_EOP);
		WAIT_CLK(CLK_period,10);

		wait; -- will wait forever
	END PROCESS stim_proc;
	--  End Test Bench 

END;
