library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BCD_Adder_2digit is
    port (
        A1, A0   : in  std_logic_vector(3 downto 0);  -- 2-digit BCD input A (A1=tens, A0=ones)
        B1, B0   : in  std_logic_vector(3 downto 0);  -- 2-digit BCD input B (B1=tens, B0=ones)
        S2, S1, S0 : out std_logic_vector(3 downto 0) -- 3-digit BCD output (S2=hundreds, S1=tens, S0=ones)
    );
end BCD_Adder_2digit;

architecture Structural of BCD_Adder_2digit is
    signal carry_intermediate : std_logic;  -- Carry from ones to tens position
begin
    -- Ones position: A0 + B0 
    U_ONES_ADDER: entity work.BCD_Adder_1digit
        port map (
            A_bcd   => A0,
            B_bcd   => B0,
            Cin     => '0',                    -- No carry-in for ones position
            Sum_bcd => S0,                     -- Ones digit of result
            Cout    => carry_intermediate      -- Carry to tens position
        );
    
    -- Tens position: A1 + B1 + carry from ones
    U_TENS_ADDER: entity work.BCD_Adder_1digit
        port map (
            A_bcd   => A1,
            B_bcd   => B1,
            Cin     => carry_intermediate,     -- Carry from ones position
            Sum_bcd => S1,                     -- Tens digit of result
            Cout    => S2(0)                   -- Carry becomes hundreds digit
        );
    
    -- Hundreds digit is just the carry from tens (0 or 1)
    S2(3 downto 1) <= "000";  -- Upper bits always 0 for single carry
    
end Structural;