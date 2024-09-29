library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
  
entity FSM is
port(
	clk, incr, decr, reset : in std_logic;
    count : out std_logic_vector (2 downto 0));
end entity;
  
architecture sim of FSM is
  type t_State is (Zero, One, Two, Three, Four);
  signal State : t_State;
  
begin
  process(clk, State, incr, decr, reset)
  begin
  	if (reset = '1') then
    	State <= Zero;
    elsif rising_edge(clk) then
    	case State is
        	when Zero =>
            	if (incr = '1' and decr = '0') then State <= One;
                end if;
                
            when One =>
            	if (incr = '1' and decr = '0') then State <= Two;
            	elsif (incr = '0' and decr = '1') then State <= Zero;
            	end if;
            
            when Two =>
            	if (incr = '1' and decr = '0') then State <= Three;
            	elsif (incr = '0' and decr = '1') then State <= One;
                end if;
            
            when Three => 
            	if (incr = '1' and decr = '0') then State <= Four;
            	elsif (incr = '0' and decr = '1') then State <= Two;
            	end if;
                
            when Four =>
            	if (incr = '0' and decr = '1') then State <= Three;
        		end if;
        end case;
  end if;
  
  end process;
  
  process(State)
  begin
    case State is
      when Zero  => count <= "000";
      when One   => count <= "001";
      when Two   => count <= "010";
      when Three => count <= "011";
      when Four  => count <= "100";
    end case;
  end process;
    
  
end architecture;