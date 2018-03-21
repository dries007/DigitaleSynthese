-- Dries Kennes
-- Sequence Controller
library IEEE;
use IEEE.std_logic_1164.all;

entity sequencecontroller_tb is
end sequencecontroller_tb;

architecture structural of sequencecontroller_tb is

    component sequencecontroller is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;

            ctrl: in std_logic;
            load: out std_logic;
            shift: out std_logic
        );
    end component;

    for uut : sequencecontroller use entity work.sequencecontroller(behav);

    constant period : time := 100 ns;
    constant delay  : time :=  10 ns;

    signal end_of_sim : boolean := false;

    signal clk_s: std_logic;
    signal clk_en_s: std_logic;
    signal rst_s: std_logic;
    
    signal ctrl_s: std_logic;
    signal load_s: std_logic;
    signal shift_s: std_logic;

begin

    uut: sequencecontroller PORT MAP(
        clk => clk_s,
        rst => rst_s,
        clk_en => clk_en_s,

        ctrl => ctrl_s,
        load => load_s,
        shift => shift_s
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
    begin
        ctrl_s <= '0';
        clk_en_s <= '1';
        -- reset
        rst_s <= '1';
        wait for 5*period;
        rst_s <= '0';
        wait for 5*period;

        for i in 0 to 50
        loop
            ctrl_s <= '1';
            wait for period;
            ctrl_s <= '0';
            wait for 30*period;
        end loop;

        -- end of sim
        end_of_sim <= true;
        wait;
    end process;

end structural;
