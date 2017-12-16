----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:36:09 11/29/2017 
-- Design Name: 
-- Module Name:    Main - Behavioral 
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

entity Main is
Port(	--clr : in std_logic;
		clk : in std_logic;
		--Instr: inout STD_LOGIC_VECTOR (31 downto 0);
		--next_pc : inout STD_LOGIC_VECTOR (1 downto 0);
		--ALUResult : inout std_logic_vector(31 downto 0);
		--DMOut : inout STD_LOGIC_VECTOR (31 downto 0);
		--addrout : inout STD_LOGIC_VECTOR (31 downto 0);	
		--RFWrtData : inout STD_LOGIC_VECTOR (31 downto 0)
		btnl: in std_logic;
		btnr: in std_logic;
		btnc: in std_logic;
		btnd: in std_logic;
		btnu: in std_logic;
		SSEG_CA : out  STD_LOGIC_VECTOR (7 downto 0);
      SSEG_AN : out  STD_LOGIC_VECTOR (7 downto 0);
		sw: in std_logic_vector(15 downto 0);
		led: out std_logic_vector(15 downto 0)
		);
end Main;

architecture Behavioral of Main is

component ProgCounter
Port(	clr : in std_logic;
		clk : in std_logic;
		addrin : in  STD_LOGIC_VECTOR (31 downto 0);
		addrout : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component InstMem
Port(	clr : in std_logic;
		addr : in  STD_LOGIC_VECTOR (31 downto 0);
		Instr : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component Decoder 
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
end component;

component RegisterFile 
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
end component;

component ALU 
Port(	clr : in  STD_LOGIC;
		Op : in std_logic_vector(5 downto 0);	
		ALUControl : in std_logic_vector(2 downto 0);
		rs_data : in STD_LOGIC_VECTOR (31 downto 0);
		rt_data : in STD_LOGIC_VECTOR (31 downto 0);			-- For R type it is rt_data, for I-type it is sign_imm
		--write_addr : out std_logic_vector(4 downto 0);
		ALUResult : out std_logic_vector(31 downto 0);
		isequal : out std_logic;
		isless : out std_logic;
		data: in std_logic_vector(31 downto 0)
		);
end component;

component DataMem
	port( clk : in  STD_LOGIC;
			clr : in  STD_LOGIC;
			addr : in  STD_LOGIC_VECTOR (31 downto 0);		-- This is the ALUResult
			DMIn : in  STD_LOGIC_VECTOR (31 downto 0);		-- This is rt_data from Register File
			DMOut : out  STD_LOGIC_VECTOR (31 downto 0);
			sel_wr : in  STD_LOGIC;		
			sel_rd : in  STD_LOGIC;
			l_arr : in STD_LOGIC_VECTOR (127 downto 0);
			din : in STD_LOGIC_VECTOR (63 downto 0);
			data_mem : out DMEM);
end component;

component MUX 
Port(	  clr : in std_logic;
		  addrin : out  STD_LOGIC_VECTOR (31 downto 0);
		  data : in  STD_LOGIC_VECTOR (31 downto 0);
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
end component;

--hex component
component Hex2LED --Converts a 4 bit hex value into the pattern to be displayed on the 7seg
port (clk: in STD_LOGIC; X: in STD_LOGIC_VECTOR (3 downto 0); Y: out STD_LOGIC_VECTOR (7 downto 0)); 
end component; 

--signal Instr: STD_LOGIC_VECTOR (31 downto 0);

signal Op :  STD_LOGIC_VECTOR (5 downto 0);
signal isless :  STD_LOGIC;
signal isequal : STD_LOGIC;
signal isload : STD_LOGIC;
signal isstore :  STD_LOGIC;
signal i_type :  STD_LOGIC;
signal isbranch :   STD_LOGIC;
signal j_type :   STD_LOGIC;
signal WE :   STD_LOGIC;
signal sel_rd :  STD_LOGIC;
signal sel_wr :  STD_LOGIC;
signal ALUControl :  STD_LOGIC_VECTOR (2 downto 0);
signal next_pc :  STD_LOGIC_VECTOR (1 downto 0);
signal Funct :   STD_LOGIC_VECTOR (5 downto 0);
signal Instr: STD_LOGIC_VECTOR (31 downto 0);

--signal write_data : STD_LOGIC_VECTOR(31 downto 0);
signal sign_imm :  std_logic_vector(31 downto 0);
signal write_addr :  std_logic_vector(4 downto 0);
signal rs_data :  std_logic_vector(31 downto 0);
signal rt_data : std_logic_vector(31 downto 0);

signal ALUResult : std_logic_vector(31 downto 0);

signal data :   STD_LOGIC_VECTOR (31 downto 0);		-- This is data in reg rt for store AND branch
signal DMOut :   STD_LOGIC_VECTOR (31 downto 0);

signal addrin : STD_LOGIC_VECTOR (31 downto 0);
signal addrout :   STD_LOGIC_VECTOR (31 downto 0);	
signal RFWrtData :  STD_LOGIC_VECTOR (31 downto 0);	
signal reg_file : RFREG;
signal data_mem : DMEM;
signal clr : std_logic:='1';
signal start_enc : std_logic := '0';
signal start_dec : std_logic := '0';
signal start_exp : std_logic := '0';

signal step_clk : std_logic;

--hex signal
type arr is array(0 to 22) of std_logic_vector(7 downto 0);
signal NAME: arr;
signal Val : std_logic_vector(3 downto 0) := (others => '0');
signal HexVal: std_logic_vector(31 downto 0);
signal slowCLK: std_logic:='0';
signal slowCLK1: std_logic:='0';
signal i_cnt: std_logic_vector(19 downto 0):=x"00000";
signal j_cnt: std_logic_vector(11 downto 0):=x"000";
--input taking signals
signal l0 : std_logic_vector(7 downto 0);
signal l1 : std_logic_vector(7 downto 0);
signal l2 : std_logic_vector(7 downto 0);
signal l3 : std_logic_vector(7 downto 0);
signal l4 : std_logic_vector(7 downto 0);
signal l5 : std_logic_vector(7 downto 0);
signal l6 : std_logic_vector(7 downto 0);
signal l7 : std_logic_vector(7 downto 0);
signal l8 : std_logic_vector(7 downto 0);
signal l9 : std_logic_vector(7 downto 0);
signal l10 : std_logic_vector(7 downto 0);
signal l11 : std_logic_vector(7 downto 0);
signal l12 : std_logic_vector(7 downto 0);
signal l13 : std_logic_vector(7 downto 0);
signal l14 : std_logic_vector(7 downto 0);
signal l15 : std_logic_vector(7 downto 0);

signal a0 : std_logic_vector(7 downto 0);
signal a1 : std_logic_vector(7 downto 0);
signal a2 : std_logic_vector(7 downto 0);
signal a3 : std_logic_vector(7 downto 0);
signal b0 : std_logic_vector(7 downto 0);
signal b1 : std_logic_vector(7 downto 0);
signal b2 : std_logic_vector(7 downto 0);
signal b3 : std_logic_vector(7 downto 0);

signal l_arr : std_logic_vector(127 downto 0);
signal din : std_logic_vector(63 downto 0);

	


begin

process(clk)
begin
if (rising_edge(clk)) then
if (j_cnt=x"186")then 
slowCLK1<=not slowCLK1; 
j_cnt<=x"000";
else
j_cnt<=j_cnt+'1';
end if;
end if;
end process;


ProgramCounter: ProgCounter port map(clr=>clr,clk=>step_clk,addrin=>addrin,addrout=>addrout);
InstructionMemory: InstMem port map(clr=>clr,addr=>addrout,Instr=>Instr);
Dec: Decoder port map(clr=>clr,Instr=>Instr,Op=>Op,isless=>isless,isequal=>isequal,isload=>isload,
							isstore=>isstore,i_type=>i_type,isbranch=>isbranch,j_type=>j_type,WE=>WE,sel_rd=>sel_rd,sel_wr=>sel_wr,
							ALUControl=>ALUControl,next_pc=>next_pc,Funct=>Funct);
RegFile: RegisterFile port map(clr=>clr,clk=>step_clk,Instr=>Instr,write_data=>RFWrtData,WE=>WE,Op=>Op,i_type=>i_type,sign_imm=>sign_imm,write_addr=>write_addr,
								rs_data=>rs_data,rt_data=>rt_data,data=>data,reg_file=>reg_file);
								
ALUnit: ALU port map(clr=>clr,Op=>Op,ALUControl=>ALUControl,rs_data=>rs_data,rt_data=>rt_data,ALUResult=>ALUResult,isequal=>isequal,isless=>isless,data=>data);
DataMemory: DataMem port map(clr=>clr,clk=>step_clk,addr=>ALUResult,DMIn=>data,DMOut=>DMOut,data_mem=>data_mem,sel_rd=>sel_rd,sel_wr=>sel_wr,din=>din,l_arr=>l_arr);
Multiplexer: MUX port map(clr=>clr,addrin=>addrin,next_pc=>next_pc,Instr=>Instr,sign_imm=>sign_imm,addrout=>addrout,RFWrtData=>RFWrtData,DMOut=>DMOut,ALUResult=>ALUResult,isload=>isload,data=>data,i_type=>i_type,isstore=>isstore);

--taking input start
led <= sw;

process(clk,sw,step_clk,btnu)
begin
if (sw(15) ='1' and sw(14) = '1' and sw(13) = '1') then
	step_clk <= btnu;
else
	step_clk <= slowCLK1;
end if;
end process;

process(btnl,btnd,btnu,btnr,btnc,sw)
begin
--giving clear
	if(btnc='1') then
		clr <= '1';
	end if;
--checking PC	
	if(sw(15)='1') then
		hexval <= addrout;
	end if;
--start expansion	
if(btnl='1') then
		clr<='0';
   start_exp <= '1';
	end if;
--start enc
	if(btnd='1') then
		clr<='0';
		start_enc <= '1';
	end if;
--start dec
	if(btnr='1') then
		clr<='0';
		start_dec <= '1';
	end if;
	
	if(sw(14)='1')then
			hexval<=data_mem(conv_integer(sw(6 downto 0)));
	end if;

	if(sw(15)='1' and sw(14)='1')then
			hexval<=reg_file(conv_integer(sw(4 downto 0)));
	end if;
end process;
	
process(l0, l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, sw(15 downto 0))
begin
if(sw(11 downto 8) = "0000" and sw(12) = '1') then
  l0 <= sw(7 downto 0);
elsif(sw(11 downto 8) = "0001" and sw(12) = '1') then
  l1 <= sw(7 downto 0);
elsif(sw(11 downto 8) = "0010" and sw(12) = '1') then
  l2 <= sw(7 downto 0);
elsif(sw(11 downto 8) = "0011" and sw(12) = '1') then
  l3 <= sw(7 downto 0);
elsif(sw(11 downto 8) = "0100" and sw(12) = '1') then
  l4 <= sw(7 downto 0);
elsif(sw(11 downto 8) = "0101" and sw(12) = '1') then
  l5 <= sw(7 downto 0);
elsif(sw(11 downto 8) = "0110" and sw(12) = '1') then
  l6 <= sw(7 downto 0);
elsif(sw(11 downto 8) = "0111" and sw(12) = '1') then
  l7 <= sw(7 downto 0);
elsif(sw(11 downto 8) = "1000" and sw(12) = '1') then
  l8 <= sw(7 downto 0);
elsif(sw(11 downto 8) = "1001" and sw(12) = '1') then
  l9 <= sw(7 downto 0);
elsif(sw(11 downto 8) = "1010" and sw(12) = '1') then
  l10 <= sw(7 downto 0);
elsif(sw(11 downto 8) = "1011" and sw(12) = '1') then
  l11 <= sw(7 downto 0);
elsif(sw(11 downto 8) = "1100" and sw(12) = '1') then
  l12 <= sw(7 downto 0);
elsif(sw(11 downto 8) = "1101" and sw(12) = '1') then
  l13 <= sw(7 downto 0);
elsif(sw(11 downto 8) = "1110" and sw(12) = '1') then
  l14 <= sw(7 downto 0);
elsif(sw(11 downto 8) = "1111" and sw(12) = '1') then
  l15 <= sw(7 downto 0);
end if;
l_arr <= l0 & l1 & l2 & l3 & l4 & l5 & l6 & l7 & l8 & l9 & l10 & l11 & l12 & l13 & l14 & l15;

end process;

process(a0, a1, a2, a3, b0, b1, b2, b3,sw(15 downto 0))
begin
    if(sw(11 downto 8) = "0000" and sw(13) = '1') then
	  a0 <= sw(7 downto 0);
   elsif(sw(11 downto 8) = "0001" and sw(13) = '1') then
	  a1 <= sw(7 downto 0);
	elsif(sw(11 downto 8) = "0010" and sw(13) = '1') then
	  a2 <= sw(7 downto 0);
	elsif(sw(11 downto 8) = "0011" and sw(13) = '1') then
	  a3 <= sw(7 downto 0);
	elsif(sw(11 downto 8) = "0100" and sw(13) = '1') then
	  b0 <= sw(7 downto 0);
   elsif(sw(11 downto 8) = "0101" and sw(13) = '1') then
	  b1 <= sw(7 downto 0);
	elsif(sw(11 downto 8) = "0110" and sw(13) = '1') then
	  b2 <= sw(7 downto 0);
	elsif(sw(11 downto 8) = "0111" and sw(13) = '1') then
	  b3 <= sw(7 downto 0);
	end if;
  din <= b0 & b1 & b2 & b3 & a0 & a1 & a2 & a3;

end process;
--taking input end








--hex code start
-----Creating a slowCLK of 500Hz using the board's 100MHz clock----
process(clk)
begin
if (rising_edge(clk)) then
if (i_cnt=x"186A0")then --Hex(186A0)=Dec(100,000)
slowCLK<=not slowCLK; --slowCLK toggles once after we see 100000 rising edges of CLK. 2 toggles is one period.
i_cnt<=x"00000";
else
i_cnt<=i_cnt+'1';
end if;
end if;
end process;

-----We use the 500Hz slowCLK to run our 7seg display at roughly 60Hz-----
timer_inc_process : process (slowCLK)
begin
if (rising_edge(slowCLK)) then
	if(Val="1000") then
		Val<="0001";
	else
		Val <= Val + '1'; --Val runs from 1,2,3,...8 on every rising edge of slowCLK
	end if;
end if;
--end if;
end process;

--This select statement selects one of the 7-segment diplay anode(active low) at a time. 
with Val select
	SSEG_AN <= "01111111" when "0001",
				  "10111111" when "0010",
				  "11011111" when "0011",
				  "11101111" when "0100",
				  "11110111" when "0101",
				  "11111011" when "0110",
				  "11111101" when "0111",
				  "11111110" when "1000",
				  "11111111" when others;

--This select statement selects the value of HexVal to the necessary
--cathode signals to display it on the 7-segment
with Val select
	SSEG_CA <= NAME(0) when "0001", --NAME contains the pattern for each hex value to be displayed.
				  NAME(1) when "0010", --See below for the conversion
				  NAME(2) when "0011",
				  NAME(3) when "0100",
				  NAME(4) when "0101",
				  NAME(5) when "0110",
				  NAME(6) when "0111",
				  NAME(7) when "1000",
				  NAME(0) when others;
				  
--Hex2LED for converting each Hex value to a pattern to be given to the cathode.
CONV1: Hex2LED port map (CLK => CLK, X => HexVal(31 downto 28), Y => NAME(0));
CONV2: Hex2LED port map (CLK => CLK, X => HexVal(27 downto 24), Y => NAME(1));
CONV3: Hex2LED port map (CLK => CLK, X => HexVal(23 downto 20), Y => NAME(2));
CONV4: Hex2LED port map (CLK => CLK, X => HexVal(19 downto 16), Y => NAME(3));		
CONV5: Hex2LED port map (CLK => CLK, X => HexVal(15 downto 12), Y => NAME(4));
CONV6: Hex2LED port map (CLK => CLK, X => HexVal(11 downto 8), Y => NAME(5));
CONV7: Hex2LED port map (CLK => CLK, X => HexVal(7 downto 4), Y => NAME(6));
CONV8: Hex2LED port map (CLK => CLK, X => HexVal(3 downto 0), Y => NAME(7));

end Behavioral;

