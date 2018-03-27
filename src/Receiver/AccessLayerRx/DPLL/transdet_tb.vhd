-- Dries Kennes
-- Transition detector Test
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity transdet_tb is
end transdet_tb;

architecture structural of transdet_tb is

    component transdet is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;

            inp: in std_logic;
            outp: out std_logic
        );
    end component;

    for uut : transdet use entity work.transdet(behav);

    constant period : time := 100 ns;
    constant delay  : time :=  10 ns;

    signal end_of_sim : boolean := false;

    signal clk_s:  std_logic;
    signal rst_s:  std_logic;
    signal clk_en_s: std_logic; 

    signal inp_s: std_logic;
    signal outp_s:  std_logic;

begin

    uut: transdet PORT MAP(
        clk => clk_s,
        clk_en => clk_en_s,
        rst => rst_s,

        inp => inp_s,
        outp => outp_s
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

        pulse(1, 1);
        pulse(1, 1);

        wait for 10*period;

        pulse(5, 5);
        pulse(5, 5);
        pulse(5, 5);

        wait for 10*period;

        pulse(1, 1);
        pulse(1, 1);
    
        -- end of sim
        end_of_sim <= true;
        wait;
    end process;

end structural;