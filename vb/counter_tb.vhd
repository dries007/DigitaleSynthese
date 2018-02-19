library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity counter_tb is
end counter_tb;

architecture structural of counter_tb is 

-- Component Declaration
component counter
port (
	clk: in std_logic;
	up_down: in std_logic;
	rst: in std_logic;
	count_out: out std_logic_vector(3 downto 0)
  );
end component;

for uut : counter use entity work.counter(behav);
 
constant period : time := 100 ns;
constant delay  : time :=  10 ns;
signal end_of_sim : boolean := false;

signal clk:  std_logic;
signal rst:  std_logic;
signal up_down:  std_logic;
signal count_out: std_logic_vector(3 downto 0);

BEGIN

	uut: counter PORT MAP(
      clk => clk,
      rst => rst,
      up_down => up_down,
      count_out => count_out);

	clock : process
   begin 
       clk <= '0';
       wait for period/2;
     loop
       clk <= '0';
       wait for period/2;
       clk <= '1';
       wait for period/2;
       exit when end_of_sim;
     end loop;
     wait;
   end process clock;
	
tb : PROCESS
   procedure tbvector(constant stimvect : in std_logic_vector(1 downto 0))is
     begin
      up_down <= stimvect(1);
      rst <= stimvect(0);

       wait for period;
   end tbvector;
   BEGIN
       
      tbvector("01");
      tbvector("01");
      tbvector("00");
      tbvector("00");
      tbvector("10");
      tbvector("10");
      tbvector("10");
      tbvector("10");
      tbvector("00");
      tbvector("00");
      tbvector("01");
      tbvector("01");   
                        
      end_of_sim <= true;
      wait;
   END PROCESS;

  END;




