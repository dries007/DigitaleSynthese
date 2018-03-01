-- Dries Kennes
-- Edgedetect Test
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity edgedetect_tb is
end edgedetect_tb;

architecture structural of edgedetect_tb is

    component edgedetect is
        port (
            clk: in std_logic;
            clk_en: in std_logic;
            rst: in std_logic;

            inp: in std_logic;
            outp: out std_logic
        );
    end component;

    for uut : edgedetect use entity work.edgedetect(behav);

    constant period : time := 100 ns;
    constant delay  : time :=  10 ns;

    signal end_of_sim : boolean := false;

    signal clk_s:  std_logic;
    signal rst_s:  std_logic;
    signal clk_en_s: std_logic; 

    signal inp_s: std_logic;
    signal outp_s:  std_logic;

begin

    uut: edgedetect PORT MAP(
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
    procedure tbvector(constant stimvect : in std_logic_vector(0 downto 0)) is
    begin
        inp_s <= stimvect(0);
    end tbvector;

    begin
        tbvector("0");
        clk_en_s <= '1';
        -- reset
        rst_s <= '1';
        wait for 5*period;
        rst_s <= '0';
        wait for 5*period;

        tbvector("0");
        wait for 2*period;
        tbvector("1");
        wait for 10*period;
        tbvector("0");
        wait for 5*period;
        tbvector("1");
        wait for 5*period;
        
        tbvector("0");
        wait for period;
        tbvector("1");
        wait for period;
        tbvector("0");
        wait for period;
        tbvector("1");
        wait for period;

        
        tbvector("0");
        wait for period;
        tbvector("1");
        wait for period;
        tbvector("0");
        wait for period;
        tbvector("1");
        wait for period;

        tbvector("0");
        wait for 5*period;
    
        -- end of sim
        end_of_sim <= true;
        wait;
    end process;

end structural;