library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BCD_Adder_1digit_behavioral is
    port (
        A_bcd    : in  std_logic_vector(3 downto 0);  -- 1-digit BCD input A
        B_bcd    : in  std_logic_vector(3 downto 0);  -- 1-digit BCD input B  
        Cin      : in  std_logic;                     -- Carry-in
        Sum_bcd  : out std_logic_vector(3 downto 0);  -- 1-digit BCD output
        Cout     : out std_logic                      -- Carry-out
    );
end BCD_Adder_1digit_behavioral;

architecture Behavioral of BCD_Adder_1digit_behavioral is
begin
    process(A_bcd, B_bcd, Cin)
        variable temp_sum : unsigned(4 downto 0);  -- 5-bit to capture carry
        variable A_int    : integer range 0 to 15;
        variable B_int    : integer range 0 to 15;
        variable Cin_int  : integer range 0 to 1;
        variable result   : integer range 0 to 31;
    begin
        -- Convert inputs to integers
        A_int := to_integer(unsigned(A_bcd));
        B_int := to_integer(unsigned(B_bcd));
        Cin_int := to_integer(unsigned'("" & Cin));
        
        -- Perform addition
        result := A_int + B_int + Cin_int;
        
        -- Generate BCD output and carry
        if result > 9 then
            Sum_bcd <= std_logic_vector(to_unsigned(result - 10, 4));
            Cout <= '1';
        else
            Sum_bcd <= std_logic_vector(to_unsigned(result, 4));
            Cout <= '0';
        end if;
    end process;
end Behavioral;