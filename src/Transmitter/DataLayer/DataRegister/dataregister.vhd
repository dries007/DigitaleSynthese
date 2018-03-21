-- Dries Kennes
-- Data register
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity dataregister is
  port (
    clk: in std_logic;
    clk_en: in std_logic;
    rst: in std_logic;

    shift: in std_logic;
    load: in std_logic;
    data: in std_logic_vector(3 downto 0);

    outp: out std_logic
  );
end entity;

architecture behav of dataregister is

    signal pres_data, next_data: std_logic_vector(10 downto 0);

begin

    sync_dataregister: process(clk)
    begin
        if (rising_edge(clk) and clk_en = '1') then
            if rst = '1' then
                pres_data <= (others => '0');
            else
                pres_data <= next_data;
            end if;
        end if;
    end process sync_dataregister;

    outp <= pres_data(10);

    comb_dataregister: process(pres_data, load, shift)
    begin
        next_data <= pres_data;
        if shift = '1' then
            next_data <= pres_data(9 downto 0) & '0';
        end if;
        if load = '1' then
            next_data <= "0111110" & data;
        end if;
    end process comb_dataregister;

end architecture;
