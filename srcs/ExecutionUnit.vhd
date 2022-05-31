----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2021 11:17:49 AM
-- Design Name: 
-- Module Name: ExecutionUnit - Behavioral
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
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ExecutionUnit is
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
end ExecutionUnit;

architecture Behavioral of ExecutionUnit is
signal ALUCtrl : std_logic_vector (2 downto 0);
signal alu_in : std_logic_vector(15 downto 0);
signal sft_left : std_logic_vector(15 downto 0);
signal sft_right : std_logic_vector(15 downto 0);
signal sllv : std_logic_vector(15 downto 0);
signal res : std_logic_vector(15 downto 0);
begin

BranchAddress <= PCinc + Ext_Imm;

alu_in <= Ext_Imm when ALUSrc ='1' else
          rd2;

sft_left <= rd1(14 downto 0) & "0" when sa='1' else
            rd1;
            
sft_right <= "0" & rd1(15 downto 1) when sa='1' else
            rd1;    
            
sllv <= std_logic_vector(shift_left(unsigned(rd1), to_integer(unsigned(rd2))));

process(ALUOp, func)
begin
    case ALUOp is
        when "010" => ALUCtrl <= func;
        when "000" => ALUCtrl <= "000";
        when "001" => ALUCtrl <= "001";
        when "011" => ALUCtrl <= "101";
        when "100" => ALUCtrl <= "100";
        when others => ALUCtrl <= "000";
    end case;
end process;

process (ALUCtrl, rd1, alu_in, sft_left, sft_right)
begin
    case ALUCtrl is
        when "000" => res <= rd1 + alu_in;
        when "001" => res <= rd1 - alu_in;
        when "010" => res <= sft_left;
        when "011" => res <= sft_right;
        when "100" => res <= rd1 and alu_in;
        when "101" => res <= rd1 or alu_in;
        when "110" => res <= rd1 xor alu_in;
        when "111" => res <= sllv;
        when others => res <= rd1;
    end case;
end process;

ALURes <= res;

Zero <= '1' when res="0000000000000000" else
        '0';

end Behavioral;
