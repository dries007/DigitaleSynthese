-- Dries Kennes
-- Matched filter Test
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity matchedfilter_tb is
end entity ; -- matchedfilter_tb

architecture arch of matchedfilter_tb is

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
    for uut : matchedfilter use entity work.matchedfilter(behav);

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

    for uut_pngen : pngen use entity work.pngen(behav);

    constant period : time := 100 ns;
    constant delay  : time :=  10 ns;

    signal end_of_sim : boolean := false;

    signal clk_s:  std_logic;
    signal rst_s:  std_logic;
    signal clk_en_s: std_logic;

    signal pn_ml1_s: std_logic;
    signal pn_ml2_s: std_logic;
    signal pn_gold_s: std_logic;
    signal ctrl_s: std_logic;

    signal invert: boolean := false;

    signal chip_sample_s:  std_logic;
    signal sdi_spread_s:  std_logic;
    signal dip_sw_s: std_logic_vector(1 downto 0);
    signal seq_det_s: std_logic;

begin

    uut: matchedfilter port map(
        clk => clk_s,
        clk_en => clk_en_s,
        rst => rst_s,

        chip_sample => chip_sample_s,
        sdi_spread => sdi_spread_s,
        dip_sw => dip_sw_s,
        seq_det => seq_det_s
    );

    uut_pngen: pngen PORT MAP(
        clk => clk_s,
        rst => rst_s,
        clk_en => clk_en_s,

        pn_ml1 => pn_ml1_s,
        pn_ml2 => pn_ml2_s,
        pn_gold => pn_gold_s,
        ctrl => ctrl_s
    );

    clock : process
    begin 
        clk_s <= '0';
        wait for period/2;
        loop
            clk_s <= '0';
            wait for period/2;
            clk_S <= '1';
            wait for period/2;
        exit when end_of_sim;
        end loop;
        wait;
    end process;

    process(invert, dip_sw_s, pn_ml1_s, pn_ml2_s, pn_gold_s)
    begin
        if not invert then
            case(dip_sw_s) is
                when "00" => sdi_spread_s <= '1';
                when "01" => sdi_spread_s <= pn_ml1_s;
                when "10" => sdi_spread_s <= pn_ml2_s;
                when "11" => sdi_spread_s <= pn_gold_s;
                when others => sdi_spread_s <= '1';
            end case ;
        else
            case(dip_sw_s) is
                when "00" => sdi_spread_s <= '0';
                when "01" => sdi_spread_s <= not pn_ml1_s;
                when "10" => sdi_spread_s <= not pn_ml2_s;
                when "11" => sdi_spread_s <= not pn_gold_s;
                when others => sdi_spread_s <= '0';
            end case ;
        end if;
    end process;

    tb : process
        procedure reset is
        begin
            rst_s <= '1';
            wait for 5*period;
            rst_s <= '0';
            wait for 5*period;
        end procedure;

    begin
        clk_en_s <= '1';
        dip_sw_s <= "00";
        reset;

        chip_sample_s <= '1';

        -- Test no code
        dip_sw_s <= "00";
        wait for 64 * period;

        -- Test first code (PN1)
        dip_sw_s <= "01";
        wait for 64 * period;

        -- Test second code (PN2)
        dip_sw_s <= "10";
        wait for 64 * period;

        -- Test gold code (PN gold)
        dip_sw_s <= "11";
        wait for 64 * period;

        -- Invert!
        invert <= true;

        -- Test no code
        dip_sw_s <= "00";
        wait for 64 * period;

        -- Test first code (PN1)
        dip_sw_s <= "01";
        wait for 64 * period;

        -- Test second code (PN2)
        dip_sw_s <= "10";
        wait for 64 * period;

        -- Test gold code (PN gold)
        dip_sw_s <= "11";
        wait for 64 * period;

        -- end of sim
        end_of_sim <= true;
        wait;
    end process;

end architecture ; -- arch
