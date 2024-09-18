library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity CounterEnvelope is 
  port (
    Clk, En : in std_logic;
    Qout    : out std_logic_vector(7 downto 0)
  ); 
end CounterEnvelope;

architecture rtl of CounterEnvelope is
  component counterpll 
    port(
      clk, enable,reset_q : in std_logic;
      q            : out std_logic_vector(7 downto 0)
    );
  end component;
  
  component PLL_0002 
    port(
		refclk   : in  std_logic := '0'; --  refclk.clk
		rst      : in  std_logic := '0'; --   reset.reset
		outclk_0 : out std_logic         -- outclk0.clk
	);
  end component;
  
  signal PLLOut : std_logic;
  --signal DivClk : std_logic; -- Divided clock signal from the counter

begin
  m0: counterpll 
    port map(
      clk => PLLOut,
      enable => En,
	  reset_q=> '0',
      q => Qout
    );

  m1: PLL_0002 
    port map(
      refclk => Clk,
      rst => '0',
		outclk_0=>PLLOut
    );


end rtl;
