-- Dries Kennes
-- AccessLayer
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity accesslayer is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;
        
        sdo_posenc: in std_logic;
        dip_sw : in std_logic_vector(1 downto 0);
        ctrl: out std_logic;
        sdo_spread: out std_logic
    );
end entity;

architecture structural of accesslayer is
    
    component demux is
        port (
            inp: in std_logic_vector(3 downto 0);
            sel: in std_logic_vector(1 downto 0);
            outp: out std_logic
        );
    end component;
    for demux_s: demux use entity work.demux(behav);

    component pngen is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;

            pn_ml1: out std_logic;
            pn_ml2: out std_logic;
            pn_gold: out std_logic;
            ctrl: out std_logic
        );
    end component;
    for pngen_s: pngen use entity work.pngen(behav);

    signal pn_ml1_s: std_logic;
    signal pn_ml2_s: std_logic;
    signal pn_gold_s: std_logic;

    signal sdo_posenc_s: std_logic;
    signal demux_inp_s: std_logic_vector(3 downto 0);

    signal pn_lm1_xor_s : std_logic;
    signal pn_lm2_xor_s : std_logic;
    signal pn_gold_xor_s : std_logic;

begin

    pngen_s: pngen port map(
        clk => clk,
        rst => rst,
        clk_en => clk_en,

        pn_ml1 => pn_ml1_s,
        pn_ml2 => pn_ml2_s,
        pn_gold => pn_gold_s,
        ctrl => ctrl
    );

    -- Combinatorial signals

    pn_lm1_xor_s <= pn_ml1_s xor sdo_posenc;
    pn_lm2_xor_s <= pn_ml2_s xor sdo_posenc;
    pn_gold_xor_s <= pn_gold_s xor sdo_posenc;
    sdo_posenc_s <= sdo_posenc;
    demux_inp_s <= pn_gold_xor_s & pn_lm1_xor_s & pn_lm2_xor_s & sdo_posenc_s;
    
    demux_s: demux port map(
            inp => demux_inp_s,
            sel => dip_sw,
            outp => sdo_spread
    );

end architecture;
