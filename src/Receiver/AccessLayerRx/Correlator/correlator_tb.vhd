-- Dries Kennes
-- Correlator Test
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity correlator_tb is
end entity ; -- correlator_tb

architecture arch of correlator_tb is

    component correlator is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;

            chip_sample: in std_logic;
            bit_sample: in std_logic;
            chip_in: in std_logic;
            bit_out: out std_logic
        ) ;
    end component; -- correlator
    for uut : correlator use entity work.correlator(behav);

    constant period : time := 100 ns;
    constant delay  : time :=  10 ns;

    signal end_of_sim : boolean := false;

    signal clk_s:  std_logic;
    signal rst_s:  std_logic;
    signal clk_en_s: std_logic;

    signal chip_sample_s: std_logic;
    signal bit_sample_s: std_logic;
    signal chip_in_s: std_logic;
    signal bit_out_s: std_logic;

begin

      uut: correlator PORT MAP(
        clk => clk_s,
        rst => rst_s,
        clk_en => clk_en_s,
        chip_sample => chip_sample_s,
        bit_sample => bit_sample_s,
        chip_in => chip_in_s,
        bit_out =>bit_out_s 
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

    tb : process
        procedure reset is
        begin
            rst_s <= '1';
            wait for 5*period;
            rst_s <= '0';
            wait for 5*period;
        end procedure;

        procedure send_chip(val: in std_logic) is
        begin
            chip_sample_s <= '0';
            chip_in_s <= val;
            wait for period;
            chip_sample_s <= '1';
            wait for period;
            chip_sample_s <= '0';
        end procedure;

    begin
        clk_en_s <= '1';
        chip_sample_s <= '0';
        bit_sample_s <= '0';
        chip_in_s <= '0';
        reset;

        -- Send 100% 0
        for i in 0 to 30 loop
            send_chip('0');
        end loop;

        chip_sample_s <= '0';
        bit_sample_s <= '0';
        chip_in_s <= '0';
        wait for period;
        chip_sample_s <= '1';
        bit_sample_s <= '1';
        wait for period;
        chip_sample_s <= '0';
        bit_sample_s <= '0';

        -- Send 100% 1
        for i in 0 to 30 loop
            send_chip('1');
        end loop;

        chip_sample_s <= '0';
        bit_sample_s <= '0';
        chip_in_s <= '1';
        wait for period;
        chip_sample_s <= '1';
        bit_sample_s <= '1';
        wait for period;
        chip_sample_s <= '0';
        bit_sample_s <= '0';

        -- Send 50%+1 0
        for i in 0 to 30 loop
            if i rem 2 = 0 then
                send_chip('0');
            else
                send_chip('1');
            end if;
        end loop;

        chip_sample_s <= '0';
        bit_sample_s <= '0';
        chip_in_s <= '1';
        wait for period;
        chip_sample_s <= '1';
        bit_sample_s <= '1';
        wait for period;
        chip_sample_s <= '0';
        bit_sample_s <= '0';

        -- Send 50%+1 0
        for i in 0 to 30 loop
            if i rem 2 = 0 then
                send_chip('0');
            else
                send_chip('1');
            end if;
        end loop;

        chip_sample_s <= '0';
        bit_sample_s <= '0';
        chip_in_s <= '1';
        wait for period;
        chip_sample_s <= '1';
        bit_sample_s <= '1';
        wait for period;
        chip_sample_s <= '0';
        bit_sample_s <= '0';

        -- Send 50%+0 0
        for i in 0 to 30 loop
            if i rem 2 = 1 then
                send_chip('0');
            else
                send_chip('1');
            end if;
        end loop;

        chip_sample_s <= '0';
        bit_sample_s <= '0';
        chip_in_s <= '0';
        wait for period;
        chip_sample_s <= '1';
        bit_sample_s <= '1';
        wait for period;
        chip_sample_s <= '0';
        bit_sample_s <= '0';

        -- Send 50%+1 0
        for i in 0 to 30 loop
            if i rem 2 = 1 then
                send_chip('0');
            else
                send_chip('1');
            end if;
        end loop;

        chip_sample_s <= '0';
        bit_sample_s <= '0';
        chip_in_s <= '1';
        wait for period;
        chip_sample_s <= '1';
        bit_sample_s <= '1';
        wait for period;
        chip_sample_s <= '0';
        bit_sample_s <= '0';

        end_of_sim <= true;
        wait;

    end process;

end architecture ; -- arch
