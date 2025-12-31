library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hex_to_ssd_const is
    Port ( hex_in : in STD_LOGIC_VECTOR (3 downto 0);
           ssd_cathode_out : out STD_LOGIC_VECTOR (7 downto 0));
end hex_to_ssd_const;

architecture Behavioral of hex_to_ssd_const is
    -- Define cathode output type
    subtype cathode_out_t is std_logic_vector(7 downto 0);
    
    -- Define constants for each digit
    -- Nexys A7 uses ACTIVE LOW segments with order: DP,G,F,E,D,C,B,A
    -- For cathodes[6:0] = {A,B,C,D,E,F,G} (active LOW, DP not used)
    constant ZERO  : cathode_out_t := "10000001"; -- 0: ABCDEF-
    constant ONE   : cathode_out_t := "11001111"; -- 1: -BC----
    constant TWO   : cathode_out_t := "10010010"; -- 2: AB-DE-G
    constant THREE : cathode_out_t := "10000110"; -- 3: ABCD--G
    constant FOUR  : cathode_out_t := "11001100"; -- 4: -BC--FG
    constant FIVE  : cathode_out_t := "10100100"; -- 5: A-CD-FG
    constant SIX   : cathode_out_t := "10100000"; -- 6: A-CDEFG
    constant SEVEN : cathode_out_t := "10001111"; -- 7: ABC----
    constant EIGHT : cathode_out_t := "10000000"; -- 8: ABCDEFG
    constant NINE  : cathode_out_t := "10000100"; -- 9: ABCD-FG
    constant A_VAL : cathode_out_t := "10001000"; -- A: ABC-EFG
    constant B_VAL : cathode_out_t := "11100000"; -- b: --CDEFG
    constant C_VAL : cathode_out_t := "10110001"; -- C: A--DEF-
    constant D_VAL : cathode_out_t := "11000010"; -- d: -BCD-FG
    constant E_VAL : cathode_out_t := "10110000"; -- E: A--DEFG
    constant F_VAL : cathode_out_t := "10111000"; -- F: A--EFG-
    constant BLANK : cathode_out_t := "11111111"; -- Blank: -------

begin
    -- Map 4-bit input to 7-segment output
    process(hex_in)
    begin
        case hex_in is
            when "0000" => ssd_cathode_out <= ZERO;   -- 0
            when "0001" => ssd_cathode_out <= ONE;    -- 1
            when "0010" => ssd_cathode_out <= TWO;    -- 2
            when "0011" => ssd_cathode_out <= THREE;  -- 3
            when "0100" => ssd_cathode_out <= FOUR;   -- 4
            when "0101" => ssd_cathode_out <= FIVE;   -- 5
            when "0110" => ssd_cathode_out <= SIX;    -- 6
            when "0111" => ssd_cathode_out <= SEVEN;  -- 7
            when "1000" => ssd_cathode_out <= EIGHT;  -- 8
            when "1001" => ssd_cathode_out <= NINE;   -- 9
            when "1010" => ssd_cathode_out <= A_VAL;  -- A
            when "1011" => ssd_cathode_out <= B_VAL;  -- b
            when "1100" => ssd_cathode_out <= C_VAL;  -- C
            when "1101" => ssd_cathode_out <= D_VAL;  -- d
            when "1110" => ssd_cathode_out <= E_VAL;  -- E
            when "1111" => ssd_cathode_out <= F_VAL;  -- F
            when others => ssd_cathode_out <= BLANK;  -- Should never happen
        end case;
    end process;

end Behavioral;