-- Dries Kennes
-- Pngen (recv) Test
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;



----------------- TODO (hele file)


entity pngen_r_tb is
end entity;

architecture arch of pngen_r_tb is

    component pngen_r is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;

            pn_ml1: out std_logic;
            pn_ml2: out std_logic;
            pn_gold: out std_logic;
            ctrl: out std_logic
        );
    end component;

    for uut : pngen_r use entity work.pngen_r(behav);

    constant period : time := 100 ns;
    constant delay  : time :=  10 ns;

    signal end_of_sim : boolean := false;

    signal clk_s: std_logic;
    signal clk_en_s: std_logic;
    signal rst_s: std_logic;

    signal pn_ml1_s: std_logic;
    signal pn_ml2_s: std_logic;
    signal pn_gold_s: std_logic;
    signal ctrl_s: std_logic;

begin

    uut: pngen_r PORT MAP(
        clk => clk_s,
        rst => rst_s,
        clk_en => clk_en_s,

        pn_ml1 => pn_ml1_s,
        pn_ml2 => pn_ml2_s,
        pn_gold => pn_gold_s,
        ctrl => ctrl_s
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
        clk_en_s <= '1';
        -- reset
        rst_s <= '1';
        wait for 5*period;
        rst_s <= '0';
        wait for 5*period;

        -- Generates input based on output clock, so no inputs here.
        wait for 5*period;

        -- Test reset in middle of squence
        rst_s <= '1';
        wait for period;
        rst_s <= '0';
        wait for period;

        -- Generate enough output to get more than 1 squence.
        wait for 64 * period;

        -- end of sim
        end_of_sim <= true;
        wait;
    end process;

end architecture ; -- arch