----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2023 08:08:21 PM
-- Design Name: 
-- Module Name: UC - Behavioral
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

entity UC is
Port (
        OpCode: in std_logic_vector(2 downto 0);
        RegDst: out std_logic;
        ExtOp: out std_logic;
        ALUSrc: out std_logic;
        Branch: out std_logic;
        Jump: out std_logic;
        ALUOp: out std_logic_vector(2 downto 0);
        MemWrite: out std_logic;
        MemToReg: out std_logic;
        RegWrite: out std_logic;
        BNE: out std_logic;
        BGTZ: out std_logic
 );
end UC;

architecture Behavioral of UC is

begin

process(OpCode)
begin
RegDst <= '0'; ExtOp <= '0'; ALUSrc <= '0';
Branch <= '0'; Jump <= '0'; ALUOp <= "000";
MemWrite <= '0'; MemToReg <= '0'; RegWrite <= '0';

case(OpCode) is
    when "000" =>                                       -- Tip R
        RegDst <= '1'; RegWrite <= '1'; ALUOp <= "000";  
    when "001" =>                                       -- ADDI
        RegWrite <= '1'; ALUSrc <= '1'; ExtOp <= '1'; ALUOp <= "001"; 
    when "010" =>                                       -- LW   
        RegWrite <= '1'; ALUSrc <= '1'; ExtOp <= '1'; MemToReg <= '1'; ALUOp <= "001";        
    when "011" =>                                       -- SW   
        MemWrite <= '1'; ALUSrc <= '1'; ExtOp <= '1'; ALUOp <= "001";    
    when "100" =>                                       -- BEQ (Branch)
        ExtOp <= '1'; Branch <= '1'; ExtOp <= '1'; ALUOp <= "010";   
    when "101" =>                                       -- BGTZ
        ExtOp <= '1'; BGTZ <= '1'; ALUOp <= "010";       
    when "110" =>                                       -- BNE
        ExtOp <= '1'; BNE <= '1'; ALUOp <= "010";
    when others =>  -- J
        Jump <= '1';
end case;
end process;

end Behavioral;
