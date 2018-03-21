-- Dries Kennes
-- Sequence Controller Test
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity dataregister_tb is
end dataregister_tb;

architecture structural of dataregister_tb is

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

    for uut : dataregister use entity work.dataregister(behav);

    constant period : time := 100 ns;
    constant delay  : time :=  10 ns;

    signal end_of_sim : boolean := false;

    signal clk_s: std_logic;
    signal clk_en_s: std_logic;
    signal rst_s: std_logic;
    
    signal data_s: std_logic_vector(3 downto 0);
    signal load_s: std_logic;
    signal shift_s: std_logic;
    signal outp_s: std_logic;

begin

    uut: dataregister PORT MAP(
        clk => clk_s,
        rst => rst_s,
        clk_en => clk_en_s,

        data => data_s,
        load => load_s,
        shift => shift_s,
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
    begin
        -- initial inputs
        load_s <= '0';
        shift_s <= '0';
        data_s <= "0000";

        clk_en_s <= '1';
        -- reset
        rst_s <= '1';
        wait for 5*period;
        rst_s <= '0';
        wait for 5*period;

        -- Outer loop: data read at the start of the loop, inc data at end.
        for j in 0 to 25
        loop
            load_s <= '1';
            wait for period;
            load_s <= '0';

            -- Inner loop: Shift data out
            for i in 0 to 9
            loop
                shift_s <= '1';
                wait for period;
                shift_s <= '0';
                wait for period;
            end loop;

            data_s <= data_s + 1;
        end loop;

        -- end of sim
        end_of_sim <= true;
        wait;
    end process;

end structural;
