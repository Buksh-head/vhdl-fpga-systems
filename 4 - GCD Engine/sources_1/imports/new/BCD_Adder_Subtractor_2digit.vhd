library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BCD_Adder_Subtractor_2digit is
    port (
        A1, A0   : in  std_logic_vector(3 downto 0);  -- 2-digit BCD input A
        B1, B0   : in  std_logic_vector(3 downto 0);  -- 2-digit BCD input B
        sub_mode : in  std_logic;                     -- '0'=Add, '1'=Subtract (B-A)
        S2, S1, S0 : out std_logic_vector(3 downto 0); -- 3-digit BCD output
        negative : out std_logic                      -- '1' if result is negative
    );
end BCD_Adder_Subtractor_2digit;

architecture Structural of BCD_Adder_Subtractor_2digit is
    -- Basic signals
    signal A1_op, A0_op       : std_logic_vector(3 downto 0);
    signal A1_comp, A0_comp   : std_logic_vector(3 downto 0);
    signal carry_intermediate : std_logic;
    signal initial_carry      : std_logic;
    signal final_carry        : std_logic;
    signal raw_S1, raw_S0     : std_logic_vector(3 downto 0);
    signal is_negative        : std_logic;
    
    -- Signals for magnitude correction (when negative)
    signal mag_S1_comp, mag_S0_comp : std_logic_vector(3 downto 0);
    signal mag_carry          : std_logic;
    signal corrected_S1, corrected_S0 : std_logic_vector(3 downto 0);
    
begin
    -- Generate 9's complement of A
    U_COMP_A0: entity work.BCD_Complement
        port map (bcd_in => A0, comp_out => A0_comp);
        
    U_COMP_A1: entity work.BCD_Complement
        port map (bcd_in => A1, comp_out => A1_comp);
        
    -- Select operand: original A for addition, complement A for subtraction
    A0_op <= A0_comp when sub_mode = '1' else A0;
    A1_op <= A1_comp when sub_mode = '1' else A1;
    initial_carry <= sub_mode;  -- +1 for subtraction to complete 10's complement
    
    -- BCD addition chain
    U_ONES_ADDER: entity work.BCD_Adder_1digit
        port map (
            A_bcd   => B0,
            B_bcd   => A0_op,
            Cin     => initial_carry,
            Sum_bcd => raw_S0,
            Cout    => carry_intermediate
        );
    
    U_TENS_ADDER: entity work.BCD_Adder_1digit
        port map (
            A_bcd   => B1,
            B_bcd   => A1_op,
            Cin     => carry_intermediate,
            Sum_bcd => raw_S1,
            Cout    => final_carry
        );
    
    -- Detect if result is negative (subtraction with no carry)
    is_negative <= sub_mode and (not final_carry);
    
    -- For negative results, convert back to magnitude using 10's complement
    U_MAG_COMP_S0: entity work.BCD_Complement
        port map (bcd_in => raw_S0, comp_out => mag_S0_comp);
        
    U_MAG_COMP_S1: entity work.BCD_Complement
        port map (bcd_in => raw_S1, comp_out => mag_S1_comp);
    
    -- Add 1 to complete 10's complement (convert to magnitude)
    U_MAG_ONES_ADDER: entity work.BCD_Adder_1digit
        port map (
            A_bcd   => mag_S0_comp,
            B_bcd   => "0000",
            Cin     => '1',           -- +1 to complete 10's complement
            Sum_bcd => corrected_S0,
            Cout    => mag_carry
        );
    
    U_MAG_TENS_ADDER: entity work.BCD_Adder_1digit
        port map (
            A_bcd   => mag_S1_comp,
            B_bcd   => "0000",
            Cin     => mag_carry,
            Sum_bcd => corrected_S1,
            Cout    => open          -- Don't need this carry
        );
    
    -- Output selection: use corrected magnitude if negative, raw result if positive
    S0 <= corrected_S0 when is_negative = '1' else raw_S0;
    S1 <= corrected_S1 when is_negative = '1' else raw_S1;
    S2 <= "000" & final_carry when sub_mode = '0' else "0000";  -- Show carry only for addition
    
    -- Output negative flag
    negative <= is_negative;
    
end Structural;