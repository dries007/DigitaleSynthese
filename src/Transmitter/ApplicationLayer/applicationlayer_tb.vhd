-- Dries Kennes
-- ApplicationLayer Test
library IEEE;
use IEEE.std_logic_1164.all;

entity applicationlayer_tb is
end applicationlayer_tb;

architecture structural of applicationlayer_tb is

    component applicationlayer is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;

            up: in std_logic;
            down: in std_logic;
            count: out std_logic_vector(3 downto 0);
            segments: out std_logic_vector(7 downto 0)
        );
    end component;

    for uut : applicationlayer use entity work.applicationlayer(structural);

    constant period : time := 100 ns;
    constant delay  : time :=  10 ns;

    signal end_of_sim : boolean := false;

    signal clk_s:  std_logic;
    signal clk_en_s: std_logic;
    signal rst_s:  std_logic;

    signal up_s:  std_logic;
    signal down_s: std_logic;

    signal count_s:  std_logic_vector(3 downto 0);
    signal segments_s: std_logic_vector(7 downto 0);

begin

    uut: applicationlayer PORT MAP(
        clk => clk_s,
        clk_en => clk_en_s,
        rst => rst_s,

        up => up_s,
        down => down_s,
        count => count_s,
        segments => segments_s
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
    procedure tbvector(constant stimvect : in std_logic_vector(1 downto 0)) is
    begin
        up_s <= stimvect(0);
        down_s <= stimvect(1);
    end tbvector;

    begin
        clk_en_s <= '1';
        -- reset
        rst_s <= '1';
        wait for 5*period;
        rst_s <= '0';
        wait for 5*period;

        -- This TB is a combination of the previous test benches, with bounced inputs.

        for i in 0 to 3
        loop
            -- simulating bouncing up
            tbvector("01"); wait for period/3;
            tbvector("00"); wait for period/2;
            tbvector("01"); wait for period/2;
            tbvector("00"); wait for period/6;  
            tbvector("01"); wait for period/3;
            tbvector("00"); wait for period/3;
            tbvector("01"); wait for period/6;
            tbvector("00"); wait for 2*period/3;
            -- done bouncing
            wait for 5*period;

            -- simulating bouncing up
            tbvector("00"); wait for period/2;
            tbvector("01"); wait for period/3;
            tbvector("00"); wait for 2*period/3;
            tbvector("01"); wait for period/3;      
            tbvector("00"); wait for period/2;
            tbvector("01"); wait for period/2;
            tbvector("00"); wait for period/3;
            tbvector("01"); wait for 5*period/6;
            -- done bouncing
            wait for 5*period;
        end loop;

        wait for 10*period;

        for i in 0 to 7
        loop
            -- simulating bouncing down
            tbvector("10"); wait for period/3;
            tbvector("00"); wait for period/2;
            tbvector("10"); wait for period/2;
            tbvector("00"); wait for period/6;  
            tbvector("10"); wait for period/3;
            tbvector("00"); wait for period/3;
            tbvector("10"); wait for period/6;
            tbvector("00"); wait for 2*period/3;
            -- done bouncing
            wait for 5*period;

            -- simulating bouncing down
            tbvector("00"); wait for period/2;
            tbvector("10"); wait for period/3;
            tbvector("00"); wait for 2*period/3;
            tbvector("10"); wait for period/3;      
            tbvector("00"); wait for period/2;
            tbvector("10"); wait for period/2;
            tbvector("00"); wait for period/3;
            tbvector("10"); wait for 5*period/6;
            -- done bouncing
            wait for 5*period;
        end loop;
    
        -- end of sim
        end_of_sim <= true;
        wait;
    end process;

end structural;