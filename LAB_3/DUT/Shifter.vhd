LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.sample_package.all;
-------------------------------------
ENTITY Shifter IS
  GENERIC (n : INTEGER := 16;
		   k : INTEGER := 4); --- k must be log2(n)		
  PORT (    
			x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			OPC: IN STD_LOGIC_VECTOR (k-1 downto 0);
            Cflag: OUT STD_LOGIC;
			Zflag: out std_logic;
			Nflag: out std_logic;
            s : OUT STD_LOGIC_VECTOR(n-1 downto 0));
END Shifter;

ARCHITECTURE shifterArch OF Shifter IS

		type MATRIX is array (0 to k - 1)  of STD_LOGIC_VECTOR (n - 1 downto 0);
		constant zeros : std_logic_vector (n-1 DOWNTO 0 ) := (others => '0');
        signal resMat: MATRIX;     -- log(n)Xn matrix
        signal carryVec : std_logic_vector (0 to k - 1);

		
begin
		--------------------------first colum ---------------------------------------------------------
        resMat(0) <= y(n - 2 downto 0) & zeros(0) when (x(0)= '1' and OPC ="0011") else y;

        carryVec(0) <= y( n - 1 )  when (x(0)= '1' and OPC ="0011") else
                                '0';
		--------------------------shift iterations-------------------------------------------------------
		loopi : for i in 1 to k - 1 generate
		
				resMAT(i) <= resMAT(i-1)(n-2**i - 1  downto 0) & zeros( 2**i - 1 downto 0 )  when (x(i)= '1' and OPC ="0011") 
				else resMAT(i-1);
				
				
                carryVec(i) <=  resMat(i-1)( n - 2**i )  when (x(i)= '1' and OPC ="0011") else carryVec(i-1);
		end generate;
		-------------------------- output ----------------------------------------------------------
		s  <= resMat(k - 1) when OPC = "0011"  else (others => 'Z');
        Cflag <= carryVec(k - 1) when OPC ="0011"  else unaffected;
		Zflag <='1' when s = zeros and OPC ="0011"  else '0' when OPC = "0011" and s/=zeros else 'Z';
		Nflag <= '1' when s(n-1) = '1' and OPC ="0011"  else '0' when OPC = "0011" and s(n-1) = '0'  else 'Z';
		-----------------------------------------------------------------------------------------------
END shifterArch;