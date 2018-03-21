-- Dries Kennes
-- Counter
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity counter is
    generic (
        N: integer -- Number of bits
    );
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;
        
        cnt_up: in std_logic;
        cnt_down: in std_logic;
        cnt: out std_logic_vector(N downto 0)
    );
end counter;


architecture behav of counter is

    signal pres_cnt, next_cnt: std_logic_vector(N downto 0);

begin
    cnt <= pres_cnt;

    sync_counter: process(clk)
    begin
        if (rising_edge(clk) and clk_en = '1') then
            if rst = '1' then
                pres_cnt <= (others => '0');
            else
                pres_cnt <= next_cnt;
            end if;
        end if;
    end process sync_counter;

    comb_counter: process(pres_cnt, cnt_down, cnt_up)
    begin
        if (cnt_up = '1' and cnt_down = '0') then
            next_cnt <= pres_cnt + 1;
        elsif (cnt_up = '0' and cnt_down = '1') then
            next_cnt <= pres_cnt - 1;
        else -- If both or no input, do nothing.
            next_cnt <= pres_cnt;
        end if;
    
    end process comb_counter;

end behav;
