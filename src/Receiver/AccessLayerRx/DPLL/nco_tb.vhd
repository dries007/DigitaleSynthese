-- Dries Kennes
-- NCO (Numeric Controlled Ocilator)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

use work.pkg_segments.all;

entity nco_tb is
end nco_tb;

architecture structural of nco_tb is

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

    for uut : nco use entity work.nco(behav);

    constant period : time := 100 ns;
    constant delay  : time :=  10 ns;

    signal end_of_sim : boolean := false;

    signal clk_s:  std_logic;
    signal rst_s:  std_logic;
    signal clk_en_s: std_logic; 

    signal segment_s: segment;
    signal chip_sample_s, chip_sample1_s, chip_sample2_s:  std_logic;

begin

    uut: nco PORT MAP(
        clk => clk_s,
        clk_en => clk_en_s,
        rst => rst_s,

        segment => segment_s,
        chip_sample => chip_sample_s,
        chip_sample1 => chip_sample1_s,
        chip_sample2 => chip_sample2_s
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
    end process clock;

    tb : process
        procedure reset is
        begin
            rst_s <= '1';
            wait for 5*period;
            rst_s <= '0';
            wait for 5*period;
        end procedure;

    begin
        segment_s <= SEG_A;
        clk_en_s <= '1';
        reset;

        segment_s <= SEG_A;
        wait for 40*period;

        segment_s <= SEG_B;
        wait for 40*period;

        segment_s <= SEG_C;
        wait for 40*period;

        segment_s <= SEG_D;
        wait for 40*period;

        segment_s <= SEG_E;
        wait for 40*period;

    
        -- end of sim
        end_of_sim <= true;
        wait;
    end process;

end structural;