-- Dries Kennes
-- Edgedetect
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity edgedetect is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;

        inp: in std_logic;
        outp: out std_logic
    );
end edgedetect;

architecture behav of edgedetect is
    -- Oh look, a proper state machine :)
    type states is (w1, p1, w0);

    signal pres_state : states;
    signal next_state : states;

begin
    sync_edgedetect: process(clk)
    begin
        if (rising_edge(clk) and clk_en = '1') then
            if rst = '1' then
                pres_state <= w1;
            else
                pres_state <= next_state;
            end if;
        end if;
    end process sync_edgedetect;

    comb_edgedetect: process(pres_state, inp)
    begin
        case pres_state is
        when w1 =>
            outp <= '0';
            if inp = '1' then
                next_state <= p1;
            else
                next_state <= w1;
            end if;
        when p1 =>
            outp <= '1';
            if inp = '0' then
                next_state <= w1;
            else
                next_state <= w0;
            end if;
        when w0 =>
            outp <= '0';
            if inp = '0' then
                next_state <= w1;
            else
                next_state <= w0;
            end if;
        end case;
    end process comb_edgedetect;

end behav;
