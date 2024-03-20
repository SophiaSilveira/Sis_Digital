--------------------------------------
-- Biblioteca
--------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

--------------------------------------
-- Entidade
--------------------------------------
entity pad_lock is
  port (clock, reset, configurar, valido : in std_logic;
        entrada : in std_logic_vector(3 downto 0);
        tranca, configurado, alarme : out std_logic);
end entity;

--------------------------------------
-- Arquitetura
--------------------------------------
architecture pad_lock of pad_lock is
  type state is (DESCONFIG, RE, RE0, RE01, RE010, ESPERE, CONFIG, PE0, PE01, PE010, CHECK, WRONGP, ALARME, ABERTO, RECONFIG);
  signal EA, PE:  state;
  signal contagem, tentativa : std_logic_vector(3 downto 0);
  signal alarme : std_logic;
  signal senha0, senha01, senha010 : std_logic_vector(3 downto 0);

begin
  process(reset, clock)
    if reset = '1' then
      EA <= DESCONFIG;
      --estado inicial
    elsif rising_edge(clock) then
      EA <= PE;
    end if;
  end process;
      
end architecture; 