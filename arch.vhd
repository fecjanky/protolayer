-- ARCH.VHD
-- ========
--
-- (C) Gabor Krodi 
--
-- This IS the ARCHITECTURE specific PACKAGE for U6SGA
-- containing virtex 5 primitives, components, and defineants
-- Some optimization tricks has been implemented here too.
--
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.tuw.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;

--
PACKAGE arch IS
--
  CONSTANT  aDefSize: INTEGER := 32;         -- Default size OF logic vectors

-- Our components generated below
--
  COMPONENT aAND
--          ~~~~
        PORT (
             A:     IN     STD_LOGIC;
             B:     IN     STD_LOGIC;
--
             Q:     OUT    STD_LOGIC
             );
  END COMPONENT;
--
--
  COMPONENT aOR3
--          ~~~~
        PORT (
             A:     IN     STD_LOGIC;
             B:     IN     STD_LOGIC;
             C:     IN     STD_LOGIC;
--
             Q:     OUT    STD_LOGIC
             );
  END COMPONENT;
--
--
  COMPONENT aCounterRE
--          ~~~~~~~~~~
        GENERIC( Size: INTEGER := aDefSize );
        PORT (
             C:     IN     STD_LOGIC;       -- Clock
             CE:    IN     STD_LOGIC;       -- Clock enable
             R:     IN     STD_LOGIC;       -- Synchronous reset
--
             Q:     OUT    STD_LOGIC_VECTOR (Size-1 downto 0);  -- Count
             TC:    OUT    STD_LOGIC;       -- Terminal count
             CEO:   OUT    STD_LOGIC        -- CE output
             );
  END COMPONENT;
--
--
  COMPONENT aCounterCE
--          ~~~~~~~~~~
        GENERIC( Size: INTEGER := aDefSize );
        PORT (
             C:     IN     STD_LOGIC;       -- Clock
             CE:    IN     STD_LOGIC;       -- Clock enable
             CLR:   IN     STD_LOGIC;       -- Async. Clear
--
             Q:     OUT    STD_LOGIC_VECTOR (Size-1 downto 0);  -- Count
             TC:    OUT    STD_LOGIC;       -- Terminal count
             CEO:   OUT    STD_LOGIC        -- CE output
             );
  END COMPONENT;
--
  COMPONENT aCountDownLE
--          ~~~~~~~~~~~~
        GENERIC( Size: INTEGER := aDefSize );
        PORT (
             C:     IN     STD_LOGIC;       -- Clock
             CE:    IN     STD_LOGIC;       -- Clock enable
             L:     IN     STD_LOGIC;       -- Synchronous load
             D:     IN     STD_LOGIC_VECTOR (Size-1 downto 0);  -- Data
--
             Q:     OUT    STD_LOGIC_VECTOR (Size-1 downto 0);
             TC:    OUT    STD_LOGIC;       -- Terminal count
             CEO:   OUT    STD_LOGIC        -- CE output
             );
  END COMPONENT;
--
--
  COMPONENT aCounterLE
--          ~~~~~~~~~~
        GENERIC( Size: INTEGER := aDefSize );
        PORT (
             C:     IN     STD_LOGIC;       -- Clock
             CE:    IN     STD_LOGIC;       -- Clock enable
             L:     IN     STD_LOGIC;       -- Synchronous load
             D:     IN     STD_LOGIC_VECTOR (Size-1 downto 0);  -- Data
--
             Q:     OUT    STD_LOGIC_VECTOR (Size-1 downto 0);  -- Count
             TC:    OUT    STD_LOGIC;       -- Terminal count
             CEO:   OUT    STD_LOGIC        -- CE output
             );
  END COMPONENT;
--
--
  COMPONENT aLess
--          ~~~~~
        GENERIC( Size: INTEGER := aDefSize );
        PORT (
             LE:    IN     STD_LOGIC;       -- ... or equal
             A:     IN     STD_LOGIC_VECTOR (Size-1 downto 0);
             B:     IN     STD_LOGIC_VECTOR (Size-1 downto 0);
             LT:    OUT    STD_LOGIC );     -- A less than B
  END COMPONENT;
--
  COMPONENT aLessSat
--          ~~~~~~~~
        GENERIC( Size: INTEGER := aDefSize );
        PORT (
             LE:    IN     STD_LOGIC;       -- ... or equal
             A:     IN     STD_LOGIC_VECTOR (Size-1 downto 0);
             B:     IN     STD_LOGIC_VECTOR (Size-1 downto 0);
             LT:    OUT    STD_LOGIC );     -- A less than B
  END COMPONENT;
--
--
  COMPONENT aRisingEdge
--          ~~~~~~~~~~~
        PORT (
             I:     IN     STD_LOGIC;       -- Input async/combi.
             C:     IN     STD_LOGIC;       -- Clock system
--
             Q:     OUT    STD_LOGIC        -- Pulse on Rising edge
             );
  END COMPONENT;
--
  COMPONENT xRisingEdge
--          ~~~~~~~~~~~
        PORT (
             I:     IN     STD_LOGIC;       -- Input async/combi.
             C:     IN     STD_LOGIC;       -- Clock system
             FI:    IN     STD_LOGIC_VECTOR( 3 downto 0);
--
             Q:     OUT    STD_LOGIC        -- Pulse on Rising edge
             );
  END COMPONENT;
--
  COMPONENT aFallingEdge
--          ~~~~~~~~~~~
        PORT (
             I:     IN     STD_LOGIC;       -- Input async/combi.
             C:     IN     STD_LOGIC;       -- Clock system
             Q:     OUT    STD_LOGIC        -- Pulse on Falling edge
             );
  END COMPONENT;
--
--
  COMPONENT aRise
--          ~~~~~~~~~~~
        PORT (
             I:     IN     STD_LOGIC;       -- Input async/combi.
             C:     IN     STD_LOGIC;       -- Clock system
             Q:     OUT    STD_LOGIC        -- Pulse on Rising edge
             );
  END COMPONENT;
--
  COMPONENT aFall
--          ~~~~~~~~~~~
        PORT (
             I:     IN     STD_LOGIC;       -- Input async/combi.
             C:     IN     STD_LOGIC;       -- Clock system
             Q:     OUT    STD_LOGIC        -- Pulse on Falling edge
             );
  END COMPONENT;
--
  COMPONENT aRippleRise
--          ~~~~~~~~~~~
        PORT (
             I:     IN     STD_LOGIC;       -- Input sync. other clock
             C:     IN     STD_LOGIC;       -- Clock system
             Q:     OUT    STD_LOGIC        -- Pulse on Rising edge
             );
  END COMPONENT;
--
  COMPONENT aRippleRiseSync
--          ~~~~~~~~~~~~~~~
        PORT (
             I:     IN     STD_LOGIC;       -- Input sync. other clock
             CI:    IN     STD_LOGIC;       -- Clock IN
             Q:     OUT    STD_LOGIC;       -- Pulse on Rising edge
             CO:    IN     STD_LOGIC        -- Clock OUT
             );
  END COMPONENT;
--
  COMPONENT aRippleRiseE
--          ~~~~~~~~~~~~
        PORT (
             I:     IN     STD_LOGIC;       -- Input sync. other clock
             C:     IN     STD_LOGIC;       -- Clock system
             E:     IN     STD_LOGIC;       -- Enable to pulse
             Q:     OUT    STD_LOGIC        -- Pulse on Rising edge
             );
  END COMPONENT;
--
--
  COMPONENT aRippleFall
--          ~~~~~~~~~~~
        PORT (
             I:     IN     STD_LOGIC;       -- Input sync. other clock
             C:     IN     STD_LOGIC;       -- Clock system
             Q:     OUT    STD_LOGIC        -- Pulse on Falling edge
             );
  END COMPONENT;
--
--
  COMPONENT aRippleFallE
--          ~~~~~~~~~~~~
        PORT (
             I:     IN     STD_LOGIC;       -- Input sync. other clock
             C:     IN     STD_LOGIC;       -- Clock system
             E:     IN     STD_LOGIC;       -- Enable to pulse
             Q:     OUT    STD_LOGIC        -- Pulse on Falling edge
             );
  END COMPONENT;
--
  COMPONENT aRippleX
--          ~~~~~~~~
        PORT (
             I:     IN     STD_LOGIC;       -- Input sync rise or fall
             C:     IN     STD_LOGIC;       -- Clock system
             Q:     OUT    STD_LOGIC        -- Pulse
             );
  END COMPONENT;
--
  COMPONENT aPipe
--          ~~~~~
        GENERIC( Size:   INTEGER := aDefSize ;
                 Length: INTEGER := 1  );
        PORT (
             I:     IN     STD_LOGIC_VECTOR (Size-1 downto 0); -- Input
             C:     IN     STD_LOGIC;                          -- Clock
             CE:    IN     STD_LOGIC;                          -- Enable
             Q:     OUT    STD_LOGIC_VECTOR (Size-1 downto 0)  -- Output
             );
  END COMPONENT;
--
  COMPONENT aPipeBack
--          ~~~~~~~~~
        GENERIC( Size:   INTEGER := aDefSize );
        PORT (
             C:     IN     STD_LOGIC;                          -- Clock
             CE:    IN     STD_LOGIC;                          -- Enable
             Q:     OUT    STD_LOGIC_VECTOR (Size-1 downto 0); -- Output
             I:     IN     STD_LOGIC_VECTOR (Size-1 downto 0); -- Input
             CEO:   OUT    STD_LOGIC                           -- Enable
             );
  END COMPONENT;
--
  COMPONENT aDelay
--          ~~~~~~
        GENERIC( Length: INTEGER := 1  );
        PORT (
             I:     IN     STD_LOGIC;      -- Input
             C:     IN     STD_LOGIC;      -- Clock
             CE:    IN     STD_LOGIC;      -- Enable
             Q:     OUT    STD_LOGIC       -- Output
             );
  END COMPONENT;
--
--
COMPONENT   aFIFO
--          ~~~~~
        GENERIC( Size:    INTEGER := aDefSize;
                 LowMark: INTEGER := 2;
                 HiMark:  INTEGER := 12 );
        PORT (
             C:      IN     STD_LOGIC;         -- Clock
             R:      IN     STD_LOGIC;         -- Reset
             WE:     IN     STD_LOGIC;         -- Write Enable
             D:      IN     STD_LOGIC_VECTOR (Size-1 downto 0);  -- IN
             Empty:  OUT    STD_LOGIC;         -- Empty
             Aempty: OUT    STD_LOGIC;         -- Almost Empty
             Afull:  OUT    STD_LOGIC;         -- Almost Full
             Full:   OUT    STD_LOGIC;         -- Full
             RE:     IN     STD_LOGIC;         -- Read Enable
             Q:      OUT    STD_LOGIC_VECTOR (Size-1 downto 0)); -- OUT
