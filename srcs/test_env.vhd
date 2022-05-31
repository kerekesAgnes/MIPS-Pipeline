----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2021 10:43:14 AM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is
--signals of IFetch
signal branch_address : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
signal jump_address : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
signal jmp : STD_LOGIC :='0';
signal PCSrc : STD_LOGIC :='0';
signal next_instruction_address : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
signal Instruction : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";

-- signals of IDecode
signal WD : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
signal RegWrite : STD_LOGIC :='0';
signal RegDst : STD_LOGIC :='0';
signal ExtOp : STD_LOGIC :='0';
signal rd1 : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
signal rd2 : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
signal ext_imm : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
signal func : STD_LOGIC_VECTOR(2 downto 0) := "000";
signal sa : STD_LOGIC :='0';
signal reg : STD_LOGIC_VECTOR(2 downto 0) := "000";

--signals of MainControl
signal ALUOp : STD_LOGIC_VECTOR(2 downto 0) := "000";
signal MemWrite : STD_LOGIC :='0';
signal MemtoReg : STD_LOGIC :='0';
signal ALUSrc : STD_LOGIC :='0';
signal Branch : STD_LOGIC :='0';
signal opcode : STD_LOGIC_VECTOR(2 downto 0) := "000";

--signals of ExecutionUnit
signal ALURes : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";
signal Zero : STD_LOGIC :='0';

--signals of MEM
signal MemData : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";

--signals of IF/ID
signal PC_IF_ID : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
signal Instruction_IF_ID : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";

--signals of ID/EX
signal ID_MemtoReg, ID_RegWrite, ID_MemWrite, id_branch, ID_AluSrc, id_sa  : STD_LOGIC :='0';
signal id_rd1, id_rd2, id_ext_imm, id_pc1 : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
signal id_func, id_rt, id_reg : STD_LOGIC_VECTOR(2 downto 0) := "000";
signal ID_AluOp : STD_LOGIC_VECTOR(2 downto 0) := "000";

--signals of Ex/Mem
signal Ex_MemtoReg, Ex_RegWrite, Ex_MemWrite, ex_branch, ex_zero  : STD_LOGIC :='0';
signal Ex_AluRes, ex_rd2, ex_branch_address : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
signal ex_reg : STD_LOGIC_VECTOR(2 downto 0) := "000";

--signals of MEM/WB
signal Mem_MemtoReg, Mem_RegWrite : STD_LOGIC :='0';
signal Mem_MemData, Mem_AluRes : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
signal mem_reg : STD_LOGIC_VECTOR(2 downto 0) := "000";

component MPG 
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : out STD_LOGIC);
end component MPG;

component SSD 
    Port ( digit0 : in STD_LOGIC_VECTOR (3 downto 0);
       digit1 : in STD_LOGIC_VECTOR (3 downto 0);
       digit2 : in STD_LOGIC_VECTOR (3 downto 0);
       digit3 : in STD_LOGIC_VECTOR (3 downto 0);
       clk : in STD_LOGIC;
       an : out STD_LOGIC_VECTOR (3 downto 0);
       cat : out STD_LOGIC_VECTOR (6 downto 0));
end component SSD;

component IFetch
    Port ( jump_address : in STD_LOGIC_VECTOR (15 downto 0);
       branch_address : in STD_LOGIC_VECTOR (15 downto 0);
       jmp : in STD_LOGIC;
       PCSrc : in STD_LOGIC;
       clk : in STD_LOGIC;
       pc1 : out STD_LOGIC_VECTOR(15 downto 0);
       Instruction : out STD_LOGIC_VECTOR(15 downto 0));
end component IFetch;

component IDecode
   Port ( clk : in STD_LOGIC;
        Instr : in STD_LOGIC_VECTOR (15 downto 0);
        WD : in STD_LOGIC_VECTOR (15 downto 0);
        RegWrite : in STD_LOGIC;
        RegDst : in STD_LOGIC;
        ExtOp : in STD_LOGIC;
        reg_in : in STD_LOGIC_VECTOR(2 downto 0);
        rd1 : out STD_LOGIC_VECTOR (15 downto 0);
        rd2 : out STD_LOGIC_VECTOR (15 downto 0);
        ext_imm : out STD_LOGIC_VECTOR (15 downto 0);
        func : out STD_LOGIC_VECTOR (2 downto 0);
        sa : out STD_LOGIC;
        wb_reg_address : out STD_LOGIC_VECTOR(2 downto 0));
