library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TopTx is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           up : in  STD_LOGIC;
           down : in  STD_LOGIC;
           dip : in  STD_LOGIC_VECTOR (1 downto 0);
           segments : out  STD_LOGIC_VECTOR (7 downto 0);
           sdo_spread : out  STD_LOGIC);
end TopTx;

architecture Behavioral of TopTx is

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

	signal clk_en_s : std_logic;
	signal counter : std_logic_vector(14 downto 0);
	

begin

	tx: transmitter PORT MAP(
        clk => clk,
        clk_en => clk_en_s,
        rst => rst,

        up => up,
        down => down,
        dip => dip,
        segments => segments,
        sdo_spread => sdo_spread
    );

	 sync_top: process(clk)
    begin
        if rising_edge(clk) then
				counter <= counter + 1;
            if counter = 0 then
                clk_en_s <= '1';
            else
                clk_en_s <= '0';
            end if;
        end if;
    end process sync_top;

	

end Behavioral;

