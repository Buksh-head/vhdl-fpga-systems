library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity greaterorlessthan is
  Port (
    A  : in  std_logic_vector(7 downto 0);
    B  : in  std_logic_vector(7 downto 0);
    gt : out std_logic;  -- A > B
    lt : out std_logic;  -- A < B
    eq : out std_logic   -- A = B
  );
end greaterorlessthan;

architecture Behavioral of greaterorlessthan is
begin
  process(A, B)
  begin
    if unsigned(A) > unsigned(B) then
      gt <= '1';
      lt <= '0';
      eq <= '0';
    elsif unsigned(A) < unsigned(B) then
      gt <= '0';
      lt <= '1';
      eq <= '0';
    else
      gt <= '0';
      lt <= '0';
      eq <= '1';
    end if;
  end process;
end Behavioral;
