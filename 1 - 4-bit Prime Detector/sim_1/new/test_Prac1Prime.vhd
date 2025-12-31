library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_Prac1Prime is
end test_Prac1Prime;

architecture Behavioral of test_Prac1Prime is

    -- Component under test
    component Prac1Prime
        Port (
            A : in  std_logic;
            B : in  std_logic;
            C : in  std_logic;
            D : in  std_logic;
            F : out std_logic
        );
    end component;

    -- Input/output signals
    signal Inputs : std_logic_vector(3 downto 0) := "0000";
    signal F : std_logic;

begin

    -- DUT instantiation
    uut: Prac1Prime
        port map (
            A => Inputs(3),
            B => Inputs(2),
            C => Inputs(1),
            D => Inputs(0),
            F => F
        );

    -- Test process
    stim_proc: process
    begin
        report "---- STARTING PRIME NUMBER SIMULATION ----";
        Inputs <= "0000";
        for i in 0 to 15 loop
            wait for 10 ns;

            -- Prime numbers in 4-bit: 2, 3, 5, 7, 11, 13
            if (Inputs = "0010" or Inputs = "0011" or 
                Inputs = "0101" or Inputs = "0111" or 
                Inputs = "1011" or Inputs = "1101") then
                assert (F = '1') report "Faulty Logic! Expected prime number output." severity error;
            else
                assert (F = '0') report "Faulty Logic! Expected non-prime number output." severity error;
            end if;

            Inputs <= Inputs + '1';  
        end loop;

        report "---- SIMULATION COMPLETE ----";
        wait;
    end process;

end Behavioral;