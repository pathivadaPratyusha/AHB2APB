`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2023 07:43:27 PM
// Design Name: 
// Module Name: top_tb
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


module top_tb();
reg hclk, hresetn;

wire hr_readyout;
wire[31:0] hrdata, hwdata, haddr,pr_data,paddr,pwdata,paddr_out,pwdata_out;
wire[1:0] htrans;
wire hwrite, hready_in;
wire[1:0] hresp=0;
wire penable,pwrite,pwrite_out,penable_out;
wire[2:0] psel,psel_out;

ahb_master_interface AHBM(hclk,hresetn,hr_readyout, hresp,hrdata,
hwrite,hready_in, htrans, hwdata,haddr);

apb_interface APBI( pwrite,penable, psel, paddr,pw_data,
pwrite_out,penable_out,psel_out,paddr_out,pwdata_out, pr_data);

ahb_top_bridge TOP( hclk,hresetn,hwrite,hready_in, htrans, hwdata,haddr,
pr_data, penable,pwrite,hr_readyout,psel, hresp,paddr,pwdata,hrdata);


 always
 #10 hclk = ~hclk;
 
 task reset;
 begin
 @(negedge hclk)                                 
 hresetn = 1'b0;
 @(negedge hclk)
 hresetn = 1'b1;
 end
 endtask
 
 initial begin
 hclk = 1'b0;
 reset;
 AHBM.single_read;
 
 end
 endmodule
