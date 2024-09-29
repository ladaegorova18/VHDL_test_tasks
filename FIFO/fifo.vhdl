-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;

entity fifo is 
generic (
        DATA_WIDTH : integer := 8;
        FIFO_DEPTH : integer := 16
);

port(
  clk   : in std_logic;
  reset : in std_logic;
  
  wr_en : in std_logic;
  rd_en : in std_logic;
  
  din  : in std_logic_vector(DATA_WIDTH-1 downto 0);
  dout : out std_logic_vector(DATA_WIDTH-1 downto 0);
  
  empty : out std_logic;
  full  : out std_logic);

end entity fifo;

architecture rtl of fifo is
    type queue_type is array (0 to FIFO_DEPTH) of std_logic_vector(DATA_WIDTH-1 downto 0);
	signal queue : queue_type;
    
    begin
    	process(clk, reset) is
    	  variable cur_len  : integer range 0 to FIFO_DEPTH;
          variable pt_write : integer range 0 to FIFO_DEPTH - 1 := 0;
          variable pt_read  : integer range 0 to FIFO_DEPTH - 1 := 0;
		  
          begin
          if (reset = '1') then
             pt_write := 0;
             pt_read := 0;
             cur_len := 0;
             
          elsif (FIFO_DEPTH = 0) then
            ---throw error

          elsif (rising_edge(clk)) then
            if (wr_en = '1' and cur_len < FIFO_DEPTH) then
                queue(pt_write) <= din;
                pt_write := (pt_write + 1) mod FIFO_DEPTH;
                cur_len := cur_len + 1;
                report "Write";
            end if;

            if (rd_en = '1' and cur_len > 0) then
                dout <= queue(pt_read);
                pt_read := (pt_read + 1) mod FIFO_DEPTH;
                cur_len := cur_len - 1;
                report "Read";
            end if;
          end if;
          
          
          empty <= '1' when cur_len = 0 else '0';
          full  <= '1' when cur_len = FIFO_DEPTH else '0';
      	end process;

end rtl;