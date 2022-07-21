----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.07.2022 20:00:44
-- Design Name: 
-- Module Name: top_component - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fpupack.all;
use work.rnapack.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_component is
    Port ( clk : in STD_LOGIC);
end top_component;

architecture Behavioral of top_component is

COMPONENT vio_0
  PORT (
    clk : IN STD_LOGIC;
    probe_out0 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe_out1 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
  );
END COMPONENT;

COMPONENT x0
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(26 DOWNTO 0)
  );
END COMPONENT;

COMPONENT x1
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(26 DOWNTO 0)
  );
END COMPONENT;

COMPONENT x2
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(26 DOWNTO 0)
  );
END COMPONENT;

COMPONENT x3
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(26 DOWNTO 0)
  );
END COMPONENT;


component neuronio is
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           x : in array1D;
           w : in array1D;
           bias : in STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0);
           start : in STD_LOGIC;
           saida : out STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0);
           ready : out STD_LOGIC);
end component;

COMPONENT ila_0

PORT (
	clk : IN STD_LOGIC;
	probe0 : IN STD_LOGIC_VECTOR(26 DOWNTO 0); 
	probe1 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
	probe2 : IN STD_LOGIC_VECTOR(26 DOWNTO 0)
);
END COMPONENT  ;


signal saddra :std_logic_vector(6 downto 0);
signal sx0,sx1,sx2,sx3,ssaida :std_logic_vector(26 downto 0);
signal sx,sw :array1d;
signal sstart,sready,srst,sstart_aux,sstart_aux2,flag,flag2 : std_logic;

begin
in_x0 : x0
  PORT MAP (
    clka => clk,
    ena => '1',
    addra => saddra,
    douta => sx0
  );
  
in_x1 : x1
  PORT MAP (
    clka => clk,
    ena => '1',
    addra => saddra,
    douta => sx1
  );
  
in_x2 : x2
  PORT MAP (
    clka => clk,
    ena => '1',
    addra => saddra,
    douta => sx2
  );
  
in_x3 : x3
  PORT MAP (
    clka => clk,
    ena => '1',
    addra => saddra,
    douta => sx3
  );

neur:neuronio 
    Port map ( reset   =>srst,
               clk     =>clk,
               x       =>sx,
               w       =>sw,
               bias    =>"001111110101001101001110100",
               start   =>sstart_aux2,
               saida   =>ssaida,
               ready   =>sready);
               
sw<=("001111011000110100110010000",
    "001111110100010100100111100",
    "001111100010100101000111101",
    "001111011010101111100000001");
    
    
ila_comp : ila_0
PORT MAP (
	clk => clk,
	probe0 => sx0, 
	probe1(0) => sready,
	probe2 => ssaida
);


vio_comp : vio_0
  PORT MAP (
    clk => clk,
    probe_out0(0) => sstart_aux,
    probe_out1(0) => srst
  );
sx<=(sx0,sx1,sx2,sx3);


process(sstart_aux,srst)
begin

    if srst='1' then
        flag<='0';
        flag2<='0';
    elsif sstart_aux='1' and flag2='0' then 
        flag<='1';
        flag2<='1';
    else
       flag<='0'; 
    end if;


end process;


process(clk,sready)
variable addr:integer range 0 to 128;
begin
    if srst='1'  then
        saddra <= (others=>'0');
        addr := 0;
    elsif rising_edge(clk)  then
        if sready='1' and  addr<128 then 
            saddra <= std_logic_vector( to_unsigned( addr, saddra'length));
            addr:=addr+1;
            sstart<='1';  
        else
            sstart<='0';       
        end if;
       
    end if;
end process;

sstart_aux2<=flag or sstart;
end Behavioral;
