-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_arb is
end entity tb_arb;

architecture bhv of tb_arb is
    signal reset, cmd : std_logic;
    signal req, gnt : std_logic_vector (2 downto 0) := "000";
    signal clk : std_logic := '0';
    signal req_temp : std_logic_vector(2 downto 0) := "001";

    component arbiter
        port(
            clk, reset, cmd     : in  std_logic;
            req   				: in  std_logic_vector (2 downto 0);
            gnt   				: out std_logic_vector (2 downto 0)
        );
    end component arbiter;

    begin 
        dut : arbiter
            port map(
                clk   => clk,
                reset => reset,
                cmd   => cmd,
                req   => req,
                gnt   => gnt
            );
        reset <= '1', '0' after 10 ns;

        clk <= not clk after 5 ns;

        process
        begin
--             report "'req' " & to_hstring(req) & " " & to_hstring(req_temp);
            
             if req_temp /= "111" then
                req_temp <= std_logic_vector(unsigned(req_temp) + 1);
             else
                req_temp <= "001";
             end if;
            wait for 10 ns;
        end process;
        
        main : process is
        begin
            cmd <= '0';
            
            wait for 20 ns;
            cmd <= '1';

            wait for 10 ns;
            cmd <= '0';
            
            wait for 10 ns;
            cmd <= '1';
        
            wait for 10 ns;
            cmd <= '0';

            wait for 10 ns;
            cmd <= '1';

            wait for 30 ns;
        end process main;

        process(cmd)
        begin
            if cmd = '1' then
                req <= req_temp;
            else
                req <= "000";
            end if;
        end process;        
                
end bhv;