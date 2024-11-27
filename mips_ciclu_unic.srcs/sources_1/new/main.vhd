----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/21/2023 04:55:22 PM
-- Design Name: 
-- Module Name: main - Behavioral
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

entity main is
Port (
    clk: in STD_LOGIC;
    btn: in std_logic_vector(4 downto 0);
    sw: in std_logic_vector(15 downto 0);
    an: out STD_LOGIC_VECTOR(3 downto 0):=(others=>'0');
    cat: out STD_LOGIC_VECTOR(6 downto 0):=(others=>'0');
    led: out STD_LOGIC_VECTOR(15 downto 0):=(others=>'0')
 );
end main;


architecture Behavioral of main is

--semnale pt MIPS_PIPELINE

--IF/ID
signal IF_INSTR: std_logic_vector( 15 downto 0):=x"0000";
signal IF_PCplus1:std_logic_vector( 15 downto 0):=x"0000";

--ID/EX
signal ID_REGDST: std_logic;
signal ID_ALUSRC: std_logic;
signal ID_BRANCH:std_logic;
signal ID_ALUOP:std_logic_vector(2 downto 0);
signal ID_MEMWR: std_logic;
signal ID_MEM2R: std_logic;
signal ID_REGWR: std_logic;
signal ID_RD1: std_logic_vector( 15 downto 0);
signal ID_RD2:std_logic_vector( 15 downto 0);
signal ID_EXT_IMM:std_logic_vector( 15 downto 0);   
signal ID_FUNC:std_logic_vector( 2 downto 0);
signal ID_SA: std_logic;
signal ID_RD:std_logic_vector( 2 downto 0);
signal ID_RT:std_logic_vector( 2 downto 0);
signal ID_PCplus1:std_logic_vector( 15 downto 0);

--EX/MEM

signal EX_BRANCH: std_logic;
signal EX_MEMWR: std_logic;
signal EX_MEM2R: std_logic;
signal EX_REGWR: std_logic;
signal EX_ZERO:std_logic;
signal EX_BRADDR:std_logic_vector( 15 downto 0):=x"0000";
signal EX_ALURES:std_logic_vector( 15 downto 0):=x"0000";
signal EX_RD:std_logic_vector( 2 downto 0):="000";
signal EX_RD2:std_logic_vector( 15 downto 0):=x"0000";

--MEM/WB

signal MEM_MEM2R: std_logic;
signal MEM_REGWR: std_logic;
signal MEM_ALURES: std_logic_vector( 15 downto 0):=x"0000";
signal MEM_MEMDATA:std_logic_vector( 15 downto 0):=x"0000";
signal MEM_RD: std_logic_vector(2 downto 0):="000";


--IF
signal enableIF: std_logic;
signal resetIF: std_logic;
--signal branchAdrSignal: std_logic_vector(15 downto 0);
signal jumpAdrSignal: std_logic_vector(15 downto 0) := x"0000";
signal PCSrcSignal: std_logic;
signal instructionSignal: std_logic_vector(15 downto 0) := x"0000";
signal nextInstrAdrSignal: std_logic_vector(15 downto 0) := x"0000";
signal instrSSD: std_logic_vector(15 downto 0):=(others=>'0');

--UC
signal RegDst: std_logic;
signal ExtOp: std_logic;
signal ALUSrc: std_logic;
signal Branch: std_logic;
signal Jump: std_logic;
signal ALUOp: std_logic_vector(2 downto 0);
signal MemWrite: std_logic;
signal MemToReg: std_logic;
signal RegWrite: std_logic;
signal BNE: std_logic;
signal BGTZ: std_logic;

-- ID
signal RD1: std_logic_vector(15 downto 0):=(others=>'0');
signal RD2: std_logic_vector(15 downto 0):=(others=>'0');
signal WD: std_logic_vector(15 downto 0):=(others=>'0');
signal Ext_Imm: std_logic_vector(15 downto 0):=(others=>'0');
signal func: std_logic_vector(2 downto 0):=(others=>'0');
signal sa: std_logic;
signal rt: std_logic_vector(2 downto 0);
signal rd: std_logic_vector(2 downto 0);
signal WA: std_logic_vector(2 downto 0);


--EX
signal ALURes: std_logic_vector(15 downto 0):=(others=>'0');
signal Zero: std_logic;
signal BranchAddressEX:std_logic_vector(15 downto 0);
--MEM
signal MemData: std_logic_vector(15 downto 0):=(others=>'0');
signal EnableWen: std_logic;
signal rWAsignal: std_logic_vector(2 downto 0);
signal ALUResOut: std_logic_vector(15 downto 0);

component debouncer is
Port ( clk: in STD_LOGIC;
       btn: in STD_LOGIC;
       rez: out STD_LOGIC);
end component;

component UC is
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
end component;

