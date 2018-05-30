-- Dries Kennes
-- Pngen (recv)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity pngen_r is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;

        chip_sample: in std_logic;
        seq_det: in std_logic;
        pn_ml1: out std_logic;
        pn_ml2: out std_logic;
        pn_gold: out std_logic;
        bit_sample: out std_logic
    );
end entity;

architecture behav of pngen_r is

    component edgedetect is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;

            inp: in std_logic;
            outp: out std_logic
        );
    end component;
    for ed : edgedetect use entity work.edgedetect(behav);

    signal pres_sr1, next_sr1: std_logic_vector(4 downto 0);
    signal pres_sr2, next_sr2: std_logic_vector(4 downto 0);

    signal full_seq_s: std_logic := '0';

begin

    ed: edgedetect PORT MAP(
        clk => clk,
        clk_en => clk_en,
        rst => rst,

        inp => full_seq_s,
        outp => bit_sample
    );

    -- Lowest bit is output.
    pn_ml1 <= pres_sr1(0);
    pn_ml2 <= pres_sr2(0);
    pn_gold <= pres_sr1(0) xor pres_sr2(0);

    sync_pngen_r : process(clk)
    begin
        if (rising_edge(clk) and clk_en = '1') then
            if rst = '1' then
                -- Non zero presets
                pres_sr1 <= "00010";
                pres_sr2 <= "00111";
            else
                if chip_sample = '1' then
                    pres_sr1 <= next_sr1;
                    pres_sr2 <= next_sr2;
                else
                    pres_sr1 <= pres_sr1;
                    pres_sr2 <= pres_sr2;
                end if;
            end if;
        end if;
    end process;

    comb_pngen_r : process(pres_sr1, pres_sr2, seq_det)
        -- GHDL doesn't like using xor in a concat, so use tmp variable.
        variable tmp: std_logic;
    begin
        -- Shift in from the top.
        tmp := pres_sr1(0) xor pres_sr1(3);
        next_sr1 <= tmp & pres_sr1(4 downto 1);

        tmp := pres_sr2(0) xor pres_sr2(1) xor pres_sr2(3) xor pres_sr2(4);
        next_sr2 <= tmp & pres_sr2(4 downto 1);

        -- Reset of sorts
        if (seq_det = '1') then
            next_sr1 <= "00010";
            next_sr2 <= "00111";
        end if;

        -- Send out start pulse.
        if (pres_sr1 = "00001") then
            full_seq_s <= '1';
        else
            full_seq_s <= '0';
        end if;
    end process;

end architecture;
