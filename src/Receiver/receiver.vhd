-- Dries Kennes
-- Receiver
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity receiver is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;

        dip: in std_logic_vector(1 downto 0);
        segments: out std_logic_vector(7 downto 0);
        sdi_spread: in std_logic
    );
end entity;

architecture arch of receiver is

    component accesslayerrx is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;

            sdi_spread: in std_logic;
            dip_sw : in std_logic_vector(1 downto 0);
            bit_sample: out std_logic;
            data_bit: out std_logic
        ) ;
    end component ; -- accesslayerrx
    for al : accesslayerrx use entity work.accesslayerrx(arch);

    component sevensegdecoder is
        port (
            inp: in std_logic_vector(3 downto 0);
            dp:  in std_logic;
            outp: out std_logic_vector(7 downto 0)
        );
    end component;
    for sevensegdecoder_s : sevensegdecoder use entity work.sevensegdecoder(behav);

    signal bit_sample_s: std_logic;
    signal data_bit_s: std_logic;
    signal count_s, count_next_s: std_logic_vector(3 downto 0);
    signal data_s, data_next_s: std_logic_vector(10 downto 0);

begin

    al: accesslayerrx port map(
        clk => clk,
        rst => rst,
        clk_en => clk_en,

        sdi_spread => sdi_spread,
        dip_sw => dip,
        bit_sample => bit_sample_s,
        data_bit => data_bit_s
    );

    sevensegdecoder_s: sevensegdecoder port map(
        inp => count_s,
        dp => rst,
        outp => segments
    );

    sync_rec : process(clk)
    begin
        if (rising_edge(clk) and clk_en = '1') then
            if rst = '1' then
                count_s <= (others => '0');
                data_s <= (others => '0');
            else
                count_s <= count_next_s;
                data_s <= data_next_s;
            end if;
        end if;
    end process;

    comb_rec : process(data_bit_s, bit_sample_s, count_s, data_s)
    begin
        if bit_sample_s = '1' then
            data_next_s <= data_s(9 downto 0) & data_bit_s;
        else
            data_next_s <= data_s;
        end if;
        if data_s(10 downto 4) = "0111110" then
            count_next_s <= data_s(3 downto 0);
        else
            count_next_s <= count_s;
        end if;
    end process;


end architecture ; -- arch
