library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BCD_Complement is
    port (
        bcd_in  : in  std_logic_vector(3 downto 0);  -- Input BCD digit
        comp_out : out std_logic_vector(3 downto 0)  -- 9's complement output
    );
end BCD_Complement;

architecture Behavioral of BCD_Complement is
begin
    process(bcd_in)
    begin
        case bcd_in is
            when "0000" => comp_out <= "1001";  -- 9 - 0 = 9
            when "0001" => comp_out <= "1000";  -- 9 - 1 = 8
            when "0010" => comp_out <= "0111";  -- 9 - 2 = 7
            when "0011" => comp_out <= "0110";  -- 9 - 3 = 6
            when "0100" => comp_out <= "0101";  -- 9 - 4 = 5
            when "0101" => comp_out <= "0100";  -- 9 - 5 = 4
            when "0110" => comp_out <= "0011";  -- 9 - 6 = 3
            when "0111" => comp_out <= "0010";  -- 9 - 7 = 2
            when "1000" => comp_out <= "0001";  -- 9 - 8 = 1
            when "1001" => comp_out <= "0000";  -- 9 - 9 = 0
            when others => comp_out <= "0000";  -- Invalid BCD -> 0
        end case;
    end process;
end Behavioral;