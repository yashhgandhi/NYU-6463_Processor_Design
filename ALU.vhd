----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:38:43 11/17/2017 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.RFPKG.all;
use work.DMEMPKG.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
Port(	clr : in  STD_LOGIC;
		Op : in std_logic_vector(5 downto 0);	
		ALUControl : in std_logic_vector(2 downto 0):= "000";
		rs_data : in STD_LOGIC_VECTOR (31 downto 0);
		rt_data : in STD_LOGIC_VECTOR (31 downto 0);			-- For R type it is rt_data, for I-type it is sign_imm
--		write_addr : out std_logic_vector(4 downto 0);
		data : in std_logic_vector(31 downto 0);
		ALUResult : out std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
		isequal : out std_logic;
		isless : out std_logic);
end ALU;

architecture Behavioral of ALU is

signal ALUResult1: std_logic_vector(31 downto 0);
signal Left_Shift: std_logic_vector(31 downto 0);
signal Right_Shift: std_logic_vector(31 downto 0);


begin

with rt_data(4 downto 0) select
					Right_Shift <=	'0' & rs_data(31 downto 1) when "00001",
									"00" & rs_data(31 downto 2) when "00010",
									"000" & rs_data(31 downto 3) when "00011",
									"0000" & rs_data(31 downto 4) when "00100",
									"00000" & rs_data(31 downto 5) when "00101",
									"000000" & rs_data(31 downto 6) when "00110",
									"0000000" & rs_data(31 downto 7) when "00111",
									"00000000" & rs_data(31 downto 8) when "01000",
									"000000000" & rs_data(31 downto 9) when "01001", 
									"0000000000" & rs_data(31 downto 10) when "01010",
									"00000000000" & rs_data(31 downto 11) when "01011", 
									"000000000000" & rs_data(31 downto 12) when "01100", 
									"0000000000000" & rs_data(31 downto 13) when "01101",
									"00000000000000" & rs_data(31 downto 14) when "01110",
									"000000000000000" & rs_data(31 downto 15) when "01111",
									"0000000000000000" & rs_data(31 downto 16) when "10000",
									"00000000000000000" & rs_data(31 downto 17) when "10001",
									"000000000000000000" & rs_data(31 downto 18) when "10010",
									"0000000000000000000" & rs_data(31 downto 19) when "10011", 
									"00000000000000000000" & rs_data(31 downto 20) when "10100",
									"000000000000000000000" & rs_data(31 downto 21) when "10101",
									"0000000000000000000000" & rs_data(31 downto 22) when "10110",
									"00000000000000000000000" & rs_data(31 downto 23) when "10111",
									"000000000000000000000000" & rs_data(31 downto 24) when "11000",
									"0000000000000000000000000" & rs_data(31 downto 25) when "11001",
									"00000000000000000000000000" & rs_data(31 downto 26) when "11010",
									"000000000000000000000000000" & rs_data(31 downto 27) when "11011",
									"0000000000000000000000000000" & rs_data(31 downto 28) when "11100",
									"00000000000000000000000000000" & rs_data(31 downto 29) when "11101",
									"000000000000000000000000000000" & rs_data(31 downto 30) when "11110",
									"0000000000000000000000000000000" & rs_data(31) when "11111",
									rs_data when others;

with rt_data(4 downto 0) select
					Left_Shift <= 	rs_data(30 downto 0) & '0' when "00001",
									rs_data(29 downto 0) & "00" when "00010", 
									rs_data(28 downto 0) & "000" when "00011", 
									rs_data(27 downto 0) & "0000" when "00100", 
									rs_data(26 downto 0) & "00000" when "00101", 
									rs_data(25 downto 0) & "000000" when "00110", 
									rs_data(24 downto 0) & "0000000" when "00111", 
									rs_data(23 downto 0) & "00000000" when "01000", 
									rs_data(22 downto 0) & "000000000" when "01001", 
									rs_data(21 downto 0) & "0000000000" when "01010", 
									rs_data(20 downto 0) & "00000000000" when "01011", 
									rs_data(19 downto 0) & "000000000000" when "01100", 
									rs_data(18 downto 0) & "0000000000000" when "01101", 
									rs_data(17 downto 0) & "00000000000000" when "01110", 
									rs_data(16 downto 0) & "000000000000000" when "01111", 
									rs_data(15 downto 0) & "0000000000000000" when "10000", 
									rs_data(14 downto 0) & "00000000000000000" when "10001",
									rs_data(13 downto 0) & "000000000000000000" when "10010", 
									rs_data(12 downto 0) & "0000000000000000000" when "10011", 
									rs_data(11 downto 0) & "00000000000000000000" when "10100", 
									rs_data(10 downto 0) & "000000000000000000000" when "10101", 
									rs_data(9 downto 0) & "0000000000000000000000" when "10110", 
									rs_data(8 downto 0) & "00000000000000000000000" when "10111", 
									rs_data(7 downto 0) & "000000000000000000000000" when "11000", 
									rs_data(6 downto 0) & "0000000000000000000000000" when "11001", 
									rs_data(5 downto 0) & "00000000000000000000000000" when "11010", 
									rs_data(4 downto 0) & "000000000000000000000000000" when "11011", 
									rs_data(3 downto 0) & "0000000000000000000000000000" when "11100", 
									rs_data(2 downto 0) & "00000000000000000000000000000" when "11101", 
									rs_data(1 downto 0) & "000000000000000000000000000000" when "11110", 
									rs_data(0) & "0000000000000000000000000000000" when "11111", 
									rs_data when others;



process(clr,rs_data,rt_data,Left_Shift,Right_Shift,ALUResult1,Op, ALUControl)
begin
if (clr = '1') then
	ALUResult1 <= x"00000000";	 
else
	--ALUResult1 <= x"00000000";	
	case ALUControl is
			when "001" => ALUResult1 <= rs_data + rt_data;
			when "010" => 
				--if (Op = "000000") then 
					ALUResult1 <= rs_data - rt_data;
				--else
				--	ALUResult1 <= rs_data - rt_data;
				--end if;
			when "011" => ALUResult1 <= rs_data and rt_data;
			when "100" => ALUResult1 <= rs_data or rt_data;			
			when "101" => ALUResult1 <= rs_data nor rt_data;			
			when "110" => ALUResult1 <= Left_Shift;
			when "111" => ALUResult1 <= Right_Shift;			
			when others => ALUResult1 <= x"00000000";
		end case;
end if;
end process;

process(clr, Op, rs_data, rt_data)
begin
if (clr = '1') then
	isequal <= '0';
	isless <= '0';
elsif(Op = "001001" or Op = "001010" or Op = "001011") then
		isequal <= '0';
		isless <= '0';
		if(rs_data = data) then
			isequal <= '1';
		elsif(rs_data < data) then
			isless <= '1';
		end if;
end if;
end process;

ALUResult <= ALUResult1;
end Behavioral;

