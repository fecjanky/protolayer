--
-- ResidentCore.VHD
-- =================
--
--
-- Multi-Gigabit Applications for GPLANAR1 PCI Express x4 adapter
-- with a Virtex-5 FPGA (xc5vlx50t-1-ff1136 )
-- Resident area. Initial Core.
-- This core contains the PCI Express x4 Controller, AND ICAP
-- for dynamic AND partial reconfiguration.
--
-- Created:  2008.06.16    - G.H. Written
-- Modified: 2008.06.16    - G.H. PCI.VHD with completer
-- Modified: 2008.07.10    - G.H. GPON ONT transceiver added
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_UNSIGNED.all;
library unisim;
use unisim.vcomponents.all;

USE work.arch.all;
USE work.apps.all;
USE work.ProtoLayerTypesAndDefs.all;
USE work.gpcspma.all;
use work.dummy_gtp_pkg.all;

-- ============================
entity   ResidentCore  is
-- ============================
port (
-- PCI Express x4 Pinouts
--   reference clock from the slot
	-- PXCLKN			: IN		STD_LOGIC;
	-- PXCLKP			: IN		STD_LOGIC;
--   x4 Lanes
	PETN				: IN		STD_LOGIC_VECTOR( 3 downto 0);
	PETP				: IN		STD_LOGIC_VECTOR( 3 downto 0);
	PERN				: OUT	STD_LOGIC_VECTOR( 3 downto 0);
	PERP				: OUT	STD_LOGIC_VECTOR( 3 downto 0);
-- SFPs
	MGTCLK_N			: IN		STD_LOGIC;
	MGTCLK_P			: IN		STD_LOGIC;
-- if "0"
	SFP_0_TXN			: OUT	STD_LOGIC;
	SFP_0_TXP			: OUT	STD_LOGIC;
	SFP_0_RXN			: IN		STD_LOGIC;
	SFP_0_RXP			: IN		STD_LOGIC;
-- if "1"
	SFP_1_TXN			: OUT	STD_LOGIC;
	SFP_1_TXP			: OUT	STD_LOGIC;
	SFP_1_RXN			: IN		STD_LOGIC;
	SFP_1_RXP			: IN		STD_LOGIC;
---
	TXFAULT			: IN		STD_LOGIC_VECTOR(1 downto 0);
	LOS				: IN		STD_LOGIC_VECTOR(1 downto 0);
	TXDIS			: OUT	STD_LOGIC_VECTOR(1 downto 0);
	PLUG_N			: IN		STD_LOGIC_VECTOR(1 downto 0);
	RATS				: OUT	STD_LOGIC_VECTOR(1 downto 0);
	LEDLOS2			: OUT	STD_LOGIC;
-- WCLOCK
	Wclock_UsrtClk		: IN		STD_LOGIC;
	Wclock_UsrtDout	: OUT	STD_LOGIC;
	Wclock_UsrtDin		: IN		STD_LOGIC;
	Wclock_UsrtReset	:OUT	STD_LOGIC;
	Wclock_PPSin		: IN		STD_LOGIC;
-- JTAG
	JTAG_TCK			: OUT	STD_LOGIC;
	JTAG_TMS			: OUT	STD_LOGIC;
	JTAG_TDI			: OUT	STD_LOGIC;
	JTAG_TDO			: IN		STD_LOGIC;
-- LED's
	LEDACT_N			: OUT	STD_LOGIC_VECTOR( 2 downto 0);
	LEDLOS_N			: OUT	STD_LOGIC_VECTOR( 2 downto 0);
--
	SFPReset			: IN		STD_LOGIC;
-- Debug option	
	TestPins			: OUT	STD_LOGIC_VECTOR( 7 downto 0);
	--- Dummy GTP stuff
	DUMMY_RXN		: IN		STD_LOGIC_VECTOR(1 downto 0);
	DUMMY_RXP		: IN		STD_LOGIC_VECTOR(1 downto 0);
	DUMMY_TXN		: OUT	STD_LOGIC_VECTOR(1 downto 0);
	DUMMY_TXP		: OUT	STD_LOGIC_VECTOR(1 downto 0)
);
end entity ResidentCore;
--
architecture rtl of ResidentCore is
--
--SIGNAL Hi, Low                  : STD_LOGIC;

