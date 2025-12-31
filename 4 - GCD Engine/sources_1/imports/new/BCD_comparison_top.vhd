library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BCD_comparison_top is
    port (
        A_bcd    : in  std_logic_vector(3 downto 0);
        B_bcd    : in  std_logic_vector(3 downto 0);
        Cin      : in  std_logic;
        
        -- Structural outputs
        Sum_struct : out std_logic_vector(3 downto 0);
        Cout_struct : out std_logic;
        
        -- Behavioral outputs  
        Sum_behav  : out std_logic_vector(3 downto 0);
        Cout_behav : out std_logic
    );
end BCD_comparison_top;

architecture Structural of BCD_comparison_top is
begin
    -- Structural implementation
    U_STRUCT: entity work.BCD_Adder_1digit
        port map (
            A_bcd => A_bcd, B_bcd => B_bcd, Cin => Cin,
            Sum_bcd => Sum_struct, Cout => Cout_struct
        );
    
    -- Behavioral implementation
    U_BEHAV: entity work.BCD_Adder_1digit_behavioral
        port map (
            A_bcd => A_bcd, B_bcd => B_bcd, Cin => Cin,
            Sum_bcd => Sum_behav, Cout => Cout_behav
        );
end Structural;