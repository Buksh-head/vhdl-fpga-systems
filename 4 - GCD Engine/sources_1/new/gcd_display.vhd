library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity gcd_display is
  Port (
    gcd_value : in  std_logic_vector(7 downto 0);   -- Final GCD result (0-255)
    d0, d1, d2, d3 : out std_logic_vector(3 downto 0) -- Digits for SSD
  );
end gcd_display;

architecture Behavioral of gcd_display is
begin
  process(gcd_value)
    variable gcd_int_v : integer range 0 to 255;
    variable hundreds_v, tens_v, ones_v : integer range 0 to 9;
  begin
    -- Use variables for intermediate calculations
    gcd_int_v := to_integer(unsigned(gcd_value));
    hundreds_v := gcd_int_v / 100;
    tens_v := (gcd_int_v / 10) mod 10;
    ones_v := gcd_int_v mod 10;

    -- Assign to output ports
    d0 <= std_logic_vector(to_unsigned(ones_v, 4));
    d1 <= std_logic_vector(to_unsigned(tens_v, 4));
    d2 <= std_logic_vector(to_unsigned(hundreds_v, 4));
    d3 <= "0000"; -- blank
  end process;
end Behavioral;
