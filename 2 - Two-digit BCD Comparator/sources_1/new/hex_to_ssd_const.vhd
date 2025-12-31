----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.08.2025 20:39:07
-- Design Name: 
-- Module Name: hex_to_ssd_const - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hex_to_ssd_const is
  port (
    hex_in          : in  std_logic_vector(3 downto 0);
    ssd_cathode_out : out std_logic_vector(7 downto 0)   -- A..G..DP (active-low)
  );
end hex_to_ssd_const;

architecture Dataflow of hex_to_ssd_const is
  subtype cathode_out_t is std_logic_vector(7 downto 0); -- [7]=A ... [0]=DP

  constant ZERO : cathode_out_t := B"0000_0011";
  constant ONE : cathode_out_t := B"1001_1111";
  constant TWO : cathode_out_t := B"0010_0101";
  constant THREE : cathode_out_t := B"0000_1101";
  constant FOUR : cathode_out_t := B"1001_1001";
  constant FIVE : cathode_out_t := B"0100_1001";
  constant SIX : cathode_out_t := B"0100_0001";
  constant SEVEN : cathode_out_t := B"0001_1111";
  constant EIGHT : cathode_out_t := B"0000_0001";
  constant NINE : cathode_out_t := B"0001_1001";  
  constant EE    : cathode_out_t := B"0110_0001"; -- 'E'
  constant HH    : cathode_out_t := B"1001_0001"; -- 'H' (segments B, C, E, F, G on)
  constant BLANK : cathode_out_t := B"1111_1111"; -- All segments off (blank)
  constant MINUS : cathode_out_t := B"1111_1101"; -- Only segment G on (middle horizontal line)
  
begin
  ssd_cathode_out <=
      ZERO  when hex_in = X"0" else
      ONE   when hex_in = X"1" else
      TWO   when hex_in = X"2" else
      THREE when hex_in = X"3" else
      FOUR  when hex_in = X"4" else
      FIVE  when hex_in = X"5" else
      SIX   when hex_in = X"6" else
      SEVEN when hex_in = X"7" else
      EIGHT when hex_in = X"8" else
      NINE  when hex_in = X"9" else
      BLANK when hex_in = X"A" else  -- Blank pattern for reset
      EE    when hex_in = X"E" else
      HH    when hex_in = X"F" else  -- 'H' pattern for hex value F
      (others => '1');
end Dataflow;