-- GPLANAR1 clocking/test SIGNALs
SIGNAL sfp_clk					: STD_LOGIC;
SIGNAL mac_clk					: STD_LOGIC;
SIGNAL clk125_o				: STD_LOGIC;
SIGNAL clk125					: STD_LOGIC;
SIGNAL testcnt					: STD_LOGIC_VECTOR(31 downto 0);
SIGNAL LOSOUT					: STD_LOGIC_VECTOR(02 downto 0);
--
-- Ethernet side
SIGNAL MAC_RESET				: STD_LOGIC;
SIGNAL SFP_PLUG_0				: STD_LOGIC;
SIGNAL MAC_0_synchron			: STD_LOGIC;
SIGNAL MAC_0_status				: STD_LOGIC_VECTOR(07 downto 0);
SIGNAL RX_0_DAV				: STD_LOGIC;
SIGNAL RX_0_SOF				: STD_LOGIC;
SIGNAL RX_0_EOF				: STD_LOGIC;
SIGNAL RX_0_GoodfFrame			: STD_LOGIC;
SIGNAL RX_0_BadFrame			: STD_LOGIC;
SIGNAL RX_0_Framedrop			: STD_LOGIC;
SIGNAL RX_0_Data				: STD_LOGIC_VECTOR(07 downto 0);
SIGNAL RX_0_DataLength			: STD_LOGIC_VECTOR(31 downto 0);
--
SIGNAL SFP_PLUG_1				: STD_LOGIC;
SIGNAL MAC_1_synchron			: STD_LOGIC;
SIGNAL MAC_1_status				: STD_LOGIC_VECTOR(07 downto 0);
SIGNAL RX_1_DAV				: STD_LOGIC;
SIGNAL RX_1_SOF				: STD_LOGIC;
SIGNAL RX_1_EOF				: STD_LOGIC;
SIGNAL RX_1_GoodfFrame			: STD_LOGIC;
SIGNAL RX_1_BadFrame			: STD_LOGIC;
SIGNAL RX_1_Framedrop			: STD_LOGIC;
SIGNAL RX_1_Data				: STD_LOGIC_VECTOR(07 downto 0);
SIGNAL RX_1_DataLength			: STD_LOGIC_VECTOR(31 downto 0);
-- TEMAC
-- debug
SIGNAL BlinkCnt				: STD_LOGIC_VECTOR(26 downto 0);
SIGNAL TestVector				: STD_LOGIC_VECTOR (7 downto 0);
SIGNAL DebugReg				: STD_LOGIC_VECTOR (31 downto 0);




--
-- ============================================ ProtoLayer
SIGNAL MAC_0_DOUT				: STD_LOGIC_VECTOR (7 downto 0);
SIGNAL MAC_0_DOUTV				: STD_LOGIC;
SIGNAL MAC_0_LOS				: STD_LOGIC;
SIGNAL MAC_1_DOUT				: STD_LOGIC_VECTOR (7 downto 0);
SIGNAL MAC_1_DOUTV				: STD_LOGIC;
SIGNAL MAC_1_LOS				: STD_LOGIC;
SIGNAL MAC_0_Err				: STD_LOGIC;
SIGNAL MAC_1_Err				: STD_LOGIC;
SIGNAL RX_0_GMII_RX_ERR			: STD_LOGIC;
SIGNAL RX_1_GMII_RX_ERR			: STD_LOGIC;




BEGIN
--
-- ==============
--	ties
-- ==============
--
-- ===========================
--		CLKs
-- ===========================
-- Generate the clock input to the GTP
-- clk_ds can be shared between multiple MAC instances.
CLK_SFP : IBUFDS port map ( I  => MGTCLK_P,	IB => MGTCLK_N,	O  => sfp_clk);
--

