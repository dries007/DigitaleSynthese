-- Dries Kennes
-- Segment Semaphore
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

use work.pkg_segments.all;

entity seg_semaphore is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;

        inp: in segment;
        outp: out segment;
        extb: in std_logic;
        chip_sample: in std_logic
    ) ;
end entity;

architecture behav of seg_semaphore is

    type states is (set, unset);
    signal state, next_state: states;

begin

    sync_seg_semaphore : process(clk)
    begin
        if (rising_edge(clk) and clk_en = '1') then
            if rst = '1' then
                state <= unset;
            else
                state <= next_state;
            end if;
        end if;
    end process;

    outp <= inp when state = set else SEG_C;

    comb_seg_semaphore : process(extb, chip_sample, state)
    begin
        next_state <= state;
        if chip_sample = '1' then
            next_state <= unset;
        end if;
        if extb = '1' then
            next_state <= set;
        end if;
    end process;
end architecture;
