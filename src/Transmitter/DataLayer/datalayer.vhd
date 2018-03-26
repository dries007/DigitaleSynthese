-- Dries Kennes
-- Datalayer
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity datalayer is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;

        ctrl: in std_logic;
        count: in std_logic_vector(3 downto 0);
        sdo_posenc: out std_logic
    );
end entity;

architecture structural of datalayer is
    component sequencecontroller is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;

            ctrl: in std_logic;
            load: out std_logic;
            shift: out std_logic
        );
    end component;
    for sq: sequencecontroller  use entity work.sequencecontroller(behav);

    component dataregister is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;

            shift: in std_logic;
            load: in std_logic;
            data: in std_logic_vector(3 downto 0);

            outp: out std_logic
        );
    end component;
    for dr: dataregister  use entity work.dataregister(behav);

    signal load_s :std_logic;
    signal shift_s :std_logic;

begin

    sq: sequencecontroller port map(
        clk => clk,
        clk_en => clk_en,
        rst => rst,

        ctrl => ctrl,
        load => load_s,
        shift => shift_s
    );

    dr: dataregister port map(
        clk => clk,
        clk_en => clk_en,
        rst => rst,

        shift => shift_s,
        load => load_s,
        data => count,

        outp => sdo_posenc
    );

end architecture;
