-- Dries Kennes
-- AccessLayer (RX) Test
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity accesslayerrx_tb is
end entity; -- accesslayerrx_tb

architecture arch of accesslayerrx_tb is
    component accesslayerrx is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;

            sdi_spread: in std_logic;
            dip_sw : in std_logic_vector(1 downto 0);
            bit_sample: out std_logic;
            data_bit: out std_logic
        ) ;
    end component ; -- accesslayerrx
    for uut : accesslayerrx use entity work.accesslayerrx(arch);

    component transmitter is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;

            up: in std_logic;
            down: in std_logic;
            dip: in std_logic_vector(1 downto 0);
            segments: out std_logic_vector(7 downto 0);
            sdo_spread: out std_logic
        );
    end component;
    for tx : transmitter use entity work.transmitter(structural);

    constant period : time := 100 ns;
    constant delay  : time :=  10 ns;

    signal end_of_sim : boolean := false;

    signal clk_s:  std_logic := '0';
    signal clk_en_s: std_logic := '0';
    signal clk_en_tx_s: std_logic := '0';
    signal counter: integer range 0 to 20 := 0;
    signal rst_s:  std_logic := '0';

    signal sdi_spread_s : std_logic := '0';
    signal dip_sw_s : std_logic_vector(1 downto 0) := "00";
    signal bit_sample_s : std_logic := '0';
    signal data_bit_s : std_logic := '0';

    signal up_s:  std_logic;
    signal down_s: std_logic;

begin
    uut: accesslayerrx port map(
        clk => clk_s,
        rst => rst_s,
        clk_en => clk_en_s,

        sdi_spread => sdi_spread_s,
        dip_sw => dip_sw_s,
        bit_sample => bit_sample_s,
        data_bit => data_bit_s
    );

    tx: transmitter port map(
        clk => clk_s,
        clk_en => clk_en_tx_s,
        rst => rst_s,

        up => up_s,
        down => down_s,
        dip => dip_sw_s,
        segments => open,
        sdo_spread => sdi_spread_s
    );

    clock : process
    begin 
        clk_s <= '0';
        counter <= 0;
        clk_en_tx_s <= '0';
        wait for period/2;
        loop
            clk_s <= '0';
            wait for period/2;
            clk_S <= '1';
            if counter = 15 then
                counter <= 0;
                clk_en_tx_s <= '1';
            else
                counter <= counter + 1;
                clk_en_tx_s <= '0';
            end if;
            wait for period/2;
        exit when end_of_sim;
        end loop;
        wait;
    end process clock;

    tb : process

        procedure reset is
        begin
            rst_s <= '1';
            wait for 5*16*period;
            rst_s <= '0';
            wait for 5*16*period;
        end procedure;

        procedure tx(n: integer) is
        begin
            wait for 16*31*11*n*period;
        end procedure;

        procedure bounce(signal x: out std_logic; n: integer) is
        begin 
            for i in 0 to n-1
            loop
                x <= '1'; wait for 16*period/4;
                x <= '0'; wait for 16*2*period/4;
                x <= '1'; wait for 16*period/2;
                x <= '0'; wait for 16*3*period/2;
                x <= '1'; wait for 16*period/5;
                x <= '0'; wait for 16*period/6;
                x <= '1'; wait for 16*3*period/8;
                x <= '0'; wait for 16*period/3;
                x <= '1'; wait for 16*3*period/2;
                
                wait for 16*15 * period;

                x <= '0'; wait for 16*period/3;
                x <= '1'; wait for 16*period/4;
                x <= '0'; wait for 16*2*period/4;
                x <= '1'; wait for 16*period/2;
                x <= '0'; wait for 16*3*period/2;
                x <= '1'; wait for 16*period/5;
                x <= '0'; wait for 16*period/6;
                x <= '1'; wait for 16*3*period/8;
                x <= '0'; wait for 16*period/3;
                x <= '1'; wait for 16*3*period/2;
                x <= '0'; wait for 16*period/3;

                wait for 16*25 * period;

                tx(1);
            end loop;
        end procedure;

    begin
        clk_en_s <= '1';
        up_s <= '0';
        down_s <= '0';
        dip_sw_s <= "00";
        reset;

        tx(5);
        bounce(up_s, 1);
        tx(5);
        bounce(down_s, 10);
        tx(5);
        bounce(up_s, 30);
        tx(5);
        
        dip_sw_s <= "01";
        reset;
        tx(5);
        bounce(up_s, 1);
        tx(5);
        bounce(down_s, 10);
        tx(5);
        bounce(up_s, 30);
        tx(5);

        dip_sw_s <= "10";
        reset;
        tx(5);
        bounce(up_s, 1);
        tx(5);
        bounce(down_s, 10);
        tx(5);
        bounce(up_s, 30);
        tx(5);

        dip_sw_s <= "11";
        reset;
        tx(5);
        bounce(up_s, 1);
        tx(5);
        bounce(down_s, 10);
        tx(5);
        bounce(up_s, 30);
        tx(5);


        -- end of sim
        end_of_sim <= true;
        wait;
    end process ; -- tb

end architecture ; -- arch
