----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:55:29 11/17/2017 
-- Design Name: 
-- Module Name:    RegisterFile - Behavioral 
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.RFPKG.all;
use work.DMEMPKG.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RegisterFile is
Port(	clr : in STD_LOGIC;
		clk : in STD_LOGIC;
		Instr : in STD_LOGIC_VECTOR(31 downto 0);
		write_data : in STD_LOGIC_VECTOR(31 downto 0);
		data : out STD_LOGIC_VECTOR (31 downto 0);
		WE : in STD_LOGIC;
		Op : in std_logic_vector(5 downto 0);	
		i_type : in std_logic;
		sign_imm : out std_logic_vector(31 downto 0);
		write_addr : out std_logic_vector(4 downto 0);
		rs_data : out std_logic_vector(31 downto 0);
		rt_data : out std_logic_vector(31 downto 0);
		reg_file : out RFREG
		);
end RegisterFile;

architecture Behavioral of RegisterFile is

signal rs_addr: std_logic_vector(4 downto 0);
signal rt_addr: std_logic_vector(4 downto 0);
signal write_addr1: std_logic_vector(4 downto 0);
signal sign_imm1 : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal rs_data1 : STD_LOGIC_VECTOR (31 downto 0);
signal rt_data1 : STD_LOGIC_VECTOR (31 downto 0);
signal data1 : STD_LOGIC_VECTOR (31 downto 0);

--type Reg_file is array(0 to 31) of std_logic_vector(31 downto 0);
signal rf: RFREG:= RFREG'(x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
										x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
										x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
										x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
										x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
										x"00000000", x"00000000");
begin

--data2 <= data;
rs_addr<=Instr(25 downto 21);
rt_addr<=Instr(20 downto 16);

--Determines write reg address 
process(clr,Op,i_type,Instr)
begin
if (clr ='1') then
	sign_imm1 <= x"00000000";
	write_addr1 <= "00000";
else
	if(Op="000000") then
		write_addr1<=Instr(15 downto 11);
		sign_imm1 <= x"00000000";
	else
		if(i_type='1') then
			if(Instr(15)='0') then
				write_addr1<=Instr(20 downto 16);
				sign_imm1<= x"0000" & Instr(15 downto 0);
			elsif(Instr(15)='1') then
				write_addr1<=Instr(20 downto 16);
				sign_imm1<= x"FFFF" & Instr(15 downto 0);
			end if;
		else 
			sign_imm1 <= x"00000000";
		end if;
	end if;
end if;
end process;

-- Determining Input data
process(clr,i_type,rs_addr,rt_addr,sign_imm1,rf)
begin
	if(clr='1') then
		rs_data1 <= x"00000000";
		rt_data1 <= x"00000000";
		data1 <= x"00000000";
	else
		rs_data1 <= rf(conv_integer(rs_addr));
		if(i_type='1') then
			rt_data1<=sign_imm1;
			data1<= rf(conv_integer(rt_addr));
		else
			rt_data1 <= rf(conv_integer(rt_addr));
		end if;
	end if;
end process;

--Writing data to address
process(clr,clk,WE,write_data,write_addr1)
begin
if(clk'event and clk='0') then
	if(clr='0') then
		if (WE='1') then
			rf(conv_integer(write_addr1)) <= write_data;
		end if;
	end if;
end if;
end process;

reg_file <= rf;
write_addr <= write_addr1;
sign_imm <= sign_imm1;
rs_data <= rs_data1;
rt_data <= rt_data1;
data <= data1;
end Behavioral;

