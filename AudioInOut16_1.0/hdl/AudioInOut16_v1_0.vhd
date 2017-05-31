library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AudioInOut16_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 6
	);
	port (
		-- Users to add ports here
		
		-- PS Side
        IRQ      : out   STD_LOGIC;
        
        -- Board Side
        CLK_100  : in    STD_LOGIC;
        AC_ADR0  : out   STD_LOGIC;
        AC_ADR1  : out   STD_LOGIC;
        AC_GPIO0 : out   STD_LOGIC;  -- I2S MISO
        AC_GPIO1 : in    STD_LOGIC;  -- I2S MOSI
        AC_GPIO2 : in    STD_LOGIC;  -- I2S_bclk
        AC_GPIO3 : in    STD_LOGIC;  -- I2S_LR
        AC_MCLK  : out   STD_LOGIC;
        AC_SCK   : out   STD_LOGIC;
        AC_SDA   : inout STD_LOGIC;
        
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic
	);
end AudioInOut16_v1_0;

architecture arch_imp of AudioInOut16_v1_0 is

    component adau1761_izedboard is
    Port ( clk_48    : in  STD_LOGIC;
           AC_ADR0   : out   STD_LOGIC;
           AC_ADR1   : out   STD_LOGIC;
           AC_GPIO0  : out   STD_LOGIC;  -- I2S MISO
           AC_GPIO1  : in    STD_LOGIC;  -- I2S MOSI
           AC_GPIO2  : in    STD_LOGIC;  -- I2S_bclk
           AC_GPIO3  : in    STD_LOGIC;  -- I2S_LR
           AC_MCLK   : out   STD_LOGIC;
           AC_SCK    : out   STD_LOGIC;
           AC_SDA    : inout STD_LOGIC;
           hphone_l  : in    std_logic_vector(23 downto 0);
           hphone_r  : in    std_logic_vector(23 downto 0);
           line_in_l : out   std_logic_vector(23 downto 0);
           line_in_r : out   std_logic_vector(23 downto 0);
           new_sample: out   std_logic
        );
    end component;

	-- component declaration
	component AudioInOut16_v1_0_S00_AXI is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 6
		);
		port (
        writeReg        : out std_logic;
        wValue          : out std_logic_vector(31 downto 0);
        wAdr            : out std_logic_vector( 5 downto 2);
        wLane           : out std_logic_vector( 3 downto 0);
        
        readReg         : out std_logic;
        rAdr            : out std_logic_vector( 5 downto 2);
        rValue          : in  std_logic_vector(31 downto 0);
		
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component AudioInOut16_v1_0_S00_AXI;
	
    component DualClockFIFO is
        generic (
            DATA_WIDTH :integer := 8;
            ADDR_WIDTH :integer := 4
        );
        port (
            -- Reading port.
            Data_out    :out std_logic_vector (DATA_WIDTH-1 downto 0);
            Empty_out   :out std_logic;
            ReadEn_in   :in  std_logic;
            RClk        :in  std_logic;
            -- Writing port.
            Data_in     :in  std_logic_vector (DATA_WIDTH-1 downto 0);
            Full_out    :out std_logic;
            WriteEn_in  :in  std_logic;
            WClk        :in  std_logic;
         
            Clear_in    :in  std_logic
        );
    end component;

    component clocking
    port(
       CLK_100           : in     std_logic;
       CLK_48            : out    std_logic;
       RESET             : in     std_logic;
       LOCKED            : out    std_logic
       );
    end component;

    signal clk_48     : std_logic;
	
	
	-- Register Adressing
    signal writeReg        : std_logic;
    signal wValue          : std_logic_vector(31 downto 0);
    signal wAdr            : std_logic_vector( 5 downto 2);
    signal wLane           : std_logic_vector( 3 downto 0);
    signal readReg         : std_logic;
    signal rAdr            : std_logic_vector( 5 downto 2);
    signal rValue          : std_logic_vector(31 downto 0);
    
    -- Physical Registers
    signal resetDACFifo    : std_logic;
    signal resetADCFifo    : std_logic;
    
    -- FIFO, Clock Connection
    signal needNewSample : std_logic;
    signal leftOut24Bit,rightOut24Bit,leftIn24Bit,rightIn24Bit : std_logic_vector(23 downto 0);
    signal dacFIFOData, adcFIFOData,adcFIFOReadData  : std_logic_vector(31 downto 0);
    signal dacFIFOEmpty, dacFIFOFull : std_logic;
    signal adcFIFOEmpty, adcFIFOFull : std_logic;

    signal readADCFifo, writeDACFifo : std_logic;

begin

    -- Instantiation of Axi Bus Interface S00_AXI
    AudioInOut16_v1_0_S00_AXI_inst : AudioInOut16_v1_0_S00_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
        -- Register Management Port
        writeReg        => writeReg,
        wValue          => wValue,
        wAdr            => wAdr,
        wLane           => wLane,
        
        readReg         => readReg,
        rAdr            => rAdr,
        rValue          => rValue,
        
        -- AXI Slave Port
        S_AXI_ACLK	    => s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready
	);

	-- Add user logic here
	
	-- 100 Mhz -> 48 Mhz clock conversion.
    i_clocking : clocking port map (
      CLK_100 => CLK_100,
      CLK_48  => CLK_48,
      RESET   => '0',
      LOCKED  => open
    );
	
    -- Register Read Process (NOT CLOCKED !)
    process(readReg,rAdr,
            adcFIFOEmpty,dacFIFOEmpty,adcFIFOFull,dacFIFOFull,adcFIFOReadData)
    begin
        rValue <= (others => '0');
        if (readReg='1') then
            case rAdr is
            when "0000" =>  
                rValue(2) <= adcFIFOEmpty;
                rValue(3) <= dacFIFOEmpty;
                rValue(4) <= adcFIFOFull;
                rValue(5) <= dacFIFOFull;
            when others =>
                -- See problem (1)
                rValue    <= adcFIFOReadData;
            end case;
        end if;
    end process;
    
    
    -- Register Write Process
    process(s00_axi_aclk,s00_axi_aresetn,wAdr,writeReg,wValue)
    begin
        if rising_edge(s00_axi_aclk) then
            resetDACFifo <= '0';
            resetADCFifo <= '0';
            
            if s00_axi_aresetn = '0' then
                -- Reset
                resetDACFifo <= '1';
                resetADCFifo <= '1';
            else
                if (writeReg = '1') then
                    case wAdr is
                    when "0000" =>  
                        resetADCFifo <= wValue(0);                
                        resetDACFifo <= wValue(1);
                    when others =>
                    end case;
                end if;
            end if;
        end if;
    end process;
    
    writeDACFifo <= '1' when (writeReg = '1' and wAdr="0001") else '0';
    readADCFifo  <= '1' when (readReg  = '1' and rAdr="0010") else '0';
    
    FIFO_OutDAC : DualClockFIFO
    generic map (
        DATA_WIDTH => 32,
        ADDR_WIDTH => 11
    )
    port map (
        -- Reading port.
        Data_out    => dacFIFOData,
        Empty_out   => dacFIFOEmpty,
        ReadEn_in   => needNewSample,
        RClk        => clk_48,
        
        -- Writing port.
        Data_in     => wValue,
        Full_out    => dacFIFOFull,
        WriteEn_in  => writeDACFifo,
        WClk        => s00_axi_aclk,
     
        Clear_in    => resetDACFifo
    );

    -- PROBLEM (1) : Output of ADC FIFO is LATE when read bit is set (1 cycle latency)
    -- RREADY bit in AXI Bus need to wait.
    
    FIFO_InADC : DualClockFIFO
    generic map (
        DATA_WIDTH => 32,
        ADDR_WIDTH => 11
    )
    port map (
        -- Reading port.
        Data_out    => adcFIFOReadData,
        Empty_out   => adcFIFOEmpty,
        ReadEn_in   => readADCFifo,
        RClk        => s00_axi_aclk,
        
        -- Writing port.
        Data_in     => adcFIFOData,
        Full_out    => adcFIFOFull,
        WriteEn_in  => needNewSample,
        WClk        => clk_48,
     
        Clear_in    => resetADCFifo
    );
    
    -- 16 bit to 24 bit conversion OUT
    leftOut24Bit  <= dacFIFOData(31 downto 16) & dacFIFOData(31 downto 24);
    rightOut24Bit <= dacFIFOData(15 downto  0) & dacFIFOData(15 downto  8);

    -- 24 bit to 16 bit conversion IN
    adcFIFOData(31 downto 16) <=  leftIn24Bit(23 downto 8);
    adcFIFOData(15 downto  0) <= rightIn24Bit(23 downto 8);
    
    adau1761_izedboard_inst : adau1761_izedboard
    Port map ( 
       clk_48    => clk_48,
       AC_ADR0   => AC_ADR0,
       AC_ADR1   => AC_ADR1,
       AC_GPIO0  => AC_GPIO0,
       AC_GPIO1  => AC_GPIO1,
       AC_GPIO2  => AC_GPIO2,
       AC_GPIO3  => AC_GPIO3,
       AC_MCLK   => AC_MCLK,
       AC_SCK    => AC_SCK,
       AC_SDA    => AC_SDA,
       hphone_l  => leftOut24Bit,
       hphone_r  => rightOut24Bit,
       line_in_l => leftIn24Bit,
       line_in_r => rightIn24Bit,
       new_sample=> needNewSample
    );

    -- IRQ Generation.
    -- TODO (2), make sure we generate ONE pulse ? Assert until... ?
    IRQ <= '0';
    
	-- User logic ends

end arch_imp;
