-- Dries Kennes
-- NCO (Numeric Controlled Ocilator)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

use work.pkg_segments.all;

entity nco is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;

        segment: in segment;
        chip_sample: out std_logic;
        chip_sample1: out std_logic;
        chip_sample2: out std_logic
    );
end nco;

architecture behav of nco is

    signal chip_sample_next, chip_sample_s, chip_sample1_s, chip_sample2_s: std_logic;
    signal pres_cnt, next_cnt: integer range 0 to 18;

begin

    chip_sample <= chip_sample_s;
    chip_sample1 <= chip_sample1_s;
    chip_sample2 <= chip_sample2_s;

    sync_nco: process(clk)
    begin
        if (rising_edge(clk) and clk_en = '1') then
            if rst = '1' then
                chip_sample_s <= '0';
                chip_sample1_s <= '0';
                chip_sample2_s <= '0';
                pres_cnt <= 0;
            else
                chip_sample_s <= chip_sample_next;
                chip_sample1_s <= chip_sample_s;
                chip_sample2_s <= chip_sample1_s;
                pres_cnt <= next_cnt;
            end if;
        end if;
    end process sync_nco;

    comb_nco : process(segment, pres_cnt)
    begin
        if pres_cnt = 0 then
            chip_sample_next <= '1';
            case (segment) is
                when SEG_A => next_cnt <= 15 + 3;
                when SEG_B => next_cnt <= 15 + 1;
                when SEG_C => next_cnt <= 15;
                when SEG_D => next_cnt <= 15 - 1;
                when SEG_E => next_cnt <= 15 - 3;
            end case;
        else
            chip_sample_next <= '0';
            next_cnt <= pres_cnt - 1;
        end if;
    end process;

end architecture;
