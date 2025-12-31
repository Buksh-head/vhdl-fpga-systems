----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.09.2025 22:52:12
-- Design Name: 
-- Module Name: BCD_Adder_1digit - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BCD_Adder_1digit is
    port (
        A_bcd    : in  std_logic_vector(3 downto 0);  -- 1-digit BCD input A
        B_bcd    : in  std_logic_vector(3 downto 0);  -- 1-digit BCD input B  
        Cin      : in  std_logic;                     -- Carry-in
        Sum_bcd  : out std_logic_vector(3 downto 0);  -- 1-digit BCD output
        Cout     : out std_logic                      -- Carry-out
    );
end BCD_Adder_1digit;

architecture Structural of BCD_Adder_1digit is
    -- Internal signals
    signal binary_sum     : std_logic_vector(3 downto 0);  -- Raw binary sum (4-bit)
    signal binary_carry   : std_logic;                     -- Raw binary carry
    signal correction     : std_logic_vector(3 downto 0);  -- Correction value (0 or 6)
    signal corrected_sum  : std_logic_vector(3 downto 0);  -- Final corrected sum
    signal correction_carry : std_logic;                   -- Carry from correction
    
begin
    -- Step 1: Perform standard 4-bit binary addition
    U_BINARY_ADD: entity work.RCAdder
        generic map (width => 4)
        port map (
            Cin  => Cin,
            A    => A_bcd,
            B    => B_bcd,
            S    => binary_sum,
            Cout => binary_carry
        );
    
    -- Step 2: Determine correction value
    -- If sum > 9 OR there's a carry from binary addition, we need correction
    correction <= "0110" when (unsigned(binary_sum) > 9 or binary_carry = '1') else "0000";
    
    -- Step 3: Add correction using another RCAdder
    U_CORRECTION_ADD: entity work.RCAdder
        generic map (width => 4)
        port map (
            Cin  => '0',
            A    => binary_sum,
            B    => correction,
            S    => corrected_sum,
            Cout => correction_carry
        );
    
    -- Step 4: Generate outputs
    Sum_bcd <= corrected_sum;
    Cout <= binary_carry or correction_carry;  -- Carry-out if either addition generated carry
    
end Structural;
