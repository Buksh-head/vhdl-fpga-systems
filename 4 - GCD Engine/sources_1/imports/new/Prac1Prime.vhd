----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.07.2025 21:56:00
-- Design Name: 
-- Module Name: Prac1Prime - Dataflow
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

entity PrimeDetector is
    Port ( num : in std_logic_vector(6 downto 0);  -- 7-bit input (0-127)
           is_prime : out std_logic);              -- '1' if prime, '0' if not
end PrimeDetector;

architecture Dataflow of PrimeDetector is
    signal num_int : integer range 0 to 127;
begin
    -- Convert the 7-bit input to an integer for easier comparison
    num_int <= to_integer(unsigned(num));
    
    -- Detect if the number is prime using a single boolean expression
    is_prime <= '1' when (num_int = 2) or (num_int = 3) or (num_int = 5) or
                         (num_int = 7) or (num_int = 11) or (num_int = 13) or
                         (num_int = 17) or (num_int = 19) or (num_int = 23) or
                         (num_int = 29) or (num_int = 31) or (num_int = 37) or
                         (num_int = 41) or (num_int = 43) or (num_int = 47) or
                         (num_int = 53) or (num_int = 59) or (num_int = 61) or
                         (num_int = 67) or (num_int = 71) or (num_int = 73) or
                         (num_int = 79) or (num_int = 83) or (num_int = 89) or
                         (num_int = 97) or (num_int = 101) or (num_int = 103) or
                         (num_int = 107) or (num_int = 109) or (num_int = 113) or
                         (num_int = 127) else '0';
end Dataflow;
