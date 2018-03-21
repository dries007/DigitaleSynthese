-- Dries Kennes
-- Demux 4 to 1
-- ASYNC
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity demux is
    port (
        inp: in std_logic_vector(3 downto 0);
        sel: in std_logic_vector(1 downto 0);
        outp: out std_logic
    );
end entity;

architecture behav of demux is
begin

    demux : process(inp, sel)
    begin
        case(sel) is
            when "00" => outp <= inp(0);
            when "01" => outp <= inp(1);
            when "10" => outp <= inp(2);
            when "11" => outp <= inp(3);
            when others => outp <= '0';
        end case ;
    end process ;

end architecture;
