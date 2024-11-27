----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/19/2023 12:50:28 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
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

entity MEM is
Port (
    signal clk: in std_logic;
    signal en: in std_logic;
    signal MemWrite: in std_logic;
    signal address: in std_logic_vector(15 downto 0);
    signal data: out std_logic_vector(15 downto 0);
    signal ALUResOut: out std_logic_vector(15 downto 0);
    signal WD: in std_logic_vector(15 downto 0)
);
end MEM;

architecture Behavioral of MEM is

type celula is array (0 to 256) of std_logic_vector(15 downto 0);
signal RAM: celula:=(x"0001", x"0002", x"0002", x"0003", x"0004", x"0005", x"0006",
                     x"0007", x"0008", x"0009",others=>"0");
begin

process(clk)
begin
    if clk'event and clk='1' then
        if en = '1' and MemWrite = '1' then
            RAM(conv_integer(address)) <= WD;            
        end if;
    end if;
end process;

data <= RAM(conv_integer(address));
ALUResOut<=address;

end Behavioral;
