----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.08.2021 08:18:30
-- Design Name: 
-- Module Name: neuronio - Behavioral
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

entity neuronio is
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           x : in array1D;
           w : in array1D;
           bias : in STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0);
           start : in STD_LOGIC;
           saida : out STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0);
           ready : out STD_LOGIC);
end neuronio;

architecture Behavioral of neuronio is

component addsubfsm_v6 is
	port (reset     :  in std_logic;
		 clk        :  in std_logic;
		 op			:  in std_logic;
		 op_a 		:  in std_logic_vector(FP_WIDTH-1 downto 0);
		 op_b 		:  in std_logic_vector(FP_WIDTH-1 downto 0);
		 start_i    :  in std_logic;
		 addsub_out : out std_logic_vector(FP_WIDTH-1 downto 0);
		 ready_as   : out std_logic);
end component;

component multiplierfsm_v2 is
    port (reset 	 :  in std_logic; 
        clk	 	 :  in std_logic;          
        op_a	 	 :  in std_logic_vector(FP_WIDTH-1 downto 0);
        op_b	 	 :  in std_logic_vector(FP_WIDTH-1 downto 0);
        start_i	 :  in std_logic;
        mul_out  : out std_logic_vector(FP_WIDTH-1 downto 0);
        ready_mul: out std_logic);
end component;

component sigmoid is
	Port( phi : in STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0);
        saida : out STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0));
end component;

signal sw_impar, sx_impar : std_logic_vector(FP_WIDTH-1 downto 0);
signal sw_par, sx_par : std_logic_vector(FP_WIDTH-1 downto 0);
signal sel : std_logic_vector(2 downto 0);
signal sel_b : std_logic;
signal outm1, outm2 : std_logic_vector(FP_WIDTH-1 downto 0);
signal outadd1, v: std_logic_vector(FP_WIDTH-1 downto 0);
signal outsig: std_logic_vector(FP_WIDTH-1 downto 0);
signal sbacc: std_logic_vector(FP_WIDTH-1 downto 0);
signal start_m : std_logic;
signal rdy_m1, rdy_m2 : std_logic;
signal rdyadd1, rdyacc : std_logic;
signal iter : integer range 0 to num_in;
--type tipo_w is array (0 to num_in-1) of std_logic_vector(FP_WIDTH-1 downto 0);
--signal w : tipo_w := ("001111111000000000000000000",
--                      "001111111000000000000000000",
--                      "001111111000000000000000000",
--                      "001111111000000000000000000");

--signal bias: std_logic_vector(FP_9955024WIDTH-1 downto 0) := "110000011010000000000000000"; --20.0

begin

    m_impar: multiplierfsm_v2 port map(
        reset 	     => reset, 
        clk	 	     => clk,     
        op_a	 	 => sx_impar,
        op_b	 	 => sw_impar, 
        start_i	     => start_m,
        mul_out      => outm1,
        ready_mul    => rdy_m1);
        
    m_par: multiplierfsm_v2 port map(
        reset 	     => reset, 
        clk	 	     => clk,     
        op_a	 	 => sx_par,
        op_b	 	 => sw_par, 
        start_i	     => start_m,
        mul_out      => outm2,
        ready_mul    => rdy_m2);
    
    s1: addsubfsm_v6 port map(
        reset 	     => reset, 
        clk	 	     => clk,     
        op_a	 	 => outm1,
        op_b	 	 => outm2,
        op           => '0', -- soma
        start_i	     => rdy_m2,
        addsub_out   => outadd1,
        ready_as     => rdyadd1);
    
    s2: addsubfsm_v6 port map(
        reset 	     => reset, 
        clk	 	     => clk,     
        op_a	 	 => outadd1,
        op_b	 	 => sbacc,
        op           => '0', -- soma
        start_i	     => rdyadd1,
        addsub_out   => v,
        ready_as     => rdyacc);
        
    mysig: sigmoid port map(
        phi     => v,
        saida   => outsig);

    -- mux x impar
    with sel select
        sx_impar <= x(1) when "000",
                    x(3) when "001",
--                    x(5) when "010",
--                    x(7) when "011",
--                    x(9) when "100",
--                    x(11) when "101",
--                    x(13) when "110",
                    x(1) when others;
        
    -- mux w impar
    with sel select
        sw_impar <= w(1) when "000",
                    w(3) when "001",
--                    w(5) when "010",
--                    w(7) when "011",
--                    w(9) when "100",
--                    w(11) when "101",
--                    w(13) when "110",
                    w(1) when others;     
        
    -- mux x par
    with sel select
        sx_par <= x(0) when "000",
                  x(2) when "001",
--                  x(4) when "010",
--                  x(6) when "011",
--                  x(8) when "100",
--                  x(10) when "101",
--                  x(12) when "110",
                  x(0) when others;
        
    -- mux w par
    with sel select
        sw_par <= w(0) when "000",
                  w(2) when "001",
--                  w(4) when "010",
--                  w(6) when "011",
--                  w(8) when "100",
--                  w(10) when "101",
--                  w(12) when "110",
                  w(0) when others;     
        
    -- mux bias_acc
    with sel_b select
        sbacc <= bias when '0',       
                 v when others; 
        
    -- processo para controlar start e seletora dos multiplicadores
    process(clk,reset)
    begin
        if reset='1' then
            iter <= 0;
            start_m <= '0';
            sel <= (others=>'0');
        elsif rising_edge(clk) then
            start_m <= '0';
            if start='1' then
                iter <= 0;
                start_m <= '1';
                sel <= (others=>'0');
            elsif rdy_m2 = '1' and iter<maxiter then
                iter <= iter +1;
                start_m <= '1';
                sel <= std_logic_vector(unsigned(sel)+1);
            end if;
        end if;
    end process;

    -- processo para controlar ready geral e seletora do mux do bias e acc
    process(clk,reset)
    variable cnt : integer range 0 to num_in := 0;   
    begin
        if reset='1' then
            cnt := 0;
            sel_b <= '0';
            ready <= '0';
            saida <= (others=> '0');
        elsif rising_edge(clk) then
            ready <= '0';               
            if start='1' then
                cnt := 0;
                sel_b <= '0';
                ready <= '0';
            elsif rdyacc='1' and sel_b = '0' then
                cnt := cnt + 1; 
                sel_b <= '1';
                saida <= (others=> '0');
                ready <= '0';
            elsif rdyacc='1' then --and cnt = maxiter then
                cnt := cnt + 1;
                if cnt = maxiter+1 then
                    cnt := cnt + 1;
					sel_b <= '0';
                    saida <= outsig;
                    ready <= '1';
                end if;
            end if;
        end if;
    end process;
                        
end Behavioral;

















