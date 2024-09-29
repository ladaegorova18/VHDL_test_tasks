LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY arbiter IS
    PORT (
        clk, reset, cmd : IN STD_LOGIC;
        req : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        gnt : OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
    );
END arbiter;

ARCHITECTURE rtl OF arbiter IS
    SIGNAL r1, r2, r3 : signed (2 DOWNTO 0) := "000";

BEGIN
    PROCESS (clk, reset, req)
        VARIABLE min : signed (2 DOWNTO 0) := "000";
        VARIABLE prior_req : INTEGER RANGE 0 TO 2 := 0;
    BEGIN
        IF (reset = '1') THEN
            gnt <= "000";
        ELSIF (rising_edge(clk)) THEN
            IF (cmd = '1' AND req /= "000") THEN
                IF 	  req = "001" THEN gnt <= "001";
                ELSIF req = "010" THEN gnt <= "010";
                ELSIF req = "100" THEN gnt <= "100";
                ELSE
                    min := "111";
                    IF req(2) = '1' AND r1 <= min THEN
                        min := r1;
                        prior_req := 0;
                    END IF;
                    IF req(1) = '1' AND r2 <= min THEN
                        min := r2;
                        prior_req := 1;
                    END IF;
                    IF req(0) = '1' AND r3 <= min THEN
                        min := r3; 
                        prior_req := 2;
                    END IF;

                    IF req(2) = '1' then
                    	if prior_req /= 0  THEN r1 <= r1 - 1;
                        else 					r1 <= r1 + 1;
                        end if;
                    END IF;
                    IF req(1) = '1'  then
                    	if prior_req /= 1 THEN  r2 <= r2 - 1;
                        else 				    r2 <= r2 + 1;
                        end if;
                    END IF;
                    IF req(0) = '1' then
                    	if prior_req /= 2 THEN  r3 <= r3 - 1; 
                        else 				    r3 <= r3 + 1;
                        end if;
                    END IF;
                    
                    CASE prior_req IS
                        WHEN 0 => gnt <= "100";
                        WHEN 1 => gnt <= "010";
                        WHEN 2 => gnt <= "001";
                        WHEN OTHERS => gnt <= "000";
                    END CASE;
                END IF;
                ELSE
                    gnt <= "000";
                END IF;

            END IF;
        END PROCESS;
END rtl;