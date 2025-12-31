library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bcd_comparator_top is
    Port ( 
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        btn1 : in STD_LOGIC; -- Store first BCD number
        btn2 : in STD_LOGIC; -- Store second BCD number
        switches : in STD_LOGIC_VECTOR (7 downto 0);
        rgb_led : out STD_LOGIC_VECTOR (2 downto 0);
        ssd_cathodes : out STD_LOGIC_VECTOR (6 downto 0);
        ssd_anodes : out STD_LOGIC_VECTOR (3 downto 0);
        ssd_anodes_unused : out STD_LOGIC_VECTOR (3 downto 0)
    );
end bcd_comparator_top;

architecture Structural of bcd_comparator_top is
    -- Component declarations
    component EightBitReg is
        Port ( 
            d_in      : in  std_logic_vector(7 downto 0);
            clk_in    : in  std_logic;
            clk_en_in : in  std_logic;
            rst       : in  std_logic;
            q_out     : out std_logic_vector(7 downto 0)
        );
    end component;
    
    component bcd_validator is
        Port ( 
            bcd_in : in STD_LOGIC_VECTOR (3 downto 0);
            valid : out STD_LOGIC
        );
    end component;
    
    component bcd_comparator is
        Port ( 
            bcd1 : in STD_LOGIC_VECTOR (7 downto 0);
            bcd2 : in STD_LOGIC_VECTOR (7 downto 0);
            match_type : out STD_LOGIC_VECTOR (1 downto 0);
            digit_matches : out STD_LOGIC_VECTOR (1 downto 0)
        );
    end component;
    
    component display_controller is
        Port ( 
            bcd1 : in STD_LOGIC_VECTOR (7 downto 0);
            bcd2 : in STD_LOGIC_VECTOR (7 downto 0);
            match_type : in STD_LOGIC_VECTOR (1 downto 0);
            digit_matches : in STD_LOGIC_VECTOR (1 downto 0);
            bcd1_valid : in STD_LOGIC_VECTOR (1 downto 0);
            bcd2_valid : in STD_LOGIC_VECTOR (1 downto 0);
            reset : in STD_LOGIC;  -- Add this line
            digit0_out : out STD_LOGIC_VECTOR (3 downto 0);
            digit1_out : out STD_LOGIC_VECTOR (3 downto 0);
            digit2_out : out STD_LOGIC_VECTOR (3 downto 0);
            digit3_out : out STD_LOGIC_VECTOR (3 downto 0);
            rgb_led : out STD_LOGIC_VECTOR (2 downto 0)
        );
    end component;
    
    component digit_counter is
        generic (
            MAX_COUNT : integer := 3;
            DIV_BITS  : integer := 15
        );
        port (
            clk    : in  std_logic;
            rst    : in  std_logic;
            count  : out integer range 0 to 3
        );
    end component;
    
    component mux4x4 is
        port (
            in3,in2,in1,in0 : in  std_logic_vector(3 downto 0);
            sel             : in  std_logic_vector(1 downto 0);
            y               : out std_logic_vector(3 downto 0)
        );
    end component;
    
    component hex_to_ssd_const is
        port (
            hex_in          : in  std_logic_vector(3 downto 0);
            ssd_cathode_out : out std_logic_vector(7 downto 0)
        );
    end component;
    
    -- Internal signals
    signal bcd1_reg, bcd2_reg : STD_LOGIC_VECTOR(7 downto 0);
    signal match_type : STD_LOGIC_VECTOR(1 downto 0);
    signal digit_matches : STD_LOGIC_VECTOR(1 downto 0);
    signal bcd1_valid, bcd2_valid : STD_LOGIC_VECTOR(1 downto 0);
    signal digit0, digit1, digit2, digit3 : STD_LOGIC_VECTOR(3 downto 0);
    signal digit_count : integer range 0 to 3;
    signal digit_sel : STD_LOGIC_VECTOR(1 downto 0);
    signal current_digit : STD_LOGIC_VECTOR(3 downto 0);
    signal ssd_cathode_full : STD_LOGIC_VECTOR(7 downto 0);
    
begin
    -- Convert digit count to 2-bit selection
    digit_sel <= std_logic_vector(to_unsigned(digit_count, 2));
    
    -- Extract only cathodes (ignore DP)
    ssd_cathodes <= ssd_cathode_full(7 downto 1);
    
    U_AN: entity work.anode_decoder
      port map (
        sel => digit_sel,     -- "00"?digit0, "01"?digit1, "10"?digit2, "11"?digit3
        an  => ssd_anodes     -- active-low anodes
      );
    
    -- Instantiate components
    reg1: EightBitReg port map(
        d_in      => switches,
        clk_in    => clk,
        clk_en_in => btn1,
        rst       => reset,
        q_out     => bcd1_reg
    );
    
    reg2: EightBitReg port map(
        d_in      => switches,
        clk_in    => clk,
        clk_en_in => btn2,
        rst       => reset,
        q_out     => bcd2_reg
    );
    
    -- BCD validators
    val1_high: bcd_validator port map(
        bcd_in => bcd1_reg(7 downto 4),
        valid => bcd1_valid(1)
    );
    
    val1_low: bcd_validator port map(
        bcd_in => bcd1_reg(3 downto 0),
        valid => bcd1_valid(0)
    );
    
    val2_high: bcd_validator port map(
        bcd_in => bcd2_reg(7 downto 4),
        valid => bcd2_valid(1)
    );
    
    val2_low: bcd_validator port map(
        bcd_in => bcd2_reg(3 downto 0),
        valid => bcd2_valid(0)
    );
    
    -- BCD comparator
    comparator: bcd_comparator port map(
        bcd1 => bcd1_reg,
        bcd2 => bcd2_reg,
        match_type => match_type,
        digit_matches => digit_matches
    );
    
    -- Display controller
    display_ctrl: display_controller port map(
        bcd1 => bcd1_reg,
        bcd2 => bcd2_reg,
        match_type => match_type,
        digit_matches => digit_matches,
        bcd1_valid => bcd1_valid,
        bcd2_valid => bcd2_valid,
        reset => reset,  -- Add this line
        digit0_out => digit0,
        digit1_out => digit1,
        digit2_out => digit2,
        digit3_out => digit3,
        rgb_led => rgb_led
    );
    
    -- Digit counter for multiplexing
    counter: digit_counter port map(
        clk => clk,
        rst => reset,
        count => digit_count
    );
    
    -- Multiplexer for digit selection
    mux: mux4x4 port map(
        in0 => digit3,
        in1 => digit2,
        in2 => digit1,
        in3 => digit0,
        sel => digit_sel,
        y => current_digit
    );
    
    -- Seven segment decoder
    ssd_decoder: hex_to_ssd_const port map(
        hex_in => current_digit,
        ssd_cathode_out => ssd_cathode_full
    );
    
    -- Keep unused anodes always off (high since they're active-low)
    ssd_anodes_unused <= "1111";
    
end Structural;