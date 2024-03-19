--------------------------------------
-- Biblioteca
--------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

--------------------------------------
-- Entidade
--------------------------------------
entity pad_lock is
  port (a, b: in std_logic;
        sum, carry: out std_logic);
end entity;

--------------------------------------
-- Arquitetura
--------------------------------------
architecture pad_lock of pad_lock is
begin
  sum <= a xor b;	
  carry <= a and b;
end architecture; 