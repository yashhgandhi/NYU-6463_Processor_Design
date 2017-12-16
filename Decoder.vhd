----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:52:29 11/17/2017 
-- Design Name: 
-- Module Name:    Decoder - Behavioral 
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
use work.RFPKG.all;
use work.DMEMPKG.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Decoder is
    Port ( clr : in  STD_LOGIC;
           Instr : in  STD_LOGIC_VECTOR (31 downto 0);
           Op : out  STD_LOGIC_VECTOR (5 downto 0);
           isless : in  STD_LOGIC;
           isequal : in  STD_LOGIC;
           isload : out  STD_LOGIC;
           isstore : out  STD_LOGIC;
           i_type : out  STD_LOGIC;
           isbranch : out  STD_LOGIC;
           j_type : out  STD_LOGIC;
           WE : out  STD_LOGIC;
           sel_rd : out  STD_LOGIC;
           sel_wr : out  STD_LOGIC;
           ALUControl : out  STD_LOGIC_VECTOR (2 downto 0);
           next_pc : out  STD_LOGIC_VECTOR (1 downto 0);
           Funct : out  STD_LOGIC_VECTOR (5 downto 0));
end Decoder;

architecture Behavioral of Decoder is

signal Op1 : std_logic_vector(5 downto 0) ;
signal Funct1 : std_logic_vector(5 downto 0) ;
signal isload1 : std_logic ;
signal isstore1 : std_logic; 
signal i_type1 : std_logic;
signal isbranch1 : std_logic;
signal j_type1 : std_logic;
signal WE1 : std_logic;
signal sel_rd1 : std_logic;
signal sel_wr1 : std_logic;
signal ALUControl1 : std_logic_vector(2 downto 0);
signal next_pc1 : std_logic_vector(1 downto 0);

begin

Op1 <= Instr(31 downto 26);
Funct1 <= Instr(5 downto 0);

--Load Instruction
process(clr,Op1)
begin
if (clr = '1') then
	isload1 <= '0';
else
	if (Op1 = "000111") then
		isload1 <= '1';
	else 
		isload1 <= '0';
	end if;
end if;
end process;

--Store Instruction
process(clr,Op1)
begin
if (clr = '1') then
	isstore1 <= '0';
else
	if (Op1 = "001000") then
		isstore1 <= '1';
	else
		isstore1 <= '0';
	end if;
end if;
end process;

--I-type Instructions
process(clr,Op1)
begin
if (clr = '1') then
	i_type1 <= '0';
else
	if (Op1 = "000000" or Op1 = "001100" or Op1 = "111111") then
		i_type1 <= '0';
	else 
		i_type1 <= '1';
	end if;
end if;
end process;

--J-type Instructions
process(clr,Op1)
begin
if (clr = '1') then
	j_type1 <= '0';
else
	if (Op1 = "001100") then 
		j_type1 <= '1';
	else
		j_type1 <= '0';
	end if;
end if;
end process;

--Branch Instructions
process(clr,Op1)
begin
if (clr = '1') then
	isbranch1 <= '0';
else
	if (Op1 = "001001" or Op1 = "001010" or Op1 = "001011") then
		isbranch1 <= '1';
	else
		isbranch1 <= '0';
	end if;
end if;
end process;

--Write Enable 
process(clr,Op1,i_type1,isstore1,isbranch1)
begin
if (clr = '1') then
	WE1 <= '0';
else
	if(Op1="000000") then
		WE1 <= '1';
	elsif(i_type1='1') then
		if(isstore1='1' or isbranch1='1') then
			WE1 <= '0';
		else
			WE1 <= '1';
		end if;
	else
		WE1 <= '0';
	end if;			
end if;
end process;

--Data Mem Read Signal
process(clr,isload1)
begin
if (clr = '1') then
	sel_rd1 <= '0';
else
	if(isload1='1') then
		sel_rd1 <= '1';
	else
		sel_rd1 <= '0';
	end if;			
end if;
end process;

--Data Mem Write Signal
process(clr,isstore1)
begin
if (clr = '1') then
	sel_wr1 <= '0';
else
	if(isstore1='1') then
		sel_wr1 <= '1';
	else
		sel_wr1 <= '0';
	end if;			
end if;
end process;

--NOP	000
--ADD	001
--SUB	010
--AND	011
--OR	100
--NOR	101	
--SHL	110
--SHR	111

--ALU Operations
process(clr,Op1,Funct1)
begin
if (clr = '1') then
	ALUControl1 <= "000";
else
	if(Op1="000000") then
		case Funct1 is
			when "010000" => ALUControl1 <= "001";
			when "010001" => ALUControl1 <= "010";
			when "010010" => ALUControl1 <= "011";
			when "010011" => ALUControl1 <= "100";
			when "010100" => ALUControl1 <= "101";
			when  others  => ALUControl1 <= "000";
		end case;
	else
		case Op1 is	
			when "000001" => ALUControl1 <= "001";
			when "000010" => ALUControl1 <= "010";
			when "000011" => ALUControl1 <= "011";
			when "000100" => ALUControl1 <= "100";
			when "000101" => ALUControl1 <= "110";
			when "000110" => ALUControl1 <= "111";
			when "000111" => ALUControl1 <= "001";
			when "001000" => ALUControl1 <= "001";
			when  others  => ALUControl1 <= "000";
		end case;
	end if;
end if;
end process;

--Control Signal for Next PC
process(clr,Op1,isequal,isless,j_type1)
begin
--if(clk'event and clk='1') then
if (clr = '1') then
	next_pc1 <= "11";
else
	if((Op1 = "001001" and isless = '1') or (Op1 = "001010" and isequal = '1') or (Op1 = "001011" and isequal = '0')) then
		next_pc1 <= "10";
	elsif (j_type1 = '1') then
		next_pc1 <= "01";
	elsif (Op1 = "111111") then
		next_pc1 <= "11";
	else
		next_pc1 <= "00";
	end if;
end if;
end process;

Op<=Op1;
Funct<=Funct1;
i_type<=i_type1;
j_type<=j_type1;
isbranch<=isbranch1;
ALUControl<=ALUControl1;
next_pc<=next_pc1;
sel_rd<=sel_rd1;
sel_wr<=sel_wr1;
WE<=WE1;
isload<=isload1;
isstore<=isstore1;


end Behavioral;

