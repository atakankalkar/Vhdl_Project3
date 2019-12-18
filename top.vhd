----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:29:29 12/05/2019 
-- Design Name: 
-- Module Name:    top - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
port(
clock : in std_logic;
reset,enable,direction : in std_logic;
enable2 : in std_logic;
seg_sel: out std_logic_vector(7 downto 0);
seg_out: out std_logic_vector(7 downto 0)
);

end top;

architecture Behavioral of top is
signal ara_deger : STD_LOGIC_VECTOR (31 downto 0) := X"00000000";
signal new_clk : STD_LOGIC :='0';
signal reg : std_logic_vector (7 downto 0 ) :="00000001";
signal dp : std_logic :='1';
signal seg_out_7 :STD_LOGIC_VECTOR(6 downto 0);
signal seg_sel_4 : STD_LOGIC_VECTOR(3 downto 0);
begin
--seg_out <= (seg_out_7 &dp);
--sel_out <= "1111"&seg_sel_4;
process(clock)
begin
	if (clock = '1' and clock'event) then
 	   
					if(ara_deger<50000000) then
					ara_deger <=  ara_deger + 1;
					--new_clk<= not new_clk;
					elsif(ara_deger=50000000) then
					new_clk<= not new_clk;
					ara_deger <= x"00000000" ;
					end if;
				
	end if;
end process;
process(new_clk,reset,enable,direction)
begin
	if (new_clk = '1' and new_clk'event) then
			if (reset = '1') then
			reg<="00000001";
			elsif(enable='1') then
					if(direction='1')then
					reg<=reg(6 downto 0 ) & reg(7);
					else
					reg<=reg(0)&reg(7 downto 1 );
					end if;
			end if;
	end if;
	end process;

			
	process(reg,enable2)
	begin
	if(enable2='1')then
	if( reg < 9 )then
	seg_sel_4 <= not(reg(3 downto 0 ));
	seg_out_7 <= "0011100";
	elsif( reg = 16)then
	seg_sel_4 <= "0111";
	seg_out_7 <= "0011100";
	else
	seg_sel_4 <= not(reg(4))& not(reg(5))&not(reg(6))&not(reg(7));
	seg_out_7 <= "0011100";
	end if;
	else
	if( reg < 9 )then
	seg_sel_4 <= not(reg(3 downto 0 ));
	seg_out_7 <= "0100011";
	elsif( reg = 16)then
	seg_sel_4 <= "0111";
	seg_out_7 <= "0011100";
	else
	seg_sel_4 <= not(reg(4))& not(reg(5))&not(reg(6))&not(reg(7));
	seg_out_7 <= "0011100";
	end if;
	end if;
	end process;
	
	
	seg_sel <= "1111"&seg_sel_4;
	seg_out <= (seg_out_7 & dp);

end Behavioral;

