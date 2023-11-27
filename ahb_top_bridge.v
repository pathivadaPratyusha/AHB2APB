`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2023 01:48:08 PM
// Design Name: 
// Module Name: ahb_top_bridge
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


///////////////////INSTANTIATION OF AHB SLAVE INTEFACE AND APB CONTROLLER///////////////////////

module ahb_top_bridge(input hclk,hresetn,hwrite,hready_in,input[1:0] htrans,
input[31:0] hwdata,haddr,pr_data,
output penable,pwrite,hr_readyout,
output [2:0]psel,output[1:0] hresp,output[31:0] paddr,pwdata,hr_data);

wire[31:0]hwdata_1,hwdata_2,haddr_1,haddr_2;
wire[2:0] temp_sel;
wire hwrite_reg1,hwrite_reg2,valid;

ahb_slave_interface ahb( hclk,hresetn,hwrite,hready_in,trans,hwdata,haddr,pr_data,
hwrite_reg1, hwrite_reg2,valid,hwdata1,hwdata2,haddr1,haddr2,hr_data,temp_sel);

apb_controller apb( hclk,hresetn,hwrite,hwrite_reg1,hwrite_reg2,valid,
haddr,hwdata,hwdata1,hwdata2,haddr1,haddr2,prdata,temp_sel,penable,pwrite, hr_readyout,
psel,paddr,pwdata);
endmodule
