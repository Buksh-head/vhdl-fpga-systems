----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.08.2025 21:30:49
-- Design Name: 
-- Module Name: ce_tick - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ce_tick is
  generic (
    CLK_HZ   : integer := 100_000_000; -- input clock
    TICK_HZ  : integer := 4000         -- desired tick rate (e.g. 4 kHz total scan)
  );
  port (
    clk   : in  std_logic;
    rst   : in  std_logic;     -- sync, active-high
    tick  : out std_logic      -- 1-cycle pulse at TICK_HZ
  );
end;

architecture rtl of ce_tick is
  constant N : integer := CLK_HZ / TICK_HZ;
  signal cnt : integer range 0 to N-1 := 0;
  signal t   : std_logic := '0';
begin
  process(clk)
  begin
    if rising_edge(clk) then
      if rst='1' then
        cnt <= 0; t <= '0';
      elsif cnt = N-1 then
        cnt <= 0;  t <= '1';
      else
        cnt <= cnt + 1; t <= '0';
      end if;
    end if;
  end process;
  tick <= t;
end;