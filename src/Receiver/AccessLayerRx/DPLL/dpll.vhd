-- Dries Kennes
-- DPLL
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

use work.pkg_segments.all;

entity dpll is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;
        
        sdi_spread: in std_logic;
        chip_sample: out std_logic;
        chip_sample1: out std_logic;
        chip_sample2: out std_logic
    );
end entity;

architecture structural of dpll is

    component transdet is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;

            inp: in std_logic;
            outp: out std_logic
        );
    end component;
    for transdet_s: transdet use entity work.transdet(behav);

    component transsegdec is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;

            inp: in std_logic;
            segment: out segment
        );
    end component;
    for transsegdec_s: transsegdec use entity work.transsegdec(behav);

    component seg_semaphore is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;

            inp: in segment;
            outp: out segment;
            extb: in std_logic;
            chip_sample: in std_logic
        );
    end component;
    for seg_semaphore_s: seg_semaphore use entity work.seg_semaphore(behav);

    component nco is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;

            segment: in segment;
            chip_sample: out std_logic;
            chip_sample1: out std_logic;
            chip_sample2: out std_logic
        );
    end component;
    for nco_s: nco use entity work.nco(behav);

    signal extb_s : std_logic;
    signal segment_out_s, segment_in_s: segment;
    signal chip_sample_s, chip_sample1_s, chip_sample2_s: std_logic;

begin

    chip_sample <= chip_sample_s;
    chip_sample1 <= chip_sample1_s;
    chip_sample2 <= chip_sample2_s;

    transdet_s: transdet port map(
        clk => clk,
        rst => rst,
        clk_en => clk_en,

        inp => sdi_spread,
        outp => extb_s
    );

    transsegdec_s: transsegdec port map(
        clk => clk,
        rst => rst,
        clk_en => clk_en,

        inp => extb_s,
        segment => segment_in_s
    );

    seg_semaphore_s: seg_semaphore port map(
        clk => clk,
        rst => rst,
        clk_en => clk_en,
        inp => segment_in_s,
        outp => segment_out_s,
        extb => extb_s,
        chip_sample => chip_sample_s
    );

    nco_s: nco PORT MAP(
        clk => clk,
        clk_en => clk_en,
        rst => rst,

        segment => segment_out_s,
        chip_sample => chip_sample_s,
        chip_sample1 => chip_sample1_s,
        chip_sample2 => chip_sample2_s
    );

end architecture ; -- structural
