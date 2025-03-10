---------------------------------------------- PWM Generator ------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
-------------------------------------------------- entity ---------------------------------------------------
entity PWM_Generator is
Port(
	clk  : in std_logic;                               -- Clock da Placa 50MHz
	rst  : in std_logic;                               -- Pino do Reset
   duty : in unsigned(7 downto 0);                    -- Velocidade desejada
	pwm  : out std_logic                               -- Velocidade real
);
end PWM_Generator;
-------------------------------------- end entity / begin architecture --------------------------------------
architecture logic of PWM_Generator is
signal cont: unsigned (7 downto 0):= (others => '0');

begin

process(clk)

begin
	if(rst='1') then
    	cont(7 downto 0) <= "00000000";
		pwm <= '0';
	elsif rising_edge(clk) then
    	cont <= cont + "00000001";
		if cont < duty then
			pwm <= '1';
		else
			pwm <= '0';
		end if;
	end if;
end process;
----------------------------------------------- end process -------------------------------------------------
end logic;
--------------------------------------------- end architecture ----------------------------------------------