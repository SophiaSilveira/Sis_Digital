--------------------------------------
-- Biblioteca
--------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

--------------------------------------
-- Entidade
--------------------------------------
entity padLock is
  port (a, b: in std_logic;
        sum, carry: out std_logic);
end entity;

--------------------------------------
-- Arquitetura
--------------------------------------
architecture half_adder of half_adder is
begin
  sum <= a xor b;	
  carry <= a and b;
end architecture;