component SSD is
Port ( clk: in STD_LOGIC;
       date: in std_logic_vector(15 downto 0);
       an: out STD_LOGIC_VECTOR(3 downto 0):=(others=>'0');
       cat: out STD_LOGIC_VECTOR(6 downto 0):=(others=>'0')
);
end component;

component InstrFetch is
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
end component;


component ID is
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
end component;

component EX is
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
end component;

component MEM is
Port (
    signal clk: in std_logic;
   signal en: in std_logic;
   signal MemWrite: in std_logic;
   signal address: in std_logic_vector(15 downto 0);
   signal data: out std_logic_vector(15 downto 0);
   signal ALUResOut: out std_logic_vector(15 downto 0);
   signal WD: in std_logic_vector(15 downto 0)
);
end component;


begin

MPG1: component debouncer port map(clk,btn(0),enableIF); 
MPG2: component debouncer port map(clk,btn(1),resetIF);
display: component SSD port map(clk,instrSSD,an,cat);
IFf: component InstrFetch port map(clk,enableIF,resetIF, EX_BRADDR,jumpAdrSignal, Jump,PCSrcSignal,nextInstrAdrSignal,instructionSignal);

IDD: component ID port map(clk, enableIF,MEM_REGWR,IF_INSTR, ExtOp, WD,RD1,RD2,MEM_RD,Ext_Imm, func,sa,rt,rd);
UCC: component UC port map(IF_INSTR(15 downto 13), RegDst, ExtOp,ALUSrc, Branch, Jump, ALUOp,MemWrite, MemToReg,RegWrite,BNE,BGTZ);
EXX: component EX port map(ID_PCplus1,BranchAddressEX, ID_RD1,ID_RD2, ID_ALUSRC,ID_EXT_IMM,ID_FUNC,ID_ALUOp,Zero,ALURes,ID_REGDST,ID_RT,ID_RD,rWAsignal);           
MEMM: component MEM port map(clk, enableIF,EX_MEMWR ,EX_ALURES, MemData,ALUResOut,EX_RD2);

process(clk)
begin
if rising_edge(clk) then
  if enableIF='1' then
  IF_INSTR<=instructionSignal;
  IF_PCplus1<=nextInstrAdrSignal;
  --ID_EX
  ID_PCplus1<=IF_PCplus1;
  ID_RD1<=RD1;
  ID_RD2<=RD2;
  ID_EXT_IMM<=Ext_Imm;
  ID_SA<=sa;
  ID_FUNC<=func;
  ID_RT<=rt;
  ID_RD<=rd;
  ID_MEM2R<=MemToReg;
  ID_REGWR<=RegWrite;
  ID_MEMWR<=MemWrite;
  ID_BRANCH<=Branch;
  ID_ALUSRC<=ALUSrc;
  ID_ALUOP<=ALUOp;
  ID_REGDST<=RegDst;
  --EX_MEM
  EX_BRADDR<=BranchAddressEX;
  EX_ZERO<=Zero;
  EX_ALURES<=ALURes;
  EX_RD2<=ID_RD2;
  EX_RD<=rWAsignal;
  EX_MEM2R<=ID_MEM2R;
  EX_REGWR<=ID_REGWR;
  EX_MEMWR<=ID_MEMWR;
  EX_BRANCH<=ID_MEMWR;
  --MEM_WB
  MEM_MEMDATA<=MemData;
  MEM_ALURES<=ALUResOut;
  MEM_RD<=EX_RD;
  MEM_MEM2R<=EX_MEM2R;
  MEM_REGWR<=EX_REGWR;
  end if;
end if;
end process;


-- SSD cu ID
process(clk, sw(7 downto 5))
begin
if clk='1' and clk'event then
    case sw(7 downto 5) is
    when "000" => instrSSD <= instructionSignal;
    when "001" => instrSSD <= nextInstrAdrSignal;
    when "010" => instrSSD <= ID_RD1;
    when "011" => instrSSD <= ID_RD2;
    when "100" => instrSSD <= ID_EXT_IMM;
    when "101" => instrSSD <= ALURes;
    when "110" => instrSSD <= MemData;
    when "111" => instrSSD <=WD;
    end case;
end if;
end process;

process(MEM_MEM2R)
begin
case MEM_MEM2R is
    when '0' => WD <=MEM_ALURES;
    when '1' => WD <=MEM_MEMDATA;
end case;
end process;

-- branch control
PCSrcSignal <= EX_ZERO and EX_BRANCH;
-- jump address
jumpAdrSignal <=  IF_PCplus1(15 downto 13) & IF_INSTR(12 downto 0);

--LED
led(0)<=Jump;
led(1)<=Branch;
led(2)<=MemtoReg;
led(3)<=MemWrite;
led(4)<=ExtOp;
led(5)<=ALUSrc;
led(6)<=RegWrite;
led(7)<=RegDst;
led(15 downto 13)<=AluOp;
led(11)<=Zero;

end Behavioral;
