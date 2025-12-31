library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RCAdder is
  generic (
    width : positive := 4
  );
  port (
    Cin  : in  std_logic;
    A,B  : in  std_logic_vector(width-1 downto 0);
    S    : out std_logic_vector(width-1 downto 0);
    Cout : out std_logic
  );
end RCAdder;

architecture Structural of RCAdder is
  component FullAdder is
    port (
      A, B, Cin : in  std_logic;
      S, Cout   : out std_logic
    );
  end component;

  signal C : std_logic_vector(width downto 0);
begin
  C(0) <= Cin;

  gen_adders : for i in 0 to width-1 generate
    fa : FullAdder
      port map (
        A   => A(i),
        B   => B(i),
        Cin => C(i),
        S   => S(i),
        Cout=> C(i+1)
      );
  end generate gen_adders;

  Cout <= C(width);
end Structural;
