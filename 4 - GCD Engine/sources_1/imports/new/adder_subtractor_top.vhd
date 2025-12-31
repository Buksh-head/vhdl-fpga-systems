library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_subtractor_top is
  port (
    clk          : in  std_logic;
    add_sub      : in  std_logic;                     -- '0'=Add, '1'=Subtract (using reset button)
    sw           : in  std_logic_vector(15 downto 0); -- 16-bit input switches
    ssd_cathodes : out std_logic_vector(6 downto 0);  -- 7-segment cathode outputs (A-G)
    ssd_anodes   : out std_logic_vector(3 downto 0);  -- 4 active anodes (AN0-AN3)
    ssd_anodes_unused : out STD_LOGIC_VECTOR (3 downto 0)
  );
end;

architecture Structural of adder_subtractor_top is
  -- Input signals (2-digit BCD numbers)
  signal a0, a1, b0, b1     : std_logic_vector(3 downto 0);  -- Individual BCD digits
  signal a0_valid, a1_valid : std_logic;                     -- Validation for A
  signal b0_valid, b1_valid : std_logic;                     -- Validation for B
  signal all_valid          : std_logic;                     -- All inputs valid
  
  -- Output signals (3-digit BCD result)
  signal s0, s1, s2         : std_logic_vector(3 downto 0);  -- BCD result digits
  
  -- Display signals
  signal d0, d1, d2, d3     : std_logic_vector(3 downto 0);  -- 4 digits for mux4x4
  signal cat_full           : std_logic_vector(7 downto 0);  -- Full cathode pattern
  signal cur_d              : std_logic_vector(3 downto 0);  -- Current digit
  signal count              : integer range 0 to 2;         -- Counter for 3 digits
  signal sel2               : std_logic_vector(1 downto 0);  -- 2-bit selection for mux
  signal result_negative     : std_logic;                   -- Result negative flag
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

  -- 2-digit BCD adder/subtractor
  U_BCD_ADDSUB: entity work.BCD_Adder_Subtractor_2digit
    port map (
      A1 => a1, A0 => a0,
      B1 => b1, B0 => b0,
      sub_mode => add_sub,  -- Control signal: 0=add, 1=subtract
      S2 => s2, S1 => s1, S0 => s0,
      negative => result_negative  -- Add this output
    );

  -- Display assignment (show error if invalid inputs)
  d0 <= s0 when all_valid = '1' else "1110";                    -- Ones or Error
  d1 <= s1 when all_valid = '1' else "1110";                    -- Tens or Error
  d2 <= "1111" when (all_valid = '1' and result_negative = '1') else -- Minus sign or...
        s2 when (all_valid = '1' and result_negative = '0') else      -- Hundreds digit or...
        "1110";                                                       -- Error
  d3 <= "0000";                               -- Unused (mux input 3)

  -- Convert count to 2-bit selection signal for mux4x4
  sel2 <= std_logic_vector(to_unsigned(count, 2));

  -- Use your existing digit_counter component (configured for 3 digits: 0, 1, 2)
  U_CNT: entity work.digit_counter
    generic map (
      MAX_COUNT => 2      -- Count 0, 1, 2 (3 digits total)
    )
    port map (
      clk   => clk,
      rst   => '0',        -- No reset needed for continuous operation
      count => count
    );

  -- Use your existing mux4x4 component
  U_MUX: entity work.mux4x4
    port map (
      in0 => d0,    -- sel="00": ones digit
      in1 => d1,    -- sel="01": tens digit  
      in2 => d2,    -- sel="10": hundreds digit
      in3 => d3,    -- sel="11": unused (always 0)
      sel => sel2,
      y   => cur_d
    );

  -- Use your existing anode_decoder component
  U_ANODE: entity work.anode_decoder
    port map (
      sel => sel2,
      an  => ssd_anodes
    );

  U_HEX: entity work.hex_to_ssd_const
    port map (
      hex_in => cur_d,
      ssd_cathode_out => cat_full
    );

  ssd_cathodes <= cat_full(7 downto 1);
  ssd_anodes_unused <= "1111";
end;