END  COMPONENT;
--
COMPONENT   aFIFOn
--          ~~~~~~
        GENERIC( Size:    INTEGER := aDefSize;
                 Depth:   INTEGER := 4;
                 LowMark: INTEGER := 2;
                 HiMark:  INTEGER := 12 );
        PORT (
             C:      IN     STD_LOGIC;         -- Clock
             R:      IN     STD_LOGIC;         -- Reset
             WE:     IN     STD_LOGIC;         -- Write Enable
             D:      IN     STD_LOGIC_VECTOR (Size-1 downto 0);  -- IN
             Empty:  OUT    STD_LOGIC;         -- Empty
             Aempty: OUT    STD_LOGIC;         -- Almost Empty
             Afull:  OUT    STD_LOGIC;         -- Almost Full
             Full:   OUT    STD_LOGIC;         -- Full
             RE:     IN     STD_LOGIC;         -- Read Enable
             Q:      OUT    STD_LOGIC_VECTOR (Size-1 downto 0)); -- OUT
END  COMPONENT;
--
COMPONENT   aFIFO32
--          ~~~~~~~
        GENERIC( Size:    INTEGER := aDefSize;
                 LowMark: INTEGER := 2;
                 HiMark:  INTEGER := 28 );
        PORT (
             C:      IN     STD_LOGIC;         -- Clock
             R:      IN     STD_LOGIC;         -- Reset
             WE:     IN     STD_LOGIC;         -- Write Enable
             D:      IN     STD_LOGIC_VECTOR (Size-1 downto 0);  -- IN
             Empty:  OUT    STD_LOGIC;         -- Empty
             Aempty: OUT    STD_LOGIC;         -- Almost Empty
             Afull:  OUT    STD_LOGIC;         -- Almost Full
             Full:   OUT    STD_LOGIC;         -- Full
             RE:     IN     STD_LOGIC;         -- Read Enable
             Q:      OUT    STD_LOGIC_VECTOR (Size-1 downto 0)); -- OUT
END  COMPONENT;
--
COMPONENT   aFIFO64
--          ~~~~~~~
        GENERIC( Size:    INTEGER := aDefSize;
                 LowMark: INTEGER := 2;
                 HiMark:  INTEGER := 60 );
        PORT (
             C:      IN     STD_LOGIC;         -- Clock
             R:      IN     STD_LOGIC;         -- Reset
             WE:     IN     STD_LOGIC;         -- Write Enable
             D:      IN     STD_LOGIC_VECTOR (Size-1 downto 0);  -- IN
             Empty:  OUT    STD_LOGIC;         -- Empty
             Aempty: OUT    STD_LOGIC;         -- Almost Empty
             Afull:  OUT    STD_LOGIC;         -- Almost Full
             Full:   OUT    STD_LOGIC;         -- Full
             RE:     IN     STD_LOGIC;         -- Read Enable
             Q:      OUT    STD_LOGIC_VECTOR (Size-1 downto 0)); -- OUT
END  COMPONENT;
--
  COMPONENT aFlop PORT (
--          ~~~~~
        D,CE,C: IN  STD_LOGIC;
        Q     : OUT STD_LOGIC );
  END COMPONENT;
--
--
  COMPONENT aFlopC PORT (
--          ~~~~~~
        D,CE,C,CLR: IN  STD_LOGIC;
        Q         : OUT STD_LOGIC );
  END COMPONENT;
--
--
  COMPONENT aRSFlop PORT (
--          ~~~~~~~
        R,S,C: IN  STD_LOGIC;
        Q       : OUT STD_LOGIC );
  END COMPONENT;
--
--
  COMPONENT aRegister
--          ~~~~~~~~~
        GENERIC( Size:   INTEGER := aDefSize );
        PORT (
             D:     IN     STD_LOGIC_VECTOR (Size-1 downto 0); -- Input
             C:     IN     STD_LOGIC;                          -- Clock
             CE:    IN     STD_LOGIC;                          -- Enable
             Q:     OUT    STD_LOGIC_VECTOR (Size-1 downto 0)  -- Output
             );
  END COMPONENT;
--
  COMPONENT aShiftLeft
--          ~~~~~~~~~~
        GENERIC( Size:   INTEGER := aDefSize );
        PORT (
             D:     IN     STD_LOGIC;                          -- Input
             C:     IN     STD_LOGIC;                          -- Clock
             CE:    IN     STD_LOGIC;                          -- Enable
             Q:     OUT    STD_LOGIC_VECTOR (Size-1 downto 0)  -- Output
             );
  END COMPONENT;
--
--
  COMPONENT aShiftRight
--          ~~~~~~~~~~~
        GENERIC( Size:   INTEGER := aDefSize );
        PORT (
             D:     IN     STD_LOGIC;                          -- Input
             C:     IN     STD_LOGIC;                          -- Clock
             CE:    IN     STD_LOGIC;                          -- Enable
             Q:     OUT    STD_LOGIC_VECTOR (Size-1 downto 0)  -- Output
             );
  END COMPONENT;
--
COMPONENT aMux16 PORT (
        D     : IN STD_LOGIC_VECTOR(15 downto 0);
        S     : IN STD_LOGIC_VECTOR( 3 downto 0);
		  E	  : IN STD_LOGIC;
        Q     : OUT STD_LOGIC
);
END COMPONENT;

COMPONENT aMux32 PORT (
        D     : IN STD_LOGIC_VECTOR(31 downto 0);
        S     : IN STD_LOGIC_VECTOR( 4 downto 0);
		  E	  : IN STD_LOGIC;
        Q     : OUT STD_LOGIC
);
END COMPONENT; 
--
COMPONENT aRAM
--        ~~~~~~~~~~
        GENERIC( Size: INTEGER := aDefSize );
        PORT (
              D     : IN  STD_LOGIC_VECTOR( Size-1 downto 0 ); -- Data IN
              WE    : IN  STD_LOGIC;       -- Write enable
              WCLK  : IN  STD_LOGIC;       -- Clock
              A     : IN  STD_LOGIC_VECTOR ( 3 downto 0);      -- Write Address
--
              RA    : IN  STD_LOGIC_VECTOR ( 3 downto 0);      -- Read Address
              DO    : OUT STD_LOGIC_VECTOR( Size-1 downto 0 )  -- Data OUT
             );
END COMPONENT;
--
COMPONENT aRAMx2
--        ~~~~~~~~~~
        GENERIC( Size: INTEGER := aDefSize );
        PORT (
              D     : IN  STD_LOGIC_VECTOR( Size-1 downto 0 ); -- Data IN
              WE    : IN  STD_LOGIC;       -- Write enable
              WCLK  : IN  STD_LOGIC;       -- Clock
              A     : IN  STD_LOGIC_VECTOR ( 4 downto 0);      -- Write Address
--
              RA    : IN  STD_LOGIC_VECTOR ( 4 downto 0);      -- Read Address
              DO    : OUT STD_LOGIC_VECTOR( Size-1 downto 0 )  -- Data OUT
             );
END COMPONENT;
-- self made components
COMPONENT SRL64E PORT (D,CE,CLK,A0,A1,A2,A3,A4,A5: IN STD_LOGIC; Q: OUT STD_LOGIC );
END COMPONENT;
-- Some attributes used
--ATTRIBUTE  RLOC_RANGE  : STRING;          -- Relative location placement range
--ATTRIBUTE  RLOC        : STRING;          -- Relative location placement
--ATTRIBUTE  LOC         : STRING;          -- Location placement
--ATTRIBUTE  INIT        : STRING;          -- Init vectors
--ATTRIBUTE  INIT_00     : STRING;
--ATTRIBUTE  INIT_01     : STRING;
--ATTRIBUTE  INIT_02     : STRING;
--ATTRIBUTE  INIT_03     : STRING;
--ATTRIBUTE  INIT_04     : STRING;
--ATTRIBUTE  INIT_05     : STRING;
--ATTRIBUTE  INIT_06     : STRING;
--ATTRIBUTE  INIT_07     : STRING;
--ATTRIBUTE  INIT_08     : STRING;
--ATTRIBUTE  INIT_09     : STRING;
--ATTRIBUTE  INIT_0A     : STRING;
--ATTRIBUTE  INIT_0B     : STRING;
--ATTRIBUTE  INIT_0C     : STRING;
--ATTRIBUTE  INIT_0D     : STRING;
--ATTRIBUTE  INIT_0E     : STRING;
--ATTRIBUTE  INIT_0F     : STRING;
ATTRIBUTE  XC_MAP      : STRING;          -- Mapping style
--
END arch;
--
--
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
USE work.arch.aDefSize;
--
ENTITY      aAND  IS
--          ~~~~
        PORT (
             A:     IN     STD_LOGIC;
             B:     IN     STD_LOGIC;
--
             Q:     OUT    STD_LOGIC );
END         aAND;
--
ARCHITECTURE FMAPAND OF aAND IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~
--
SIGNAL       Ap          : STD_LOGIC;
SIGNAL       Bp          : STD_LOGIC;
SIGNAL       Qp          : STD_LOGIC;
SIGNAL       Low         : STD_LOGIC;
--
ATTRIBUTE    XC_MAP OF Ap  : SIGNAL IS "FMAP";
ATTRIBUTE    XC_MAP OF Bp  : SIGNAL IS "FMAP";
ATTRIBUTE    XC_MAP OF Qp  : SIGNAL IS "FMAP";
--
BEGIN
--
Low <= '0';
--
Ap <= A;
Bp <= B;
Qp <= Ap AND Bp;
Q  <= Qp;
--
U1: FMAP PORT MAP( I1 => Ap, I2 => Bp, I3 => Low, I4 => Low, O => Qp );
--
END FMAPAND;
--
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
USE work.arch.aDefSize;
--
ENTITY      aOR3  IS
--          ~~~~
        PORT (
             A:     IN     STD_LOGIC;
             B:     IN     STD_LOGIC;
             C:     IN     STD_LOGIC;
--
             Q:     OUT    STD_LOGIC );
END         aOR3;
--
ARCHITECTURE FMAPOR3 OF aOR3 IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~
--
SIGNAL       Ap          : STD_LOGIC;
SIGNAL       Bp          : STD_LOGIC;
SIGNAL       Cp          : STD_LOGIC;
SIGNAL       Qp          : STD_LOGIC;
SIGNAL       Low         : STD_LOGIC;
--
ATTRIBUTE    XC_MAP OF Ap  : SIGNAL IS "FMAP";
ATTRIBUTE    XC_MAP OF Bp  : SIGNAL IS "FMAP";
ATTRIBUTE    XC_MAP OF Cp  : SIGNAL IS "FMAP";
ATTRIBUTE    XC_MAP OF Qp  : SIGNAL IS "FMAP";
--
BEGIN
--
Low <= '0';
--
Ap <= A;
Bp <= B;
Cp <= C;
Qp <= Ap OR Bp OR Cp;
Q  <= Qp;
--
U1: FMAP PORT MAP( I1 => Ap, I2 => Bp, I3 => Cp, I4 => Low, O => Qp );
--
END FMAPOR3;
--
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
USE work.arch.aDefSize;
--
ENTITY      aCounterRE  IS
--          ~~~~~~~~~~
        GENERIC( Size: INTEGER := aDefSize );
        PORT (
             C:     IN     STD_LOGIC;       -- Clock
             CE:    IN     STD_LOGIC;       -- Clock enable
             R:     IN     STD_LOGIC;       -- Synchronous reset
--
             Q:     OUT    STD_LOGIC_VECTOR (Size-1 downto 0);  -- Count
             TC:    OUT    STD_LOGIC;       -- Terminal count
             CEO:   OUT    STD_LOGIC );     -- CE output
