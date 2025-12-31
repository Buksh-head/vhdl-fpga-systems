library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gcd_top_tb is
end gcd_top_tb;

architecture testbench of gcd_top_tb is
    -- Component declaration
    component gcd_top
        port (
            clk          : in  std_logic;
            reset        : in  std_logic;
            btn_save     : in  std_logic;
            sw           : in  std_logic_vector(15 downto 0);
            ssd_cathodes : out std_logic_vector(6 downto 0);
            ssd_anodes   : out std_logic_vector(3 downto 0);
            ssd_anodes_unused : out std_logic_vector(3 downto 0);
            led_used     : out std_logic_vector(3 downto 0);
            gcd_result : out std_logic_vector(7 downto 0)

        );
    end component;

    -- Test bench signals
    signal clk          : std_logic := '0';
    signal reset        : std_logic := '1';
    signal btn_save     : std_logic := '0';
    signal sw           : std_logic_vector(15 downto 0) := (others => '0');
    signal ssd_cathodes : std_logic_vector(6 downto 0);
    signal ssd_anodes   : std_logic_vector(3 downto 0);
    signal ssd_anodes_unused : std_logic_vector(3 downto 0);
    signal led_used     : std_logic_vector(3 downto 0);
    signal gcd_result   : std_logic_vector(7 downto 0);

    -- Clock period definition
    constant CLK_PERIOD : time := 10 ns; -- 100 MHz

    -- Helper function to extract displayed digit from SSD cathodes
    function cathode_to_digit(cath : std_logic_vector(6 downto 0)) return integer is
        -- This must match your hex_to_ssd mapping!
        -- Example for active-low, standard mapping:
        type cath_array is array (0 to 9) of std_logic_vector(6 downto 0);
        constant digits : cath_array := (
            "0000001", -- 0
            "1001111", -- 1
            "0010010", -- 2
            "0000110", -- 3
            "1001100", -- 4
            "0100100", -- 5
            "0100000", -- 6
            "0001111", -- 7
            "0000000", -- 8
            "0000100"  -- 9
        );
    begin
        for i in 0 to 9 loop
            if cath = digits(i) then
                return i;
            end if;
        end loop;
        return -1; -- Not a valid digit
    end function;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: gcd_top
        port map (
            clk          => clk,
            reset        => reset,
            btn_save     => btn_save,
            sw           => sw,
            ssd_cathodes => ssd_cathodes,
            ssd_anodes   => ssd_anodes,
            ssd_anodes_unused => ssd_anodes_unused,
            led_used     => led_used,
            gcd_result   => gcd_result
        );

    -- Clock generation
    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Stimulus process
    stim_proc: process
        procedure run_gcd_test(a_val, b_val, expected_gcd : integer; test_name : string) is
        begin
            report "Starting test: " & test_name;
            -- Set input values
            sw <= std_logic_vector(to_unsigned(b_val, 8)) & std_logic_vector(to_unsigned(a_val, 8));
            wait for CLK_PERIOD * 2;

            -- Press and release save button
            btn_save <= '1';
            wait for CLK_PERIOD * 2;
            btn_save <= '0';

            -- Wait for calculation to finish (led_used(0) or similar)
            wait until led_used(0) = '1' for 2 ms;

            -- Check result (if you have a test port for GCD result, use it here)
            -- Otherwise, check SSD display (requires correct anode/cathode mapping)
            -- For demonstration, just report completion
            report "Test " & test_name & " completed. (Manual check required for SSD output)";
            wait for CLK_PERIOD * 10;
        end procedure;

        procedure run_bcd_test(val : integer; test_name : string) is
            variable hundreds, tens, ones : integer;
        begin
            report "Starting BCD test: " & test_name;
            sw <= std_logic_vector(to_unsigned(val, 8)) & std_logic_vector(to_unsigned(val, 8));
            wait for CLK_PERIOD * 2;
            btn_save <= '1';
            wait for CLK_PERIOD * 2;
            btn_save <= '0';
            wait until led_used(0) = '1' for 2 ms;

            -- Extract expected BCD digits
            hundreds := val / 100;
            tens := (val / 10) mod 10;
            ones := val mod 10;

            -- Here you would check the SSD outputs for each digit
            -- For demonstration, just report expected digits
            report "Expected BCD: " & integer'image(hundreds) & " " & integer'image(tens) & " " & integer'image(ones);
            wait for CLK_PERIOD * 10;
        end procedure;

    begin
        -- Reset the system
        reset <= '1';
        wait for CLK_PERIOD * 2;
        reset <= '0';
        wait for CLK_PERIOD * 2;

        -- Test case for A > B

        -- -- Test case for B > A
        --run_gcd_test(30, 75, 15, "B > A (30,75)");

        -- -- Test case for A and B prime
        ---run_gcd_test(13, 17, 1, "Coprime (13,17)");

        -- -- Test case for correct 8-bit binary to 3-digit BCD conversion
        run_bcd_test(187, "BCD Test (187)");

        report "All tests completed.";
        wait;
    end process;

end testbench;