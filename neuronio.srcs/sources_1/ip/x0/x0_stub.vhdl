-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
-- Date        : Thu Jul 14 20:11:23 2022
-- Host        : DESKTOP-2RL7D6R running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub c:/Users/lxm10/neuronio/neuronio.srcs/sources_1/ip/x0/x0_stub.vhdl
-- Design      : x0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity x0 is
  Port ( 
    clka : in STD_LOGIC;
    ena : in STD_LOGIC;
    addra : in STD_LOGIC_VECTOR ( 6 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 26 downto 0 )
  );

end x0;

architecture stub of x0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clka,ena,addra[6:0],douta[26:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blk_mem_gen_v8_4_2,Vivado 2018.3";
begin
end;
