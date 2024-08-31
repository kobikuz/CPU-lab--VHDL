LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.sample_package.all;
-------------------------------------
ENTITY AdderSub IS
  GENERIC (Dwidth : INTEGER :=16 );
  PORT (    
        x, y: IN STD_LOGIC_VECTOR (Dwidth-1 DOWNTO 0);
        OPC: IN STD_LOGIC_VECTOR (3 downto 0);
        s: OUT STD_LOGIC_VECTOR(Dwidth-1 DOWNTO 0);
        Cflag: OUT STD_LOGIC;
        Zflag: OUT STD_LOGIC;
        Nflag: OUT STD_LOGIC);
END AdderSub;
--------------------------------------------------------------
ARCHITECTURE dfl OF AdderSub IS
    COMPONENT FA IS
        PORT (xi, yi, cin: IN std_logic;
              s, cout: OUT std_logic);
    END COMPONENT;

    SIGNAL reg : std_logic_vector(Dwidth-1 DOWNTO 0);
    SIGNAL x2 : STD_LOGIC_VECTOR(Dwidth-1 DOWNTO 0);
    SIGNAL y2 : STD_LOGIC_VECTOR(Dwidth-1 DOWNTO 0);
    SIGNAL s2 : STD_LOGIC_VECTOR(Dwidth-1 DOWNTO 0);
    SIGNAL c2 : STD_LOGIC;
    SIGNAL Nflag_temp : STD_LOGIC;-- := '0';
    SIGNAL Zflag_temp: STD_LOGIC;-- := '0';
    SIGNAL Cflag_temp : STD_LOGIC;-- := '0';
    SIGNAL borrow_flag : STD_LOGIC;

BEGIN

    x2 <= x;
    y2 <= NOT y WHEN OPC="0001" ELSE y;
    c2 <= '1' WHEN OPC="0001" ELSE '0';

    first : FA PORT MAP(
        xi => x2(0),
        yi => y2(0),
        cin => c2,
        s => s2(0),
        cout => reg(0)
    );

    rest : FOR i IN 1 TO Dwidth-1 GENERATE
        chain : FA PORT MAP(
            xi => x2(i),
            yi => y2(i),
            cin => reg(i-1),
            s => s2(i),
            cout => reg(i)
        );
    END GENERATE;

    s <= s2;

    -- Carry/Borrow Calculation
 --   borrow_flag <= NOT reg(Dwidth-1);
 --   PROCESS (OPC, reg)
 --   BEGIN
  --      IF OPC = "0000" THEN  -- Addition
   --         Cflag_temp <= reg(Dwidth-1);  -- Use carry-out directly
   --     ELSIF OPC = "0001" THEN  -- Subtraction
   --         Cflag_temp <= borrow_flag;  -- Use borrow flag for subtraction
   --     ELSE
   --         Cflag_temp <= 'Z';
   --     END IF;
   -- END PROCESS;

    -- Zero Flag
    Zflag <= '1' when s2 = x"0000" else '0' ;-- and OPC(3 DOWNTO 1) = "000" else '0' when (s2 /=x"0000" and OPC(3 DOWNTO 1) = "000") else 'Z';

    -- Negative Flag
    Nflag <=  s2(Dwidth-1); -- when OPC(3 DOWNTO 1) = "000" else 'Z';

    -- Assign flags to outputs
    --Nflag <= Nflag_temp;
    --Zflag <= Zflag_temp;
    Cflag <= reg(Dwidth -1) when OPC ="0000" else reg(Dwidth-1) when OPC= "0001" else '0';

END dfl;