----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2021 11:39:30 PM
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
    Port ( clk : in STD_LOGIC;
           rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemWrite : in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           ALURes : in STD_LOGIC_VECTOR (15 downto 0));
end MEM;

architecture Behavioral of MEM is
--RAM
type ram_type is array(0 to 128) of std_logic_vector(15 downto 0);
signal ram : ram_type := (others=>"0000000000000000");
 
begin
MemData <= ram(conv_integer(ALURes(4 downto 0)));

process(clk)
begin      
       if clk'event and clk='1' then
            if MemWrite='1' then
                ram(conv_integer(ALURes(4 downto 0))) <= rd2;
            end if;
        end if;
end process;

end Behavioral;
