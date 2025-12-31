----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.08.2025 14:39:26
-- Design Name: 
-- Module Name: FullAdder - Behavioral
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

entity FullAdder is
port (
    A, B, Cin: in std_logic;
    S, Cout: out std_logic
);
end FullAdder;
 
architecture Dataflow of FullAdder is
 
begin
 
S <= A xor B xor Cin;
Cout <= ((A xor B) and Cin) or (A and B);
 
end Dataflow;