END         aCounterRE;
--
ARCHITECTURE FastCarryCRE OF aCounterRE IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~
--
SIGNAL       Qtr         : STD_LOGIC_VECTOR (Size-1 downto 0);
SIGNAL       Qt          : STD_LOGIC_VECTOR (Size-1 downto 0);
SIGNAL       Qo          : STD_LOGIC_VECTOR (Size-1 downto 0);
SIGNAL       Cy          : STD_LOGIC_VECTOR (Size-1 downto 1);
SIGNAL       Tco         : STD_LOGIC;
SIGNAL       CeD         : STD_LOGIC;
SIGNAL       Low,Hi      : STD_LOGIC;
--
ATTRIBUTE    XC_MAP OF Qtr : SIGNAL IS "FMAP";
--
BEGIN
--
Low <= '0';
Hi  <= '1';
--
CeD <= CE OR R;
--
G0: FOR I IN 0 TO Size-1 GENERATE
       BEGIN
U0:    PROCESS (R,Qt) BEGIN
         IF( R = '1' ) THEN
           Qtr( I ) <= '0';
         ELSE
           Qtr( I ) <= Qt(I);
         END IF;
       END PROCESS;

U1:		FDCPE GENERIC MAP (INIT=>'0') PORT MAP ( D=>Qtr(I), C=>C, CE=>CeD,CLR=>'0',PRE=>'0', Q=>Qo(I) ); 

G1:    IF I = 0 GENERATE
U2:       XORCY PORT MAP ( LI=>Qo(I),CI=>Hi,O=>Qt(I) );
U3:       MUXCY_L PORT MAP ( DI=>Low,CI=>Hi,S=>Qo(I),LO=>Cy(I+1) );
       END GENERATE;
G2:    IF I > 0 AND I < Size-1 GENERATE
U4:       XORCY PORT MAP ( LI=>Qo(I),CI=>Cy(I),O=>Qt(I) );
U5:       MUXCY_L PORT MAP ( DI=>Low,CI=>Cy(I),S=>Qo(I),LO=>Cy(I+1) );
       END GENERATE;
G3:    IF I = Size-1 GENERATE
U6:       XORCY PORT MAP ( LI=>Qo(I),CI=>Cy(I),O=>Qt(I) );
U7:       MUXCY PORT MAP ( DI=>Low,CI=>Cy(I),S=>Qo(I),O=>Tco );
       END GENERATE;
    END GENERATE;
--
CeoGen: PROCESS ( CE, Tco, Qo )
BEGIN
  Q  <= Qo;
  TC <= Tco;
  IF ( Tco = '1' AND CE = '1' ) THEN
       CEO <= '1';
  ELSE
       CEO <= '0';
  END IF;
END PROCESS;
--
END FastCarryCRE;
--
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
USE work.arch.aDefSize;
--
ENTITY      aCounterCE  IS
--          ~~~~~~~~~~
        GENERIC( Size: INTEGER := aDefSize );
        PORT (
             C:     IN     STD_LOGIC;       -- Clock
             CE:    IN     STD_LOGIC;       -- Clock enable
             CLR:   IN     STD_LOGIC;       -- Asyncronous Clear
--
             Q:     OUT    STD_LOGIC_VECTOR (Size-1 downto 0);  -- Count
             TC:    OUT    STD_LOGIC;       -- Terminal count
             CEO:   OUT    STD_LOGIC );     -- CE output
END         aCounterCE;
--
ARCHITECTURE FastCarryCCE OF aCounterCE IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~
--
SIGNAL       Qtr         : STD_LOGIC_VECTOR (Size-1 downto 0);
SIGNAL       Qt          : STD_LOGIC_VECTOR (Size-1 downto 0);
SIGNAL       Qo          : STD_LOGIC_VECTOR (Size-1 downto 0);
SIGNAL       Cy          : STD_LOGIC_VECTOR (Size-1 downto 1);
SIGNAL       Tco         : STD_LOGIC;
SIGNAL       CeD         : STD_LOGIC;
SIGNAL       Low,Hi      : STD_LOGIC;
--
ATTRIBUTE    XC_MAP OF Qtr : SIGNAL IS "FMAP";
--
BEGIN
--
Low <= '0';
Hi  <= '1';
--
CeD <= CE;
--
G0: FOR I IN 0 TO Size-1 GENERATE
       BEGIN
       Qtr( I ) <= Qt(I);
U1:		FDCPE GENERIC MAP (INIT=>'0') PORT MAP ( D=>Qtr(I), C=>C, CE=>CeD,CLR=>CLR,PRE=>'0', Q=>Qo(I) ); 


G1:    IF I = 0 GENERATE
U2:       XORCY PORT MAP ( LI=>Qo(I),CI=>Hi,O=>Qt(I) );
U3:       MUXCY_L PORT MAP ( DI=>Low,CI=>Hi,S=>Qo(I),LO=>Cy(I+1) );
       END GENERATE;
G2:    IF I > 0 AND I < Size-1 GENERATE
U4:       XORCY PORT MAP ( LI=>Qo(I),CI=>Cy(I),O=>Qt(I) );
U5:       MUXCY_L PORT MAP ( DI=>Low,CI=>Cy(I),S=>Qo(I),LO=>Cy(I+1) );
       END GENERATE;
G3:    IF I = Size-1 GENERATE
U6:       XORCY PORT MAP ( LI=>Qo(I),CI=>Cy(I),O=>Qt(I) );
U7:       MUXCY PORT MAP ( DI=>Low,CI=>Cy(I),S=>Qo(I),O=>Tco );
       END GENERATE;
    END GENERATE;
--
CeoGen: PROCESS ( CE, Tco, Qo )
BEGIN
  Q  <= Qo;
  TC <= Tco;
  IF ( Tco = '1' AND CE = '1' ) THEN
       CEO <= '1';
  ELSE
       CEO <= '0';
  END IF;
END PROCESS;
--
END FastCarryCCE;
--
--
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
USE work.arch.aDefSize;
--
ENTITY      aCountDownLE  IS
--          ~~~~~~~~~~~~
        GENERIC( Size: INTEGER := aDefSize );
        PORT (
             C:     IN     STD_LOGIC;       -- Clock
             CE:    IN     STD_LOGIC;       -- Clock enable
             L:     IN     STD_LOGIC;       -- Synchronous load
             D:     IN     STD_LOGIC_VECTOR (Size-1 downto 0);  -- Data
--
             Q:     OUT    STD_LOGIC_VECTOR (Size-1 downto 0);
             TC:    OUT    STD_LOGIC;       -- Terminal count
             CEO:   OUT    STD_LOGIC );     -- CE output
END         aCountDownLE;
--
ARCHITECTURE FastCarryDLE OF aCountDownLE IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--
SIGNAL       Qtr         : STD_LOGIC_VECTOR (Size downto 0);
SIGNAL       Qt          : STD_LOGIC_VECTOR (Size downto 0);
SIGNAL       Qo          : STD_LOGIC_VECTOR (Size downto 0);
SIGNAL       Cy          : STD_LOGIC_VECTOR (Size downto 1);
SIGNAL       CeD         : STD_LOGIC;
SIGNAL       Tco         : STD_LOGIC;
SIGNAL       Low,Hi      : STD_LOGIC;
--
ATTRIBUTE    XC_MAP OF Qtr : SIGNAL IS "FMAP";
--
BEGIN
--
Low <= '0';
Hi  <= '1';
--
CeD <= CE OR L;
Q   <= Qo(Size-1 downto 0);
--
U0:    PROCESS (L,D,Qt) BEGIN
         IF( L  = '1' ) THEN        -- Load superseeds OTHERS!
           Qtr <= '1'&(NOT D);
         ELSE
           Qtr <= Qt;
         END IF;
       END PROCESS;
--
G0: FOR I IN 0 TO Size GENERATE
       BEGIN
U1:    FDCE  PORT MAP ( C=>C, CE=>CeD, CLR=>Low, D=>Qtr(I), Q=>Qo(I) );
G1:    IF I = 0 GENERATE
U2:       XORCY PORT MAP ( LI=>Qo(I),CI=>Hi,O=>Qt(I) );
U3:       MUXCY_L PORT MAP ( DI=>Low,CI=>Hi,S=>Qo(I),LO=>Cy(I+1) );
       END GENERATE;
G2:    IF I > 0 AND I < Size GENERATE
U4:       XORCY PORT MAP ( LI=>Qo(I),CI=>Cy(I),O=>Qt(I) );
U5:       MUXCY_L PORT MAP ( DI=>Low,CI=>Cy(I),S=>Qo(I),LO=>Cy(I+1) );
       END GENERATE;
G3:    IF I = Size GENERATE
U6:       XORCY PORT MAP ( LI=>Qo(I),CI=>Cy(I),O=>Qt(I) );
U7:       MUXCY PORT MAP ( DI=>Low,CI=>Cy(I),S=>Qo(I),O=>Tco );
       END GENERATE;
    END GENERATE;
--
CeoGen: PROCESS ( CE, Tco, Qo )
BEGIN
  TC <= Tco OR (NOT Qo(Size));         -- Inhibit reset problem
  IF ( Tco = '1' AND CE = '1' ) THEN
       CEO <= Qo(Size);
  ELSE
       CEO <= '0';
  END IF;
END PROCESS;
--
END FastCarryDLE;
--
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
USE work.arch.aDefSize;
--
ENTITY      aCounterLE  IS
--          ~~~~~~~~~~
        GENERIC( Size: INTEGER := aDefSize );
        PORT (
             C:     IN     STD_LOGIC;       -- Clock
             CE:    IN     STD_LOGIC;       -- Clock enable
             L:     IN     STD_LOGIC;       -- Synchronous load
             D:     IN     STD_LOGIC_VECTOR (Size-1 downto 0);  -- Data
--
             Q:     OUT    STD_LOGIC_VECTOR (Size-1 downto 0);  -- Count
             TC:    OUT    STD_LOGIC;       -- Terminal count
             CEO:   OUT    STD_LOGIC );     -- CE output
