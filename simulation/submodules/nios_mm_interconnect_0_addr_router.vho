--IP Functional Simulation Model
--VERSION_BEGIN 13.1 cbx_mgl 2013:10:24:09:16:30:SJ cbx_simgen 2013:10:24:09:15:20:SJ  VERSION_END


-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- You may only use these simulation model output files for simulation
-- purposes and expressly not for synthesis or any other purposes (in which
-- event Altera disclaims all warranties of any kind).


--synopsys translate_off

--synthesis_resources = mux21 4 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  nios_mm_interconnect_0_addr_router IS 
	 PORT 
	 ( 
		 clk	:	IN  STD_LOGIC;
		 reset	:	IN  STD_LOGIC;
		 sink_data	:	IN  STD_LOGIC_VECTOR (89 DOWNTO 0);
		 sink_endofpacket	:	IN  STD_LOGIC;
		 sink_ready	:	OUT  STD_LOGIC;
		 sink_startofpacket	:	IN  STD_LOGIC;
		 sink_valid	:	IN  STD_LOGIC;
		 src_channel	:	OUT  STD_LOGIC_VECTOR (4 DOWNTO 0);
		 src_data	:	OUT  STD_LOGIC_VECTOR (89 DOWNTO 0);
		 src_endofpacket	:	OUT  STD_LOGIC;
		 src_ready	:	IN  STD_LOGIC;
		 src_startofpacket	:	OUT  STD_LOGIC;
		 src_valid	:	OUT  STD_LOGIC
	 ); 
 END nios_mm_interconnect_0_addr_router;

 ARCHITECTURE RTL OF nios_mm_interconnect_0_addr_router IS

	 ATTRIBUTE synthesis_clearbox : natural;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS 1;
	 SIGNAL	wire_nios_mm_interconnect_0_addr_router_src_channel_24m_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nios_mm_interconnect_0_addr_router_src_channel_25m_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nios_mm_interconnect_0_addr_router_src_data_27m_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nios_mm_interconnect_0_addr_router_src_data_28m_dataout	:	STD_LOGIC;
	 SIGNAL  wire_w_lg_w_sink_data_range119w278w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_sink_data_range143w275w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w1w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_sink_data_range122w277w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_sink_data_range146w274w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  s_wire_nios_mm_interconnect_0_addr_router_src_channel_1_261_dataout :	STD_LOGIC;
	 SIGNAL  s_wire_nios_mm_interconnect_0_addr_router_src_channel_2_276_dataout :	STD_LOGIC;
	 SIGNAL  wire_w_sink_data_range119w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_sink_data_range122w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_sink_data_range143w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_sink_data_range146w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
 BEGIN

	wire_w_lg_w_sink_data_range119w278w(0) <= wire_w_sink_data_range119w(0) AND wire_w_lg_w_sink_data_range122w277w(0);
	wire_w_lg_w_sink_data_range143w275w(0) <= wire_w_sink_data_range143w(0) AND wire_w_lg_w_sink_data_range146w274w(0);
	wire_w1w(0) <= NOT s_wire_nios_mm_interconnect_0_addr_router_src_channel_1_261_dataout;
	wire_w_lg_w_sink_data_range122w277w(0) <= NOT wire_w_sink_data_range122w(0);
	wire_w_lg_w_sink_data_range146w274w(0) <= NOT wire_w_sink_data_range146w(0);
	s_wire_nios_mm_interconnect_0_addr_router_src_channel_1_261_dataout <= (wire_w_lg_w_sink_data_range143w275w(0) AND sink_data(49));
	s_wire_nios_mm_interconnect_0_addr_router_src_channel_2_276_dataout <= (((((((((wire_w_lg_w_sink_data_range119w278w(0) AND sink_data(41)) AND (NOT sink_data(42))) AND (NOT sink_data(43))) AND (NOT sink_data(44))) AND (NOT sink_data(45))) AND (NOT sink_data(46))) AND (NOT sink_data(47))) AND sink_data(48)) AND sink_data(49));
	sink_ready <= src_ready;
	src_channel <= ( "0" & "0" & s_wire_nios_mm_interconnect_0_addr_router_src_channel_2_276_dataout & wire_nios_mm_interconnect_0_addr_router_src_channel_24m_dataout & wire_nios_mm_interconnect_0_addr_router_src_channel_25m_dataout);
	src_data <= ( sink_data(89 DOWNTO 77) & "0" & wire_nios_mm_interconnect_0_addr_router_src_data_27m_dataout & wire_nios_mm_interconnect_0_addr_router_src_data_28m_dataout & sink_data(73 DOWNTO 0));
	src_endofpacket <= sink_endofpacket;
	src_startofpacket <= sink_startofpacket;
	src_valid <= sink_valid;
	wire_w_sink_data_range119w(0) <= sink_data(39);
	wire_w_sink_data_range122w(0) <= sink_data(40);
	wire_w_sink_data_range143w(0) <= sink_data(47);
	wire_w_sink_data_range146w(0) <= sink_data(48);
	wire_nios_mm_interconnect_0_addr_router_src_channel_24m_dataout <= wire_w1w(0) AND NOT(s_wire_nios_mm_interconnect_0_addr_router_src_channel_2_276_dataout);
	wire_nios_mm_interconnect_0_addr_router_src_channel_25m_dataout <= s_wire_nios_mm_interconnect_0_addr_router_src_channel_1_261_dataout AND NOT(s_wire_nios_mm_interconnect_0_addr_router_src_channel_2_276_dataout);
	wire_nios_mm_interconnect_0_addr_router_src_data_27m_dataout <= wire_w1w(0) AND NOT(s_wire_nios_mm_interconnect_0_addr_router_src_channel_2_276_dataout);
	wire_nios_mm_interconnect_0_addr_router_src_data_28m_dataout <= s_wire_nios_mm_interconnect_0_addr_router_src_channel_1_261_dataout AND NOT(s_wire_nios_mm_interconnect_0_addr_router_src_channel_2_276_dataout);

 END RTL; --nios_mm_interconnect_0_addr_router
--synopsys translate_on
--VALID FILE
