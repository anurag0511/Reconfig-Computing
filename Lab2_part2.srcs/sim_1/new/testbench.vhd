----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/11/2017 11:32:25 AM
-- Design Name: 
-- Module Name: tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
entity testbench is
end testbench;

architecture Behavioral of testbench is

component fsm 
port (
		PS2_CLK   : in  std_logic;  -- keyboard clock
		PS2_DATA  : in  std_logic;  -- keyboard data
		
		BTN_UP    : in  std_logic;
		SWITCHES  : in  std_logic_vector (3 downto 0);
		LEDS      : out std_logic_vector (7 downto 0)
	);
end component;

constant cP     : time := 1 us;
constant cDelay : time := 100 ns;

signal sPS2_CLK, sPS2_Data, sBTN_UP : std_logic := '0'; 

signal sSWITCHES : std_logic_vector(3 downto 0); 
signal sLEDS     : std_logic_vector(7 downto 0); 

begin

UUT : fsm port map (PS2_CLK  => sPS2_CLK, 
                             PS2_DATA => sPS2_Data,  
                             BTN_UP   => sBTN_UP, 
                             SWITCHES => sSWITCHES, 
                             LEDS     => sLEDS );

 sBTN_UP <= '0', '1' after 1 us, '0' after 2 us;
 --sSWITCHES <= (others => '0');
 
 process 
 variable vKEY : std_logic_vector (10 downto 0); 
 begin
   
   sSWITCHES <= "0000" ;
   sPS2_CLK  <= '1';
   
   sPS2_DATA <= '1';    
   vKEY := "00110100001";
   
   wait for 3*cP; 
    
   for i in vKEY'range loop
    
    sPS2_DATA <= vKEY(i);
    wait for 100 ns; 
    
    sPS2_CLK <= '0';   
    wait for cP/2;   
    sPS2_CLK <= '1';   
    wait for cP/2;     

  end loop;    
  vKEY := "01010101011";
  for i in vKEY'range loop
   
   sPS2_DATA <= vKEY(i);
   wait for 100 ns; 
   
   sPS2_CLK <= '0';   
   wait for cP/2;   
   sPS2_CLK <= '1';   
   wait for cP/2;     

 end loop;
    sSWITCHES <= "0001";
   vKEY := "00011010001";
 for i in vKEY'range loop
  
  sPS2_DATA <= vKEY(i);
  wait for 100 ns; 
  
  sPS2_CLK <= '0';   
  wait for cP/2;   
  sPS2_CLK <= '1';   
  wait for cP/2;     

end loop;
   sSWITCHES <= "0010";
   vKEY := "00110100001";
      
      wait for 3*cP; 
       
      for i in vKEY'range loop
       
       sPS2_DATA <= vKEY(i);
       wait for 100 ns; 
       
       sPS2_CLK <= '0';   
       wait for cP/2;   
       sPS2_CLK <= '1';   
       wait for cP/2;     
   
     end loop; 
     vKEY := "01010101011";
       for i in vKEY'range loop
        
        sPS2_DATA <= vKEY(i);
        wait for 100 ns; 
        
        sPS2_CLK <= '0';   
        wait for cP/2;   
        sPS2_CLK <= '1';   
        wait for cP/2;     
     
      end loop;
      sSwitches <= "0011";
      vKEY := "00110100001";
            
            wait for 3*cP; 
             
            for i in vKEY'range loop
             
             sPS2_DATA <= vKEY(i);
             wait for 100 ns; 
             
             sPS2_CLK <= '0';   
             wait for cP/2;   
             sPS2_CLK <= '1';   
             wait for cP/2;     
         
           end loop; 
           vKEY := "01010101011";
             for i in vKEY'range loop
              
              sPS2_DATA <= vKEY(i);
              wait for 100 ns; 
              
              sPS2_CLK <= '0';   
              wait for cP/2;   
              sPS2_CLK <= '1';   
              wait for cP/2;     
           
            end loop;  
  assert false
      report "End of tests"
        severity failure;

end process;


end Behavioral;