END         aCounterLE;
--
ARCHITECTURE FastCarryCLE OF aCounterLE IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~
--
SIGNAL       Qtr         : STD_LOGIC_VECTOR (Size-1 downto 0);
SIGNAL       Qt          : STD_LOGIC_VECTOR (Size-1 downto 0);
SIGNAL       Qo          : STD_LOGIC_VECTOR (Size-1 downto 0);
SIGNAL       Cy          : STD_LOGIC_VECTOR (Size-1 downto 1);
SIGNAL       Tco         : STD_LOGIC;
SIGNAL       CeD         : STD_LOGIC;
SIGNAL       Low,Hi      : STD_LOGIC;
--
ATTRIBUTE    XC_MAP OF Qtr : SIGNAL IS "FMAP";
--
BEGIN
--
Low <= '0';
Hi  <= '1';
--
Ced <= CE OR L;
--
U0:    PROCESS (L,D,Qt) BEGIN
         IF( L  = '1' ) THEN        -- Load superseeds OTHERS!
           Qtr <= D;
         ELSE
           Qtr <= Qt;
         END IF;
       END PROCESS;
--
G0: FOR I IN 0 TO Size-1 GENERATE
       BEGIN
U1:    FDCE  PORT MAP ( C=>C, CE=>CeD, CLR=>Low, D=>Qtr(I), Q=>Qo(I) );
G1:    IF I = 0 GENERATE
U2:       XORCY PORT MAP ( LI=>Qo(I),CI=>Hi,O=>Qt(I) );
U3:       MUXCY_L PORT MAP ( DI=>Low,CI=>Hi,S=>Qo(I),LO=>Cy(I+1) );
       END GENERATE;
G2:    IF I > 0 AND I < Size-1 GENERATE
U4:       XORCY PORT MAP ( LI=>Qo(I),CI=>Cy(I),O=>Qt(I) );
U5:       MUXCY_L PORT MAP ( DI=>Low,CI=>Cy(I),S=>Qo(I),LO=>Cy(I+1) );
       END GENERATE;
G3:    IF I = Size-1 GENERATE
U6:       XORCY PORT MAP ( LI=>Qo(I),CI=>Cy(I),O=>Qt(I) );
U7:       MUXCY PORT MAP ( DI=>Low,CI=>Cy(I),S=>Qo(I),O=>Tco );
       END GENERATE;
    END GENERATE;
--
CeoGen: PROCESS ( CE, Tco, Qo )
BEGIN
  Q  <= Qo;
  TC <= Tco;
  IF ( Tco = '1' AND CE = '1' ) THEN
       CEO <= '1';
  ELSE
       CEO <= '0';
  END IF;
END PROCESS;
--
END FastCarryCLE;
--
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
USE work.arch.aDefSize;
--
ENTITY      aLess  IS
--          ~~~~~~~~~~
        GENERIC( Size: INTEGER := aDefSize );
        PORT (
             LE:    IN     STD_LOGIC;       -- ... or equal
             A:     IN     STD_LOGIC_VECTOR (Size-1 downto 0);
             B:     IN     STD_LOGIC_VECTOR (Size-1 downto 0);
             LT:    OUT    STD_LOGIC );     -- A less than B
END         aLess;
--
ARCHITECTURE FastCarryLT OF aLess IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~
--
SIGNAL       Qtr         : STD_LOGIC_VECTOR (Size-1 downto 0);
SIGNAL       Qcy         : STD_LOGIC_VECTOR (Size   downto 0);
SIGNAL       Low,Hi      : STD_LOGIC;
--
ATTRIBUTE    XC_MAP OF Qtr : SIGNAL IS "FMAP";
--
BEGIN
--
Low <= '0';
Hi  <= '1';
--
Qcy(0) <= LE;
LT     <= Qcy( Size );
--
G0: FOR I IN 0 TO Size-1 GENERATE
    BEGIN
       Qtr(I) <= NOT ( A(I) XOR B(I) );
U1:    MUXCY_L PORT MAP ( DI=>B(I),CI=>Qcy(I),S=>Qtr(I),LO=>Qcy(I+1) );
    END GENERATE;
--
END FastCarryLT;
--
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
USE work.arch.aDefSize;
--
ENTITY      aLessSat IS
--          ~~~~~~~~~~~
        GENERIC( Size: INTEGER := aDefSize );
        PORT (
             LE:    IN     STD_LOGIC;       -- ... or equal
             A:     IN     STD_LOGIC_VECTOR (Size-1 downto 0);
             B:     IN     STD_LOGIC_VECTOR (Size-1 downto 0);
             LT:    OUT    STD_LOGIC );     -- A less than B
END         aLessSat;
--
ARCHITECTURE FastCarryLTS OF aLessSat IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~
--
SIGNAL       Qtr         : STD_LOGIC_VECTOR (Size-1 downto 0);
SIGNAL       Qcy         : STD_LOGIC_VECTOR (Size   downto 0);
SIGNAL       Bundle      : STD_LOGIC_VECTOR (   2   downto 0);
SIGNAL       Sat         : STD_LOGIC;
SIGNAL       Low,Hi      : STD_LOGIC;
--
ATTRIBUTE    XC_MAP OF Qtr : SIGNAL IS "FMAP";
--
BEGIN
--
Low <= '0';
Hi  <= '1';
--
Qcy(0) <= Sat XOR LE;
LT     <= Sat XOR Qcy( Size );
--
G0: FOR I IN 0 TO Size-1 GENERATE
    BEGIN
       Qtr(I) <= NOT ( A(I) XOR B(I) );
U1:    MUXCY_L PORT MAP ( DI=>B(I),CI=>Qcy(I),S=>Qtr(I),LO=>Qcy(I+1) );
    END GENERATE;
--
Bundle <= A(Size-1)&A(Size-2)&B(Size-1);
WITH Bundle SELECT Sat <=
     '1'  WHEN "001",
     '1'  WHEN "110",
     '0'  WHEN OTHERS;
--
END FastCarryLTS;
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
USE work.arch.aDefSize;
--
ENTITY      aRisingEdge IS
--          ~~~~~~~~~~~
        PORT (
             I:     IN     STD_LOGIC;
             C:     IN     STD_LOGIC;
--
             Q:     OUT    STD_LOGIC ); -- OUT
END         aRisingEdge;
--
ARCHITECTURE MacroCellRE  OF aRisingEdge IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~~
SIGNAL       Ta,Tb,Tc    : STD_LOGIC;
SIGNAL       Low,Hi      : STD_LOGIC;
--
BEGIN
--
Low <= '0';
Hi  <= '1';
Tc  <= I AND Ta AND NOT Tb;
--
U0:    FDCE  PORT MAP ( C=>C, CE=>Hi, CLR=>Low, D=>I,  Q=>Ta );
U1:    FDCE  PORT MAP ( C=>C, CE=>Hi, CLR=>Low, D=>Ta, Q=>Tb );
U2:    FDCE  PORT MAP ( C=>C, CE=>Hi, CLR=>Low, D=>Tc, Q=>Q  );
--
END         MacroCellRE;
--
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
USE work.arch.aDefSize;
--
ENTITY      aFallingEdge IS
--          ~~~~~~~~~~~~
        PORT (
             I:     IN     STD_LOGIC;
             C:     IN     STD_LOGIC;
--
             Q:     OUT    STD_LOGIC ); -- OUT
END         aFallingEdge;
--
ARCHITECTURE MacroCellFE  OF aFallingEdge IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SIGNAL       Ta,Tb,Tc    : STD_LOGIC;
SIGNAL       Low,Hi      : STD_LOGIC;
--
BEGIN
--
Low <= '0';
Hi  <= '1';
Tc  <= NOT I AND NOT Ta AND Tb;
--
U0:    FDCE  PORT MAP ( C=>C, CE=>Hi, CLR=>Low, D=>I,  Q=>Ta );
U1:    FDCE  PORT MAP ( C=>C, CE=>Hi, CLR=>Low, D=>Ta, Q=>Tb );
U2:    FDCE  PORT MAP ( C=>C, CE=>Hi, CLR=>Low, D=>Tc, Q=>Q  );
--
END         MacroCellFE;
--
--
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
USE work.arch.aDefSize;
--
ENTITY      aRise       IS
--          ~~~~~~~~~~~
        PORT (
             I:     IN     STD_LOGIC;
             C:     IN     STD_LOGIC;
--
             Q:     OUT    STD_LOGIC ); -- OUT
END         aRise;
--
ARCHITECTURE MacroCellR   OF aRise IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~~
SIGNAL       Ta,Tc       : STD_LOGIC;
SIGNAL       Low,Hi      : STD_LOGIC;
--
BEGIN
--
Low <= '0';
Hi  <= '1';
Tc  <= I AND NOT Ta;
--
U0:    FDCE  PORT MAP ( C=>C, CE=>Hi, CLR=>Low, D=>I,  Q=>Ta );
U1:    FDCE  PORT MAP ( C=>C, CE=>Hi, CLR=>Low, D=>Tc, Q=>Q  );
--
END         MacroCellR;
--
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
USE work.arch.aDefSize;
--
ENTITY      aFall IS
--          ~~~~~~~~~~~~
        PORT (
             I:     IN     STD_LOGIC;
             C:     IN     STD_LOGIC;
--
             Q:     OUT    STD_LOGIC ); -- OUT
END         aFall;
--
ARCHITECTURE MacroCellF  OF aFall IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SIGNAL       Ta,Tc       : STD_LOGIC;
SIGNAL       Low,Hi      : STD_LOGIC;
--
BEGIN
--
Low <= '0';
Hi  <= '1';
Tc  <= NOT I AND Ta;
--
U0:    FDCE  PORT MAP ( C=>C, CE=>Hi, CLR=>Low, D=>I,  Q=>Ta );
U1:    FDCE  PORT MAP ( C=>C, CE=>Hi, CLR=>Low, D=>Tc, Q=>Q  );
--
END         MacroCellF;
--
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
-- USE work.tuw.ALL;
-- USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;

LIBRARY work;
USE work.arch.aDefSize;
USE work.tuw.Let;

--
ENTITY aPipe IS
--          ~~~~~
	GENERIC(
		Size		: INTEGER := aDefSize;
		Length	: INTEGER := 1
	);
	PORT (
		I	: IN		STD_LOGIC_VECTOR (Size-1 downto 0);  -- IN
		C	: IN		STD_LOGIC;         -- Clock
		CE	: IN		STD_LOGIC;         -- Clock Enable
		Q	: OUT	STD_LOGIC_VECTOR (Size-1 downto 0)
	); -- OUT
END aPipe;
--
ARCHITECTURE LUTCellPP  OF aPipe    IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~
SIGNAL	A : STD_LOGIC_VECTOR (3 downto 0);
BEGIN
--
Let( A, Length-1 );
--
G0: FOR J IN 0 TO Size-1 GENERATE
	U0: SRL16E GENERIC MAP (
		INIT=> x"0000"
	)
	PORT MAP (
		D=>I(J), CE=>CE, CLK=>C,
		A0=>A(0),A1=>A(1),A2=>A(2),A3=>A(3),
		Q=>Q(J)
	);
END GENERATE;
--
END  LUTCellPP;
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
-- USE work.tuw.ALL;
-- USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;

LIBRARY work;
USE work.arch.aDefSize;
USE work.tuw.Let;

