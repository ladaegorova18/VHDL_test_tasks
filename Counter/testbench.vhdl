library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity testbench is
-- empty
end testbench;

architecture tb of testbench is

-- DUT component
component counter_gate is
  port(
    clk, incr, decr, reset: in std_logic;
    count: out std_logic_vector (2 downto 0));
end component;

signal clk_in, incr_in, decr_in, reset_in: std_logic;
signal count_out: std_logic_vector(2 downto 0);

begin

  -- Connect DUT
  DUT: counter_gate port map(clk_in, incr_in, decr_in, reset_in, count_out);

  -- Clock generation
  process
  begin
    while true loop
      clk_in <= '0';
      wait for 5 ns;
      clk_in <= '1';
      wait for 5 ns;
    end loop;
  end process;

  -- Test process
  process
  begin
      -- Initial values
    incr_in <= '0';
    decr_in <= '0';
    reset_in <= '0';
    wait for 20 ns;

    -- Increment test 1
    incr_in <= '1';
    wait for 10 ns; -- Wait for one clock cycle
    incr_in <= '0';
    wait for 10 ns;
    assert(count_out = "001") report "Fail 1/0/0 (001)" severity error;

    -- Increment test 2
    incr_in <= '1';
    wait for 10 ns;
    incr_in <= '0';
    wait for 10 ns;
    assert(count_out = "010") report "Fail 1/0/0 (010)" severity error;

    -- Increment test 3
    incr_in <= '1';
    wait for 10 ns;
    incr_in <= '0';
    wait for 10 ns;
    assert(count_out = "011") report "Fail 1/0/0 (011)" severity error;

    -- Increment test 4
    incr_in <= '1';
    wait for 10 ns;
    incr_in <= '0';
    wait for 10 ns;
    assert(count_out = "100") report "Fail 1/0/0 (100)" severity error;

    -- Increment test 5 (should stay at 4)
    incr_in <= '1';
    wait for 10 ns;
    incr_in <= '0';
    wait for 10 ns;
    assert(count_out = "100") report "Fail 1/0/0 (100)" severity error;

    -- Decrement test 1
    decr_in <= '1';
    wait for 10 ns;
    decr_in <= '0';
    wait for 10 ns;
    assert(count_out = "011") report "Fail 0/1/0 (011)" severity error;

    -- Reset test
    reset_in <= '1';
    wait for 10 ns;
    reset_in <= '0';
    wait for 10 ns;
    assert(count_out = "000") report "Fail 0/0/1 (000)" severity error;

    -- Decrement test 2
    decr_in <= '1';
    wait for 10 ns;
    decr_in <= '0';
    wait for 10 ns;
    assert(count_out = "000") report "Fail 0/1/0 (000)" severity error;

    -- End of tests
    assert false report "Test done." severity note;
    wait;
  end process;
end tb;
