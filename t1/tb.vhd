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
  signal a, b : std_logic; -- inputs
  signal sum, carry: std_logic; -- outputs

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

  DUT: entity work.padLock
    port map(a => a, b => b, sum => sum, carry => carry);

  process
  begin
    for i in test_vectors'range loop
      a <= test_vectors(i).a;  -- signal a = i^th-row-value of test_vector's a
      b <= test_vectors(i).b;

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