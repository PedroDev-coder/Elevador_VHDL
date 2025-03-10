------------------------------------------------- Elevador --------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-------------------------------------------------- entity ---------------------------------------------------
entity Elevador is
port(
	CLK  : in std_logic;                          -- Clock da Placa 50MHz
	RST  : in std_logic;                          -- Pino do Reset
	RXD  : in std_logic;                          -- Pino de Entrada Rx
	SP1  : in std_logic;                          -- Sensor de proximidade 1
	SP2  : in std_logic;                          -- Sensor de proximidade 2
	PWM  : out std_logic;                         -- Velocidade do motor
	Dir1 : out std_logic;                         -- Sentido de giro do motor
	Dir2 : out std_logic;                          -- Sentido de giro do motor
	LED  : out std_logic_vector(1 downto 0);
	SENSOR : out std_logic_vector(2 downto 0)
);
end Elevador;
-------------------------------------- end entity / begin architecture --------------------------------------
architecture Elevator of Elevador is

signal Byte: std_logic_vector(7 downto 0);       -- Armazena o byte recebido
signal Busy: std_logic;                          -- Sinal de Ocupação
signal Speed: std_logic_vector(7 downto 0);      -- Velocide
signal Direction: std_logic_vector(1 downto 0);  -- Sentido de Rotação
signal Motor: std_logic;                         -- Variavel de controle

component UART_RX
port(
	clk  : in std_logic;                          -- Clock da Placa 50MHz
	rst  : in std_logic;                          -- Pino do Reset
	rxd  : in std_logic;                          -- Pino Rx
	data : out std_logic_vector(7 downto 0);      -- Dados Recebidos9 9
	busy : out std_logic                          -- Sinal de Ocupação
);
end component UART_RX;

component PWM_Generator
port(
	clk  : in std_logic;                          -- Clock da Placa 50MHz
	rst  : in std_logic;                          -- Pino do Reset
	duty : in std_logic_vector(7 downto 0);       -- Velocidade desejada
	pwm  : out std_logic                          -- Velocidade real
);
end component PWM_Generator;

begin

C1: UART_RX port map (CLK,RST,RXD,Byte,Busy);
C2: PWM_Generator port map (CLK,RST,Speed,PWM);

---------------------------------------------- begin process ------------------------------------------------
process (CLK)

begin

if(rising_edge(CLK)) then

	if(RST = '1') then
    
		Direction   <= "00";
		Speed <= (others => '0');
		Motor <= '0';
        
	elsif (rising_edge(CLK) and Busy = '1') then
    
    	Direction <= Byte(7 downto 6);
      Speed <= "10" & Byte(5 downto 0);
        
	end if;
    
	if(SP1 = '0' and Direction = "10") or (SP2 = '0' and Direction = "01") or RST = '1' then
		Motor <= '0';
	else
		Motor <= '1';
	end if;
    
end if;

end process;
----------------------------------------------- end process -------------------------------------------------

Dir1 <= '1' when (direction = "01" and Motor = '1') else '0';
Dir2 <= '1' when (direction = "10" and Motor = '1') else '0';
SENSOR(0) <= '1' when (SP1 = '1') else '0';
SENSOR(1) <= '1' when (SP2 = '1') else '0';
SENSOR(2) <= '1' when (Motor = '1') else '0';
LED(0) <= '1' when (direction = "01") else '0';
LED(1) <= '1' when (direction = "10") else '0';

end architecture ;
--------------------------------------------- end architecture ----------------------------------------------
--https://github.com/kiranjose/PWM-in-VHDL/blob/master/pwm.vhd