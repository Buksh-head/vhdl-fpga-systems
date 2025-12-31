library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bcd_comparator is
    Port ( 
        bcd1 : in STD_LOGIC_VECTOR (7 downto 0);  -- First 2-digit BCD (AB)
        bcd2 : in STD_LOGIC_VECTOR (7 downto 0);  -- Second 2-digit BCD (XY)
        match_type : out STD_LOGIC_VECTOR (1 downto 0); -- 00=no match, 01=partial, 10=full
        digit_matches : out STD_LOGIC_VECTOR (1 downto 0) -- bit 1: high digit match, bit 0: low digit match
    );
end bcd_comparator;

architecture Behavioral of bcd_comparator is
    signal high_digit_match, low_digit_match : STD_LOGIC;
begin
    -- Compare high digits (A vs X)
    high_digit_match <= '1' when bcd1(7 downto 4) = bcd2(7 downto 4) else '0';
    
    -- Compare low digits (B vs Y)  
    low_digit_match <= '1' when bcd1(3 downto 0) = bcd2(3 downto 0) else '0';
    
    digit_matches <= high_digit_match & low_digit_match;
    
    -- Determine match type
    process(high_digit_match, low_digit_match)
    begin
        if high_digit_match = '1' and low_digit_match = '1' then
            match_type <= "10"; -- Full match
        elsif high_digit_match = '1' or low_digit_match = '1' then
            match_type <= "01"; -- Partial match
        else
            match_type <= "00"; -- No match
        end if;
    end process;
end Behavioral;