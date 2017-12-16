----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:41:56 11/27/2017 
-- Design Name: 
-- Module Name:    ProgCounter - Behavioral 
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

entity ProgCounter is
Port (	clr : in std_logic; 
			clk : in std_logic;
			addrin : in  STD_LOGIC_VECTOR (31 downto 0);
			addrout : out  STD_LOGIC_VECTOR (31 downto 0));
end ProgCounter;

architecture Behavioral of ProgCounter is

begin
process(clr,clk,addrin)
begin
if(clk'event and clk='1') then
	if(clr='1') then
		addrout <= x"00000000";
	else
		addrout<=addrin;
	end if;
end if;
end process;

end Behavioral;

