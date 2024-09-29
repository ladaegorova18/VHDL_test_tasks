library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter_gate is
  port(
    clk, incr, decr, reset: in std_logic;
    count: out std_logic_vector (2 downto 0));
end entity counter_gate;

architecture rtl of counter_gate is
    signal q: unsigned (2 downto 0) := "000";
begin
  
  process(clk, incr, decr, reset)
  begin
  	if rising_edge(clk) then
      if (incr = '1' and decr = '0' and q < 4) then q <= q + "001";
      elsif (incr = '0' and decr = '1' and q > 0) then q <= q - "001";
      elsif (reset = '1') then q <= "000"; 
      end if;
    end if;
  end process;
    
  count <= std_logic_vector(q);
end rtl;