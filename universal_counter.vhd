----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:12:57 11/24/2015 
-- Design Name: 
-- Module Name:    universal_counter - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;






entity universal_counter is
 Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           up_down : in  STD_LOGIC;
           enable : in  STD_LOGIC;
			  alarm_stop : in STD_LOGIC;
			  
			 --Upper_limit : in STD_LOGIC_VECTOR(3 downto 0);			  
			  --dp  : out  STD_LOGIC;
			 -- enable_out : out STD_LOGIC;
			  alarm : out STD_LOGIC;
           sel_out : out  STD_LOGIC_VECTOR (7 downto 0);
           seg_out : out  STD_LOGIC_VECTOR (7 downto 0)
			  
			 
			
            );
			  
end universal_counter;

architecture Behavioral of universal_counter is

component seven_four
 Port ( in1 : in  STD_LOGIC_VECTOR (3 downto 0);
           in2 : in  STD_LOGIC_VECTOR (3 downto 0);
           in3 : in  STD_LOGIC_VECTOR (3 downto 0);
           in4 : in  STD_LOGIC_VECTOR (3 downto 0);
           clk : in  STD_LOGIC;
			  dp  : out  STD_LOGIC;
           sel : out  STD_LOGIC_VECTOR (3 downto 0);
           segment : out  STD_LOGIC_VECTOR (6 downto 0) 
			 
			);
end component;

signal ara_deger : STD_LOGIC_VECTOR (31 downto 0) := X"00000000";
signal ara_deger2 : STD_LOGIC_VECTOR (31 downto 0) := X"00000000";
signal new_clk : STD_LOGIC :='0';
signal secless,secmost,minless,minmost,sel : STD_LOGIC_VECTOR (3 downto 0) := "0000";
signal dp : std_logic ;
signal seg_out_7 :STD_LOGIC_VECTOR(6 downto 0);
signal seg_sel_4 : STD_LOGIC_VECTOR(3 downto 0);
signal upperlimit : STD_LOGIC_VECTOR(15 downto 0);


begin
 A0 : seven_four port map(secless, secmost,minless,minmost , clk,dp,seg_sel_4,seg_out_7 ); 
seg_out <= (seg_out_7 &dp); 
sel_out <= "1111"&seg_sel_4;
upperlimit <= minmost & minless & secmost & secless;

process(clk, rst, enable, up_down,alarm_stop)
begin
	if (clk = '1' and clk'event) then
 	   
					if(ara_deger<50000000) then
					ara_deger <=  ara_deger + 1;
					--new_clk<= not new_clk;
					elsif(ara_deger=50000000) then
					new_clk<= not new_clk;
					ara_deger <= x"00000000" ;
					end if;
				
	end if;
			
end process;



process(new_clk,alarm_stop)
begin
	
if (new_clk = '1' and new_clk'event) then
			if (rst = '1') then 
    		     secless <= "0000";
    		     secmost <= "0000";
    		     minless <= "0000";
    		     minmost <= "0000";
				  --enable_out <= '0'; --yeni
		 elsif(enable = '1') then
				--if(secless = "1001") then   --yeni
					--enable_out <= '1';		--yeni
					--else                  --yeni
					--enable_out <= '0'; --yeni
					--end if; -- aþaðý inebilir.
		      if(up_down = '1') then
					
						secless <= secless + 1;
					if(secless = "1001") then
						secless <= "0000";
						secmost <= secmost + 1;
							if(secmost = "0101") then
								secmost <= "0000";
								minless <= minless + 1;
									if(minless = "1001") then
										minless <= "0000";
										minmost <= minmost + 1;
											if(minmost = "0101") then 
												minmost <= "0000";
												if( upperlimit > "0000000100100101" and alarm_stop='0') then
												if(ara_deger2<100000000) then
											ara_deger2 <=  ara_deger2 + 1;
											alarm <= '1';
											elsif(ara_deger2=100000000) then
											alarm <= '0';
											ara_deger2 <= x"00000000" ;
										end if;
											end if;
									end if;										
							end if;
					end if;

				end if;
				
			end if;
			--else
			if(up_down = '0') then
						secless <= secless - 1;
					if(secless = "0000") then
						secless <= "1001";
						secmost <= secmost - 1;
							if(secmost = "0000") then
								secmost <= "0101";
								minless <= minless -1;
									if(minless = "0000") then
										minless <= "1001";
										minmost <= minmost - 1;
											if(minmost = "0000") then 
												minmost <= "0101";   -- 0000 yapýlabilir.
												if( upperlimit < "0000000100100101" and alarm_stop='0' ) then
											if(ara_deger2<100000000) then
											ara_deger2 <=  ara_deger2 + 1;
											alarm <= '1';
											elsif(ara_deger2=100000000) then
											alarm <= '0';
											ara_deger2 <= x"00000000" ;
										end if;
											end if;
									end if;										
							end if;
					end if;

				end if;
		end if;
	end if;
end if;

end process;


	
end Behavioral;