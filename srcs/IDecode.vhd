----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2021 11:18:52 AM
-- Design Name: 
-- Module Name: IDecode - Behavioral
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

entity IDecode is
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
end IDecode;

architecture Behavioral of IDecode is
component reg_file
    Port ( clk : in STD_LOGIC;
       ra1 : in STD_LOGIC_VECTOR (2 downto 0);
       ra2 : in STD_LOGIC_VECTOR (2 downto 0);
       wa : in STD_LOGIC_VECTOR (2 downto 0);
       wd : in STD_LOGIC_VECTOR (15 downto 0);
       rd1 : out STD_LOGIC_VECTOR (15 downto 0);
       rd2 : out STD_LOGIC_VECTOR (15 downto 0);
       we : in std_logic);
end component reg_file;

signal mux_out : std_logic_vector(2 downto 0);
signal rs : std_logic_vector(2 downto 0);
signal rt : std_logic_vector(2 downto 0);
signal rd : std_logic_vector(2 downto 0);
signal immediate : std_logic_vector (6 downto 0);

begin
rs <= Instr(12 downto 10);
rt <= Instr(9 downto 7);
rd <= Instr(6 downto 4);
immediate <= Instr(6 downto 0);
mux_out <=  rd when RegDst='1' else rt;
wb_reg_address <= mux_out;
--register file
reg: reg_file port map(clk, rs, rt, reg_in, WD, rd1, rd2, RegWrite);

--extension unit
process(ExtOp, immediate)
begin 
    if ExtOp='1' then
        if immediate(6)='1' then
            Ext_Imm <= "111111111" & immediate;
        else
            Ext_Imm <= "000000000" & immediate;
        end if;
    else 
        Ext_Imm <= "000000000" & immediate;
    end if;
end process;



func <= Instr(2 downto 0);
sa <= Instr(3);

end Behavioral;
