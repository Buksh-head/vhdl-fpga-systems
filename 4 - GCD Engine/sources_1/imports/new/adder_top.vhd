library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_top is
  port (
    clk          : in  std_logic;
    reset        : in  std_logic;
    sw           : in  std_logic_vector(7 downto 0);  -- 8-bit input switches (A and B)
    ssd_cathodes : out std_logic_vector(6 downto 0);  -- 7-segment cathode outputs (A-G)
    ssd_anodes   : out std_logic_vector(3 downto 0);   -- 4 active anodes (AN0-AN3)
    ssd_anodes_unused : out STD_LOGIC_VECTOR (3 downto 0)
  );
end;

architecture Structural of adder_top is
  -- Internal signals
  signal a_raw, b_raw    : std_logic_vector(3 downto 0);  -- Raw switch inputs
  signal a, b            : std_logic_vector(3 downto 0);  -- Validated BCD digits A and B
  signal a_valid, b_valid : std_logic;                    -- Validation flags
  signal sum_bcd         : std_logic_vector(3 downto 0);  -- BCD corrected sum (ones digit)
  signal cout            : std_logic;                     -- Carry-out from BCD addition (tens digit)
  signal d0, d1          : std_logic_vector(3 downto 0);  -- d0=ones, d1=tens
  signal cat_full        : std_logic_vector(7 downto 0);  -- Full cathode pattern (A-G + DP)
  signal sel1            : std_logic;                     -- SSD selection signal
  signal cur_d           : std_logic_vector(3 downto 0);  -- Current digit to be displayed
  signal count           : integer range 0 to 1;         -- Counter for digit selection
begin
  -- Connect input switches to raw inputs
  a_raw <= sw(3 downto 0);  -- First 4 switches for digit A
  b_raw <= sw(7 downto 4);  -- Next 4 switches for digit B

  -- Validate input A using your bcd_validator
  U_VALIDATE_A: entity work.bcd_validator
    port map (
      bcd_in => a_raw,
      valid  => a_valid
    );

  -- Validate input B using your bcd_validator  
  U_VALIDATE_B: entity work.bcd_validator
    port map (
      bcd_in => b_raw,
      valid  => b_valid
    );

  -- Only use inputs if they are valid BCD, otherwise force to 0
  a <= a_raw when a_valid = '1' else "0000";
  b <= b_raw when b_valid = '1' else "0000";

  -- Instantiate 1-digit BCD Adder (only operates if both inputs are valid)
  U_BCD_ADD: entity work.BCD_Adder_1digit
    port map (
      A_bcd   => a,
      B_bcd   => b,
      Cin     => '0',      
      Sum_bcd => sum_bcd,  
      Cout    => cout      
    );

  -- Assign digit outputs: D0 = ones digit, D1 = tens digit
  -- Only show result if both inputs are valid, otherwise show error (E)
  d0 <= sum_bcd when (a_valid = '1' and b_valid = '1') else "1110";  -- "E" for error
  d1 <= "000" & cout when (a_valid = '1' and b_valid = '1') else "1110";  -- "E" for error

  -- Convert integer count to std_logic for selection
  sel1 <= '1' when count = 1 else '0';

  -- Modified digit counter for only 2 digits
  U_CNT: entity work.digit_counter 
    port map (
      clk => clk, 
      rst => reset, 
      count => count
    );

  -- Simple 2-input mux for ones/tens selection
  cur_d <= d1 when sel1 = '1' else d0;

  -- Anode control: only use 2 rightmost displays
  ssd_anodes <= "1101" when sel1 = '1' else "1110";

  U_HEX: entity work.hex_to_ssd_const
    port map (
      hex_in => cur_d,
      ssd_cathode_out => cat_full
    );

  ssd_cathodes <= cat_full(7 downto 1);
  ssd_anodes_unused <= "1111";
end;
