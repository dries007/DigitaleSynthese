-- Dries Kennes
-- 7 Segment Decoder Test
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity sevensegdecoder_tb is
end sevensegdecoder_tb;

architecture structural of sevensegdecoder_tb is

    component sevensegdecoder is
        port (
            inp: in std_logic_vector(3 downto 0);
            dp:  in std_logic;
            outp: out std_logic_vector(7 downto 0)
        );
    end component;

    for uut : sevensegdecoder use entity work.sevensegdecoder(behav);

    constant period : time := 100 ns;
    constant delay  : time :=  10 ns;

    signal end_of_sim : boolean := false;

    signal inp_s: std_logic_vector(3 downto 0);
    signal dp_s: std_logic;
    signal outp_s:  std_logic_vector(7 downto 0);

begin

    uut: sevensegdecoder PORT MAP(
        inp => inp_s,
        dp => dp_s,
        outp => outp_s
    );

    tb : process
    procedure tbvector(constant stimvect : in std_logic_vector(3 downto 0)) is
    begin
        inp_s <= stimvect;
    end tbvector;

    begin
        dp_s <= '0'; -- Decimal point
        tbvector("0000"); wait for period; -- 0
        tbvector("0001"); wait for period; -- 1
        tbvector("0010"); wait for period; -- 2
        tbvector("0011"); wait for period; -- 3
        tbvector("0100"); wait for period; -- 4
        tbvector("0101"); wait for period; -- 5
        tbvector("0110"); wait for period; -- 6
        tbvector("0111"); wait for period; -- 7
        dp_s <= '1'; 
        tbvector("1000"); wait for period; -- 8
        tbvector("1001"); wait for period; -- 9
        tbvector("1010"); wait for period; -- A
        tbvector("1011"); wait for period; -- B
        tbvector("1100"); wait for period; -- C
        tbvector("1101"); wait for period; -- D
        tbvector("1110"); wait for period; -- E
        tbvector("1111"); wait for period; -- F
        
        -- end of sim
        end_of_sim <= true;
        wait;
    end process;

end structural;