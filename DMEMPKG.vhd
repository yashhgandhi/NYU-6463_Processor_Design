--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package DMEMPKG is

TYPE DMEM is ARRAY (0 to 127) of std_logic_vector(31 downto 0);

end DMEMPKG;

