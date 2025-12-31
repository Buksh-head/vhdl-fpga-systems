----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.08.2025 21:25:07
-- Design Name: 
-- Module Name: digit_counter - Behavioral
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

entity digit_counter is
  generic (
    MAX_COUNT : integer := 2
  );
  port (
    clk   : in  std_logic;
    rst   : in  std_logic;
    count : out integer range 0 to MAX_COUNT
  );
end digit_counter;

architecture rtl of digit_counter is
  signal big_counter : unsigned(15 downto 0) := (others=>'0');  -- 16-bit
  signal digit_sel   : unsigned(1 downto 0);
begin
  -- Main counter
  process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        big_counter <= (others=>'0');
      else
        big_counter <= big_counter + 1;
      end if;
    end if;
  end process;
  
  -- Use upper bits for digit selection (changes every 2^14 = 16,384 clocks)
  digit_sel <= big_counter(15 downto 14);
  
  -- Convert to integer output
  with digit_sel select
    count <= 0 when "00",
             1 when "01", 
             2 when "10",
             0 when others;  -- Wrap around for 3-digit display
             
end rtl;
