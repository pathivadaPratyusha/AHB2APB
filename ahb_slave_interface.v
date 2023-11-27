`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2023 01:09:13 PM
// Design Name: 
// Module Name: ahb_slave_interface
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




//ahb slave interface need to satisfy 3 rules
//2 stage pipeline logic
//tempselx
//valid

module ahb_slave_interface(input hclk,hresetn,hwrite,hready_in,
input[1:0]htrans,input[31:0]hwdata,input[31:0]haddr,pr_data,
output reg hwrite_reg1, hwrite_reg2,valid,output reg[31:0] hwdata1,hwdata2,haddr1,haddr2,
output[31:0]hr_data,output reg [2:0]temp_sel);

//pipeline logic for haddr
always@(posedge hclk)
begin
   if(hresetn)
     begin
     haddr1<=0;
     haddr2<=0;
     end
   else
   begin
      haddr1<=haddr;
      haddr2<=haddr1;
   end
 end
 
 //pipeline logic for hwdata
 always@(posedge hclk)
begin
   if(hresetn)
     begin
     hwdata1<=0;
     hwdata2<=0;
     end
   else
   begin
      hwdata1<=hwdata;
      hwdata2<=hwdata1;
   end
end
 
  //pipeline logic for hwrite
  always@(posedge hclk)
begin
   if(hresetn)
     begin
     hwrite_reg1<=0;
     hwrite_reg2<=0;
     end
   else
   begin
      hwrite_reg1<=hwrite;
      hwrite_reg2<=hwrite_reg1;
   end
end
//valid signal
always@(*) begin
 valid=1'b0;
 if(hready_in==1 && htrans==2'b10 || htrans==2'b11 && haddr>=32'h0000_0000 && haddr<32'h8c00_0000)
 valid=1'b1;
 else
 valid=1'b0;
 end
 //temp selx
always@(*) begin
temp_sel=3'b0000;
if(haddr >= 32'h0000_0000 && haddr < 32'h8400_0000)
temp_sel=3'b001;

else if(haddr >= 32'h4000_0000 && haddr < 32'h8800_0000)
temp_sel=3'b010;
end
assign hr_data=pr_data;
endmodule














