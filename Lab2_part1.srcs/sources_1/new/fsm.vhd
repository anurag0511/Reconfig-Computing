----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/11/2017 07:00:52 PM
-- Design Name: 
-- Module Name: fsm - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;



-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fsm is
Port (	
    CLK_100MHZ : in  std_logic;  -- Main FPGA clock, needed for designs with external clock

    PS2_CLK   : in  std_logic;  -- keyboard clock
    PS2_DATA  : in  std_logic;  -- keyboard data    
    BTN_UP    : in  std_logic;
    SWITCHES  : in  std_logic_vector (3 downto 0);
    LEDS      : out std_logic_vector (7 downto 0)
); 
end fsm;

architecture Behavioral of fsm is
    signal sreg : std_logic_vector (7 downto 0);
	signal shex : std_logic_vector (15 downto 0);
    signal spar : std_logic;
    signal sparb : std_logic_vector(1 downto 0);
	signal reset : std_logic;
	signal ssel  : std_logic_vector (3 downto 0);
	signal s_clk_divider: std_logic_vector(27 downto 0);
	signal s_clk_enable:std_logic;
    signal check_par : std_logic_vector(1 downto 0);
    signal temp_par : std_logic;
    signal temp_par2,temp_parf : std_logic;
	type t_state is (idle, rd0,rd1,rd2,rd3,rd4,rd5,rd6,rd7,rdp,rds);
	--signal s_state : t_state; 
	attribute ENUM_ENCODING: STRING;
	attribute ENUM_ENCODING of t_state: type is "0000 0001 0010 0011 0100 0101 0110 0111 1000 1001 1010"; 
	signal curr_state, next_state: t_state;
	signal s_clk,syn_in, syn_mid,syn_out,edge_in,edge_out,ps2_enable:std_logic;
	signal s_data,s_reg1,s_reg2,s_reg3:std_logic;
begin
    reset <= BTN_UP;
    ssel <= SWITCHES;
    s_clk <= PS2_CLK;
    s_data<=PS2_DATA;
    process (CLK_100MHZ,reset)
    begin
    if reset ='1' then
        syn_in <= '0';
        syn_mid <= '0';
        syn_out <= '0';
        edge_in <= '0';
        edge_out <= '0';
     elsif CLK_100MHZ'event and CLK_100MHZ = '1' then
        
        syn_mid <= s_clk;
        syn_out <= syn_mid;
        edge_in <= syn_out;
        edge_out <= edge_in;
        ps2_enable <= not(edge_out) and edge_in; 
     end if;   
    end process;
    
    process(CLK_100MHZ,reset)
    begin
    if reset = '1' then
        s_reg1 <= '0';        
        s_reg2 <= '0';
        s_reg3 <= '0';
    elsif CLK_100MHZ'event and CLK_100MHZ = '1' then
        s_reg1 <= s_data;
        s_reg2 <= s_reg1;
        s_reg3 <= s_reg2;
        
    end if;
    end process;
     
    process (CLK_100MHZ, reset,ps2_enable)
    variable read_enable : std_logic;
    variable count : unsigned(3 downto 0);
    begin
    
    if (reset = '1') then 
        curr_state <= idle;
        read_enable := '0';
        sreg <= (others => '0');
        shex <= (others => '0');
    --elsif (CLK_100MHZ'event and CLK_100MHZ = '1')  then
            --if ((ps2_enable)='1') and s_clk_enable ='1' then 
       elsif (CLK_100MHZ'event and CLK_100MHZ = '1' and ps2_enable='1') then
                --read_enable := '1';
                case curr_state is
                when idle => count := (others=>'0'); 
                     curr_state <= next_state;
                when rd0 to rd7 => 
                    --if (read_enable = '1') then 
                        sreg(6 downto 0) <= sreg(7 downto 1);
                        sreg(7) <= s_reg3;
                        --count := count+1;
                        curr_state <= next_state;
                    --end if;
                                                                                                                    
                when rdp => spar <= s_reg3;
                            temp_par <= (sreg(7) xor sreg(6) xor sreg(5) xor sreg(4)) xor (sreg(3) xnor sreg(2) xnor sreg(1) xnor sreg(0));
                            --temp_par2 <=  
                            --temp_parf <= temp_par xor temp_par2;
                         count := (others=> '0');
                         curr_state <= next_state; 
                when rds => shex ( 15 downto 8) <= shex(7 downto 0);
                            sparb (1) <= sparb(0);
                            check_par(1) <= check_par(0);
                            shex (7 downto 0) <= sreg(7 downto 0);
                            --check_par(1) <=(shex(15) xor shex(14) xor shex(13) xor shex(12) xor shex(11) xor shex(10) xor shex(9) xor shex(8));
                            --check_par(0) <=
                            check_par(0) <= temp_par; 
                            sparb (0) <= spar;
                            curr_state <= next_state; 
                end case;
             end if;
          --end if;                            
--    LEDS <= shex(15 downto 8);     
end process;
    
    process (curr_state) is 
    begin 
        case curr_state is 
        when idle => next_state <= rd0;
        when rd0 => next_state <= rd1;
        when rd1 => next_state <= rd2;
        when rd2 => next_state <= rd3;
        when rd3 => next_state <= rd4;
        when rd4 => next_state <= rd5;
        when rd5 => next_state <= rd6;
        when rd6 => next_state <= rd7;
        when rd7 => next_state <= rdp;
        when rdp => next_state <= rds;
        when rds => next_state <= idle;
        end case;     
    end process;
    
    process (ssel, shex)
        begin
            case ssel is
                when "0000" => LEDS <= shex (15 downto 8);
                when "0001" => LEDS <= shex (7  downto 0);
                when "0011" => LEDS(1 downto 0) <= check_par(1 downto 0);
                               LEDS( 7 downto 2) <= (others=> '0');
                when "0010" => LEDS(1 downto 0) <= sparb(1 downto 0);
                               LEDS( 7 downto 2) <= (others=> '0');
                when others => LEDS <= X"FF";
            end case;
        end process;
        
        process (CLK_100MHZ,reset)
        begin
            if (reset = '1') then 
                s_clk_divider <= (others => '0');
                s_clk_enable <= '0';
            elsif (CLK_100MHZ'event and CLK_100MHZ = '1') then
     --           if (s_clk_divider = X"5F5E100") then
                if (s_clk_divider = X"0000100") then
                    s_clk_divider <= (others => '0');
                    s_clk_enable <= '1';
                else
                    s_clk_divider <= std_logic_vector(unsigned(s_clk_divider)+1);
                    s_clk_enable <= '0';
                end if; 
            end if;           
        end process; 
end Behavioral;