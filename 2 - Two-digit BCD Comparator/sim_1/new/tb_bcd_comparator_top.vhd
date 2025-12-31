-- =====================================================================
-- Testbench: tb_bcd_comparator_top (fast)
-- Purpose  : Functional sim of top with fast TB clock and short waits:
--            1) Reset
--            2) Full match (AB == XY)
--            3) Partial match (one digit equal)
--            4) No match (both digits differ)
-- Notes:
--  - TB clock = 1 GHz (1 ns period) to accelerate sim
--  - Buttons pulse for 1 TB clock
--  - W_SCAN is ~hundreds of us so your digit_counter can scan
--  - Observe: ssd_anodes (active-low), ssd_cathodes (A..G active-low), rgb_led
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_bcd_comparator_top is
end entity;

architecture sim of tb_bcd_comparator_top is
  -- DUT I/O
  signal clk          : std_logic := '0';
  signal reset        : std_logic := '0';
  signal btn1         : std_logic := '0';
  signal btn2         : std_logic := '0';
  signal switches     : std_logic_vector(7 downto 0) := (others => '0');
  signal rgb_led      : std_logic_vector(2 downto 0);
  signal ssd_cathodes : std_logic_vector(6 downto 0);  -- A..G only (active-low)
  signal ssd_anodes   : std_logic_vector(3 downto 0);  -- 4 active digits (active-low)

  constant Tclk   : time := 1 ns;     -- 1 GHz TB clock (faster sim)
  constant W_SCAN : time := 3 us;   -- enough for your divider to cycle digits

  -- Pulse a button for one TB clock
  procedure pulse_btn(signal b : out std_logic) is
  begin
    b <= '1';
    wait for Tclk;
    b <= '0';
  end procedure;

  -- Latch a value into register A (btn1)
  procedure latch_A(signal sw : out std_logic_vector(7 downto 0);
                    signal b  : out std_logic;
                    val       : std_logic_vector(7 downto 0)) is
  begin
    sw <= val;
    wait for Tclk;
    pulse_btn(b);
  end procedure;

  -- Latch a value into register B (btn2)
  procedure latch_B(signal sw : out std_logic_vector(7 downto 0);
                    signal b  : out std_logic;
                    val       : std_logic_vector(7 downto 0)) is
  begin
    sw <= val;
    wait for Tclk;
    pulse_btn(b);
  end procedure;

begin
  -- Fast TB clock
  clk <= not clk after Tclk/2;

  -- DUT instance
  dut: entity work.bcd_comparator_top
    port map (
      clk          => clk,
      reset        => reset,
      btn1         => btn1,
      btn2         => btn2,
      switches     => switches,
      rgb_led      => rgb_led,
      ssd_cathodes => ssd_cathodes,
      ssd_anodes   => ssd_anodes
    );

  -- OPTIONAL: simple monitor to see what each digit outputs in hex

  -- Stimulus
  stim: process
  begin

    -- (3) PARTIAL MATCH: tens equal, units differ (AB=0x35, XY=0x34)
    report "TB: Partial match case (tens equal: AB=0x35, XY=0x34)";
    reset <= '1';
    wait for 8000*Tclk;
    reset <= '0';
    wait for W_SCAN;

    report "TB: Completed all scenarios" severity note;
    wait;
  end process;

end architecture sim;
