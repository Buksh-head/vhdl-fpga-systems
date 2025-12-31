library ieee;
use ieee.std_logic_1164.all;

entity debounce is
  port (
    clk        : in std_logic;       -- Clock signal
    btn_save   : in std_logic;       -- Button signal to be debounced
    btn_save_pulse : out std_logic  -- Output debounced pulse
  );
end debounce;

architecture Behavioral of debounce is
  signal btn_save_d1, btn_save_d2 : std_logic := '0';  -- Two-stage flip-flop for debouncing
begin
  -- Debounce process: creates a single cycle pulse for btn_save
  process(clk)
  begin
    if rising_edge(clk) then
      btn_save_d1 <= btn_save;
      btn_save_d2 <= btn_save_d1;
    end if;
  end process;

  -- Create pulse on the btn_save_pulse signal (high for one clock cycle)
  btn_save_pulse <= btn_save_d1 and not btn_save_d2;

end Behavioral;
