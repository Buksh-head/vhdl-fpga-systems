library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity two_adder_top is
  port (
    clk          : in  std_logic;
    reset        : in  std_logic;
    sw           : in  std_logic_vector(15 downto 0); -- 16-bit input switches
    ssd_cathodes : out std_logic_vector(6 downto 0);  -- 7-segment cathode outputs (A-G)
    ssd_anodes   : out std_logic_vector(3 downto 0);  -- 4 active anodes (AN0-AN3)
    ssd_anodes_unused : out STD_LOGIC_VECTOR (3 downto 0)
  );
end;

architecture Structural of two_adder_top is
  -- Input signals (2-digit BCD numbers)
  signal a0, a1, b0, b1     : std_logic_vector(3 downto 0);  -- Individual BCD digits
  signal a0_valid, a1_valid : std_logic;                     -- Validation for A
  signal b0_valid, b1_valid : std_logic;                     -- Validation for B
  signal all_valid          : std_logic;                     -- All inputs valid
  
  -- Output signals (3-digit BCD result)
  signal s0, s1, s2         : std_logic_vector(3 downto 0);  -- BCD result digits
  
  -- Display signals
  signal d0, d1, d2         : std_logic_vector(3 downto 0);  -- Digits to display
  signal cat_full           : std_logic_vector(7 downto 0);  -- Full cathode pattern
  signal sel2               : std_logic_vector(1 downto 0);  -- Selection for 3 displays
  signal cur_d              : std_logic_vector(3 downto 0);  -- Current digit
  signal count              : integer range 0 to 2;         -- Counter for 3 digits
begin
  -- Map switches to BCD digits
  a0 <= sw(3 downto 0);    -- A ones digit
  a1 <= sw(7 downto 4);    -- A tens digit  
  b0 <= sw(11 downto 8);   -- B ones digit
  b1 <= sw(15 downto 12);  -- B tens digit

  -- Validate all inputs
  U_VALIDATE_A0: entity work.bcd_validator port map (bcd_in => a0, valid => a0_valid);
  U_VALIDATE_A1: entity work.bcd_validator port map (bcd_in => a1, valid => a1_valid);
  U_VALIDATE_B0: entity work.bcd_validator port map (bcd_in => b0, valid => b0_valid);
  U_VALIDATE_B1: entity work.bcd_validator port map (bcd_in => b1, valid => b1_valid);
  
  all_valid <= a0_valid and a1_valid and b0_valid and b1_valid;

  -- 2-digit BCD adder
  U_BCD_2DIGIT: entity work.BCD_Adder_2digit
    port map (
      A1 => a1, A0 => a0,
      B1 => b1, B0 => b0,
      S2 => s2, S1 => s1, S0 => s0
    );

  -- Display assignment (show error if invalid inputs)
  d0 <= s0 when all_valid = '1' else "1110";  -- Ones or Error
  d1 <= s1 when all_valid = '1' else "1110";  -- Tens or Error  
  d2 <= s2 when all_valid = '1' else "1110";  -- Hundreds or Error

  -- Convert count to selection bits
  sel2 <= std_logic_vector(to_unsigned(count, 2));

  -- 3-digit counter (0, 1, 2)
  U_CNT: entity work.digit_counter 
    port map (
      clk => clk, 
      rst => reset, 
      count => count
    );

  -- 3-input mux for digit selection
  cur_d <= d0 when count = 0 else    -- AN0: ones
           d1 when count = 1 else    -- AN1: tens  
           d2;                       -- AN2: hundreds

  -- Anode decoder for 3 displays
  ssd_anodes <= "1110" when count = 0 else  -- AN0 active
                "1101" when count = 1 else  -- AN1 active
                "1011";                     -- AN2 active

  U_HEX: entity work.hex_to_ssd_const
    port map (
      hex_in => cur_d,
      ssd_cathode_out => cat_full
    );

  ssd_cathodes <= cat_full(7 downto 1);
  ssd_anodes_unused <= "1111";
end;