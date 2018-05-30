-- Dries Kennes
-- Correlator
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity correlator is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;

        chip_sample: in std_logic;
        bit_sample: in std_logic;
        chip_in: in std_logic;
        bit_out: out std_logic
    ) ;
end entity; -- correlator

architecture behav of correlator is

    signal bit_out_s, next_bit_out_s : std_logic;
    signal cnt_s, next_cnt_s : std_logic_vector(5 downto 0);

begin

    sync_correlator : process(clk)
    begin
        if (rising_edge(clk) and clk_en = '1') then
            if rst = '1' then
                bit_out_s <= '0';
                cnt_s <= "100000";
            else
                bit_out_s <= next_bit_out_s;
                cnt_s <= next_cnt_s;
            end if;
        end if;
    end process ; -- sync_correlator

    bit_out <= bit_out_s;

    comb_correlator : process(chip_in, chip_sample, bit_sample, cnt_s, bit_out_s)
    begin
        if chip_sample = '1' then
            if chip_in = '1' then
                next_cnt_s <= cnt_s + 1;
            else
                next_cnt_s <= cnt_s - 1;
            end if;
        else
            next_cnt_s <= cnt_s;
        end if;

        if bit_sample = '1' then
            next_bit_out_s <= cnt_s(5);
            next_cnt_s <= "100000";
        else
            next_bit_out_s <= bit_out_s;
        end if;
    end process ; -- comb_correlator

end architecture; -- behav
