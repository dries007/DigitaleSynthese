-- Dries Kennes
-- Transition segment decoder
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

use work.pkg_segments.all;

entity transsegdec is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;

        inp: in std_logic;
        segment: out segment
    );
end transsegdec;

architecture behav of transsegdec is

    signal pres_cnt, next_cnt: integer range 0 to 15;

begin
    
    sync_transsegdec: process(clk)
    begin
        if (rising_edge(clk) and clk_en = '1') then
            if rst = '1' then
                pres_cnt <= 0;
            else
                pres_cnt <= next_cnt;
            end if;
        end if;
    end process sync_transsegdec;


    comb_transsegdec: process(pres_cnt, inp)
    begin
        if inp = '1' then
            next_cnt <= 0;
        elsif pres_cnt = 15 then
            next_cnt <= pres_cnt;
        else
            next_cnt <= pres_cnt + 1;
        end if;

        case (pres_cnt) is
            when 0 to 4 => segment <= SEG_A;
            when 5 to 6 => segment <= SEG_B;
            when 7 to 8 => segment <= SEG_C;
            when 9 to 10 => segment <= SEG_D;
            when 11 to 15 => segment <= SEG_E;
        end case;

    end process comb_transsegdec;

end architecture ; -- behav
