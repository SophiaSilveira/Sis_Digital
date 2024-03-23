--------------------------------------
-- Biblioteca
--------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--------------------------------------
-- Entidade
--------------------------------------
entity pad_lock is
    port (clock, reset, configurar, valido : in std_logic;
        entrada : in std_logic_vector(3 downto 0);
        tranca, configurado, alarme : out std_logic
    );
end entity;

--------------------------------------
-- Arquitetura
--------------------------------------
architecture pad_lock of pad_lock is
  type state is (DESCONFIG, RE, RE0, RE01, RE010, ESPERE, CONFIG, SE0, SE01, SE010, ALARM, ABERTO, RESTORE);
  signal EA, PE:  state;
  signal contagem : std_logic_vector(3 downto 0);
  signal is_config, is_open, is_alarm : std_logic;
  signal senha0, senha01, senha010 : std_logic_vector(3 downto 0);
  signal tentativa : integer;

begin
  seq: process(reset, clock) 
  begin
    if reset = '1' then
      EA <= DESCONFIG;
    elsif rising_edge(clock) then
      EA <= PE;
    end if;
  end process;
  
comb: process(EA, entrada, configurar, valido, is_config, contagem, senha0, senha01, senha010)
  begin
    case EA is
      when DESCONFIG => if configurar = '1' AND valido = '1' then PE <= RE;
                        else PE <= DESCONFIG;
                        end if;
      when RE => contagem <= entrada;
                 if  configurar = '0' then PE <= DESCONFIG;
                  elsif valido = '0'   then PE <= RE0;
                  else  
                    PE <= RE;
                  end if;
      when RE0 => if configurar = '0' then PE <= DESCONFIG;
                  elsif valido = '1'  then 
                  senha0 <= entrada;
                  PE <= RE01;
                  else  
                    PE <= RE0;
                  end if;
      when RE01 =>  if configurar = '0' then PE <= DESCONFIG;
                    elsif valido = '1'   then
                      senha01 <= entrada; 
                      PE <= RE010;
                    else  
                      PE <= RE01;
                    end if;
      when RE010 => if configurar = '0' then PE <= DESCONFIG;
                    elsif valido = '1'   then
                      senha010 <= entrada;
                      PE <= ESPERE;
                    else 
                      PE <= RE010;
                    end if;
      when ESPERE => if configurar = '0' then 
                          PE <= CONFIG;
                          tentativa <= to_integer(unsigned(contagem));
                        else PE <= ESPERE;
                        end if;
      when CONFIG =>  is_config <= '1'; 
                      fechar <= to_integer(unsigned(contagem));
                      if valido = '0' then
                        if tentativa = 0 then
                          is_alarm <= '1';
                          PE <= SE0;
                        else PE <= SE0;
                        end if;
                      else PE <= CONFIG;
                      end if;
      when SE0 => if valido = '1' then
                    if entrada = senha0 then
                      PE <= SE01;
                    else PE <= ALARM;
                    end if;
                  else PE <= SE0;
                  end if;
      when SE01 => if valido = '1' then
                    if entrada = senha01 then
                      PE <= SE010;
                    else PE <= ALARM;
                    end if;
                  else PE <= SE01;
                  end if;
      when SE010 => if valido = '1' then
                      if entrada = senha010 then
                        PE <=  ABERTO;
                      else PE <= ALARM;
                      end if;
                  else PE <= SE010;
                  end if;
      when ALARM => if contagem = "0000" then PE <= CONFIG;
                    else
                      tentativa <= tentativa - 1;
                      PE <= CONFIG;
                    end if;
      when ABERTO => if entrada = senha010 then
                        PE <= ABERTO;   
                      else
                        is_open <= '1';
                        is_alarm <= '0';
                        PE <= RESTORE;
                      end if;
      When RESTORE => is_open <= '0';
                      PE <= CONFIG;
    end case;
  end process;

      alarme <= '1' when is_alarm = '1'
                else '0';

      tranca <= '0' when is_open = '1'
                else '1';

      configurado <= '1' when is_config = '1' 
                      else '0';

end architecture; 