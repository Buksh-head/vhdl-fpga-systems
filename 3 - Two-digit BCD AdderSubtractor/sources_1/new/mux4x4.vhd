----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.08.2025 21:18:32
-- Design Name: 
-- Module Name: mux4x4 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux4x4 is
  port (
    in3,in2,in1,in0 : in  std_logic_vector(3 downto 0);
    sel             : in  std_logic_vector(1 downto 0);
    y               : out std_logic_vector(3 downto 0)
  );
end;

architecture rtl of mux4x4 is
begin
  with sel select y <=
    in3 when "11",
    in2 when "10",
    in1 when "01",
    in0 when others;  -- "00"
end;
