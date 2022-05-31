----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2021 11:20:23 AM
-- Design Name: 
-- Module Name: IFetch - Behavioral
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

entity IFetch is
    Port ( jump_address : in STD_LOGIC_VECTOR (15 downto 0);
           branch_address : in STD_LOGIC_VECTOR (15 downto 0);
           jmp : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           clk : in STD_LOGIC;
           pc1 : out STD_LOGIC_VECTOR(15 downto 0);
           Instruction : out STD_LOGIC_VECTOR(15 downto 0));
end IFetch;

architecture Behavioral of IFetch is
signal pc_in : std_logic_vector(15 downto 0) := "0000000000000000";
signal pc_out : std_logic_vector(15 downto 0):= "0000000000000000";
signal mux1_out : std_logic_vector(15 downto 0):= "0000000000000000";
signal sum : std_logic_vector(15 downto 0) := "0000000000000000";

--ROM
type rom is array(0 to 255) of std_logic_vector(15 downto 0);
signal r_rom : rom := (

--PROGRAM DE TEST
--B"001_001_010_0000010",   -- addi $2, $1, 2       $2=2
--B"001_000_000_0000000",
--B"001_000_000_0000000",
--B"001_000_000_0000000",
--B"001_001_100_0000010",   -- addi $4, $1, 2       $2=2 
--B"001_000_000_0000000",
--B"001_000_000_0000000",
--B"001_000_000_0000000",
--B"101_010_011_0000010",   -- andi $3 $2, 2      $3=2
--B"110_010_011_0000100",   -- ori $3, $2, 4      $3=6
--B"000_001_010_011_0_000", -- add $3, $1, $2     $3=2
--B"000_010_000_101_1_011", -- srl $5, $2, 1      $5=1
--B"000_100_010_111_0_100", -- and $7, $4, $2     $7=2
--B"000_100_010_110_0_101", -- or $6, $4, $2      $6=2
--B"100_010_100_0000001",   -- beq $2, $4, 1   
--B"001_000_101_0000101",   -- addi $5, $0, 5     $5=5     
--B"000_100_010_111_0_001", -- sub $7, $4, $2     $7=2 
--B"000_010_100_101_0_110", -- xor $5, $2, $4     $5=4
--B"000_100_010_111_0_111", -- sllv $7, $4, $2    $7=16 (10)
--B"011_001_010_0000001",   -- sw $2, 1($1)       M[1]=2
--B"001_000_000_0000000",
--B"001_000_000_0000000",
--B"001_000_000_0000000",
--B"010_001_110_0000001",   -- lw $6, 1($1)       $6=2

-- $2: even numbers 
-- $3: odd numbers
B"001_000_001_0000000",   -- addi $1, $0, 0      -0 $1=0 
B"001_000_000_0000000",
B"001_000_000_0000000",
B"001_000_000_0000000",
B"001_001_001_0000001",   -- addi $1, $1, 1      -1 $1=1
B"001_000_000_0000000",
B"001_000_000_0000000",
B"001_000_000_0000000",
B"000_001_000_010_1_010", -- sll $2, $1, 1       -2 $2=2
B"001_000_000_0000000",
B"001_000_000_0000000",
B"001_000_000_0000000",
B"001_010_011_0000001",   -- addi $3, $2, 1      -3 $3=3
B"001_000_000_0000000",
B"001_000_000_0000000",
B"001_000_000_0000000",
B"111_0000000000100",     -- J 4                 -4

others => X"0000"         --NoOp (add $0, $0, $0)
);

begin

--Program Counter
process(clk)
begin
    if clk'event and clk='1' then
         pc_out <= pc_in;
    end if;
end process;

--ROM
Instruction <= r_rom(conv_integer(pc_out));       

--mux1
mux1_out <= branch_address when PCSrc='1' else sum;
--mux2
pc_in <= jump_address when jmp='1' else mux1_out;

sum <= pc_out + 1;
pc1 <= sum;


end Behavioral;