ENTITY aDelay IS
--
	GENERIC(
		Length: INTEGER := 1
	);
	PORT (
		I:	IN	STD_LOGIC;  -- IN
		C:	IN	STD_LOGIC;  -- Clock
		CE:	IN	STD_LOGIC;  -- Clock Enable
		Q:	OUT	STD_LOGIC
	); -- OUT
END         aDelay;
--
ARCHITECTURE LUTCellDL  OF aDelay   IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~
SIGNAL	A	: STD_LOGIC_VECTOR (3 downto 0);
SIGNAL	aQ	: STD_LOGIC;

BEGIN
--
Let( A, Length-1);
--
U0: SRL16E GENERIC MAP (
	INIT =>x"0000"
)
PORT MAP (
	D	=>I,
	CE	=>CE,
	CLK	=>C,
	A0=>A(0),A1=>A(1),A2=>A(2),A3=>A(3),
	Q=>Q );
--Q<=aQ;
--Exhcange: PROCESS( CE,aQ)
---- --------------
--BEGIN
--	IF (CE='1') THEN
--		Q<=aQ;
--	ELSE
--		Q<='0';
--	END IF;
--END PROCESS;
--
END  LUTCellDL;
--
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
USE work.arch.aDefSize;
--
ENTITY      aRippleRise IS
--          ~~~~~~~~~~~
        PORT (
             I:     IN     STD_LOGIC;
             C:     IN     STD_LOGIC;
             Q:     OUT    STD_LOGIC
             );
END         aRippleRise;
--
ARCHITECTURE MacroCellRR  OF aRippleRise IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~~
SIGNAL       Ta,Tp       : STD_LOGIC;
SIGNAL       Low,Hi      : STD_LOGIC;
--
BEGIN
--
Low <= '0';
Hi  <= '1';
Q   <= Tp;
--
U0:    FDCE  PORT MAP ( C=>I, CE=>Hi, CLR=>Tp,  D=>Hi, Q=>Ta );
U1:    FDCE  PORT MAP ( C=>C, CE=>Hi, CLR=>Low, D=>Ta, Q=>Tp );
--
END         MacroCellRR;
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
USE work.arch.aDefSize;
--
ENTITY      aRippleRiseSync IS
--          ~~~~~~~~~~~~~~~
        PORT (
             I:     IN     STD_LOGIC;       -- Input sync. other clock
             CI:    IN     STD_LOGIC;       -- Clock IN
             Q:     OUT    STD_LOGIC;       -- Pulse on Rising edge
             CO:    IN     STD_LOGIC        -- Clock OUT
             );
END         aRippleRiseSync;
--
ARCHITECTURE MacroCellRR  OF aRippleRiseSync IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SIGNAL       Ta,Tp       : STD_LOGIC;
SIGNAL       Low,Hi      : STD_LOGIC;
--
BEGIN
--
Low <= '0';
Hi  <= '1';
Q   <= Tp;
--
U0:    FDCE  PORT MAP ( C=>CI, CE=>I,  CLR=>Tp,  D=>Hi, Q=>Ta );
U1:    FDCE  PORT MAP ( C=>CO, CE=>Hi, CLR=>Low, D=>Ta, Q=>Tp );
--
END         MacroCellRR;
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
USE work.arch.aDefSize;
--
ENTITY      aRippleRiseE IS
--          ~~~~~~~~~~~~
        PORT (
             I:     IN     STD_LOGIC;
             C:     IN     STD_LOGIC;
             E:     IN     STD_LOGIC;
             Q:     OUT    STD_LOGIC
             );
END         aRippleRiseE;
--
ARCHITECTURE MacroCellRRE OF aRippleRiseE IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SIGNAL       Ta,Tp       : STD_LOGIC;
SIGNAL       Low,Hi      : STD_LOGIC;
--
BEGIN
--
Low <= '0';
Hi  <= '1';
Q   <= Tp;
--
U0:    FDCE  PORT MAP ( C=>I, CE=>Hi, CLR=>Tp,  D=>E,  Q=>Ta );
U1:    FDCE  PORT MAP ( C=>C, CE=>Hi, CLR=>Low, D=>Ta, Q=>Tp );
--
END         MacroCellRRE;
--
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
USE work.arch.aDefSize;
--
ENTITY      aRippleFall  IS
--          ~~~~~~~~~~~
        PORT (
             I:     IN     STD_LOGIC;
             C:     IN     STD_LOGIC;
--
             Q:     OUT    STD_LOGIC ); -- OUT
END         aRippleFall;
--
ARCHITECTURE MacroCellRF  OF aRippleFall  IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~~
SIGNAL       Ta,Tp       : STD_LOGIC;
SIGNAL       Low,Hi      : STD_LOGIC;
--
BEGIN
--
Low <= '0';
Hi  <= '1';
Q   <= Tp;
--
U0:    FDCE_1  PORT MAP ( C=>I, CE=>Hi, CLR=>Tp,  D=>Hi, Q=>Ta );
U1:    FDCE    PORT MAP ( C=>C, CE=>Hi, CLR=>Low, D=>Ta, Q=>Tp );
--
END         MacroCellRF;
--
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
USE work.arch.aDefSize;
--
ENTITY      aRippleFallE IS
--          ~~~~~~~~~~~~
        PORT (
             I:     IN     STD_LOGIC;
             C:     IN     STD_LOGIC;
             E:     IN     STD_LOGIC;
--
             Q:     OUT    STD_LOGIC ); -- OUT
END         aRippleFallE;
--
ARCHITECTURE MacroCellRFE OF aRippleFallE  IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SIGNAL       Ta,Tp       : STD_LOGIC;
SIGNAL       Low,Hi      : STD_LOGIC;
--
BEGIN
--
Low <= '0';
Hi  <= '1';
Q   <= Tp;
--
U0:    FDCE_1  PORT MAP ( C=>I, CE=>Hi, CLR=>Tp,  D=>E,  Q=>Ta );
U1:    FDCE    PORT MAP ( C=>C, CE=>Hi, CLR=>Low, D=>Ta, Q=>Tp );
--
END         MacroCellRFE;
--
--
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.tuw.ALL;
USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
USE work.arch.aDefSize;
--
ENTITY      aFIFO       IS
--          ~~~~~
        GENERIC( Size:    INTEGER := aDefSize;
                 LowMark: INTEGER := 2;
                 HiMark:  INTEGER := 12 );
        PORT (
             C:      IN     STD_LOGIC;         -- Clock
             R:      IN     STD_LOGIC;         -- Reset
-- Flood side
             WE:     IN     STD_LOGIC;         -- Write Enable
             D:      IN     STD_LOGIC_VECTOR (Size-1 downto 0);  -- IN
-- Fullness
             Empty:  OUT    STD_LOGIC;         -- Empty
             Aempty: OUT    STD_LOGIC;         -- Almost Empty
             Afull:  OUT    STD_LOGIC;         -- Almost Full
             Full:   OUT    STD_LOGIC;         -- Full
-- Sink side
             RE:     IN     STD_LOGIC;         -- Read Enable
             Q:      OUT    STD_LOGIC_VECTOR (Size-1 downto 0)); -- OUT
END         aFIFO;
--
ARCHITECTURE LUTCellFF  OF aFIFO    IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~
SIGNAL       A       : STD_LOGIC_VECTOR( 3 downto 0 ); -- Sink Address
SIGNAL       WEint   : STD_LOGIC;
SIGNAL       REint   : STD_LOGIC;
SIGNAL       nEmpty  : STD_LOGIC;
SIGNAL       nAempty : STD_LOGIC;
SIGNAL       AfullO  : STD_LOGIC;
SIGNAL       FullO   : STD_LOGIC;
--
BEGIN
--
Empty   <= NOT nEmpty;
Aempty  <= NOT nAempty;
Afull   <= AfullO;
Full    <= FullO;
-- Flood
WEint <= WE AND NOT FullO;
--
G1: FOR I IN 0 TO Size-1 GENERATE
U1: SRL16E PORT MAP (
       D=>D(I), CE=>WEint, CLK=>C,
       A0=>A(0),A1=>A(1),A2=>A(2),A3=>A(3),
       Q=>Q(I) );
