-- Dries Kennes
-- Transmitter
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity transmitter is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;

        up: in std_logic;
        down: in std_logic;
        dip: in std_logic_vector(1 downto 0);
        segments: out std_logic_vector(7 downto 0);
        sdo_spread: out std_logic
    );
end entity;

architecture structural of transmitter is
    component accesslayertx is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;
            
            sdo_posenc: in std_logic;
            dip_sw : in std_logic_vector(1 downto 0);
            ctrl: out std_logic;
            sdo_spread: out std_logic
        );
    end component;
    for acc_lay: accesslayertx use entity work.accesslayertx(structural);

    component applicationlayer is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;
            
            up: in std_logic;
            down: in std_logic;
            count: out std_logic_vector(3 downto 0);
            segments: out std_logic_vector(7 downto 0)
        );
    end component;
    for all_lay: applicationlayer use entity work.applicationlayer(structural);

    component datalayer is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;

            ctrl: in std_logic;
            count: in std_logic_vector(3 downto 0);
            sdo_posenc: out std_logic
        );
    end component;
    for dat_lay: datalayer use entity work.datalayer(structural);

    signal ctrl_s : std_logic;
    signal sdo_posenc_s : std_logic;
    signal count_s : std_logic_vector(3 downto 0);

begin
    acc_lay: accesslayertx port map(
        clk => clk,
        clk_en => clk_en,
        rst => rst,

        sdo_posenc => sdo_posenc_s,
        dip_sw => dip,
        ctrl => ctrl_s,
        sdo_spread => sdo_spread
    );

    all_lay: applicationlayer port map(
        clk => clk,
        clk_en => clk_en,
        rst => rst,

        up => up,
        down => down,
        count => count_s,
        segments => segments
    );

    dat_lay: datalayer port map(
        clk => clk,
        clk_en => clk_en,
        rst => rst,

        ctrl => ctrl_s,
        count => count_s,
        sdo_posenc => sdo_posenc_s
    );

    -- todo datalayer

end structural;