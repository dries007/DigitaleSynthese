library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity debouncer  is
port (
	clk: in std_logic;
 	rst: in std_logic;
	cha: in std_logic;
	syncha: out std_logic
	);
end debouncer;

architecture behav of debouncer is
    
signal pres_shiftreg, next_shiftreg: std_logic_vector(3 DOWNTO 0);

begin
    
syncha <= pres_shiftreg(0);

syn_shiftreg: process(clk)
begin
    
if rising_edge(clk) then
    if rst = '1' then
          pres_shiftreg <= (others => '0');   -- reset registers
    else
          pres_shiftreg <= next_shiftreg;
    end if;
end if;

end process syn_shiftreg;

com_shiftreg: process(pres_shiftreg, cha)
begin
if(cha XOR pres_shiftreg(0) = '1') then  -- shift
   next_shiftreg <= cha & pres_shiftreg(3 downto 1);
else                                     -- load
   next_shiftreg <= (others => pres_shiftreg(0);
end if;

end process com_shiftreg; 
    
end behav;
    
