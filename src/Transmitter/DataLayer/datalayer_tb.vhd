-- Dries Kennes
-- Datalayer Test
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity datalayer_tb is
end entity;

architecture arch of datalayer_tb is

    component datalayer is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;

            ctrl: in std_logic;
            count: in std_logic_vector(3 downto 0);
            sdo_posenc: out std_logic
        );
    end component;

    for uut : datalayer use entity work.datalayer(structural);

    constant period : time := 100 ns;
    constant delay  : time :=  10 ns;

    signal end_of_sim : boolean := false;

    signal clk_s:  std_logic;
    signal clk_en_s: std_logic;
    signal rst_s:  std_logic;

    signal ctrl_s : std_logic;
    signal count_s : std_logic_vector (3 downto 0);
    signal sdo_posenc_s : std_logic;

begin

    uut: datalayer PORT MAP(
        clk => clk_s,
        clk_en => clk_en_s,
        rst => rst_s,

        ctrl => ctrl_s,
        count => count_s,
        sdo_posenc => sdo_posenc_s
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

    tb: process

        procedure reset is
        begin
            rst_s <= '1';
            wait for 5*period;
            rst_s <= '0';
            wait for 5*period;
        end procedure;

        procedure pulse_ctrl(constant n: integer) is
        begin
            for i in 0 to n-1
            loop
                ctrl_s <= '1';
                wait for period;
                ctrl_s <= '0';
                wait for period;
            end loop;
        end procedure;

    begin
        clk_en_s <= '1';
        count_s <= "0000";
        reset;

        -- 'Happy flow' test
        for data in 0 to 16
        loop
            count_s <= conv_std_logic_vector(data, 4);
            pulse_ctrl(11);
        end loop;
        reset;

        -- Test changing data halfway trought transmit

        -- Load initial data
        count_s <= "0000";
        pulse_ctrl(5);

        -- Output should not yet have 1111
        count_s <= "1111";

        -- Output should change after 11-5 pulses
        pulse_ctrl(20);
        
        reset;

        -- end of sim
        end_of_sim <= true;
        wait;
    end process;

end architecture ; -- arch