-- =====================================================================
--				LEDs
-- =====================================================================
 -- Green if Frame Sync. Acquired
--	RED if no SIGNAL present
-- LEDLOS : "red"
LEDLOS_N(0)	<= SFP_PLUG_0;
LEDLOS_N(1)	<= SFP_PLUG_1;
LEDLOS_N(2)	<= Hi;
-- LEDACT_N: "green"
LEDACT_N(0)	<= MAC_0_synchron;
LEDACT_N(1)	<= MAC_1_synchron;
LEDACT_N(2)	<= LOSOUT(2);
--

-- =====================================================================
--				Soft ethernet MAC
-- =====================================================================

-- 1G user interface clock (one clock to rule them all...)
SFPIntfClk: BUFG PORT MAP (
		I => clk125_o,
		O => clk125
);
mac_clk<=clk125;
-- ==================================
--	SFP specific parameters
-- ==================================
SFP_PLUG_0	<= MAC_0_status(0);
SFP_PLUG_1	<= MAC_1_status(0);
--
RATS(0)		<=Low;
RATS(1)		<=Low;

ClkTest:PROCESS (mac_clk, BlinkCnt)
BEGIN
	IF (rising_edge(mac_clk)) THEN
		BlinkCnt		<=BlinkCnt+1;

		LOSOUT(0)		<= LOS(0);
		LOSOUT(1)		<= LOS(1);
		LOSOUT(2)		<= BlinkCnt(26);

		MAC_0_synchron	<= LOS(0);--LOS(0);
		MAC_1_synchron	<= LOS(1);--LOS(1);

	END IF;
END PROCESS;
--
TXDIS(0)					<= PLUG_N(0) OR TXFAULT(0);
TXDIS(1)					<= PLUG_N(1) OR TXFAULT(1);
RX_0_DataLength(31 downto 16)	<=x"0000";
RX_1_DataLength(31 downto 16)	<=x"0000";
--
EthernetMac : Mac1G_pcspma PORT MAP (
	-- clocks
	rxnocrc				=> Hi,
	refclkout				=> clk125_o,
	gtpreset				=> Low,
	clkin				=> sfp_clk,
	userclk2				=> mac_clk, -- 1 clock feed for all GTPs !!!
	-- ===================================
	--			MAC "0"
	-- ===================================
	Tx_Data0				=> MAC_0_DOUT,
	Tx_Dav0				=> MAC_0_DOUTV,
	gmii_tx_er0			=> Low,
	--
	Rx_Data0				=> RX_0_Data,
	Rx_Dav0				=> RX_0_DAV,
	Rx_SOF0				=> RX_0_SOF,
	Rx_EOF0				=> RX_0_EOF,
	Rx_Frlen0				=> RX_0_DataLength(15 downto 0),
	Rx_BadCRC0			=> RX_0_BadFrame,
	gmii_rx_er0			=> RX_0_GMII_RX_ERR, --MAC1G_RX_ERR(0),
	gmii_isolate0			=> open,
	--
	configuration_vector0	=> x"0",
	status_vector0			=> MAC_0_status,
	reset0				=> MAC_RESET,
	signal_detect0			=> Hi,
	-- ===================================
	--			MAC "1"
	-- ===================================
	Tx_Data1				=> MAC_0_DOUT,
	Tx_Dav1				=> MAC_0_DOUTV,
	gmii_tx_er1			=> Low,
	--
	Rx_Data1				=> RX_1_Data,
	Rx_Dav1				=> RX_1_DAV,
	Rx_SOF1				=> RX_1_SOF,
	Rx_EOF1				=> RX_1_EOF,
	Rx_Frlen1				=> RX_1_DataLength(15 downto 0),
	Rx_BadCRC1			=> RX_1_BadFrame,
	gmii_rx_er1			=> RX_1_GMII_RX_ERR, --MAC1G_gmii_rx_er(1),
	gmii_isolate1			=> open,
	--
	configuration_vector1	=> x"0",
	status_vector1			=> MAC_1_status,
	reset1				=> MAC_RESET,
	signal_detect1			=> Hi,
	-- ===================================
	--			SFPs
	-- ===================================
	txp0					=> SFP_0_TXP,
	txn0					=> SFP_0_TXN,
	rxp0					=> SFP_0_RXP,
	rxn0					=> SFP_0_RXN,

	txp1					=> SFP_1_TXP,
	txn1					=> SFP_1_TXN,
	rxp1					=> SFP_1_RXP,
	rxn1					=> SFP_1_RXN
);
RX_0_Framedrop		<= Low;
RX_1_Framedrop		<= Low;
RX_0_GoodfFrame	<= not RX_0_BadFrame AND RX_0_EOF;
RX_1_GoodfFrame	<= not RX_1_BadFrame AND RX_1_EOF;