END GENERATE;
--
EmptyFull: PROCESS ( C, R, A, WE, nEmpty, WEint, RE, REint )
BEGIN
IF( C'event AND C='1' ) THEN
IF( R ='1' ) THEN
    nEmpty  <= '0';
    nAempty <= '0';
    AfullO  <= '0';
    FullO   <= '0';
    Reset(A);
ELSE
-- Emptyness
    IF( nEmpty = '0' ) THEN
        IF( WE = '1' ) THEN
            nEmpty <= '1';
        END IF;
    ELSE
        IF( RE = '1' AND WEint = '0' ) THEN
            IF( A = "0000" ) THEN
                nEmpty <= '0';
            END IF;
        END IF;
    END IF;
-- Fullness
    IF( FullO = '1' ) THEN
        IF( RE = '1' ) THEN
            FullO <= '0';
        END IF;
    ELSE
        IF( WEint = '1' AND RE = '0' ) THEN
            IF( A = "1110" ) THEN
                FullO <= '1';
            END IF;
        END IF;
    END IF;
-- Count
    IF( WEint = '1' ) THEN
        IF( REint = '0' ) THEN
            IF( nEmpty = '1' ) THEN
                Incr( A );
            END IF;
            IF( A > LowMark-1 ) THEN
                nAempty <= '1';
            ELSE
                nAempty <= '0';
            END IF;
            IF( A > HiMark-1 ) THEN
                AfullO  <= '1';
            ELSE
                AfullO  <= '0';
            END IF;
        END IF;
    ELSE
        IF( REint = '1' ) THEN
            IF( A /= 0 ) THEN
                Decr( A );
            END IF;
            IF( A < LowMark+1 ) THEN
                nAempty <= '0';
            ELSE
                nAempty <= '1';
            END IF;
            IF( A < HiMark+1 ) THEN
                AfullO  <= '0';
            ELSE
                AfullO  <= '1';
            END IF;
        END IF;
    END IF;
END IF;
END IF;
END PROCESS;
-- Sink
REint <= RE AND nEmpty;
END  LUTCellFF;
--
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.tuw.ALL;
USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
USE work.arch.aDefSize;
--
ENTITY      aFIFOn        IS
--          ~~~~~~
        GENERIC( Size:    INTEGER := aDefSize;
                 Depth:   INTEGER := 4;
                 LowMark: INTEGER := 2;
                 HiMark:  INTEGER := 14 );
        PORT (
             C:      IN     STD_LOGIC;         -- Clock
             R:      IN     STD_LOGIC;         -- Reset
-- Flood side
             WE:     IN     STD_LOGIC;         -- Write Enable
             D:      IN     STD_LOGIC_VECTOR (Size-1 downto 0);  -- IN
-- Fullness
             Empty:  OUT    STD_LOGIC;         -- Empty
             Aempty: OUT    STD_LOGIC;         -- Almost Empty
             Afull:  OUT    STD_LOGIC;         -- Almost Full
             Full:   OUT    STD_LOGIC;         -- Full
-- Sink side
             RE:     IN     STD_LOGIC;         -- Read Enable
             Q:      OUT    STD_LOGIC_VECTOR (Size-1 downto 0)); -- OUT
END         aFIFOn;
--
ARCHITECTURE LUTCascad  OF aFIFOn    IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~
SIGNAL  WEx  : STD_LOGIC_VECTOR( Depth-1 downto 0 );
SIGNAL  WEc  : STD_LOGIC_VECTOR( Depth-1 downto 0 );
SIGNAL   Ec  : STD_LOGIC_VECTOR( Depth-1 downto 0 );
SIGNAL  AEc  : STD_LOGIC_VECTOR( Depth-1 downto 0 );
SIGNAL  AFc  : STD_LOGIC_VECTOR( Depth-1 downto 0 );
SIGNAL   Fc  : STD_LOGIC_VECTOR( Depth-1 downto 0 );
SIGNAL  REc  : STD_LOGIC_VECTOR( Depth-1 downto 0 );
SIGNAL   Dc  : STD_LOGIC_VECTOR( Depth*Size-1 downto 0 );
SIGNAL   Qc  : STD_LOGIC_VECTOR( Depth*Size-1 downto 0 );
--
BEGIN
--
REc( Depth-1 ) <= RE;
Rec( Depth-2 downto 0 ) <= WEc( Depth-1 downto 1 );
--
WEx( 0       ) <= WE;
WEx( Depth-1 downto 1 ) <= NOT Ec( Depth-2 downto 0 );
--
Dc <= Qc((Depth-1)*Size-1 downto 0 )&D;
Q  <= Qc( Depth   *Size-1 downto (Depth-1)*Size);
--
Empty  <=  Ec( Depth-1 );
AEmpty <= AEc( Depth-1 );
Full   <=  Fc( 0 );
AFull  <= AFc( 0 );
--
G1: FOR I IN 0 TO Depth-1 GENERATE
--
WEc(I) <= WEx(I) AND NOT Fc(I);
--
U1: aFIFO GENERIC MAP(
-- --------------
     Size  => Size, LowMark => LowMark, HiMark => HiMark )
          PORT MAP (
     C     => C,     R => R, WE => WEc(I),
     D     => Dc((I+1)*Size-1 downto I*Size ),
     Empty => Ec(I), Aempty => AEc(I), Afull => AFc(I), Full => Fc(I),
     RE    => REc(I),
     Q     => Qc((I+1)*Size-1 downto I*Size ) );
END GENERATE;
--
END  LUTCascad;
--
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.tuw.ALL;
USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
USE work.arch.aDefSize;
--
ENTITY      aFIFO32       IS
--          ~~~~~~~
        GENERIC( Size:    INTEGER := aDefSize;
                 LowMark: INTEGER := 2;
                 HiMark:  INTEGER := 28 );
        PORT (
             C:      IN     STD_LOGIC;         -- Clock
             R:      IN     STD_LOGIC;         -- Reset
-- Flood side
             WE:     IN     STD_LOGIC;         -- Write Enable
             D:      IN     STD_LOGIC_VECTOR (Size-1 downto 0);  -- IN
-- Fullness
             Empty:  OUT    STD_LOGIC;         -- Empty
             Aempty: OUT    STD_LOGIC;         -- Almost Empty
             Afull:  OUT    STD_LOGIC;         -- Almost Full
             Full:   OUT    STD_LOGIC;         -- Full
-- Sink side
             RE:     IN     STD_LOGIC;         -- Read Enable
             Q:      OUT    STD_LOGIC_VECTOR (Size-1 downto 0)); -- OUT
END         aFIFO32;
--
ARCHITECTURE LUTCeFF32  OF aFIFO32    IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~
SIGNAL       A       : STD_LOGIC_VECTOR( 4 downto 0 ); -- Sink Address
SIGNAL       WEint   : STD_LOGIC;
SIGNAL       REint   : STD_LOGIC;
SIGNAL       nEmpty  : STD_LOGIC;
SIGNAL       nAempty : STD_LOGIC;
SIGNAL       AfullO  : STD_LOGIC;
SIGNAL       FullO   : STD_LOGIC;
--
BEGIN
--
Empty   <= NOT nEmpty;
Aempty  <= NOT nAempty;
Afull   <= AfullO;
Full    <= FullO;
-- Flood
WEint <= WE AND NOT FullO;
--
G1: FOR I IN 0 TO Size-1 GENERATE
	U1: SRLC32E GENERIC MAP (INIT=>x"00000000") PORT MAP (
		D=>D(I), CE=>WEint, CLK=>C,
		A=>A,
		Q=>Q(I) );
END GENERATE;
--
EmptyFull: PROCESS ( C, R, A, WE, nEmpty, WEint, RE, REint )
BEGIN
IF( C'event AND C='1' ) THEN
IF( R ='1' ) THEN
    nEmpty  <= '0';
    nAempty <= '0';
    AfullO  <= '0';
    FullO   <= '0';
    Reset(A);
ELSE
-- Emptyness
    IF( nEmpty = '0' ) THEN
        IF( WE = '1' ) THEN
            nEmpty <= '1';
        END IF;
    ELSE
        IF( RE = '1' AND WEint = '0' ) THEN
            IF( A = "00000" ) THEN
                nEmpty <= '0';
            END IF;
        END IF;
    END IF;
-- Fullness
    IF( FullO = '1' ) THEN
        IF( RE = '1' ) THEN
            FullO <= '0';
        END IF;
    ELSE
        IF( WEint = '1' AND RE = '0' ) THEN
            IF( A = "11110" ) THEN
                FullO <= '1';
            END IF;
        END IF;
    END IF;
-- Count
    IF( WEint = '1' ) THEN
        IF( REint = '0' ) THEN
            IF( nEmpty = '1' ) THEN
                Incr( A );
            END IF;
            IF( A > LowMark-1 ) THEN
                nAempty <= '1';
            ELSE
                nAempty <= '0';
            END IF;
            IF( A > HiMark-1 ) THEN
                AfullO  <= '1';
            ELSE
                AfullO  <= '0';
            END IF;
        END IF;
    ELSE
        IF( REint = '1' ) THEN
            IF( A /= 0 ) THEN
                Decr( A );
            END IF;
            IF( A < LowMark+1 ) THEN
                nAempty <= '0';
            ELSE
                nAempty <= '1';
            END IF;
            IF( A < HiMark+1 ) THEN
                AfullO  <= '0';
            ELSE
                AfullO  <= '1';
            END IF;
        END IF;
    END IF;
END IF;
END IF;
END PROCESS;
-- Sink
REint <= RE AND nEmpty;
END  LUTCeFF32;
--
--
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
USE work.tuw.ALL;
USE work.arch.ALL;
--
ENTITY      SRL64E      IS
--          ~~~~~~
        PORT (
             D:      IN     STD_LOGIC;         -- Data IN
             CE:     IN     STD_LOGIC;         -- Clock enable
             CLK:    IN     STD_LOGIC;         -- Clock
--
             A0:     IN     STD_LOGIC;         -- Address lines
             A1:     IN     STD_LOGIC;
             A2:     IN     STD_LOGIC;
             A3:     IN     STD_LOGIC;
             A4:     IN     STD_LOGIC;
             A5:     IN     STD_LOGIC;
--
             Q:      OUT    STD_LOGIC);        -- OUT
END         SRL64E;
--
ARCHITECTURE LUTSRL64   OF SRL64E   IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~
SIGNAL       AA      : STD_LOGIC_VECTOR( 3 downto 0 );
SIGNAL       QA      : STD_LOGIC;
SIGNAL       AB      : STD_LOGIC_VECTOR( 3 downto 0 );
SIGNAL       QB      : STD_LOGIC;
SIGNAL       AC      : STD_LOGIC_VECTOR( 3 downto 0 );
SIGNAL       QC      : STD_LOGIC;
SIGNAL       AD      : STD_LOGIC_VECTOR( 3 downto 0 );
SIGNAL       QD      : STD_LOGIC;
SIGNAL       A5PA4   : STD_LOGIC_VECTOR( 1 downto 0 );
--
BEGIN
--
A5PA4 <= A5&A4;
--
U1: SRL16E PORT MAP (
       D=>D, CE=>CE, CLK=>CLK,
       A0=>AA(0),A1=>AA(1),A2=>AA(2),A3=>AA(3),
       Q=>QA );
U2: SRL16E PORT MAP (
       D=>QA, CE=>CE, CLK=>CLK,
       A0=>AB(0),A1=>AB(1),A2=>AB(2),A3=>AB(3),
       Q=>QB );
U3: SRL16E PORT MAP (
       D=>QB, CE=>CE, CLK=>CLK,
       A0=>AC(0),A1=>AC(1),A2=>AC(2),A3=>AC(3),
       Q=>QC );
U4: SRL16E PORT MAP (
       D=>QC, CE=>CE, CLK=>CLK,
       A0=>AD(0),A1=>AD(1),A2=>AD(2),A3=>AD(3),
       Q=>QD );
--
WITH  A5PA4 SELECT Q  <=
         QA WHEN "00",
         QB WHEN "01",
         QC WHEN "10",
         QD WHEN OTHERS;
WITH  A5PA4 SELECT AA <=
         A3&A2&A1&A0 WHEN "00",
         "1111"      WHEN OTHERS;
WITH  A5PA4 SELECT AB <=
         A3&A2&A1&A0 WHEN "01",
         "1111"      WHEN OTHERS;
WITH  A5PA4 SELECT AC <=
         A3&A2&A1&A0 WHEN "10",
         "1111"      WHEN OTHERS;
AD <= A3&A2&A1&A0;
--
END  LUTSRL64;
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.tuw.ALL;
USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
USE work.arch.aDefSize;
--
ENTITY      aFIFO64       IS
--          ~~~~~~~
        GENERIC( Size:    INTEGER := aDefSize;
                 LowMark: INTEGER := 2;
                 HiMark:  INTEGER := 60 );
        PORT (
             C:      IN     STD_LOGIC;         -- Clock
             R:      IN     STD_LOGIC;         -- Reset
-- Flood side
             WE:     IN     STD_LOGIC;         -- Write Enable
             D:      IN     STD_LOGIC_VECTOR (Size-1 downto 0);  -- IN
-- Fullness
             Empty:  OUT    STD_LOGIC;         -- Empty
             Aempty: OUT    STD_LOGIC;         -- Almost Empty
             Afull:  OUT    STD_LOGIC;         -- Almost Full
             Full:   OUT    STD_LOGIC;         -- Full
-- Sink side
             RE:     IN     STD_LOGIC;         -- Read Enable
             Q:      OUT    STD_LOGIC_VECTOR (Size-1 downto 0)); -- OUT
END         aFIFO64;
--
ARCHITECTURE LUTCeFF64  OF aFIFO64    IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~
SIGNAL       A       : STD_LOGIC_VECTOR( 5 downto 0 ); -- Sink Address
SIGNAL       WEint   : STD_LOGIC;
SIGNAL       REint   : STD_LOGIC;
SIGNAL       nEmpty  : STD_LOGIC;
SIGNAL       nAempty : STD_LOGIC;
SIGNAL       AfullO  : STD_LOGIC;
SIGNAL       FullO   : STD_LOGIC;
--
BEGIN
--
Empty   <= NOT nEmpty;
Aempty  <= NOT nAempty;
Afull   <= AfullO;
Full    <= FullO;
-- Flood
WEint <= WE AND NOT FullO;
--
G1: FOR I IN 0 TO Size-1 GENERATE
U1: SRL64E PORT MAP (
       D=>D(I), CE=>WEint, CLK=>C,
       A0=>A(0),A1=>A(1),A2=>A(2),A3=>A(3), A4=>A(4), A5=>A(5),
       Q=>Q(I) );
END GENERATE;
--
EmptyFull: PROCESS ( C, R, A, WE, nEmpty, WEint, RE, REint )
BEGIN
IF( C'event AND C='1' ) THEN
IF( R ='1' ) THEN
    nEmpty  <= '0';
    nAempty <= '0';
    AfullO  <= '0';
    FullO   <= '0';
    Reset(A);
ELSE
-- Emptyness
    IF( nEmpty = '0' ) THEN
        IF( WE = '1' ) THEN
            nEmpty <= '1';
        END IF;
    ELSE
        IF( RE = '1' AND WEint = '0' ) THEN
            IF( A = "000000" ) THEN
                nEmpty <= '0';
            END IF;
        END IF;
    END IF;
-- Fullness
    IF( FullO = '1' ) THEN
        IF( RE = '1' ) THEN
            FullO <= '0';
        END IF;
    ELSE
        IF( WEint = '1' AND RE = '0' ) THEN
            IF( A = "111110" ) THEN
                FullO <= '1';
            END IF;
        END IF;
    END IF;
-- Count
    IF( WEint = '1' ) THEN
        IF( REint = '0' ) THEN
            IF( nEmpty = '1' ) THEN
                Incr( A );
            END IF;
            IF( A > LowMark-1 ) THEN
                nAempty <= '1';
            ELSE
                nAempty <= '0';
            END IF;
            IF( A > HiMark-1 ) THEN
                AfullO  <= '1';
            ELSE
                AfullO  <= '0';
            END IF;
        END IF;
    ELSE
        IF( REint = '1' ) THEN
            IF( A /= 0 ) THEN
                Decr( A );
            END IF;
            IF( A < LowMark+1 ) THEN
                nAempty <= '0';
            ELSE
                nAempty <= '1';
            END IF;
            IF( A < HiMark+1 ) THEN
                AfullO  <= '0';
            ELSE
                AfullO  <= '1';
            END IF;
        END IF;
    END IF;
END IF;
END IF;
END PROCESS;
-- Sink
REint <= RE AND nEmpty;
END  LUTCeFF64;
-----
--
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;

LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
-- USE work.arch.aDefSize;
--
ENTITY      aFlop       IS
--          ~~~~~
        PORT (
             D:     IN     STD_LOGIC;   -- IN
             C:     IN     STD_LOGIC;   -- Clock
             CE:    IN     STD_LOGIC;   -- Clock Enable
--
             Q:     OUT    STD_LOGIC ); -- OUT
END         aFlop;
--
ARCHITECTURE MacroCellFl  OF aFlop      IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~
BEGIN
--
	U1: FDCPE GENERIC MAP (INIT=>'0') PORT MAP ( D=>D, C=>C, CE=>CE,CLR=>'0',PRE=>'0', Q=>Q );
	-- process (C, CE) is
	-- begin
		-- if(rising_edge(C))then
			-- if CE = '1' then
				-- Q <= D;
			-- end if;
		-- end if;
	-- end process;
--
END  MacroCellFl;

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
--
ENTITY      aFlopC       IS
--          ~~~~~
        PORT (
             D:     IN     STD_LOGIC;   -- IN
             C:     IN     STD_LOGIC;   -- Clock
             CE:    IN     STD_LOGIC;   -- Clock Enable
             CLR:   IN     STD_LOGIC;   -- Clear
--
             Q:     OUT    STD_LOGIC ); -- OUT
END         aFlopC;
--
ARCHITECTURE MacroCellFlC  OF aFlopC      IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~
BEGIN
--
	U1: FDCPE GENERIC MAP (INIT=>'0') PORT MAP ( D=>D, C=>C, CE=>CE,CLR=>CLR,PRE=>'0', Q=>Q );
--
END  MacroCellFlC;
--
--
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
USE work.arch.aDefSize;
--
ENTITY      aRSFlop       IS
--          ~~~~~~~
        PORT (
             R:     IN     STD_LOGIC;   -- Reset
             S:     IN     STD_LOGIC;   -- Set
             C:     IN     STD_LOGIC;   -- Clock
--
             Q:     OUT    STD_LOGIC ); -- OUT
END         aRSFlop;
--
ARCHITECTURE MacroCellRS  OF aRSFlop      IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~
SIGNAL   Stat,NewStat: STD_LOGIC;
--
BEGIN
--
	U1: FDRSE GENERIC MAP (INIT=>'0') PORT MAP ( D=>'0', R=>R, S=>S, C=>C, CE=>'0', Q=>Q );
--
END  MacroCellRS;
--
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
USE work.arch.aDefSize;
--
ENTITY      aRegister   IS
--          ~~~~~~~~~
        GENERIC( Size:   INTEGER := aDefSize );
        PORT (
             D:     IN     STD_LOGIC_VECTOR (Size-1 downto 0);  -- IN
             C:     IN     STD_LOGIC;   -- Clock
             CE:    IN     STD_LOGIC;   -- Clock Enable
--
             Q:     OUT    STD_LOGIC_VECTOR (Size-1 downto 0)); -- OUT
END         aRegister;
--
ARCHITECTURE MacroCellre  OF aRegister  IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~
BEGIN
--
G1: FOR J IN 0 TO Size-1 GENERATE
	U1: FDCPE GENERIC MAP (INIT=>'0') PORT MAP ( D=>D(J), C=>C, CE=>CE,CLR=>'0',PRE=>'0', Q=>Q(J) ); 

END GENERATE;
--
END  MacroCellre;
--
--
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
USE work.arch.aDefSize;
--
ENTITY      aShiftLeft  IS
--          ~~~~~~~~~~
        GENERIC( Size:   INTEGER := aDefSize );
        PORT (
             D:     IN     STD_LOGIC;   -- Serial Data IN
             C:     IN     STD_LOGIC;   -- Clock
             CE:    IN     STD_LOGIC;   -- Clock Enable
--
             Q:     OUT    STD_LOGIC_VECTOR (Size-1 downto 0)); -- OUT
END         aShiftLeft;
--
ARCHITECTURE MacroCellre  OF aShiftLeft IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~
SIGNAL Data,NewData: STD_LOGIC_VECTOR( Size-1 downto 0);
--
BEGIN
--
Q <= Data;
--
G1: FOR J IN 0 TO Size-1 GENERATE
U1: FDCE PORT MAP ( D=>NewData(J), C=>C, CE=>CE,CLR=>'0', Q=>Data(J) );
    END GENERATE;
--
Shift: PROCESS ( Data, D )
BEGIN
        NewData <= Data( Size-2 downto 0) & D;
END PROCESS;
--
END  MacroCellre;

--
--
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
USE work.arch.aDefSize;
--
ENTITY      aShiftRight IS
--          ~~~~~~~~~~~
        GENERIC( Size:   INTEGER := aDefSize );
        PORT (
             D:     IN     STD_LOGIC;   -- Serial Data IN
             C:     IN     STD_LOGIC;   -- Clock
             CE:    IN     STD_LOGIC;   -- Clock Enable
--
             Q:     OUT    STD_LOGIC_VECTOR (Size-1 downto 0)); -- OUT
END         aShiftRight;
--
ARCHITECTURE MacroCellre  OF aShiftRight IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~~
SIGNAL Data,NewData: STD_LOGIC_VECTOR( Size-1 downto 0);
--
BEGIN
--
Q <= Data;
--
G1: FOR J IN 0 TO Size-1 GENERATE
U1: FDCE PORT MAP ( D=>NewData(J), C=>C, CE=>CE,CLR=>'0', Q=>Data(J) );
    END GENERATE;
--
Shift: PROCESS ( Data, D )
BEGIN
        NewData <= D & Data( Size-1 downto 1);
END PROCESS;
--
END  MacroCellre;
--
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;

--
ENTITY      aMux16  IS
--          ~~~~~~~~~~~~~~~~
        PORT (
        D     : IN STD_LOGIC_VECTOR(15 downto 0);
        S     : IN STD_LOGIC_VECTOR( 3 downto 0);
		  E	  : IN STD_LOGIC;
        Q     : OUT STD_LOGIC
             );
END         aMux16;
--
ARCHITECTURE aMux16_ARCH OF aMux16 IS
SIGNAL	DATA_LSB: STD_LOGIC;
SIGNAL	DATA_MSB: STD_LOGIC;
BEGIN
--UpSel <= S(4) OR S(3);
--
SELECT_PROCESS_LSB: PROCESS (D, S)
BEGIN
--
	CASE S(2 downto 0) IS
		WHEN "000" => DATA_LSB <= D (0);
		WHEN "001" => DATA_LSB <= D (1);
		WHEN "010" => DATA_LSB <= D (2);
		WHEN "011" => DATA_LSB <= D (3);
		WHEN "100" => DATA_LSB <= D (4);
		WHEN "101" => DATA_LSB <= D (5);
		WHEN "110" => DATA_LSB <= D (6);
		WHEN OTHERS=> DATA_LSB <= D (7);
	END CASE;
END PROCESS;
--
SELECT_PROCESS_MSB: PROCESS (S, D)
BEGIN
	CASE S(2 downto 0) IS
		WHEN "000" => DATA_MSB <= D (8);
		WHEN "001" => DATA_MSB <= D (9);
		WHEN "010" => DATA_MSB <= D (10);
		WHEN "011" => DATA_MSB <= D (11);
		WHEN "100" => DATA_MSB <= D (12);
		WHEN "101" => DATA_MSB <= D (13);
		WHEN "110" => DATA_MSB <= D (14);
		WHEN OTHERS=> DATA_MSB <= D (15);
	END CASE;
END PROCESS;
--
-- MUXF7 instantiation
U_MUXF7: MUXF7
    PORT MAP (
    	I0 => DATA_LSB,
    	I1 => DATA_MSB,
    	S  => S(3),
    	O  => Q 
    );  

--Selector: PROCESS(S)
--BEGIN
--
--CASE S IS 
--	WHEN "00000" =>
--		Q <= D(0);
--	WHEN "00001" =>
--		Q <= D(1);
--	WHEN "00010" =>
--		Q <= D(2);
--	WHEN "00011" =>
--		Q <= D(3);	
--	WHEN "00100" =>
--		Q <= D(4);	
--	WHEN "00101" =>
--		Q <= D(5);	
--	WHEN "00110" =>
--		Q <= D(6);	
--	WHEN "00111" =>
--		Q <= D(7);	
--	WHEN "01001" =>
--		Q <= D(9);	
--	WHEN "01010" =>
--		Q <= D(10);	
--	WHEN "01011" =>
--		Q <= D(11);	
--	WHEN "01100" =>
--		Q <= D(12);	
--	WHEN "01101" =>
--		Q <= D(13);	
--	WHEN "01110" =>
--		Q <= D(14);	
--	WHEN "01111" =>
--		Q <= D(15);	
--	WHEN OTHERS =>
--		Q <= D(8);
--END CASE;
--END PROCESS;

END aMux16_arch; 
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;

--
ENTITY      aMux32  IS
--          ~~~~~~~~~~~~~~~~
        PORT (
        D     : IN STD_LOGIC_VECTOR(31 downto 0);
        S     : IN STD_LOGIC_VECTOR( 4 downto 0);
		  E	  : IN STD_LOGIC;
        Q     : OUT STD_LOGIC
             );
END         aMux32;
--
ARCHITECTURE aMux32_ARCH OF aMux32 IS
SIGNAL	DATA_LSB0, DATA_LSB1: STD_LOGIC;
SIGNAL	DATA_MSB0, DATA_MSB1: STD_LOGIC;
SIGNAL	Q0, Q1: STD_LOGIC;
BEGIN
--
SELECT_PROCESS_LSB0: PROCESS (D, S)
BEGIN
--
	CASE S(2 downto 0) IS
		WHEN "000" => DATA_LSB0 <= D (0);
		WHEN "001" => DATA_LSB0 <= D (1);
		WHEN "010" => DATA_LSB0 <= D (2);
		WHEN "011" => DATA_LSB0 <= D (3);
		WHEN "100" => DATA_LSB0 <= D (4);
		WHEN "101" => DATA_LSB0 <= D (5);
		WHEN "110" => DATA_LSB0 <= D (6);
		WHEN OTHERS=> DATA_LSB0 <= D (7);
	END CASE;
END PROCESS;
--
SELECT_PROCESS_MSB0: PROCESS (S, D)
BEGIN
	CASE S(2 downto 0) IS
		WHEN "000" => DATA_MSB0 <= D (8);
		WHEN "001" => DATA_MSB0 <= D (9);
		WHEN "010" => DATA_MSB0 <= D (10);
		WHEN "011" => DATA_MSB0 <= D (11);
		WHEN "100" => DATA_MSB0 <= D (12);
		WHEN "101" => DATA_MSB0 <= D (13);
		WHEN "110" => DATA_MSB0 <= D (14);
		WHEN OTHERS=> DATA_MSB0 <= D (15);
	END CASE;
END PROCESS;
--
-- MUXF7 instantiation
U0_MUXF7: MUXF7
    PORT MAP (
    	I0 => DATA_LSB0,
    	I1 => DATA_MSB0,
    	S  => S(3),
    	O  => Q0
    );  
--
----
--
SELECT_PROCESS_LSB1: PROCESS (D, S)
BEGIN
--
	CASE S(2 downto 0) IS
		WHEN "000" => DATA_LSB1 <= D (16);
		WHEN "001" => DATA_LSB1 <= D (17);
		WHEN "010" => DATA_LSB1 <= D (18);
		WHEN "011" => DATA_LSB1 <= D (19);
		WHEN "100" => DATA_LSB1 <= D (20);
		WHEN "101" => DATA_LSB1 <= D (21);
		WHEN "110" => DATA_LSB1 <= D (22);
		WHEN OTHERS=> DATA_LSB1 <= D (23);
	END CASE;
END PROCESS;
--
SELECT_PROCESS_MSB1: PROCESS (S, D)
BEGIN
	CASE S(2 downto 0) IS
		WHEN "000" => DATA_MSB1 <= D (24);
		WHEN "001" => DATA_MSB1 <= D (25);
		WHEN "010" => DATA_MSB1 <= D (26);
		WHEN "011" => DATA_MSB1 <= D (27);
		WHEN "100" => DATA_MSB1 <= D (28);
		WHEN "101" => DATA_MSB1 <= D (29);
		WHEN "110" => DATA_MSB1 <= D (30);
		WHEN OTHERS=> DATA_MSB1 <= D (31);
	END CASE;
END PROCESS;
--
-- MUXF7 instantiation
U1_MUXF7: MUXF7
    PORT MAP (
    	I0 => DATA_LSB1,
    	I1 => DATA_MSB1,
    	S  => S(3),
    	O  => Q1 
    );
-- Final Stage
U_MUXF8: MUXF8
    PORT MAP (
    	I0 => Q0,
    	I1 => Q1,
    	S  => S(4),
    	O  => Q 
    );
--	 
END aMux32_arch; 
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.tuw.ALL;
USE work.arch.ALL;
LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;

--
ENTITY      aPipeBack       IS
--          ~~~~~~~~~
        GENERIC( Size:   INTEGER := aDefSize );
        PORT (
             C:     IN     STD_LOGIC;                          -- Clock
             CE:    IN     STD_LOGIC;                          -- Enable
             Q:     OUT    STD_LOGIC_VECTOR (Size-1 downto 0); -- Output
             I:     IN     STD_LOGIC_VECTOR (Size-1 downto 0); -- Input
             CEO:   OUT    STD_LOGIC                           -- Enable
             );
END         aPipeBack;
--
ARCHITECTURE LUTCellPPB    OF aPipeBack    IS
--           ~~~~~~~~~~~~~~~~~~~~~~~~~~
SIGNAL       Read:  STD_LOGIC;
SIGNAL       Write: STD_LOGIC;
SIGNAL       Empty: STD_LOGIC;
SIGNAL       A0:    STD_LOGIC;
SIGNAL       Low,Hi: STD_LOGIC;
--
BEGIN
--
Low  <= '0';
Hi   <= '1';
--
Read <= CE;
CEO  <= Write;
A0   <= NOT Empty;
--
G0: FOR J IN 0 TO Size-1 GENERATE
U1: SRL16E PORT MAP (
       D=>I(J), CE=>Write, CLK=>C,
       A0=>A0,A1=>Low,A2=>Low,A3=>Low,
       Q=>Q(J) );
    END GENERATE;
-- --------------
Exhcange: PROCESS( C, Read, Write, Empty )
-- --------------
BEGIN
IF( C'event AND C = '1' ) THEN
    IF( Write = '1' ) THEN           -- Write to FIFO
        IF( Read = '0' ) THEN        -- Write came IN clear
            Write <= '0';
            Empty <= '0';            -- Has Data
        END IF;
    ELSE
        IF( Read = '1' ) THEN        -- Read came IN clear
            Write <= '1';            -- Keep it full
            Empty <= '1';            -- No further data
        END IF;
    END IF;
END IF;
END PROCESS;
--
END  LUTCellPPB;
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.tuw.ALL;
USE work.arch.aDefSize; --ALL;

LIBRARY UNISIM;
USE UNISIM.VCOMPONENTS.ALL;
--
ENTITY aRAM   IS
--     ~~~~~~
GENERIC( Size: INTEGER := aDefSize );
PORT (
     D     : IN  STD_LOGIC_VECTOR( Size-1 downto 0 ); -- Data IN
     WE    : IN  STD_LOGIC;       -- Write enable
     WCLK  : IN  STD_LOGIC;       -- Clock
     A     : IN  STD_LOGIC_VECTOR ( 3 downto 0);      -- Write Address
--
     RA    : IN  STD_LOGIC_VECTOR ( 3 downto 0);      -- Read Address
     DO    : OUT STD_LOGIC_VECTOR( Size-1 downto 0 )  -- Data OUT
     );
END aRAM;
--
ARCHITECTURE LUTRAM33 OF aRAM IS
--           =================
BEGIN
--
G1: FOR I IN 0 TO Size-1 GENERATE
--
U1: RAM16X1D    PORT    MAP(
-- -----------
                              D     => D(I),          -- Write data
                              WE    => WE,            -- Write enable
                              WCLK  => WCLK,          -- Clock
                              A0    => A(0),          -- Write Address
                              A1    => A(1),          -- Write Address
                              A2    => A(2),          -- Write Address
                              A3    => A(3),          -- Write Address
                              DPRA0 => RA(0),         -- Read address
                              DPRA1 => RA(1),         -- Read address
                              DPRA2 => RA(2),         -- Read address
                              DPRA3 => RA(3),         -- Read address
                              DPO   => DO(I) );       -- Data OUT
END GENERATE;
END LUTRAM33;
----
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_UNSIGNED.ALL;
USE work.tuw.ALL;
USE work.arch.ALL;
--
ENTITY aRAMx2 IS
--     ~~~~~~
GENERIC( Size: INTEGER := aDefSize );
PORT (
     D     : IN  STD_LOGIC_VECTOR( Size-1 downto 0 ); -- Data IN
     WE    : IN  STD_LOGIC;       -- Write enable
     WCLK  : IN  STD_LOGIC;       -- Clock
     A     : IN  STD_LOGIC_VECTOR ( 4 downto 0);      -- Write Address
--
     RA    : IN  STD_LOGIC_VECTOR ( 4 downto 0);      -- Read Address
     DO    : OUT STD_LOGIC_VECTOR( Size-1 downto 0 )  -- Data OUT
     );
END aRAMx2;
--
ARCHITECTURE LUTRAM33x2 OF aRAMx2 IS
--           ====================
   SIGNAL   Wr1,Wr2     : STD_LOGIC;
   SIGNAL   Dout1,Dout2 : STD_LOGIC_VECTOR( Size-1 downto 0);
--
BEGIN
--
Wr1 <= WE AND NOT A(4);
Wr2 <= WE AND     A(4);
--
U1: aRAM        GENERIC MAP(  Size  => Size )
-- -----------
                PORT    MAP(  D     => D,               -- Write data
                              WE    => Wr1,             -- Write enable
                              WCLK  => WCLK,            -- Clock
                              A     => A(3 downto 0),   -- Write Address
                              RA    => RA(3 downto 0),  -- Read address
                              DO    => Dout1  );        -- Data OUT
--
U2: aRAM        GENERIC MAP(  Size  => Size )
-- -----------
                PORT    MAP(  D     => D,               -- Write data
                              WE    => Wr2,             -- Write enable
                              WCLK  => WCLK,            -- Clock
                              A     => A(3 downto 0),   -- Write Address
                              RA    => RA(3 downto 0),  -- Read address
                              DO    => Dout2  );        -- Data OUT
WITH RA(4) SELECT DO <=  Dout1 WHEN '0',
                         Dout2 WHEN OTHERS;
--
END LUTRAM33x2;

-- ******** END OF arch.vhd ***********
