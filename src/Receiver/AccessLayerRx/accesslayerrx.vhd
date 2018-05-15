-- Dries Kennes
-- AccessLayer (RX)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity accesslayerrx is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;

        sdi_spread: in std_logic;
        dip_sw : in std_logic_vector(1 downto 0);
        bit_sample: out std_logic;
        data_bit: out std_logic
    ) ;
end entity ; -- accesslayerrx

architecture arch of accesslayerrx is
    component correlator is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;

            chip_sample: in std_logic;
            bit_sample: in std_logic;
            chip_in: in std_logic;
            bit_out: out std_logic
        ) ;
    end component; -- correlator
    for correlator_u : correlator use entity work.correlator(behav);

    component dpll is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;
            
            sdi_spread: in std_logic;
            extb: out std_logic;
            chip_sample: out std_logic;
            chip_sample1: out std_logic;
            chip_sample2: out std_logic
        );
    end component;
    for dpll_u : dpll use entity work.dpll(structural);

    component matchedfilter is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;

            chip_sample: in std_logic;
            sdi_spread: in std_logic;
            dip_sw : in std_logic_vector(1 downto 0);
            seq_det: out std_logic
        ) ;
    end component;
    for matchedfilter_u : matchedfilter use entity work.matchedfilter(behav);

    component pngen_r is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;

            chip_sample: in std_logic;
            seq_det: in std_logic;
            pn_ml1: out std_logic;
            pn_ml2: out std_logic;
            pn_gold: out std_logic;
            full_seq: out std_logic
        );
    end component;
    for pngen_r_u : pngen_r use entity work.pngen_r(behav);

    signal chip_sample_s: std_logic;
    signal chip_sample1_s: std_logic;
    signal chip_sample2_s: std_logic;
    signal bit_sample_s: std_logic;
    signal chip_in_s: std_logic;
    signal despread_s: std_logic;
    signal pn_seq_s: std_logic;
    signal pn_ml1_s: std_logic;
    signal pn_ml2_s: std_logic;
    signal pn_gold_s: std_logic;
    signal seq_det_s: std_logic;
    signal seq_det_out_s: std_logic;
    signal extb_s: std_logic;

begin

    bit_sample <= bit_sample_s;
    chip_in_s <= sdi_spread when dip_sw = "00" else despread_s;
    despread_s <= sdi_spread xor pn_seq_s;
    pn_seq_s <= pn_ml1_s when dip_sw = "01" else pn_ml2_s when dip_sw = "10" else pn_gold_s;
    seq_det_s <= extb_s when dip_sw = "00" else seq_det_out_s;

    correlator_u: correlator PORT MAP(
        clk => clk,
        rst => rst,
        clk_en => clk_en,
        chip_sample => chip_sample2_s,
        bit_sample => bit_sample_s,
        chip_in => chip_in_s,
        bit_out =>data_bit 
    );

    dpll_u: dpll port map(
        clk => clk,
        clk_en => clk_en,
        rst => rst,

        sdi_spread => sdi_spread,
        chip_sample => chip_sample_s,
        chip_sample1 => chip_sample1_s,
        chip_sample2 => chip_sample2_s,
        extb => extb_s
    );

    matchedfilter_u: matchedfilter port map(
        clk => clk,
        clk_en => clk_en,
        rst => rst,

        chip_sample => chip_sample_s,
        sdi_spread => sdi_spread,
        dip_sw => dip_sw,
        seq_det => seq_det_out_s
    );

    pngen_r_u: pngen_r PORT MAP(
        clk => clk,
        rst => rst,
        clk_en => clk_en,

        chip_sample => chip_sample1_s,
        seq_det => seq_det_s,
        pn_ml1 => pn_ml1_s,
        pn_ml2 => pn_ml2_s,
        pn_gold => pn_gold_s,
        full_seq => bit_sample_s
    );

end architecture ; -- arch
