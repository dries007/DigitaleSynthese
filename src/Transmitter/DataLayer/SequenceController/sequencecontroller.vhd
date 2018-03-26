-- Dries Kennes
-- Sequence Controller
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity sequencecontroller is
  port (
    clk: in std_logic;
    clk_en: in std_logic;
    rst: in std_logic;

    ctrl: in std_logic;
    load: out std_logic;
    shift: out std_logic
  );
end entity;

architecture behav of sequencecontroller is

    signal pres_cnt, next_cnt: integer range 0 to 11;

begin

    sync_sq: process(clk)
    begin
        if (rising_edge(clk) and clk_en = '1') then
            if rst = '1' then
                pres_cnt <= 0;
            else
                pres_cnt <= next_cnt;
            end if;
        end if;
    end process sync_sq;

    comb_sq: process(pres_cnt, ctrl)
    begin
        -- Set defaults
        next_cnt <= pres_cnt;
        load <= '0';
        shift <= '0';
        if ctrl = '1' then
            next_cnt <= pres_cnt + 1; -- Override prev default
            shift <= '1'; -- Override prev default
            if pres_cnt = 0 then
                shift <= '0'; -- Override prev default
                load <= '1';  -- Override prev default
            elsif pres_cnt = 10 then
                next_cnt <= 0; -- Reset counter
            end if;
        end if;
    end process comb_sq;

end architecture;
