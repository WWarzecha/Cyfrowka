library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fpga is
	port (
		clk_input : in std_logic;
		spd_input : in std_logic;
		rvs_input : in std_logic;
		left_out : out std_logic_vector(6 downto 0);
		right_out : out std_logic_vector(6 downto 0)
	);
end fpga;


architecture snake of fpga is
	signal state : unsigned(2 downto 0) := "000";
	
	signal reverse_state: std_logic := '0';
	signal speed_state: std_logic := '0';

	constant fast_delay : natural := 10;
	constant slow_delay : natural := 2 * fast_delay;
	signal delay : natural := slow_delay;
	signal clock_counter : natural range 0 to 20 := 0;
	
	begin
	
	CHANGE_SPEED : process(spd_input)
	begin
		if spd_input ='1' then
			if speed_state = '1' then
				speed_state <= '0';
				delay <= slow_delay;
			else
				speed_state <= '1';
				delay <= fast_delay;
			end if;
		end if;
	end process CHANGE_SPEED;
	
	CHANGE_DIRECTION : process(rvs_input)
	begin
		if rvs_input = '1' then
			if reverse_state = '0' then
				reverse_state <= '1';
			else
				reverse_state <= '0';
			end if;
		end if;
	end process CHANGE_DIRECTION;

	
	MOVE: process(clk_input)
	begin
		if rising_edge(clk_input) then
			clock_counter <= clock_counter + 1;
			
			if clock_counter >= delay then
				if reverse_state = '0' then
					state <= state + 1;
				else
					state <= state -1;
				end if;
				
				clock_counter <= 0;
			end if;
		end if;
	end process MOVE;
	
	
	DISPLAY : process(state)
	begin
		case state is
		when "000" => 
			left_out <= "1110111";
			right_out <= "1110111";
		when "001" => 
			left_out <= "1111111";
			right_out <= "1110011";
		when "010" => 
			left_out <= "1111111";
			right_out <= "1111001";
		when "011" => 
			left_out <= "1111111";
			right_out <= "0111101";
		when "100" => 
			left_out <= "0111111";
			right_out <= "0111111";
		when "101" => 
			left_out <= "0011111";
			right_out <= "1111111";
		when "110" => 
			left_out <= "1001111";
			right_out <= "1111111";
		when "111" => 
			left_out <= "1100111";
			right_out <= "1111111";
		when others =>
			left_out <= "1111111";
			right_out <= "1111111";
		end case;
		
	end process DISPLAY;
		
end snake;	
	