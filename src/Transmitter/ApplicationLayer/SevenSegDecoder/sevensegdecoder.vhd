-- Dries Kennes
-- 7 Segment Decoder
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity sevensegdecoder is
    port (
        inp: in std_logic_vector(3 downto 0);
        dp:  in std_logic;
        outp: out std_logic_vector(7 downto 0)
    );
end sevensegdecoder;

architecture behav of sevensegdecoder is
begin
    comb_sevensegdecoder: process(inp)
    begin
        case inp is
        --    bin                     abcdefg
        when "0000" => outp <= (dp & "1111110"); -- 0
        when "0001" => outp <= (dp & "0011000"); -- 1
        when "0010" => outp <= (dp & "1101101"); -- 2
        when "0011" => outp <= (dp & "1111001"); -- 3
        when "0100" => outp <= (dp & "0110011"); -- 4
        when "0101" => outp <= (dp & "1011011"); -- 5
        when "0110" => outp <= (dp & "1011111"); -- 6
        when "0111" => outp <= (dp & "1110000"); -- 7
        when "1000" => outp <= (dp & "1111111"); -- 8
        when "1001" => outp <= (dp & "1111011"); -- 9
        when "1010" => outp <= (dp & "1110111"); -- a
        when "1011" => outp <= (dp & "0011111"); -- b
        when "1100" => outp <= (dp & "1001110"); -- c
        when "1101" => outp <= (dp & "0111101"); -- d
        when "1110" => outp <= (dp & "1001111"); -- e
        when "1111" => outp <= (dp & "1000111"); -- f
        when others => outp <= (dp & "1111111"); -- oops
        end case;
    end process comb_sevensegdecoder;

end behav;
