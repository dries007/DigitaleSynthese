-- Dries Kennes
-- Segment Semaphore test
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

use work.pkg_segments.all;

entity seg_semaphore_tb is
end seg_semaphore_tb;

architecture structural of seg_semaphore_tb is

    component seg_semaphore is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;

            inp: in segment;
            outp: out segment;
            extb: in std_logic;
            chip_sample: in std_logic
        );
    end component;

    for uut : seg_semaphore use entity work.seg_semaphore(behav);

    constant period : time := 100 ns;
    constant delay  : time :=  10 ns;

    signal end_of_sim : boolean := false;

    signal clk_s:  std_logic;
    signal rst_s:  std_logic;
    signal clk_en_s: std_logic; 

    signal inp_s, outp_s: segment;
    signal extb_s, chip_sample_s:  std_logic;

begin

    uut: seg_semaphore PORT MAP(
        clk => clk_s,
        clk_en => clk_en_s,
        rst => rst_s,

        inp => inp_s,
        outp => outp_s,
        extb => extb_s,
        chip_sample => chip_sample_s
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

        procedure extb is
        begin
            extb_s <= '1';
            wait for period;
            extb_s <= '0';
            wait for period;
        end procedure;

        procedure chip_sample is
        begin
            chip_sample_s <= '1';
            wait for period;
            chip_sample_s <= '0';
            wait for period;
        end procedure;

    begin
        inp_s <= SEG_C;
        extb_s <= '0';
        chip_sample_s <= '0';
        clk_en_s <= '1';
        reset;
    
        inp_s <= SEG_A;
        wait for 5*period;
        extb;
        wait for 5*period;
        chip_sample;
        wait for 5*period;
        inp_s <= SEG_B;
        wait for 5*period;
        inp_s <= SEG_C;
        wait for 5*period;
        inp_s <= SEG_D;
        extb;
        wait for 5*period;
        inp_s <= SEG_E;
        chip_sample;
        wait for 5*period;
        inp_s <= SEG_A;
        wait for 5*period;
        extb;
        wait for 5*period;


        -- end of sim
        end_of_sim <= true;
        wait;
    end process;

end structural;