end component IDecode;

component ExecutionUnit
Port ( rd1 : in STD_LOGIC_VECTOR (15 downto 0);
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
           PCinc : in STD_LOGIC_VECTOR (15 downto 0);
           func : in STD_LOGIC_VECTOR (2 downto 0);
           sa : in STD_LOGIC;
           ALUSrc : in STD_LOGIC;
           ALUOp : in STD_LOGIC_VECTOR(2 downto 0);
           BranchAddress : out STD_LOGIC_VECTOR (15 downto 0);
           ALURes : out STD_LOGIC_VECTOR (15 downto 0);
           Zero : out STD_LOGIC);
end component ExecutionUnit;

component MEM 
    Port ( clk : in STD_LOGIC;
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemWrite : in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           ALURes : in STD_LOGIC_VECTOR (15 downto 0));
end component MEM;

component MainControl 
    Port ( Instr : in STD_LOGIC_VECTOR (2 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           Branch : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR (2 downto 0);
           MemWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end component MainControl;

begin
opcode <= Instruction_IF_ID(15 downto 13);
jump_address <= PC_IF_ID(15 downto 13) & Instruction_IF_ID(12 downto 0);

--main unit
inst_IF: IFetch port map (jump_address, ex_branch_address, jmp, PCSrc, clk, next_instruction_address, Instruction);
inst_ID: IDecode port map (clk, Instruction_IF_ID, WD, Mem_RegWrite, RegDst, ExtOp, mem_reg, rd1, rd2, ext_imm, func, sa, reg); 
inst_Ex: ExecutionUnit port map(id_rd1, id_rd2, id_ext_imm, id_pc1, id_func, id_sa, ID_ALUSrc, ID_ALUOp, ex_branch_address, ALURes, Zero);
inst_MEM: MEM port map(clk, ex_rd2, Ex_MemWrite, MemData, Ex_ALURes);
inst_Main: MainControl port map (opcode, RegDst, ExtOp, ALUSrc, Branch, jmp, ALUOp, MemWrite, MemtoReg, RegWrite);

--branch and gate
PCSrc <= ex_branch and Zero;

--write back
WD <= Mem_MemData when Mem_MemtoReg='1' else
      Mem_AluRes;

--Registru IF/ID
process(clk)
begin
    if clk'event and clk='1' then
        PC_IF_ID <= next_instruction_address;
        Instruction_IF_ID <= Instruction;
    end if;
end process;

--Registru ID/EX
process(clk)
begin
    if clk'event and clk='1' then
        ID_MemtoReg <= MemtoReg;
        ID_RegWrite <= RegWrite;
        ID_MemWrite <= MemWrite;
        id_branch <= branch;
        ID_AluOp <= AluOp;
        ID_AluSrc <= AluSrc;
        id_pc1 <= PC_IF_ID;
        id_rd1 <= rd1;
        id_rd2 <= rd2;
        id_ext_imm <= ext_imm;
        id_func <= func;
        id_sa <= sa;
        id_reg <= reg;
    end if;
end process;

--Registru Ex/MEM
process(clk)
begin
    if clk'event and clk='1' then
      branch_address <= ex_branch_address;
      Ex_MemtoReg <= ID_MemtoReg;
      Ex_RegWrite <= ID_RegWrite;
      Ex_MemWrite <= ID_MemWrite;
      ex_branch <= id_branch;
      ex_rd2 <= id_rd2;
      Ex_AluRes <= AluRes;
      ex_reg <= id_reg;
    end if;
end process;

--Registru MEM/WB
process(clk)
begin
    if clk'event and clk='1' then
      branch_address <= ex_branch_address;
      Mem_MemtoReg <= Ex_MemtoReg;
      Mem_RegWrite <= Ex_RegWrite;
      Mem_MemData <= MemData;
      Mem_AluRes <= Ex_AluRes;
      mem_reg <= ex_reg;
    end if;
end process;

end Behavioral;
