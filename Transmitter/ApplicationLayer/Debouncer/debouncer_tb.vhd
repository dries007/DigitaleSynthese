-- Dries Kennes
-- Debouncer Test
library IEEE;
use IEEE.std_logic_1164.all;

entity debouncer_tb is
end debouncer_tb;

architecture structural of debouncer_tb is

    component debouncer is
      port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;
        cha: in std_logic;
        syncha: out std_logic
      );
    end component;

    for uut : debouncer use entity work.debouncer(behav);

    constant period : time := 100 ns;
    constant delay  : time :=  10 ns;

    signal end_of_sim : boolean := false;

    signal clk_s:  std_logic;
    signal rst_s:  std_logic;
    signal cha_s:  std_logic;
    signal clk_en_s: std_logic;
    signal syncha_s: std_logic;

begin

    uut: debouncer PORT MAP(
        clk => clk_s,
        rst => rst_s,
        cha => cha_s,
        clk_en => clk_en_s,
        syncha => syncha_s
    );

    clock : process
    begin 
        clk_s <= '0';
        wait for period/2;
        loop
            clk_s <= '0';
            wait for period/2;
            clk_S <= '1';
            wait for period/2;
        exit when end_of_sim;
        end loop;
        wait;
    end process clock;

    tb : process
    procedure tbvector(constant stimvect : in std_logic_vector(2 downto 0)) is
    begin
        cha_s <= stimvect(0);
        clk_en_s <= stimvect(1);
        rst_s <= stimvect(2);
    end tbvector;

    begin
        -- reset
        tbvector ("110");
        wait for 3*period;
        tbvector ("011");
        wait for 3*period;

	-- simulating bouncing
        tbvector("011");
        wait for period/3;
        tbvector("010");
        wait for period/2;
        tbvector("011");
        wait for period/2;
        tbvector("010");
        wait for period/6;  
        tbvector("011");
        wait for period/3;
        tbvector("010");
        wait for period/3;
        tbvector("011");
        wait for period/6;
        tbvector("010");
        wait for 2*period/3;
        -- done bouncing
  
        wait for 4*period;

        -- simulating bouncing
        tbvector("010");
        wait for period/2;
        tbvector("011");
        wait for period/3;
        tbvector("010");
        wait for 2*period/3;
        tbvector("011");
        wait for period/3;      
        tbvector("010");
        wait for period/2;
        tbvector("011");
        wait for period/2;
        tbvector("010");
        wait for period/3;
        tbvector("011");
        wait for 5*period/6;
    	-- done bouncing
    
        wait for 5*period;

    	-- simulating bouncing
        tbvector("011");
        wait for 2*period/3;
        tbvector("010");
        wait for period/2;
        tbvector("011");
        wait for period/6;
        tbvector("010");
        wait for 2*period/3;        
        tbvector("011");
        wait for period/6;
        tbvector("010");
        wait for 2*period/3;
        tbvector("011");
        wait for period/3;
        tbvector("010");
        wait for period/2;
    -- done bouncing
    
        wait for 2*period;

    -- simulating bouncing
        tbvector("010");
        wait for period/2;
        tbvector("011");
        wait for period/3;
        tbvector("010");
        wait for 2*period/3;
        tbvector("011");
    
        -- end of sim
        end_of_sim <= true;
        wait;
    end process;

end structural;