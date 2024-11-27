
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/02/2023 09:02:20 PM
-- Design Name: 
-- Module Name: AC - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debouncer is
Port ( clk: in STD_LOGIC;
       btn: in STD_LOGIC;
       rez: out STD_LOGIC);
end debouncer;

architecture Behavioral of debouncer is

signal counter: std_logic_vector (15 downto 0);

signal Q1: std_logic;
signal Q2: std_logic;
signal Q3: std_logic;

begin

process(clk)
begin

if clk = '1' and clk'event then
    
    if counter = "1111111111111111" then
        Q1 <= btn;
    end if;
    Q2 <= Q1;
    Q3 <= Q2;
    counter<=counter+1;
end if;

end process;

rez <= not(Q3) and Q2;

end Behavioral;
