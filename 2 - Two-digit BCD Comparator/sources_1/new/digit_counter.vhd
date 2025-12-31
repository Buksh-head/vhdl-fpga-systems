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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity digit_counter is
  generic (
    MAX_COUNT : integer := 3;    -- 0..3 = 4 digits
    DIV_BITS  : integer := 15    -- clock divider (2^15 ? 32768)
  );
  port (
    clk    : in  std_logic;
    rst    : in  std_logic;         -- synchronous reset, active high
    count  : out integer range 0 to MAX_COUNT
  );
end digit_counter;

architecture rtl of digit_counter is
  signal div     : unsigned(DIV_BITS-1 downto 0) := (others=>'0');
  signal q       : integer range 0 to MAX_COUNT := 0;
begin

  process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        div <= (others=>'0');
        q   <= 0;
      else
        div <= div + 1;
        if div = 0 then                  -- rollover of divider
          if q = MAX_COUNT then
            q <= 0;
          else
            q <= q + 1;
          end if;
        end if;
      end if;
    end if;
  end process;

  count <= q;

end rtl;
