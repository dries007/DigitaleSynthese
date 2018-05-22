-- Dries Kennes
-- ApplicationLayer
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity applicationlayer is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;
        
        up: in std_logic;
        down: in std_logic;
        count: out std_logic_vector(3 downto 0);
        segments: out std_logic_vector(7 downto 0)
    );
end applicationlayer;

architecture structural of applicationlayer is
    component debouncer is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;

            cha: in std_logic;
            syncha: out std_logic
        );
    end component;
    for debouncer_up: debouncer use entity work.debouncer(behav);
    for debouncer_down: debouncer use entity work.debouncer(behav);

    component edgedetect is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;

            inp: in std_logic;
            outp: out std_logic
        );
    end component;
    for edgedetect_up : edgedetect use entity work.edgedetect(behav);
    for edgedetect_down : edgedetect use entity work.edgedetect(behav);

    component counter is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;

            cnt_up: in std_logic;
            cnt_down: in std_logic;
            cnt: out std_logic_vector(3 downto 0)
        );
    end component;
    for counter_s : counter use entity work.counter(behav);

    component sevensegdecoder is
        port (
            inp: in std_logic_vector(3 downto 0);
            dp:  in std_logic;
            outp: out std_logic_vector(7 downto 0)
        );
    end component;
    for sevensegdecoder_s : sevensegdecoder use entity work.sevensegdecoder(behav);

    signal debounced_up:  std_logic;
    signal debounced_down:  std_logic;

    signal edge_up:  std_logic;
    signal edge_down:  std_logic;

    signal count_s: std_logic_vector(3 downto 0);

begin

    debouncer_up: debouncer PORT MAP(
        clk => clk,
        clk_en => clk_en,
        rst => rst,

        cha => up,
        syncha => debounced_up
    );
    debouncer_down: debouncer PORT MAP(
        clk => clk,
        clk_en => clk_en,
        rst => rst,

        cha => down,
        syncha => debounced_down
    );

    edgedetect_up: edgedetect PORT MAP(
        clk => clk,
        clk_en => clk_en,
        rst => rst,

        inp => debounced_up,
        outp => edge_up
    );

    edgedetect_down: edgedetect PORT MAP(
        clk => clk,
        clk_en => clk_en,
        rst => rst,

        inp => debounced_down,
        outp => edge_down
    );

    counter_s: counter PORT MAP(
        clk => clk,
        rst => rst,
        clk_en => clk_en,

        cnt_up => edge_up,
        cnt_down => edge_down,
        cnt => count_s
    );
    count <= count_s; -- Also output this for the 7seg disp.

    sevensegdecoder_s: sevensegdecoder PORT MAP(
        inp => count_s,
        dp => rst, -- Decimal point = feedback on reset
        outp => segments
    );

end structural;