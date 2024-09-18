LIBRARY ieee;
USE ieee.std_logic_1164.all;
-------------------------------------
ENTITY To7seg IS
  PORT (    
			BCDin: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      Hex7seg: OUT STD_LOGIC_VECTOR(13 downto 0));
      
END To7seg;
--------------------------------------------------------------
ARCHITECTURE behave OF To7seg is


BEGIN

  process(BCDin)
  begin
      case BCDin(3 downto 0) is
      when "0000" =>
      Hex7seg(6 downto 0) <= not"0111111"; ---0
      when "0001" =>
      Hex7seg(6 downto 0) <= not"0000110"; ---1
      when "0010" =>
      Hex7seg(6 downto 0) <= not"1011011"; ---2
      when "0011" =>
      Hex7seg(6 downto 0) <= not"1001111"; ---3
      when "0100" =>
      Hex7seg(6 downto 0) <= not"1100110"; ---4
      when "0101" =>
      Hex7seg(6 downto 0) <= not"1101101"; ---5
      when "0110" =>
      Hex7seg(6 downto 0) <= not"1111101"; ---6
      when "0111" =>
      Hex7seg(6 downto 0) <= not"0000111"; ---7
      when "1000" =>
      Hex7seg(6 downto 0) <= not"1111111"; ---8
      when "1001" =>
      Hex7seg(6 downto 0) <= not"1101111"; ---9
      when "1010" =>
      Hex7seg(6 downto 0) <= not"1110111"; ---A
      when "1011" =>
      Hex7seg(6 downto 0) <= not"1111100"; ---b
      when "1100" =>
      Hex7seg(6 downto 0) <= not"0111001"; ---C
      when "1101" =>
      Hex7seg(6 downto 0) <= not"1011110"; ---d
      when "1110" =>
      Hex7seg(6 downto 0) <= not"1111001"; ---E
      when "1111" =>
      Hex7seg(6 downto 0) <= not"1110001"; ---F
		when others =>
      Hex7seg(6 downto 0) <= (others => '1'); -- Default
  end case;

 
      case BCDin(7 downto 4) is
        when "0000" =>
        Hex7seg(13 downto 7) <= not"0111111"; ---0
        when "0001" =>
        Hex7seg(13 downto 7) <= not"0000110"; ---1
        when "0010" =>
        Hex7seg(13 downto 7) <= not"1011011"; ---2
        when "0011" =>
        Hex7seg(13 downto 7) <= not"1001111"; ---3
        when "0100" =>
        Hex7seg(13 downto 7) <= not"1100110"; ---4
        when "0101" =>
        Hex7seg(13 downto 7)<= not"1101101"; ---5
        when "0110" =>
        Hex7seg(13 downto 7)<= not"1111101"; ---6
        when "0111" =>
        Hex7seg(13 downto 7)<= not"0000111"; ---7
        when "1000" =>
        Hex7seg(13 downto 7)<= not"1111111"; ---8
        when "1001" =>
        Hex7seg(13 downto 7)<= not"1101111"; ---9
        when "1010" =>
        Hex7seg(13 downto 7)<= not"1110111"; ---A
        when "1011" =>
        Hex7seg(13 downto 7)<= not"1111100"; ---b
        when "1100" =>
        Hex7seg(13 downto 7) <= not"0111001"; ---C
        when "1101" =>
        Hex7seg(13 downto 7)<= not"1011110"; ---d
        when "1110" =>
        Hex7seg(13 downto 7)<= not"1111001"; ---E
        when "1111" =>
        Hex7seg(13 downto 7) <= not"1110001"; ---F
				when others =>
      Hex7seg(13 downto 7) <= (others => '1'); -- Default
  end case;

      end process;

 

END behave;

