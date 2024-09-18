LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY Divider IS
    GENERIC(
        N : INTEGER := 32  
    );
    PORT(
        clk      : IN  STD_LOGIC;
        reset    : IN  STD_LOGIC;
        enable   : IN  STD_LOGIC;
        dividend : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        divisor  : IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        divIFG   : OUT STD_LOGIC;
        residue  : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        quotient : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		 count_o   :out INTEGER RANGE 0 TO N := 0;
		 q_o       :out STD_LOGIC_VECTOR(N-1 DOWNTO 0) := (OTHERS => '0');
		 r_o       :out STD_LOGIC_VECTOR(N-1 DOWNTO 0) := (OTHERS => '0');
		 d_o       :out STD_LOGIC_VECTOR(2*N-1 DOWNTO 0) := (OTHERS => '0')
    );
END ENTITY;

ARCHITECTURE Behavioral OF Divider IS
    TYPE state_type IS (IDLE, DIVIDE, DONE);
    SIGNAL state   : state_type := IDLE;
    SIGNAL count   : INTEGER RANGE 0 TO N := 0;
    SIGNAL q       : STD_LOGIC_VECTOR(N-1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL r       : STD_LOGIC_VECTOR(N-1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL d       : STD_LOGIC_VECTOR(2*N-1 DOWNTO 0) := (OTHERS => '0');
	
BEGIN
    PROCESS(clk, reset,d,r,divisor,count,dividend)
    BEGIN
        IF reset = '1' THEN
            state <= IDLE;
            count <= 0;
            q <= (OTHERS => '0');
         --   r <= (OTHERS => '0');
            d <= (OTHERS => '0');
            divIFG <= '0';
            residue <= (OTHERS => '0');
            quotient <= (OTHERS => '0');
        ELSIF (enable = '0') THEN
            divIFG <= '0';  
        ELSIF rising_edge(clk) THEN
            CASE state IS
                WHEN IDLE =>
                    IF enable = '1' THEN
                        q <= (OTHERS => '0');
                     --   r <= (OTHERS => '0');
                        d <= x"00000000"&dividend;  -- Load the dividend
						count <= 0;
                        state <= DIVIDE;
                    END IF;
                WHEN DIVIDE =>
				
		         	d <= d(2*N-2 DOWNTO 0) & '0';      -- Shift d left			
					
					--r <= d(2*N-1 DOWNTO N);


					
					IF  r >= divisor THEN
					
						q <= q(N-2 DOWNTO 0) & '1'; 						
						d(2*N-1 DOWNTO N+1) <= r(N-2 downto 0)- divisor(N-2 downto 0); 
						
                    ELSE
						q <= q(N-2 DOWNTO 0) & '0'; -- Set quotient bit to '0'
                    END IF;                       
					if ( count = N) then
                        state <= DONE;
					else count <= count + 1;
                    END IF;
                WHEN DONE =>
                    divIFG <= '1';
                    residue <= '0'&r(N-1 downto 1);
                    quotient <= q;
                    state <= IDLE;
            END CASE;
        END IF;
    END PROCESS;
	
r <= d(2*N-1 DOWNTO N);
q_o <= q;
d_o<= d;
r_o<=r;
count_o <= count;
END ARCHITECTURE;