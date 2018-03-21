-- Dries Kennes
-- Demux 4 to 1 Test
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity demux_tb is
end entity;

architecture arch of demux_tb is

    component demux is
        port (
            inp: in std_logic_vector(3 downto 0);
            sel: in std_logic_vector(1 downto 0);
            outp: out std_logic
        );
    end component;

    for uut : demux use entity work.demux(behav);

    constant period : time := 100 ns;
    constant delay  : time :=  10 ns;

    signal end_of_sim : boolean := false;

    signal inp_s: std_logic_vector(3 downto 0);
    signal sel_s: std_logic_vector(1 downto 0);
    signal outp_s: std_logic;

begin

    uut: demux PORT MAP(
        inp => inp_s,
        sel => sel_s,
        outp => outp_s
    );

    tb: process
    begin
        inp_s <= "0000"; wait for period;
        sel_s <= "00"; wait for period;
        sel_s <= "01"; wait for period;
        sel_s <= "10"; wait for period;
        sel_s <= "11"; wait for period;

        inp_s <= "0001"; wait for period;
        sel_s <= "00"; wait for period;
        sel_s <= "01"; wait for period;
        sel_s <= "10"; wait for period;
        sel_s <= "11"; wait for period;


        inp_s <= "0101"; wait for period;
        sel_s <= "00"; wait for period;
        sel_s <= "01"; wait for period;
        sel_s <= "10"; wait for period;
        sel_s <= "11"; wait for period;

        inp_s <= "1000"; wait for period;
        sel_s <= "00"; wait for period;
        sel_s <= "01"; wait for period;
        sel_s <= "10"; wait for period;
        sel_s <= "11"; wait for period;

        end_of_sim <= true;

        wait;
        
    end process;

end architecture;
