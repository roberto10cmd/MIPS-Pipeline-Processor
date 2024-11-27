----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2023 12:16:03 PM
-- Design Name: 
-- Module Name: ID - Behavioral
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

entity ID is
Port ( 
    clk: in std_logic;
    en: in std_logic;
    RegWrite: in std_logic;
    Instr: in std_logic_vector(15 downto 0);
    ExtOp: in std_logic;
    WD: in std_logic_vector(15 downto 0);
    RD1: out std_logic_vector(15 downto 0);
    RD2: out std_logic_vector(15 downto 0);
    WA: in std_logic_vector(2 downto 0);
    Ext_Imm: out std_logic_vector(15 downto 0);
    func: out std_logic_vector(2 downto 0);
    sa: out std_logic;
    rt: out std_logic_vector(2 downto 0);
    rd: out std_logic_vector(2 downto 0)
);
end ID;

architecture Behavioral of ID is

signal RA1: std_logic_vector(2 downto 0);
signal RA2: std_logic_vector(2 downto 0);

type reg is array (0 to 7) of std_logic_vector(15 downto 0);
signal reg_file: reg :=(x"0000", 
                        x"0000",
                        x"0000",
                        x"0000",
                        x"0000", 
                        x"0001", 
                        x"0101", 
                        others=>"0");

begin

--process(clk, Instr)
--begin
--if falling_edge(clk) then
    RA1 <= Instr(12 downto 10);
    RA2 <= Instr(9 downto 7);
--end if;
--end process;

-- extindere cu 0 / 1
process(clk, Instr, ExtOp)
begin
case(ExtOp) is
    when '0' => Ext_Imm <= "000000000" & Instr(6 downto 0);
    when '1' => Ext_Imm <= Instr(6)&Instr(6)&Instr(6)&Instr(6)&Instr(6) 
                          &Instr(6)&Instr(6)&Instr(6)&Instr(6)& Instr(6 downto 0);
end case;
end process;

-- WA si WD
process(clk)
begin
if falling_edge(clk) then
    if en='1' and RegWrite = '1' then
        reg_file(conv_integer(unsigned(WA))) <= WD;
    end if;
end if;
end process;

-- extragere func & sa
func <= Instr(2 downto 0);
sa <= Instr(3);

-- citire RF
RD1 <= reg_file(conv_integer(unsigned(RA1)));
RD2 <= reg_file(conv_integer(unsigned(RA2)));

--iesire rt/rd
rt<=Instr(9 downto 7);
rd<=Instr(6 downto 4);
end Behavioral;
