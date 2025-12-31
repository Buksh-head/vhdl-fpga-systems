library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_BCD_Adder_Subtractor_2digit is
-- Testbench has no ports
end tb_BCD_Adder_Subtractor_2digit;

architecture Behavioral of tb_BCD_Adder_Subtractor_2digit is
    -- Component declaration
    component BCD_Adder_Subtractor_2digit
        port (
            A1, A0   : in  std_logic_vector(3 downto 0);
            B1, B0   : in  std_logic_vector(3 downto 0);
            sub_mode : in  std_logic;
            S2, S1, S0 : out std_logic_vector(3 downto 0)
        );
    end component;
    
    -- Test signals
    signal A1, A0       : std_logic_vector(3 downto 0) := "0000";
    signal B1, B0       : std_logic_vector(3 downto 0) := "0000";
    signal sub_mode     : std_logic := '0';
    signal S2, S1, S0   : std_logic_vector(3 downto 0);
    
    -- Helper signals for readability
    signal A_decimal    : integer;
    signal B_decimal    : integer;
    signal Result_decimal : integer;
    
begin
    -- Unit Under Test (UUT)
    UUT: BCD_Adder_Subtractor_2digit
        port map (
            A1 => A1,
            A0 => A0,
            B1 => B1,
            B0 => B0,
            sub_mode => sub_mode,
            S2 => S2,
            S1 => S1,
            S0 => S0
        );
    
    -- Convert BCD to decimal for easier verification
    A_decimal <= to_integer(unsigned(A1)) * 10 + to_integer(unsigned(A0));
    B_decimal <= to_integer(unsigned(B1)) * 10 + to_integer(unsigned(B0));
    Result_decimal <= to_integer(unsigned(S2)) * 100 + to_integer(unsigned(S1)) * 10 + to_integer(unsigned(S0));
    
    -- Test process
    stim_proc: process
    begin
        -- Initialize
        wait for 10 ns;
        
        -- ====================================================================
        -- ADDITION MODE - 2 TEST CASES
        -- ====================================================================
        
        report "=== ADDITION MODE TESTS ===";
        sub_mode <= '0';
        wait for 10 ns;
        
        -- Addition Test Case 1: 23 + 45 = 68
        report "--- Addition Test 1: 23 + 45 ---";
        A1 <= "0010"; A0 <= "0011";  -- A = 23
        B1 <= "0100"; B0 <= "0101";  -- B = 45
        wait for 30 ns;
        
        assert (S2 = "0000" and S1 = "0110" and S0 = "1000")
            report "ERROR: 23 + 45 should equal 068, got " & 
                   integer'image(Result_decimal)
            severity error;
        report "PASS: 23 + 45 = " & integer'image(Result_decimal);
        
        -- Addition Test Case 2: 57 + 68 = 125 (with carry)
        report "--- Addition Test 2: 57 + 68 ---";
        B1 <= "0101"; B0 <= "0111";  -- A = 57
        A1 <= "0110"; A0 <= "1000";  -- B = 68
        wait for 30 ns;
        
        assert (S2 = "0001" and S1 = "0010" and S0 = "0101")
            report "ERROR: 57 + 68 should equal 125, got " & 
                   integer'image(Result_decimal)
            severity error;
        report "PASS: 57 + 68 = " & integer'image(Result_decimal);
        
        -- ====================================================================
        -- SUBTRACTION MODE - 2 TEST CASES (P > Q and P < Q)
        -- Note: Implementation does B - A
        -- ====================================================================
        
        report "=== SUBTRACTION MODE TESTS ===";
        sub_mode <= '1';
        wait for 10 ns;
        
        -- Subtraction Test Case 1: P > Q (B=75, A=32, so 75-32=43)
        report "--- Subtraction Test 1: P > Q (75 - 32) ---";
        A1 <= "0011"; A0 <= "0010";  -- A = 32 (subtracted from B)
        B1 <= "0111"; B0 <= "0101";  -- B = 75 (minuend)
        wait for 30 ns;
        
        -- Expected: 75 - 32 = 43, with carry=1 (positive result)
        assert (S2 = "0001" and S1 = "0100" and S0 = "0011")
            report "ERROR: 75 - 32 should equal 143 (with carry), got " & 
                   integer'image(Result_decimal)
            severity error;
        report "PASS: 75 - 32 = " & integer'image(Result_decimal) & " (carry=1, positive)";
        
        -- Subtraction Test Case 2: P < Q (B=23, A=67, so 23-67=-44)
        report "--- Subtraction Test 2: P < Q (23 - 67) ---";
        A1 <= "0110"; A0 <= "0111";  -- A = 67 (subtracted from B)
        B1 <= "0010"; B0 <= "0011";  -- B = 23 (minuend)
        wait for 30 ns;
        
        -- Expected: 23 - 67 = -44, result in 10's complement form (56), carry=0
        assert (S2 = "0000" and S1 = "0101" and S0 = "0110")
            report "ERROR: 23 - 67 should equal 056 (10's complement), got " & 
                   integer'image(Result_decimal)
            severity error;
        report "PASS: 23 - 67 = " & integer'image(Result_decimal) & " (carry=0, negative in 10's complement)";
        
        -- ====================================================================
        -- TEST SUMMARY
        -- ====================================================================
        
        wait for 20 ns;
        report "=== ALL 4 REQUIRED TESTS COMPLETED ===";
        report "SUMMARY:";
        report "- Addition: 2 test cases completed";
        report "- Subtraction: P > Q and P < Q cases completed";
        report "If no ERROR messages appeared, all tests PASSED!";
        
        wait;  -- End simulation
    end process;

end Behavioral;