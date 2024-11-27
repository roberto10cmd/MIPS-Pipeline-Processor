----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2023 02:15:01 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
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

entity SSD is
Port ( clk: in STD_LOGIC;
       date: in std_logic_vector(15 downto 0);
       an: out STD_LOGIC_VECTOR(3 downto 0):=(others=>'0');
       cat: out STD_LOGIC_VECTOR(6 downto 0):=(others=>'0')
);
end SSD;

architecture Behavioral of SSD is

signal counter: std_logic_vector(15 downto 0):=(others=>'0');
signal hexa: std_logic_vector (3 downto 0):=(others=>'0');

begin

process(clk)
begin
if clk = '1' and clk'event then
    counter <= counter + 1;
end if;
end process;

process(counter, date)
begin 
case counter(15 downto 14) is
    when "00" => an <= "0111"; hexa <= date(15 downto 12);
    when "01" => an <= "1011"; hexa <= date(11 downto 8);
    when "10" => an <= "1101"; hexa <= date(7 downto 4);
    when "11" => an <= "1110"; hexa <= date(3 downto 0);
end case;
end process;

process (hexa)
begin 
case (hexa) is
    when "0001" => cat <= "1111001";    --1
    when "0010" => cat <= "0100100";    --2
    when "0011" => cat <= "0110000";    --3
    when "0100" => cat <= "0011001";    --4
    when "0101" => cat <= "0010010";    --5
    when "0110" => cat <= "0000010";    --6
    when "0111" => cat <= "1111000";    --7
    when "1000" => cat <= "0000000";    --8
    when "1001" => cat <= "0010000";    --9
    when "1010" => cat <= "0001000";    --A
    when "1011" => cat <= "0000011";    --b
    when "1100" => cat <= "1000110";    --C
    when "1101" => cat <= "0100001";    --d
    when "1110" => cat <= "0000110";    --E
    when "1111" => cat <= "0001110";    --F
    when others => cat <= "1000000";    --0
 end case;
end process;

end Behavioral;
