----------------------------------------
-- Function    : Code Gray counter.
-- Coder       : Alex Claros F.
-- Date        : 15/May/2005.
-- Translator  : Alexander H Pham (VHDL)
-- Found at http://www.asic-world.com/examples/vhdl/asyn_fifo.html
----------------------------------------
--library ieee;
--    use ieee.std_logic_1164.all;
--    use ieee.std_logic_unsigned.all;
--    use ieee.std_logic_arith.all;
    
--entity GrayCounter is
--    generic (
--        COUNTER_WIDTH :integer := 4
--    );
--    port (                                  --'Gray' code count output.
--        GrayCount_out :out std_logic_vector (COUNTER_WIDTH-1 downto 0);  
--        Enable_in     :in  std_logic;       -- Count enable.
--        Clear_in      :in  std_logic;       -- Count reset.
--        clk           :in  std_logic        -- Input clock
--    );
--end entity;

--architecture rtl of GrayCounter is
--    signal BinaryCount :std_logic_vector (COUNTER_WIDTH-1 downto 0);
--begin
--    process (clk) begin
--        if (rising_edge(clk)) then
--            if (Clear_in = '1') then
--                --Gray count begins @ '1' with
--                BinaryCount   <= conv_std_logic_vector(1, COUNTER_WIDTH);  
--                GrayCount_out <= (others=>'0');
--            -- first 'Enable_in'.
--            elsif (Enable_in = '1') then
--                BinaryCount   <= BinaryCount + 1;
--                GrayCount_out <= (BinaryCount(COUNTER_WIDTH-1) & 
--                                  BinaryCount(COUNTER_WIDTH-2 downto 0) xor 
--                                  BinaryCount(COUNTER_WIDTH-1 downto 1));
--            end if;
--        end if;
--    end process;    
--end architecture;


-- TODO : Code by Altera License, to check.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity GrayCounter is
    generic (
        COUNTER_WIDTH :integer := 4
    );
	port 
	(
		GrayCount_out : out std_logic_vector(COUNTER_WIDTH-1 downto 0);
		Enable_in  : in std_logic;
		Clear_in   : in std_logic;
		clk		   : in std_logic
	);
	
end entity;

-- Implementation:

-- There is an imaginary bit in the counter, at q(0), that resets to 1
-- (unlike the rest of the bits of the counter) and flips every clock cycle.
-- The decision of whether to flip any non-imaginary bit in the counter
-- depends solely on the bits below it, down to the imaginary bit.	It flips
-- only if all these bits, taken together, match the pattern 10* (a one
-- followed by any number of zeros).

-- Almost every non-imaginary bit has a component instance that sets the 
-- bit based on the values of the lower-order bits, as described above.
-- The rules have to differ slightly for the most significant bit or else 
-- the counter would saturate at it's highest value, 1000...0.

architecture rtl of GrayCounter is

	-- q contains all the values of the counter, plus the imaginary bit
	-- (values are shifted to make room for the imaginary bit at q(0))
	signal q  : std_logic_vector (COUNTER_WIDTH downto 0);
	
	-- no_ones_below(x) = 1 iff there are no 1's in q below q(x)
	signal no_ones_below  : std_logic_vector (COUNTER_WIDTH downto 0);
	
	-- q_msb is a modification to make the msb logic work
	signal q_msb : std_logic;

begin

	q_msb <= q(COUNTER_WIDTH-1) or q(COUNTER_WIDTH);
	
	process(clk, Clear_in, Enable_in, q, no_ones_below)
	begin
	
		if(Clear_in = '1') then
		
			-- Resetting involves setting the imaginary bit to 1
			q(0) <= '1';
			q(COUNTER_WIDTH downto 1) <= (others => '0');
		
		elsif(rising_edge(clk) and Enable_in='1') then
		
			-- Toggle the imaginary bit
			q(0) <= not q(0);
			
			for i in 1 to COUNTER_WIDTH loop
			
				-- Flip q(i) if lower bits are a 1 followed by all 0's
				q(i) <= q(i) xor (q(i-1) and no_ones_below(i-1));
			
			end loop;  -- i
			
			q(COUNTER_WIDTH) <= q(COUNTER_WIDTH) xor (q_msb and no_ones_below(COUNTER_WIDTH-1));
			
		end if;
		
	end process;
	
	-- There are never any 1's beneath the lowest bit
	
	process(q, no_ones_below,Clear_in)
	begin
	   if (Clear_in = '1') then
	   		no_ones_below <= (others => '0');
	   else
        	no_ones_below(0) <= '1';

            for j in 1 to COUNTER_WIDTH loop
                no_ones_below(j) <= no_ones_below(j-1) and not q(j-1);
            end loop;
	  end if;
	end process;
	
	-- Copy over everything but the imaginary bit
	GrayCount_out <= q(COUNTER_WIDTH downto 1);
	
end rtl;
