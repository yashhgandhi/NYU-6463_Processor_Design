----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:04:39 11/27/2017 
-- Design Name: 
-- Module Name:    MUX - Behavioral 
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

entity MUX is
Port(	  clr : in std_logic;
			data: in  STD_LOGIC_VECTOR (31 downto 0);
		   addrin : out  STD_LOGIC_VECTOR (31 downto 0);
			next_pc : in  STD_LOGIC_VECTOR (1 downto 0);
		  Instr : in  STD_LOGIC_VECTOR (31 downto 0);
		  sign_imm : in  STD_LOGIC_VECTOR (31 downto 0);		
		  addrout : in  STD_LOGIC_VECTOR (31 downto 0);	
		  RFWrtData : out  STD_LOGIC_VECTOR (31 downto 0);	
		  DMOut : in  STD_LOGIC_VECTOR (31 downto 0);			
		  ALUResult : in  STD_LOGIC_VECTOR (31 downto 0);		
		  isload : in std_logic;
		  isstore: in std_logic;
		  i_type: in std_logic);
end MUX;

architecture Behavioral of MUX is
signal newaddr : STD_LOGIC_VECTOR (31 downto 0);

begin


process(clr,next_pc,newaddr,sign_imm,Instr,addrout)
begin

if(clr='1') then
	addrin <= x"00000000";
	newaddr <= x"00000000";
else
	newaddr <= addrout + 1;
	if(next_pc="00") then
		addrin<=newaddr;
	elsif(next_pc="10") then
		addrin<=newaddr+sign_imm;
	elsif(next_pc="01") then
		addrin<= newaddr(31 downto 28) & "00" & Instr(25 downto 0) ;
	else
		addrin<= addrout;	--x"00000000";
	end if;
end if;

end process;

--MUX for wrtdata to RF
process(clr, isload, DMOut, ALUResult)
begin
if(clr='1') then
	RFWrtData<=x"00000000";
else
	if(isload='1') then
		RFWrtData<=DMOut;
	elsif(isstore='1') then
		RFWrtData<=data;	
	elsif(Instr(31 downto 26) = "000000" or i_type='1') then
		RFWrtData<=ALUResult;
	end if;
end if;

end process;
end Behavioral;

