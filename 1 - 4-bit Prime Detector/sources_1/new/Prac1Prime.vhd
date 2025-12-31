----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.07.2025 21:56:00
-- Design Name: 
-- Module Name: Prac1Prime - Dataflow
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

entity Prac1Prime is
    Port ( A : in std_logic;
           B : in std_logic;
           C : in std_logic;
           D : in std_logic;
           F : out std_logic);
end Prac1Prime;

architecture Dataflow of Prac1Prime is
begin
    
    F <= (not A and not B and C) or
         (not C and B and D) or
         (not B and C and D) or
         (not A and C and D) after 10 ns;

end Dataflow;
