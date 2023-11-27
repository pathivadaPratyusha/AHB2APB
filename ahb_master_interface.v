`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2023 10:09:41 AM
// Design Name: 
// Module Name: ahb_master_interface
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
           //AHB MASTER INTERFACE WILL INITIATE TRANSACTIONS 
           //GENERATE REQUIRED SIGNALS TO
          // AHB SLAVE INTERFACE
          
          
          
          //SINGLE WRITE
module ahb_master_interface(input hclk,hresetn,hr_readyout,input[31:0] hrdata,
output reg hwrite,hready_in,output reg[1:0] htrans,
output reg[31:0] hwdata,haddr);

reg[2:0] hsize,hburst;   //TRANSFER SIZE AND TYPE OF TRANSACTION
  integer i=0;
  
//SINGLE WRITE

task single_write;
begin
@(posedge hclk) ;                   //always????????
#1;
begin
haddr=32'h8000_0000;
hwrite=1; 
htrans=2'd2;                                                  
hready_in=1;
hburst=0;             // single transaction  
hsize=0;   //32bit data
end

@(posedge hclk) ;                   //always????????
#1;
begin
htrans=2'd0;                       // as it is an singke transaction
hwdata=32'h24;
end
end         
endtask  
                                   

///SINGLE READ////////////////////////////////////////////////////////////
task single_read();
begin
@(posedge hclk) ;                   
#1;
begin
haddr=32'h8000_0000;
htrans=2'b10;
hsize=0;
hwrite=0;                                                  
hready_in=1;
hburst=0;    
end

@(posedge hclk)                    
#1;
begin
htrans=2'd0; 
end
end           
endtask 
//////BURST4/////////

task burst_4_incr_write();
begin
@(posedge hclk) ;                   
#1;
begin
haddr=32'h8000_0000;
htrans=2'b10;
hsize=0;
hwrite=1;                                                  
hready_in=1;
hburst=3'd1;    
end

@(posedge hclk);
#1;
begin
haddr=haddr+1;
hwdata={$random}%250;
htrans=2'd3;
end

for(i=0; i<2; i=i+1)
begin

@(posedge hclk);
#1;
begin
haddr=haddr+1;
hwdata={$random}%250;
htrans=2'd3;
end
@(posedge hclk);
end
@(posedge hclk);
#1;
begin

hwdata={$random}%250;
htrans=2'd0;
end
end
endtask
endmodule




                      
   















