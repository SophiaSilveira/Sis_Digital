--------------------------------------
-- Biblioteca
--------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

--------------------------------------
-- Entidade
--------------------------------------
entity tb is
end entity;

--------------------------------------
-- Arquitetura
--------------------------------------
architecture tb of tb is
  signal clock, reset, configurar, valido : std_logic; --inputs
  signal entrada: std_logic_vector(3 downto 0);
  signal tranca, configurado, alarme: out std_logic; --outputs

  --criar uma variavel const

  -- declare record type
  type test_vector is record
    a, b : std_logic;
    sum, carry : std_logic;
  end record; 

  type test_vector_array is array (natural range <>) of test_vector;
  constant test_vectors : test_vector_array := (
    -- a, b, sum , carry   -- positional method is used below
    ('0', '0', '0', '0'), -- or (a => '0', b => '0', sum => '0', carry => '0')
    ('0', '1', '1', '0'),
    ('1', '0', '1', '0'),
    ('1', '1', '0', '1'),
    ('0', '1', '0', '1')  -- fail test
  );

begin

  DUT: entity work.pad_lock
    port map(clock => clock, reset => reset, configurar => configurar, valido => valido, 
    entrada => entrada, tranca => tranca, configurado => configurado, alarme => alarme);

  clock <= not clock after 6.25 ns;

  process
  begin
    for i in test_vectors'range loop
      configurar = test_vectors();


      wait for 20 ns;

      assert ( 
        (sum = test_vectors(i).sum) and 
        (carry = test_vectors(i).carry) 
      )

      -- image is used for string-representation of integer etc.
      report  "test_vector " & integer'image(i) & " failed " & 
              " for input a = " & std_logic'image(a) & 
              " and b = " & std_logic'image(b)
              severity error;
    end loop;
    wait;
  end process; 

end architecture;