-- Dries Kennes
-- Transition detector
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity transdet is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;

        inp: in std_logic;
        outp: out std_logic
    );
end transdet;

architecture behav of transdet is

    type states is (w1, p1, w0, p0);

    signal pres_state : states;
    signal next_state : states;

begin

    sync_transdet: process(clk)
    begin
        if (rising_edge(clk) and clk_en = '1') then
            if rst = '1' then
                pres_state <= w1;
            else
                pres_state <= next_state;
            end if;
        end if;
    end process sync_transdet;

    comb_transdet: process(pres_state, inp)
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
                next_state <= p0;
            else
                next_state <= w0;
            end if;
        when w0 =>
            outp <= '0';
            if inp = '0' then
                next_state <= p0;
            else
                next_state <= w0;
            end if;
        when p0 =>
            outp <= '1';
            if inp = '1' then
                next_state <= p1;
            else
                next_state <= w1;
            end if;
        end case;
    end process comb_transdet;


end architecture ; -- behav
