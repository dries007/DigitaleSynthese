-- Dries Kennes
-- Transition segment decoder
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

use work.pkg_segments.all;

entity transsegdec_tb is
end transsegdec_tb;

architecture behav of transsegdec_tb is

    component transsegdec is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;

            inp: in std_logic;
            segment: out segment
        );
    end component;

    for uut : transsegdec use entity work.transsegdec(behav);

    constant period : time := 100 ns;
    constant delay  : time :=  10 ns;

    signal end_of_sim : boolean := false;

    signal clk_s:  std_logic;
    signal rst_s:  std_logic;
    signal clk_en_s: std_logic; 

    signal inp_s: std_logic;
    signal segment_s: segment;

begin

    uut: transsegdec PORT MAP(
        clk => clk_s,
        clk_en => clk_en_s,
        rst => rst_s,

        inp => inp_s,
        segment => segment_s
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

        procedure pulse(ontime: integer; offtime: integer) is
        begin
            inp_s <= '1';
            wait for ontime*period;
            inp_s <= '0';
            wait for offtime*period;
        end procedure;

    begin
        inp_s <= '0';
        clk_en_s <= '1';
        reset;

        pulse(1, 1); wait for 16*period;
        pulse(1, 1); wait for 16*period;
        pulse(1, 1); wait for 16*period;
        pulse(1, 1); wait for 16*period;
    
        -- end of sim
        end_of_sim <= true;
        wait;
    end process;

end architecture ; -- behav
