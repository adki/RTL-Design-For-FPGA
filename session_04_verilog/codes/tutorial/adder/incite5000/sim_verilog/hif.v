`timescale 1ns / 1ps

module hif (
    SYS_CLK,
    SYS_RSTb,
    SL_FULLb,
    SL_EMPTYb,
    SL_RDb,
    SL_WRb,
    SL_AD,
    SL_DT_I,
    SL_DT_O,
    SL_DT_T,
    SL_OEb,
    SL_PKTENDb,
    iwp_enable,
    iwp_data_in,
    iwp_clk0,
    iwp_cmd_valid0,
    iwp_cmd_read0,
    iwp_cmd_data0,
    iwp_cmd_count0,
    iwp_rd_rdble0,
    iwp_rd_read0,
    iwp_rd_data0,
    iwp_rd_count0,
    iwp_wr_wrble0,
    iwp_wr_write0,
    iwp_wr_data0,
    iwp_wr_count0,
    iwp_read_en0,
    iwp_write_en0,
    iwp_data_out0,
    iwp_clk1,
    iwp_cmd_valid1,
    iwp_cmd_read1,
    iwp_cmd_data1,
    iwp_cmd_count1,
    iwp_rd_rdble1,
    iwp_rd_read1,
    iwp_rd_data1,
    iwp_rd_count1,
    iwp_wr_wrble1,
    iwp_wr_write1,
    iwp_wr_data1,
    iwp_wr_count1,
    iwp_read_en1,
    iwp_write_en1,
    iwp_data_out1 );
    input		SYS_CLK;
    input		SYS_RSTb;
    input		SL_FULLb;
    input		SL_EMPTYb;
    output		SL_RDb;
    output		SL_WRb;
    output	[1:0]	SL_AD;
    input	[15:0]	SL_DT_I;
    output	[15:0]	SL_DT_O;
    output		SL_DT_T;
    output		SL_OEb;
    output		SL_PKTENDb;
    output	[1:0]	iwp_enable;
    output	[31:0]	iwp_data_in;
    input		iwp_clk0;
    output		iwp_cmd_valid0;
    input		iwp_cmd_read0;
    output	[31:0]	iwp_cmd_data0;
    output	[15:0]	iwp_cmd_count0;
    output		iwp_rd_rdble0;
    input		iwp_rd_read0;
    output	[31:0]	iwp_rd_data0;
    output	[15:0]	iwp_rd_count0;
    output		iwp_wr_wrble0;
    input		iwp_wr_write0;
    input	[31:0]	iwp_wr_data0;
    output	[15:0]	iwp_wr_count0;
    output		iwp_read_en0;
    output		iwp_write_en0;
    input	[31:0]	iwp_data_out0;
    input		iwp_clk1;
    output		iwp_cmd_valid1;
    input		iwp_cmd_read1;
    output	[31:0]	iwp_cmd_data1;
    output	[15:0]	iwp_cmd_count1;
    output		iwp_rd_rdble1;
    input		iwp_rd_read1;
    output	[31:0]	iwp_rd_data1;
    output	[15:0]	iwp_rd_count1;
    output		iwp_wr_wrble1;
    input		iwp_wr_write1;
    input	[31:0]	iwp_wr_data1;
    output	[15:0]	iwp_wr_count1;
    output		iwp_read_en1;
    output		iwp_write_en1;
    input	[31:0]	iwp_data_out1;

// synthesis translate_off

    wire	[31:0]	fifo_wdata;
    wire 		intSYS_RSTo;
    wire 		iwp_clk0;
    wire 		iwp_clk1;
    wire	[31:0]	iwp_data_in;
    wire	[31:0]	iwp_data_out0;
    wire	[31:0]	iwp_data_out1;
    wire	[1:0]	iwp_enable;
    wire 		iwp_read_en0;
    wire 		iwp_read_en1;
    wire 		iwp_write_en0;
    wire 		iwp_write_en1;
    wire 		netgnd;
    wire	[1:0]	SL_AD;
    wire	[15:0]	SL_DT_I;
    wire	[15:0]	SL_DT_O;
    wire 		SL_DT_T;
    wire 		SL_EMPTYb;
    wire 		SL_FULLb;
    wire 		SL_OEb;
    wire 		SL_PKTENDb;
    wire 		SL_RDb;
    wire 		SL_WRb;
    wire 		SYS_CLK;
    wire 		SYS_RSTb;


    usbhif8core 	usbhif8core (
        .SYS_CLK( SYS_CLK ),
        .SYS_RSTb( SYS_RSTb ),
        .intSYS_RSTo( intSYS_RSTo ),
        .SL_FULLb( SL_FULLb ),
        .SL_EMPTYb( SL_EMPTYb ),
        .SL_RDb( SL_RDb ),
        .SL_WRb( SL_WRb ),
        .SL_AD( SL_AD ),
        .SL_DT_I( SL_DT_I ),
        .SL_DT_O( SL_DT_O ),
        .SL_DT_T( SL_DT_T ),
        .SL_OEb( SL_OEb ),
        .SL_PKTENDb( SL_PKTENDb ),
        .iwp_enable( iwp_enable ),
        .iwp_data_in( iwp_data_in ),
        .fifo_wdata( fifo_wdata ),
        .iwp_clk0( iwp_clk0 ),
        .iwp_cmd_valid0(  ),
        .iwp_cmd_count0(  ),
        .iwp_rd_rdble0(  ),
        .iwp_rd_count0(  ),
        .iwp_wr_wrble0(  ),
        .iwp_wr_count0(  ),
        .iwp_read_en0( iwp_read_en0 ),
        .iwp_write_en0( iwp_write_en0 ),
        .iwp_data_out0( iwp_data_out0 ),
        .cfifo_full0( netgnd ),
        .cfifo_write0(  ),
        .cfifo_empty0( netgnd ),
        .cfifo_rd_count0( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .rfifo_full0( netgnd ),
        .rfifo_write0(  ),
        .rfifo_empty0( netgnd ),
        .rfifo_wr_count0( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .rfifo_rd_count0( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .wfifo_empty0( netgnd ),
        .wfifo_read0(  ),
        .wfifo_rdata0( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .wfifo_full0( netgnd ),
        .wfifo_wr_count0( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .wfifo_rd_count0( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .iwp_clk1( iwp_clk1 ),
        .iwp_cmd_valid1(  ),
        .iwp_cmd_count1(  ),
        .iwp_rd_rdble1(  ),
        .iwp_rd_count1(  ),
        .iwp_wr_wrble1(  ),
        .iwp_wr_count1(  ),
        .iwp_read_en1( iwp_read_en1 ),
        .iwp_write_en1( iwp_write_en1 ),
        .iwp_data_out1( iwp_data_out1 ),
        .cfifo_full1( netgnd ),
        .cfifo_write1(  ),
        .cfifo_empty1( netgnd ),
        .cfifo_rd_count1( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .rfifo_full1( netgnd ),
        .rfifo_write1(  ),
        .rfifo_empty1( netgnd ),
        .rfifo_wr_count1( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .rfifo_rd_count1( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .wfifo_empty1( netgnd ),
        .wfifo_read1(  ),
        .wfifo_rdata1( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .wfifo_full1( netgnd ),
        .wfifo_wr_count1( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .wfifo_rd_count1( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .iwp_clk2( netgnd ),
        .iwp_cmd_valid2(  ),
        .iwp_cmd_count2(  ),
        .iwp_rd_rdble2(  ),
        .iwp_rd_count2(  ),
        .iwp_wr_wrble2(  ),
        .iwp_wr_count2(  ),
        .iwp_read_en2(  ),
        .iwp_write_en2(  ),
        .iwp_data_out2( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .cfifo_full2( netgnd ),
        .cfifo_write2(  ),
        .cfifo_empty2( netgnd ),
        .cfifo_rd_count2( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .rfifo_full2( netgnd ),
        .rfifo_write2(  ),
        .rfifo_empty2( netgnd ),
        .rfifo_wr_count2( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .rfifo_rd_count2( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .wfifo_empty2( netgnd ),
        .wfifo_read2(  ),
        .wfifo_rdata2( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .wfifo_full2( netgnd ),
        .wfifo_wr_count2( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .wfifo_rd_count2( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .iwp_clk3( netgnd ),
        .iwp_cmd_valid3(  ),
        .iwp_cmd_count3(  ),
        .iwp_rd_rdble3(  ),
        .iwp_rd_count3(  ),
        .iwp_wr_wrble3(  ),
        .iwp_wr_count3(  ),
        .iwp_read_en3(  ),
        .iwp_write_en3(  ),
        .iwp_data_out3( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .cfifo_full3( netgnd ),
        .cfifo_write3(  ),
        .cfifo_empty3( netgnd ),
        .cfifo_rd_count3( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .rfifo_full3( netgnd ),
        .rfifo_write3(  ),
        .rfifo_empty3( netgnd ),
        .rfifo_wr_count3( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .rfifo_rd_count3( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .wfifo_empty3( netgnd ),
        .wfifo_read3(  ),
        .wfifo_rdata3( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .wfifo_full3( netgnd ),
        .wfifo_wr_count3( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .wfifo_rd_count3( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .iwp_clk4( netgnd ),
        .iwp_cmd_valid4(  ),
        .iwp_cmd_count4(  ),
        .iwp_rd_rdble4(  ),
        .iwp_rd_count4(  ),
        .iwp_wr_wrble4(  ),
        .iwp_wr_count4(  ),
        .iwp_read_en4(  ),
        .iwp_write_en4(  ),
        .iwp_data_out4( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .cfifo_full4( netgnd ),
        .cfifo_write4(  ),
        .cfifo_empty4( netgnd ),
        .cfifo_rd_count4( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .rfifo_full4( netgnd ),
        .rfifo_write4(  ),
        .rfifo_empty4( netgnd ),
        .rfifo_wr_count4( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .rfifo_rd_count4( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .wfifo_empty4( netgnd ),
        .wfifo_read4(  ),
        .wfifo_rdata4( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .wfifo_full4( netgnd ),
        .wfifo_wr_count4( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .wfifo_rd_count4( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .iwp_clk5( netgnd ),
        .iwp_cmd_valid5(  ),
        .iwp_cmd_count5(  ),
        .iwp_rd_rdble5(  ),
        .iwp_rd_count5(  ),
        .iwp_wr_wrble5(  ),
        .iwp_wr_count5(  ),
        .iwp_read_en5(  ),
        .iwp_write_en5(  ),
        .iwp_data_out5( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .cfifo_full5( netgnd ),
        .cfifo_write5(  ),
        .cfifo_empty5( netgnd ),
        .cfifo_rd_count5( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .rfifo_full5( netgnd ),
        .rfifo_write5(  ),
        .rfifo_empty5( netgnd ),
        .rfifo_wr_count5( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .rfifo_rd_count5( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .wfifo_empty5( netgnd ),
        .wfifo_read5(  ),
        .wfifo_rdata5( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .wfifo_full5( netgnd ),
        .wfifo_wr_count5( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .wfifo_rd_count5( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .iwp_clk6( netgnd ),
        .iwp_cmd_valid6(  ),
        .iwp_cmd_count6(  ),
        .iwp_rd_rdble6(  ),
        .iwp_rd_count6(  ),
        .iwp_wr_wrble6(  ),
        .iwp_wr_count6(  ),
        .iwp_read_en6(  ),
        .iwp_write_en6(  ),
        .iwp_data_out6( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .cfifo_full6( netgnd ),
        .cfifo_write6(  ),
        .cfifo_empty6( netgnd ),
        .cfifo_rd_count6( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .rfifo_full6( netgnd ),
        .rfifo_write6(  ),
        .rfifo_empty6( netgnd ),
        .rfifo_wr_count6( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .rfifo_rd_count6( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .wfifo_empty6( netgnd ),
        .wfifo_read6(  ),
        .wfifo_rdata6( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .wfifo_full6( netgnd ),
        .wfifo_wr_count6( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .wfifo_rd_count6( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .iwp_clk7( netgnd ),
        .iwp_cmd_valid7(  ),
        .iwp_cmd_count7(  ),
        .iwp_rd_rdble7(  ),
        .iwp_rd_count7(  ),
        .iwp_wr_wrble7(  ),
        .iwp_wr_count7(  ),
        .iwp_read_en7(  ),
        .iwp_write_en7(  ),
        .iwp_data_out7( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .cfifo_full7( netgnd ),
        .cfifo_write7(  ),
        .cfifo_empty7( netgnd ),
        .cfifo_rd_count7( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .rfifo_full7( netgnd ),
        .rfifo_write7(  ),
        .rfifo_empty7( netgnd ),
        .rfifo_wr_count7( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .rfifo_rd_count7( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .wfifo_empty7( netgnd ),
        .wfifo_read7(  ),
        .wfifo_rdata7( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .wfifo_full7( netgnd ),
        .wfifo_wr_count7( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } ),
        .wfifo_rd_count7( { netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd, netgnd } )
    );



    GND 	GND (
        .G( netgnd )
    );


// synthesis translate_on

endmodule

