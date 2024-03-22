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
  signal is_alarme : std_logic;
  signal senha0, senha01, senha010 : std_logic_vector(3 downto 0);

begin
  seq: process(reset, clock) 
    if reset = '1' then
      EA <= DESCONFIG;
      configurado <= '0';
      tranca <= '1';
      alarme <= '0';
      --estado inicial
    elsif rising_edge(clock) then
      EA <= PE;
    end if;
  end process;
  
  comb_desconfig: process(EA, configurar, valido, entrada, contagem) -- e necessario ter entrada e contagem como sensiveis?
      begin
        cased EA is
          when DESCONFIG => if configurar = '1' then PE <= RE
                                                else PE <= DESCONFIG
                            end if;
          when RE =>  if  configurar = '0' then PE <= DESCONFIG
                      elsif valido = '0'   then PE <= RE0
                                           else PE <= RE
                                           contagem <= entrada
                      end if;
          when RE0 => if configurar = '0' then PE <= DESCONFIG
                      elsif valido = '1'  then PE <= RE01
                                          else PE <= RE0
                                               senha0 <= entrada
                      end if;
          when RE01 => if configurar = '0' then PE <= DESCONFIG
                      elsif valido = '0'   then PE <= RE010
                                         else PE <= RE01
                                              senha01 <= entrada
                      end if;
          when RE010 => if configurar = '0' then PE <= DESCONFIG
                        else senha010 <= entrada
                             PE <= ESPERE
                        end if;
          when ESPERE => if configurar = '0' then 
                            PE <= CONFIG;
                            if contagem = "0000" then 
                              is_alarme <= '0';
                            else 
                              tentativa <= contagem;
                              is_alarme <= '1';
                            end if;
                        else PE <= ESPERE
                        end if;
      end process;

  -- NECESSARIO SER UM UNICO PROCESSO 
  --comb_config: process(EA, valido, entrada, tentativa, is_alarme, senha0, senha01, senha010)
                


end architecture; 