`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2023 11:30:09 AM
// Design Name: 
// Module Name: apb_interface
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


////////////////PERIPHERAL BLOCK//////////////////////////

module apb_interface(input pwrite,penable,input[2:0] psel,
input[31:0] paddr,pw_data,
output pwrite_out,penable_out,
output[2:0] psel_out,
output[31:0] paddr_out,pwdata_out,output reg [31:0]pr_data);

assign pwrite_out = pwrite;
assign penable_out = penable;
assign psel_out = psel;
assign paddr_out = paddr;
assign pwdata_out = pw_data;

//////prdata

always@(*) begin
if(pwrite==0 && penable==1)
pr_data = {$random}%100; ///0 to 149
else
pr_data = 32'h0;
end
endmodule
