--------------------------------------------------------------------------------
-- Componente UART_RX
-- Recebe dados via RS232 e gera, a cada frame, o código ASCII do caractere.
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART_RX is
Port(
	clk  : in std_logic;                         -- Clock da Placa 50MHz
	rst  : in std_logic;                         -- Pino do Reset
	rxd  : in std_logic;                         -- Pino Rx
	data : out std_logic_vector(7 downto 0);     -- Dados Recebidos
	busy : out std_logic                         -- Sinal de Ocupação
);
end UART_RX;

architecture Behavioral of UART_RX is

constant BAUD_RATE  : integer := 9600;
constant CLOCK_FREQ : integer := 50000000;
constant BIT_PERIOD : integer := CLOCK_FREQ / BAUD_RATE;
 
signal bit_counter : integer range 0 to 10 := 0;
signal shift_reg   : std_logic_vector(7 downto 0) := (others => '0');
signal sampling    : integer := 0;
signal receiving   : std_logic := '0';

begin

process(clk)
begin
	if rising_edge(clk) then
		if rst = '1' then
			bit_counter <= 0;
			sampling    <= 0;
			receiving   <= '0';
			shift_reg   <= (others => '0');
			busy        <= '0';
		else
			if receiving = '0' then
				if rxd = '0' then  -- Detecção do start bit
					receiving   <= '1';
					sampling    <= BIT_PERIOD / 2;
					bit_counter <= 0;
					busy <= '1';
				end if;
			else
				if sampling = 0 then
					if bit_counter < 9 then
						-- Armazena o bit recebido; a saída será o código ASCII do caractere
						shift_reg <= shift_reg(6 downto 0) & rxd;
					end if;
					bit_counter <= bit_counter + 1;
					if bit_counter = 9 then
						receiving <= '0';
						data  <= shift_reg;
						busy      <= '0';
					else
						busy <= '0';
					end if;
					sampling <= BIT_PERIOD;
				else
					sampling <= sampling - 1;
				end if;
			end if;
		end if;
	end if;
 end process;
end Behavioral;