-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;

entity testbench is
end testbench;

architecture tb of testbench is
    constant DATA_WIDTH : integer := 8;
  	constant FIFO_DEPTH : integer := 16;
    
    component fifo is 
        port(
            clk   : in std_logic;
            reset : in std_logic;
            
            wr_en : in std_logic;
            rd_en : in std_logic;
            
            din  : in std_logic_vector(DATA_WIDTH-1 downto 0);
            dout : out std_logic_vector(DATA_WIDTH-1 downto 0);
            
            empty : out std_logic;
  			full  : out std_logic);
    end component;

    signal clk_in, reset_in, wr_en_in, rd_en_in, empty, full : std_logic;
    signal din, dout  : std_logic_vector(DATA_WIDTH-1 downto 0);
    
    begin
    -- Connect DUT
    DUT: fifo port map(clk_in, reset_in, wr_en_in, rd_en_in, din, dout, empty, full);
    
    -- Clock generation
    process
    begin
      while true loop
      clk_in <= '1';
      wait for 5 ns;
      clk_in <= '0';
      wait for 5 ns;
      end loop;
    end process;

    process
    begin
      -- Initial reset
      reset_in <= '1';
      wait for 10 ns;
      
      reset_in <= '0';
      wr_en_in <= '0';
      rd_en_in <= '0';
      din      <= "00000000";
      wait for 20 ns;
      
      -- Test 0
      assert(empty = '1') report "Fail Test 0, current is " & to_string(empty) severity error;

      -- Test 1
      wr_en_in <= '1';
      din      <= "00100000";
      wait for 10 ns;
      
      wr_en_in <= '0';
      rd_en_in <= '1';
      wait for 10 ns;

      assert(dout = "00100000") report "Fail Test 1, current is " & to_string(dout) severity error;
      assert(empty = '0') report "Fail Test 1, current is " & to_string(empty) severity error;
      
      -- Test 2
      rd_en_in <= '0';
      wr_en_in <= '1';
      din      <= "00100000";
      wait for 10 ns;
      
      din      <= "00000001";
      wait for 10 ns;
      
      wr_en_in <= '0';
      rd_en_in <= '1';
      wait for 10 ns;

      assert(dout = "00100000") report "Fail Test 2, current is " & to_string(dout) severity error;
      
      -- Test 3
      rd_en_in <= '1';
      wr_en_in <= '0';
      wait for 10 ns;

      assert(dout = "00000001") report "Fail Test 3, current is " & to_string(dout) severity error;
    
    -- End of tests
    assert false report "Test done." severity note;
    wait;
    end process;

end tb;