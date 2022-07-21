-------------------------------------------------
-- Company:       GRACO-FT/UnB, FGA/UnB
-- Engineer:      DANIEL MAURICIO MU�OZ ARBOLEDA
-- 
-- Create Date:   07-May-2016 
-- Design name:   
-- Module name:   fpupack
-- Description:   This package defines types, subtypes and constants
-- Automatically generated using the vHPSOgen.m v1.0
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.fpupack.all;

package rnapack is

constant max_num_in : integer := 16;
constant num_in : integer range 0 to max_num_in := 4;
type array1D is array (0 to num_in-1) of std_logic_vector(FP_WIDTH-1 downto 0);

constant maxiter : integer range 0 to num_in := (num_in/2)-1;

end rnapack;

package body rnapack is
end rnapack;
