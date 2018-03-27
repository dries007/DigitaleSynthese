-- Dries Kennes
-- NCO (Numeric Controlled Ocilator)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

use work.pkg_segments.all;

entity nco is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;

        segment: in segment;
        chip_sample: out std_logic;
        chip_sample1: out std_logic;
        chip_sample2: out std_logic
    );
end nco;

architecture behav of nco is

    -- ToDo

begin



end architecture;
