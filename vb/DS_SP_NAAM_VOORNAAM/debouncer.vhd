-------------------------------------------------------------------
-- Project	: Debouncer voor zender Digitale Synthese
-- Author	: Rondelez Lukas - campus De Nayer
-- Begin Date	: 13/02/2017
-- bestand	: debouncer.vhd
-- info: Dit blok heeft als doel de inkomende signalen (van de knoppen) te
-- 				debouncen. 
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity debouncer  is
port (
	clk: in std_logic;
	clk_en: in std_logic;
 	rst: in std_logic;
	cha: in std_logic;
	syncha: out std_logic
	);
end debouncer;

architecture behav of debouncer is
	
-- schuifregister 

signal pres_shiftreg, next_shiftreg: std_logic_vector(3 DOWNTO 0);

-- indien 1: shift; indien 0 load LFB in alle bits    
	SIGNAL sh_ldb: std_logic; 

begin
    
syncha <= pres_shiftreg(0);
-- exor
sh_ldb <= pres_shiftreg(0) XOR cha;
	
syn_shiftreg: process(clk)
begin
    
if (rising_edge(clk) and clk_en = '1') then
    if rst = '1' then
          pres_shiftreg <= (others => '0');   -- reset registers
    else
          pres_shiftreg <= next_shiftreg;
    end if;
end if;

end process syn_shiftreg;

com_shiftreg: process(pres_shiftreg, cha, sh_ldb)
begin
if(sh_ldb = '1') then  -- shift
   next_shiftreg <= cha & pres_shiftreg(3 downto 1);
else                                     -- load
   next_shiftreg <= (others => pres_shiftreg(0));
end if;

end process com_shiftreg; 
    
end behav;
    

