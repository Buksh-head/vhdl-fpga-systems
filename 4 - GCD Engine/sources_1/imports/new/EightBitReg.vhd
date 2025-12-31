----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.08.2025 19:30:13
-- Design Name: 
-- Module Name: EightBitReg - Behavioral
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

entity EightBitReg is
  port (
    d_in      : in  std_logic_vector(7 downto 0);
    clk_in    : in  std_logic;
    clk_en_in : in  std_logic;
    rst       : in  std_logic;                      -- active-high, synchronous
    q_out     : out std_logic_vector(7 downto 0)
  );
end EightBitReg;

architecture Behavioral of EightBitReg is
  signal r : std_logic_vector(7 downto 0) := (others => '0');
begin
  process(clk_in)
  begin
    if rising_edge(clk_in) then
      if rst = '1' then
        r <= (others => '0');          -- clear register
      elsif clk_en_in = '1' then
        r <= d_in;                     -- latch input
      end if;
    end if;
  end process;

  q_out <= r;
end Behavioral;
