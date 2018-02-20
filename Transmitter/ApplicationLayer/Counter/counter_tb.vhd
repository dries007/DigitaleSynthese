-- Dries Kennes
-- Counter Test
library IEEE;
use IEEE.std_logic_1164.all;

entity counter_tb is
end counter_tb;

architecture structural of counter_tb is

    component counter is
      port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;
        cnt_up: in std_logic;
        cnt_down: in std_logic;
        cnt: out std_logic_vector(3 downto 0)
      );
    end component;

    for uut : counter use entity work.counter(behav);

    constant period : time := 100 ns;
    constant delay  : time :=  10 ns;

    signal end_of_sim : boolean := false;

    signal rst_s: std_logic;
    signal clk_s: std_logic;
    signal clk_en_s: std_logic;
    
    signal cnt_up_s: std_logic;
    signal cnt_down_s: std_logic;
    signal cnt_s: std_logic_vector(3 downto 0);

begin

    uut: counter PORT MAP(
        clk => clk_s,
        rst => rst_s,
        clk_en => clk_en_s,

        cnt_up => cnt_up_s,
        cnt_down => cnt_down_s,
        cnt => cnt_s
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
        cnt_up_s <= stimvect(0);
        cnt_down_s <= stimvect(1);
    end tbvector;

    begin
        tbvector("00");
        clk_en_s <= '1';
        -- reset
        rst_s <= '1';
        wait for 5*period;
        rst_s <= '0';
        wait for 5*period;

	    -- simulating couting
        tbvector("00");
        wait for period;

        tbvector("10");
        wait for period;
        tbvector("10");
        wait for period;
        tbvector("10");
        wait for period;

        tbvector("00");
        wait for period * 3;

        tbvector("01");
        wait for period;
        tbvector("01");
        wait for period;
        tbvector("01");
        wait for period;

        tbvector("00");
        wait for period * 3;

        tbvector("01");
        wait for period;
        tbvector("01");
        wait for period;
        tbvector("01");
        wait for period;
        tbvector("01");
        wait for period;
        tbvector("01");
        wait for period;
        tbvector("01");
        wait for period;

        tbvector("00");
        wait for period * 3;

        -- end of sim
        end_of_sim <= true;
        wait;
    end process;

end structural;