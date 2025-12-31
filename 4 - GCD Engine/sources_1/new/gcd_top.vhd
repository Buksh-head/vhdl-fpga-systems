library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gcd_top is
  port (
    clk          : in  std_logic;                 -- 100 MHz clock input
    reset        : in  std_logic;                 -- Reset signal
    btn_save     : in  std_logic;                 -- Button for saving input to registers
    sw           : in  std_logic_vector(15 downto 0);  -- 16-bit input switches for A and B
    ssd_cathodes : out std_logic_vector(6 downto 0);  -- 7-segment cathode outputs (A-G)
    ssd_anodes   : out std_logic_vector(3 downto 0);  -- 4 active anodes (AN0-AN3)
    ssd_anodes_unused : out std_logic_vector(3 downto 0); -- Unused SSD anodes
    led_used     : out std_logic_vector(3 downto 0)   -- Unused LEDs
  );
end gcd_top;

architecture Structural of gcd_top is
  -- Internal signals
  signal d0, d1, d2, d3 : std_logic_vector(3 downto 0);  -- Nibbles for SSD display
  signal cat_full      : std_logic_vector(7 downto 0);  -- Full cathode pattern
  signal sel2          : std_logic_vector(1 downto 0);  -- Selection for SSD
  signal cur_d         : std_logic_vector(3 downto 0);  -- Current digit for display
  signal count         : integer range 0 to 3;         -- Counter for SSD display
  
  -- Register signals
  signal Reg_A, Reg_B  : std_logic_vector(7 downto 0); -- Registers to hold A and B
  signal a_binary, b_binary : std_logic_vector(7 downto 0); -- Binary conversion signals
  
  -- FSM signals
  signal gt, lt, eq : std_logic;  -- Comparison signals
  signal sel_A, sel_B : std_logic;  -- Mux select signals
  signal en_A, en_B : std_logic;   -- Register enable signals
  signal finished : std_logic;     -- GCD calculation complete
  
  -- Subtraction signals
  signal a_minus_b : std_logic_vector(7 downto 0);
  signal b_minus_a : std_logic_vector(7 downto 0);
  
  -- Input mux signals
  signal a_input, b_input : std_logic_vector(7 downto 0);
  
  -- Button debounce signals
  signal btn_save_d1, btn_save_d2 : std_logic := '0';
  signal btn_save_pulse : std_logic;

begin  
  -- Initial input binary conversion
  a_binary <= sw(7 downto 0);    -- A is lower 8 bits
  b_binary <= sw(15 downto 8);   -- B is upper 8 bits
  
  -- Comparator logic
  U_COMP: entity work.greaterorlessthan port map (
    A  => Reg_A,
    B  => Reg_B,
    gt => gt,
    lt => lt,
    eq => eq
  );
  
  -- Subtraction operations
  a_minus_b <= std_logic_vector(unsigned(Reg_A) - unsigned(Reg_B));
  b_minus_a <= std_logic_vector(unsigned(Reg_B) - unsigned(Reg_A));
  

  a_input <= a_binary when sel_A = '0' else a_minus_b;
  b_input <= b_binary when sel_B = '0' else b_minus_a;

  -- Button debounce process
  U_DEBOUNCE: entity work.debounce port map (
    clk => clk, 
    btn_save => btn_save, 
    btn_save_pulse => btn_save_pulse
  );

  -- Instantiate the GCD FSM
  U_GCD_FSM: entity work.gcd_fsm port map (
    clk => clk,
    reset => reset,
    btn_save => btn_save_pulse,  -- Use debounced signal
    gt => gt,
    lt => lt,
    eq => eq,
    sel_A => sel_A,
    sel_B => sel_B,
    en_A => en_A,
    en_B => en_B,
    finished => finished
  );
  
  -- 8-bit registers for storing A and B
  U_NUM_REG_A: entity work.EightBitReg port map (
    d_in => a_input, 
    clk_in => clk, 
    clk_en_in => en_A, 
    rst => reset, 
    q_out => Reg_A
  );
  
  U_NUM_REG_B: entity work.EightBitReg port map (
    d_in => b_input, 
    clk_in => clk, 
    clk_en_in => en_B, 
    rst => reset, 
    q_out => Reg_B
  );
  
  -- Display logic - show GCD result when finished
  U_DISPLAY: entity work.gcd_display port map (
    gcd_value => Reg_A,
    d0        => d0,
    d1        => d1,
    d2        => d2,
    d3        => d3
  );
  
  -- Timebase for cycling SSD digits
  U_CNT: entity work.digit_counter port map (
    clk => clk, 
    rst => reset, 
    count => count
  );
  
  -- Select the active SSD anode based on the counter value
  sel2 <= std_logic_vector(to_unsigned(count, 2));
  U_ANODE: entity work.anode_decoder port map (
    sel => sel2, 
    an => ssd_anodes
  );
  
  -- Use mux to select which digit to display
  U_MUX: entity work.mux4x4 port map (
    in0 => d0, 
    in1 => d1, 
    in2 => d2, 
    in3 => d3, 
    sel => sel2, 
    y => cur_d
  );
  
  -- Convert the selected hex digit to SSD pattern
  U_HEX: entity work.hex_to_ssd_const port map (
    hex_in => cur_d, 
    ssd_cathode_out => cat_full
  );
  
  -- Output the cathode pattern to the SSD (ignore DP)
  ssd_cathodes <= cat_full(6 downto 0);
  
  -- Unused SSD anodes set to '1'
  ssd_anodes_unused <= "1111"; 
  led_used <= "1111"; 
  
end Structural;
