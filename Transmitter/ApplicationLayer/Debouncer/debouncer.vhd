-- Dries Kennes
-- Debouncer
library IEEE;
use IEEE.std_logic_1164.all;

entity debouncer is
  port (
    clk: in std_logic;
    clk_en: in std_logic;
    rst: in std_logic;
    cha: in std_logic;
    syncha: out std_logic
  );
end debouncer;

architecture behav of debouncer is
    
signal pres_sr, next_sr: std_logic_vector(3 downto 0);
signal sl_ldb: std_logic;

begin
    syncha <= pres_sr(0);
    sh_ldb <= pres_sr(0) XOR cha;

    syn_debouncer: process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                pres_sr <= (others => '0');
            else
                pres_sr <= next_sr;
            end if;
        end if;
    end process syn_debouncer;

    com_debouncer: process(pres_sr, cha, sh_ldb)
    begin
        if (sh_ldb = '1') then
            next_sr <= cha & pres_sr(3 DOWNTO 1);
        else
            next_count <= pres_count - "0001";
        end if;
    end process com_debouncer; 
end behav;
