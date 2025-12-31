library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bcd_validator is
    Port ( 
        bcd_in : in STD_LOGIC_VECTOR (3 downto 0);
        valid : out STD_LOGIC
    );
end bcd_validator;

architecture Behavioral of bcd_validator is
begin
    process(bcd_in)
    begin
        if unsigned(bcd_in) <= 9 then
            valid <= '1';
        else
            valid <= '0';
        end if;
    end process;
end Behavioral;