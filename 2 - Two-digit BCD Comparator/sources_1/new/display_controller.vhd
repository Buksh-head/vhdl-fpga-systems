library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display_controller is
    Port ( 
        bcd1 : in STD_LOGIC_VECTOR (7 downto 0);
        bcd2 : in STD_LOGIC_VECTOR (7 downto 0);
        match_type : in STD_LOGIC_VECTOR (1 downto 0);
        digit_matches : in STD_LOGIC_VECTOR (1 downto 0);
        bcd1_valid : in STD_LOGIC_VECTOR (1 downto 0); -- validity for each digit of bcd1
        bcd2_valid : in STD_LOGIC_VECTOR (1 downto 0); -- validity for each digit of bcd2
        reset : in STD_LOGIC;  -- Add this line
        digit0_out : out STD_LOGIC_VECTOR (3 downto 0); -- rightmost digit
        digit1_out : out STD_LOGIC_VECTOR (3 downto 0);
        digit2_out : out STD_LOGIC_VECTOR (3 downto 0);
        digit3_out : out STD_LOGIC_VECTOR (3 downto 0); -- leftmost digit
        rgb_led : out STD_LOGIC_VECTOR (2 downto 0) -- RGB LED control
    );
end display_controller;

architecture Behavioral of display_controller is
    constant H_PATTERN : STD_LOGIC_VECTOR(3 downto 0) := "1111"; -- Use F to represent 'H'
    constant E_PATTERN : STD_LOGIC_VECTOR(3 downto 0) := "1110"; -- Use E for error
    constant BLANK_PATTERN : STD_LOGIC_VECTOR(3 downto 0) := "1010"; -- Use A for blank
begin
    process(bcd1, bcd2, match_type, digit_matches, bcd1_valid, bcd2_valid, reset)
    begin
        -- Check for reset first - highest priority
        -- Also check if both registers are still at reset state (all zeros)
        if reset = '1' or (bcd1 = "00000000" and bcd2 = "00000000") then
            -- Reset case or no input yet - blank all displays and set LED to red
            rgb_led <= "001"; -- Red
            digit3_out <= BLANK_PATTERN;
            digit2_out <= BLANK_PATTERN;
            digit1_out <= BLANK_PATTERN;
            digit0_out <= BLANK_PATTERN;
            
        else
            -- Default RGB LED to red
            rgb_led <= "001"; -- Red
            
            -- Check for invalid BCD inputs
            if bcd1_valid /= "11" or bcd2_valid /= "11" then
                -- Error case - show 'E' for invalid digits
                rgb_led <= "001"; -- Red
                -- Show E for invalid digits, actual digits for valid ones
                if bcd1_valid(1) = '0' then
                    digit3_out <= E_PATTERN;
                else
                    digit3_out <= bcd1(7 downto 4);
                end if;
                
                if bcd1_valid(0) = '0' then
                    digit2_out <= E_PATTERN;
                else
                    digit2_out <= bcd1(3 downto 0);
                end if;
                
                if bcd2_valid(1) = '0' then
                    digit1_out <= E_PATTERN;
                else
                    digit1_out <= bcd2(7 downto 4);
                end if;
                
                if bcd2_valid(0) = '0' then
                    digit0_out <= E_PATTERN;
                else
                    digit0_out <= bcd2(3 downto 0);
                end if;
                
            else
                -- Valid BCD inputs
                case match_type is
                    when "10" => -- Full match
                        rgb_led <= "010"; -- Green
                        digit3_out <= H_PATTERN;
                        digit2_out <= H_PATTERN;
                        digit1_out <= H_PATTERN;
                        digit0_out <= H_PATTERN;
                        
                    when "01" => -- Partial match
                        rgb_led <= "011"; -- Yellow (red + green)
                        -- Show H for matching digits, actual digits for non-matching
                        if digit_matches(1) = '1' then
                            digit3_out <= H_PATTERN; -- A matches X
                            digit1_out <= H_PATTERN;
                        else
                            digit3_out <= bcd1(7 downto 4); -- Show A
                            digit1_out <= bcd2(7 downto 4); -- Show X
                        end if;
                        
                        if digit_matches(0) = '1' then
                            digit2_out <= H_PATTERN; -- B matches Y
                            digit0_out <= H_PATTERN;
                        else
                            digit2_out <= bcd1(3 downto 0); -- Show B
                            digit0_out <= bcd2(3 downto 0); -- Show Y
                        end if;
                        
                    when others => -- No match
                        rgb_led <= "001"; -- Red
                        digit3_out <= bcd1(7 downto 4); -- A
                        digit2_out <= bcd1(3 downto 0); -- B
                        digit1_out <= bcd2(7 downto 4); -- X
                        digit0_out <= bcd2(3 downto 0); -- Y
                end case;
            end if;
        end if;
    end process;
end Behavioral;