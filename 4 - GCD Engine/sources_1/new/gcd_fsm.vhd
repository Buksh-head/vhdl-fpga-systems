----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.09.2025 18:50:53
-- Design Name: 
-- Module Name: gcd_fsm - Behavioral
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

entity gcd_fsm is
  Port (
    clk       : in  std_logic;
    reset     : in  std_logic;
    btn_save  : in  std_logic;
    gt        : in  std_logic;  -- A > B
    lt        : in  std_logic;  -- A < B
    eq        : in  std_logic;  -- A = B
    sel_A     : out std_logic;  -- Select input for A (0: from switches, 1: from A-B)
    sel_B     : out std_logic;  -- Select input for B (0: from switches, 1: from B-A)
    en_A      : out std_logic;  -- Enable for register A
    en_B      : out std_logic;  -- Enable for register B
    finished  : out std_logic   -- Calculation complete flag
  );
end gcd_fsm;

architecture Behavioral of gcd_fsm is
  -- Define state type
  type state_type is (IDLE, LOAD, CHECK, SUB_A_B, SUB_B_A, FINISH);
  
  -- State signals
  signal state, next_state : state_type;

begin
  -- State register
  process(clk, reset)
  begin
    if reset = '1' then
      state <= IDLE;
    elsif rising_edge(clk) then
      state <= next_state;
    end if;
  end process;

  -- Next state logic
  process(state, btn_save, gt, lt, eq)
  begin
    -- Default next state to prevent latches
    next_state <= state;
    
    case state is
      when IDLE =>
        if btn_save = '1' then
          next_state <= LOAD;
        else
          next_state <= IDLE;
        end if;

      when LOAD =>
        next_state <= CHECK;

      when CHECK =>
        if eq = '1' then
          next_state <= FINISH;
        elsif gt = '1' then
          next_state <= SUB_A_B;
        else
          next_state <= SUB_B_A;
        end if;

      when SUB_A_B =>
        next_state <= CHECK;

      when SUB_B_A =>
        next_state <= CHECK;

      when FINISH =>
        if btn_save = '1' then
          next_state <= LOAD;  -- Start a new calculation when save button is pressed
        else
          next_state <= FINISH; -- hold result
        end if;

      when others =>
        next_state <= IDLE;
    end case;
  end process;

  -- Output logic (Moore FSM)
  process(state)
  begin
    -- default values
    sel_A <= '0'; 
    sel_B <= '0';
    en_A <= '0'; 
    en_B <= '0';
    finished <= '0';

    case state is
      when IDLE =>
        null;

      when LOAD =>
        sel_A <= '0'; 
        sel_B <= '0'; -- load switches
        en_A <= '1'; 
        en_B <= '1';

      when CHECK =>
        null; -- only look at comparator

      when SUB_A_B =>
        sel_A <= '1'; 
        en_A <= '1'; -- load A := A-B

      when SUB_B_A =>
        sel_B <= '1'; 
        en_B <= '1'; -- load B := B-A

      when FINISH =>
        finished <= '1'; -- signal completion
    end case;
  end process;

end Behavioral;
