-- Dries Kennes
-- Shift register
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity matchedfilter is
    port (
        clk: in std_logic;
        clk_en: in std_logic;
        rst: in std_logic;

        chip_sample: in std_logic;
        sdi_spread: in std_logic;
        dip_sw : in std_logic_vector(1 downto 0);
        seq_det: out std_logic
    ) ;
end entity; -- matchedfilter

architecture behav of matchedfilter is

    signal pres_sr, next_sr: std_logic_vector(30 downto 0);

    constant pattern1 : std_logic_vector(30 downto 0) := "1101001100000111001000101011110"; -- From file
    constant pattern2 : std_logic_vector(30 downto 0) := "0110010000010111011010100111100"; -- same

begin

    sync_matchedfilter : process(clk)
    begin
        if (rising_edge(clk) and clk_en = '1') then
            if rst = '1' then
                pres_sr <= (others => '0');
            else
                pres_sr <= next_sr;
            end if;
        end if;
    end process;

    comb_matchedfilter : process(pres_sr, dip_sw, chip_sample, sdi_spread)
        variable pn_ptrn: std_logic_vector(pres_sr'length-1 downto 0);
    begin
        if chip_sample = '1' then
            next_sr <= sdi_spread & pres_sr(pres_sr'length-1 downto 1);
        else
            next_sr <= pres_sr;
        end if;

        case(dip_sw) is
            when "00" => pn_ptrn := (others => '1');
            when "01" => pn_ptrn := pattern1;
            when "10" => pn_ptrn := pattern2;
            when "11" => pn_ptrn := pattern1 xor pattern2;
            when others => pn_ptrn := (others => '1');
        end case ;

        if pn_ptrn = pres_sr or pn_ptrn = not pres_sr then
            seq_det <= '1';
        else 
            seq_det <= '0';
        end if;

    end process;

end architecture; -- behav
