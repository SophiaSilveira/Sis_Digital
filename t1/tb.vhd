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
  signal clock, reset : std_logic  := '1';
  signal configurar, valido : std_logic := '0'; --inputs
  signal entrada: std_logic_vector(3 downto 0); --input
  signal tranca, configurado, alarme: std_logic := '0'; --outputs
  constant time_clock : time := 6.25 ns; -- tempo do clok


  -- declare record type
  type test_desconfig is record
    configurar, valido : std_logic;
    entrada : std_logic_vector(3 downto 0);
    configurado, tranca, alarme : std_logic;
  end record; 

  type test_desconfig_array is array (natural range <>) of test_desconfig;
  constant test_desconfigs : test_desconfig_array := (
    --configurar, valido, entrada , configurado, tranca, alarme   -- positional method is used below
    ('0', '0', "0000", '0', '1', '0'), 
    ('1', '0', "0000", '0', '1', '0'),
    ('1', '0', "0011", '0', '1', '0'),
    ('1', '1', "0011", '0', '1', '0'),
    ('1', '0', "0011", '0', '1', '0'),
    ('1', '0', "1010", '0', '1', '0'),
    ('1', '1', "1010", '0', '1', '0'),
    ('1', '0', "1010", '0', '1', '0'),
    ('1', '0', "0000", '0', '1', '0'),
    ('1', '1', "0000", '0', '1', '0'),
    ('1', '0', "0000", '0', '1', '0'),
    ('1', '0', "0111", '0', '1', '0'),
    ('1', '1', "0111", '0', '1', '0'),
    ('1', '0', "0111", '0', '1', '0'),
    ('1', '0', "0000", '0', '1', '0'),
    ('1', '0', "0000", '0', '1', '0'),
    ('1', '0', "0000", '0', '1', '0'),
    ('0', '0', "0000", '0', '1', '0'),
    ('0', '0', "0000", '1', '1', '0')       
  );

  type test_config is record
    configurar, valido : std_logic;
    entrada : std_logic_vector(3 downto 0);
    configurado, tranca, alarme : std_logic;
  end record; 

  type test_config_array is array (natural range <>) of test_config;
  constant test_configs : test_config_array := (
    --configurar, valido, entrada , configurado, tranca, alarme   -- positional method is used below
    ('0', '0', "1010", '1', '1', '0'),
    ('0', '1', "1010", '1', '1', '0'),
    ('0', '0', "1010", '1', '1', '0'),
    ('0', '0', "0000", '1', '1', '0'),
    ('0', '1', "0000", '1', '1', '0'),
    ('0', '0', "0000", '1', '1', '0'),
    ('0', '0', "0111", '1', '1', '0'),
    ('0', '1', "0111", '1', '1', '0'),
    ('0', '0', "0111", '1', '1', '0'),
    ('0', '0', "0000", '1', '0', '0')       
  );

  type test_wrong_password is record
    configurar, valido : std_logic;
    entrada : std_logic_vector(3 downto 0);
    configurado, tranca, alarme : std_logic;
  end record; 

  type test_wrong_password_array is array (natural range <>) of test_wrong_password;
  constant test_wrong_passwords : test_wrong_password_array := (
    --configurar, valido, entrada , configurado, tranca, alarme   -- positional method is used below
    ('0', '0', "1011", '1', '1', '0'),
    ('0', '1', "1011", '1', '1', '0'),
    ('0', '0', "1011", '1', '1', '0'),
    ('0', '0', "1011", '1', '1', '0'),
    ('0', '1', "1011", '1', '1', '0'),
    ('0', '0', "1011", '1', '1', '0'),
    ('0', '0', "1011", '1', '1', '0'),
    ('0', '1', "1011", '1', '1', '0'),
    ('0', '0', "1011", '1', '1', '0'),
    ('0', '0', "1010", '1', '1', '1'),
    ('0', '1', "1010", '1', '1', '1'),
    ('0', '0', "1010", '1', '1', '1'),
    ('0', '0', "0000", '1', '1', '1'),
    ('0', '1', "0000", '1', '1', '1'),
    ('0', '0', "0000", '1', '1', '1'),
    ('0', '0', "0111", '1', '1', '1'),
    ('0', '1', "0111", '1', '1', '1'),
    ('0', '0', "0111", '1', '1', '1'),
    ('0', '0', "0000", '1', '0', '0'),
    ('0', '0', "0000", '1', '0', '0'),
    ('0', '0', "0000", '1', '0', '0'),
    ('0', '0', "0000", '1', '0', '0'),
    ('0', '0', "0000", '1', '0', '0'),
    ('0', '0', "0000", '1', '0', '0')

  );

  begin

  DUT: entity work.pad_lock
    port map(clock => clock, reset => reset, configurar => configurar, valido => valido, 
    entrada => entrada, tranca => tranca, configurado => configurado, alarme => alarme);


  clock <= not clock after time_clock;
  reset <= '1', '0' after 3 ns;

  process
  begin
    for i in test_desconfigs'range loop
      configurar <= test_desconfigs(i).configurar;
      valido <= test_desconfigs(i).valido;
      entrada <= test_desconfigs(i).entrada;

      wait for time_clock * 2;

      assert ( 
        (configurado = test_desconfigs(i).configurado) and
        (tranca = test_desconfigs(i).tranca) and 
        (alarme = test_desconfigs(i).alarme)
      )

      -- image is used for string-representation of integer etc.
      report  "test_desconfigs " & integer'image(i) & " failed " & 
              " for input configurado = " & std_logic'image(configurado) & 
              " teste = " & std_logic'image(test_desconfigs(i).configurado) & 
              " and tranca = " & std_logic'image(tranca) &
              " teste = " & std_logic'image(test_desconfigs(i).tranca) & 
              " and alarme = " & std_logic'image(alarme) &
              " teste = " & std_logic'image(test_desconfigs(i).alarme) 
              severity error;
    end loop;
    
    -- for i in test_configs'range loop
    --   configurar <= test_configs(i).configurar;
    --   valido <= test_configs(i).valido;
    --   entrada <= test_configs(i).entrada;

    --   wait for time_clock * 2;

    --   assert ( 
    --     (configurado = test_configs(i).configurado) and
    --     (tranca = test_configs(i).tranca) and 
    --     (alarme = test_configs(i).alarme)
    --   )

    --   -- image is used for string-representation of integer etc.
    --   report  "test_configs " & integer'image(i) & " failed " & 
    --           " for input configurado = " & std_logic'image(configurado) & 
    --           " teste = " & std_logic'image(test_configs(i).configurado) & 
    --           " and tranca = " & std_logic'image(tranca) &
    --           " teste = " & std_logic'image(test_configs(i).tranca) & 
    --           " and alarme = " & std_logic'image(alarme) &
    --           " teste = " & std_logic'image(test_configs(i).alarme) 
    --           severity error;
    -- end loop;

    for i in test_wrong_passwords'range loop
      configurar <= test_wrong_passwords(i).configurar;
      valido <= test_wrong_passwords(i).valido;
      entrada <= test_wrong_passwords(i).entrada;

      wait for time_clock * 2;

      assert ( 
        (configurado = test_wrong_passwords(i).configurado) and
        (tranca = test_wrong_passwords(i).tranca) and 
        (alarme = test_wrong_passwords(i).alarme)
      )
      -- image is used for string-representation of integer etc.
      report  "test_wrong_passwords " & integer'image(i) & " failed " & 
              " for input configurado = " & std_logic'image(configurado) & 
              " teste = " & std_logic'image(test_wrong_passwords(i).configurado) & 
              " and tranca = " & std_logic'image(tranca) &
              " teste = " & std_logic'image(test_wrong_passwords(i).tranca) & 
              " and alarme = " & std_logic'image(alarme) &
              " teste = " & std_logic'image(test_wrong_passwords(i).alarme) 
              severity error;
    end loop;
    wait;
  end process; 

end architecture;