MAC_0_LOS			<=	LOSOUT(0);
MAC_1_LOS			<=	LOSOUT(1);

MAC_0_Err			<= RX_0_BadFrame or RX_0_GMII_RX_ERR or LOSOUT(0);
MAC_1_Err			<= RX_1_BadFrame or RX_1_GMII_RX_ERR or LOSOUT(1);

dgtp: dummy_gtp PORT MAP(
	clk_in			=> clk125,
	RXN				=> DUMMY_RXN,
	RXP				=> DUMMY_RXP,
	TXN				=> DUMMY_TXN,
	TXP				=> DUMMY_TXP
);


-- =====================================================================
--				Application area
-- =====================================================================
-- Transient Core Containing the user's application
-- identified by the HEX Core ID
--
apps: O2e10020 port map
-- --------------------
(
-- Clock output to fabric
	MacClk			=> clk125,
	TestO			=> testcnt,
	MAC_RESET			=> MAC_RESET,
-- Ethernet MACs
	MAC_0_SYNCH		=> MAC_0_synchron,
	MAC_0_SOF			=> RX_0_SOF,
	MAC_0_EOF			=> RX_0_EOF,
	MAC_0_DAV			=> RX_0_DAV,
	MAC_0_GOODF		=> RX_0_GoodfFrame,
	MAC_0_BADF		=> RX_0_BadFrame,
	MAC_0_DROPF		=> RX_0_Framedrop,
	MAC_0_Err			=> MAC_0_Err,
	MAC_0_LOS			=> MAC_0_LOS,
	MAC_0_DIN			=> RX_0_Data,
	MAC_0_LENGTH		=> RX_0_DataLength,
	
	MAC_0_DOUT		=> MAC_0_DOUT,
	MAC_0_DOUTV		=> MAC_0_DOUTV,

	MAC_1_SYNCH		=> MAC_1_synchron,
	MAC_1_SOF			=> RX_1_SOF,
	MAC_1_EOF			=> RX_1_EOF,
	MAC_1_DAV			=> RX_1_DAV,
	MAC_1_GOODF		=> RX_1_GoodfFrame,
	MAC_1_BADF		=> RX_1_BadFrame,
	MAC_1_DROPF		=> RX_1_Framedrop,
	MAC_1_Err			=> MAC_1_Err,
	MAC_1_LOS			=> MAC_1_LOS,
	MAC_1_DIN			=> RX_1_Data,
	MAC_1_LENGTH		=> RX_1_DataLength,
	
	MAC_1_DOUT		=> MAC_1_DOUT,
	MAC_1_DOUTV		=> MAC_1_DOUTV,

-- Debug
	DebugReg			=> DebugReg,

	TestVector		=> TestVector
);
--
-- ======================
--	Debug mode
-- ======================
--
-- |....................|
-- |.xxxxxxxx...........|
--
-- Test pin out
TestPins(0)	<= TestVector(0);
TestPins(1)	<= TestVector(1);
TestPins(2)	<= TestVector(2);
TestPins(3)	<= TestVector(3);
TestPins(4)	<= TestVector(4);
TestPins(5)	<= TestVector(5);
TestPins(6)	<= TestVector(6);
TestPins(7)	<= TestVector(7);

--TestPins <= TestVector;
end architecture rtl;
--
-- End of ResidentCore.VHD