----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2023 02:19:39 PM
-- Design Name: 
-- Module Name: IF - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity InstrFetch is
Port(
    signal clk: in std_logic;
    signal we: in std_logic;
    signal reset: in std_logic;
    signal branch_adress: in std_logic_vector(15 downto 0);
    signal jump_adress: in std_logic_vector(15 downto 0);
    signal jump: in std_logic;
    signal PCSrc: in std_logic;
    signal pcOut: out std_logic_vector(15 downto 0);
    signal instruction: out std_logic_vector(15 downto 0)
);
end InstrFetch;

architecture Behavioral of InstrFetch is

signal program_counter: std_logic_vector(15 downto 0);
signal mux1: std_logic_vector(15 downto 0);
signal mux2: std_logic_vector(15 downto 0);
signal pc1: std_logic_vector(15 downto 0);

type celula is array(0 to 40) of std_logic_vector(15 downto 0);
signal memorie: celula:=( 
B"000_000_000_001_0_000",-- ADD $1, $0, $0  --0    X"0010"
B"001_000_100_0000101", --ADDDI $4,$0,5     --1    X"2205"
B"000_000_000_010_0_000",-- ADD $2, $0, $0  --2    X"0020"
B"000_000_000_101_0_000",-- ADD $5, $0, $0  --3    X"0050"
B"100_001_100_0001111",  -- BEQ $1, $4, 15  --4    X"860F"
B"000_000_000_000_0_000",-- ADD $0, $0, $0  --5    x"0000"
B"000_000_000_000_0_000",-- ADD $0, $0, $0  --6    x"0000"
B"000_000_000_000_0_000",-- ADD $0, $0, $0  --7    x"0000"
B"010_010_011_0000000",  -- LW  $3, 0($2)   --8    X"4980"
B"000_000_000_000_0_000",-- ADD $0, $0, $0  --9    x"0000" 
B"000_000_000_000_0_000",-- ADD $0, $0, $0  --10    x"0000"
B"000_010_011_011_1_010",-- SLL $3,$3,2     --11   X"09BA"
B"011_010_011_0000000",  -- SW $3, 0($2)    --12    X"6980"
B"000_000_000_000_0_000",-- ADD $0, $0, $0  --13   X"0000" 
B"000_000_000_000_0_000",-- ADD $0, $0, $0  --14   X"0000"
B"000_101_011_101_0_000",-- ADD $5, $5, $3  --15   X"15D0"
B"001_010_010_0000001",  -- ADDI $2, $2, 1  --16   X"2901"
B"001_001_001_0000001",  -- ADDI $1, $1, 1  --17   X"2481"
B"111_0000000000100",    -- J 4             --18   X"E004"
B"000_000_000_000_0_000",-- ADD $0, $0, $0  --19   X"0000" 
B"011_010_101_0001010",  -- SW $5,   10($2) --20   X"628A"  

---- Fibonacci
--B"001_000_001_0000000", -- X"2080" -- ADDI $1, $0, 0  --1
--B"001_000_010_0000001", -- X"2101" -- ADDI $2, $0, 1  --2
--B"001_000_011_0000000", -- X"2180" -- ADDI $3, $0, 0  --3
--B"001_000_100_0000001", -- X"2201" -- ADDI $4, $0, 1  --4
--B"000_000_000_000_0_000",-- ADD $0, $0, $0  --5    x"0000"
--B"011_011_001_0000000", -- X"6C80" -- SW $1, 0($3)  --5
--B"011_100_010_0000000", -- X"7100" -- SW $2, 0($4)  --6
--B"010_011_001_0000000", -- X"4C80" -- LW $1, 0($3)  --7
--B"010_100_010_0000000", -- X"5100" -- LW $2, 0($4)  --8
--B"000_000_000_000_0_000",-- ADD $0, $0, $0  --5    x"0000"
--B"000_000_000_000_0_000",-- ADD $0, $0, $0  --5    x"0000"
--B"000_001_010_101_0_000", -- X"0550" -- ADD $5, $1, $2  --9
--B"000_000_010_001_0_000", -- X"0110" -- ADD $1, $0, $2  --10
--B"000_000_000_000_0_000",-- ADD $0, $0, $0  --5    x"0000"
--B"000_000_101_010_0_000", -- X"02A0" -- ADD $2, $0, $3  --11
--B"111_0000000001011", -- X"E008" -- J 8  --12
others => X"0000" --NoOp (ADD $0, $0, $0)  --13);
);
begin

process(clk)
begin
if (reset = '1') then
    program_counter <= x"0000";
elsif rising_edge(clk) and we='1' then
    program_counter <= mux2;
end if;
end process;

process(PCSrc, branch_adress, program_counter)
begin
if PCSrc = '1' then
    mux1 <= branch_adress;
else
    mux1 <= pc1;
end if;
end process;

process(jump, mux1, jump_adress)
begin
if jump = '1' then
    mux2 <= jump_adress;
else
    mux2 <= mux1;
end if;
end process;

pc1 <= program_counter + 1;
pcOut <= program_counter;
instruction <= memorie(conv_integer(unsigned(program_counter(3 downto 0))));

end Behavioral;

