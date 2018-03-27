-- Dries Kennes
-- AccessLayer Test
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity accesslayertx_tb is
end entity;

architecture structural of accesslayertx_tb is

    component accesslayertx is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;
            
            sdo_posenc: in std_logic;
            dip_sw : in std_logic_vector(1 downto 0);
            ctrl: out std_logic;
            sdo_spread: out std_logic
        );
    end component;

    for uut : accesslayertx use entity work.accesslayertx(structural);

    constant period : time := 100 ns;
    constant delay  : time :=  10 ns;

    signal end_of_sim : boolean := false;

    signal clk_s:  std_logic;
    signal clk_en_s: std_logic;
    signal rst_s:  std_logic;

    signal sdo_posenc_s: std_logic;
    signal dip_sw_s : std_logic_vector(1 downto 0);
    signal ctrl_s: std_logic;
    signal sdo_spread_s: std_logic;

begin

    uut: accesslayertx PORT MAP(
        clk => clk_s,
        clk_en => clk_en_s,
        rst => rst_s,

        sdo_posenc => sdo_posenc_s,
        dip_sw => dip_sw_s,
        ctrl => ctrl_s,
        sdo_spread => sdo_spread_s
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
        -- preset input
        dip_sw_s <= "00";
        sdo_posenc_s <= '0';

        clk_en_s <= '1';
        -- reset
        rst_s <= '1';
        wait for 5*period;
        rst_s <= '0';
        wait for 5*period;

        -- Mode 0
        dip_sw_s <= "00";
        sdo_posenc_s <= '1'; --input data 1
        wait for 5*period; -- partial pngen
        rst_s <= '1'; wait for period; rst_s <= '0'; wait for period; -- reset
        wait for 32 * period; -- 32x for pngen
        sdo_posenc_s <= '0'; --input data 0
        wait for 32 * period; -- 32x for pngen
        -- Repeat for every mode
        -- Mode 1
        dip_sw_s <= "01";
        sdo_posenc_s <= '1';
        wait for 5*period;
        rst_s <= '1'; wait for period; rst_s <= '0'; wait for period;
        wait for 32 * period;
        sdo_posenc_s <= '0';
        wait for 32 * period;

        -- Mode 2
        dip_sw_s <= "10";
        sdo_posenc_s <= '1';
        wait for 5*period;
        rst_s <= '1'; wait for period; rst_s <= '0'; wait for period;
        wait for 32 * period;
        sdo_posenc_s <= '0';
        wait for 32 * period;

        -- Mode 3
        dip_sw_s <= "11";
        sdo_posenc_s <= '1';
        wait for 5*period;
        rst_s <= '1'; wait for period; rst_s <= '0'; wait for period;
        wait for 32 * period;
        sdo_posenc_s <= '0';
        wait for 32 * period;

        -- end of sim
        end_of_sim <= true;
        wait;
    end process;

end architecture;
