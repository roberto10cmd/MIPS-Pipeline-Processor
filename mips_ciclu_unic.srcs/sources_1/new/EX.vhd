----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/12/2023 12:28:03 PM
-- Design Name: 
-- Module Name: EX - Behavioral
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

entity EX is
Port ( 
    PCinc: in std_logic_vector(15 downto 0);
    branch_address: out std_logic_vector(15 downto 0);
    RD1: in std_logic_vector(15 downto 0);
    RD2: in std_logic_vector(15 downto 0);
    ALUSrc: in std_logic;
    Ext_Imm: in std_logic_vector(15 downto 0);
    --sa: in std_logic;
    func: in std_logic_vector(2 downto 0);
    ALUOp: in std_logic_vector(2 downto 0);
    Zero: out std_logic;
    ALURes: out std_logic_vector(15 downto 0);
    RegDst: in std_logic;
    rt: in std_logic_vector(2 downto 0);
    rd: in std_logic_vector(2 downto 0);
    rWA: out std_logic_vector(2 downto 0)
);
end EX;

architecture Behavioral of EX is

signal A: std_logic_vector(15 downto 0);
signal B: std_logic_vector(15 downto 0);
signal C: std_logic_vector(15 downto 0);
signal ALUCtrl: std_logic_vector (2 downto 0);

begin

-- mux mic
process(ALUSrc)
begin
if (ALUSrc = '0') then
    B <= RD2;
else 
    B <= Ext_Imm;
end if;
end process;

-- ALU Control
process(ALUOp, func)
begin
case ALUOp is
    when "000" =>   -- tipR
        case func is
            when "000" => ALUCtrl <= "000";  -- +
            when "001" => ALUCtrl <= "001";  -- -
            when "010" => ALUCtrl <= "010";  -- <<
            when "011" => ALUCtrl <= "011";  -- >>
            when "100" => ALUCtrl <= "100";  -- &
            when "101" => ALUCtrl <= "101";  -- |
            when "110" => ALUCtrl <= "110";  -- ^
            when others => ALUCtrl <= "111";  -- >> cu semn
        end case;
    when "001" => ALUCtrl <= "000";  -- +   addi, lw, sw
    when "010" => ALUCtrl <= "001";  -- -   
    --when "100" => ALUCtrl <= "001";  -- -   beq
    --when "101" => ALUCtrl <= "001";  -- -    bgtz
    --when "110" => ALUCtrl <= "001";  -- -   bne
    when others => ALUCtrl <= "000";  -- +
end case;
end process;

-- ALU
process(ALUCtrl)
begin
case ALUCtrl is
    when "000" => C <=  A + B; -- +
    when "001" => C <=  A - B; -- -
    when "010" =>              -- <<
        case A is    
            when x"0001" => C <= B(14 downto 0) & '0';
            when others => C <= B;
        end case;
    when "011" => C <= '0' & B(15 downto 1);        -- >>
    when "100" => C <= A and B;                     -- and
    when "101" => C <= A or B;                      -- or
    when "110" => C <= A xor B;                     -- xor
    when others => 
    -- CU SEMN
        case A is
            when x"0001" => C <= B(15) & B(15 downto 1);
            when others => C <= B;
        end case;
end case;
end process;

A <= RD1;
ALURes <= C;
Zero <= '1' when C = x"0000" else  '0'; 
branch_address <= Ext_Imm + PCinc;

process(RegDst)
begin
case RegDst is
when '1' => rWA<=rd;
when '0' => rWA<=rt;
end case;
end process;


end Behavioral;