`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2023 10:24:06 AM
// Design Name: 
// Module Name: apb_controller
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

//FSM STATES
//WRITE OR READ || SINGLE OR BURST TRANSACTIONS

module apb_controller(input hclk,hresetn,hwrite,hwrite_reg1,hwrite_reg2,valid,
input[31:0] haddr,hwdata,hwdata1,hwdata2,haddr1,haddr2,prdata,input[2:0] temp_sel,
output reg penable,pwrite,
output reg hr_readyout,
output reg [2:0] psel,
output reg [2:0] paddr,pwdata);

reg[2:0]present_state,next_state;

parameter idle   =   3'd0,
          wwait  =   3'd1,
          read   =   3'd2,
          read_en = 3'd3,
          write = 3'd4,
          writep = 3'd5,
          write_en = 3'd6,
          write_enp = 3'd7;

  reg penable_temp,pwrite_temp,hr_readyout_temp;
  reg[2:0] psel_temp;
  reg[31:0] paddr_temp, pwdata_temp;
  
       
always@(posedge hclk) begin
  if(!hresetn) 
      present_state<=idle;
  else                                     //PRESENT STATE LOGIC
      present_state<=next_state;
end 

always@(*)
 begin
  case(present_state)
 idle     :       if(valid==1 && hwrite==1)
                        next_state = wwait;
                  else if (valid==1 && hwrite==0)
                        next_state=read;
                   else
                        next_state=idle;
        
 read     :             next_state=read_en;
        
 read_en  :        if(valid==1 && hwrite==1)
                        next_state=wwait;
                   else if(valid==1 && hwrite==0)
                        next_state=read;
                   else
                        next_state=idle;
                        
 write     :       if(valid) 
                         next_state=write_enp ;                   
                    else                                              //NEXT_STATE LOGIC
                         next_state=write_en ;  
                         
 writep    :       next_state=write_enp;                          
                                                                                         
                        
 wwait    :        if(valid)
                        next_state=writep;
                    else
                        next_state=write;
                            
write_en   :       if(valid==1 && hwrite==0)
                             next_state=read;
                    else
                             next_state=idle;                
   
                                                                                                    
 write_enp :       if(valid==1 && hwrite_reg1==1)
                           next_state=writep;
                   else if(valid==0 && hwrite_reg1==1)       
                            next_state=write;
                   else if(hwrite==0)
                            next_state=read;
                            
                   default    :        next_state=idle ;
  endcase  
  end
 
  //TEMPORARY OUTPUT LOGIC//////////////////
  
  always@(*) begin
  case(present_state)
  idle : if(valid==1 && hwrite==0) 
         begin
         paddr_temp = haddr;
         pwrite_temp = hwrite;
         psel_temp = temp_sel;
         penable_temp = 0;
         hr_readyout_temp = 0;
         end
         else if(valid==1 && hwrite==1)
         begin
         psel_temp = 0;
         penable_temp = 0;
         hr_readyout_temp = 1;
         end
         else
         begin
         psel_temp = 0;
         penable_temp = 0;
         hr_readyout_temp = 1;
         end
         
 read :  begin
         penable_temp = 1;
         hr_readyout_temp = 1; 
         end
         
read_en :if(valid==1 && hwrite==0)   
         begin
         paddr_temp = haddr;
         pwrite_temp = hwrite;
         psel_temp = temp_sel;
         penable_temp = 0;
         hr_readyout_temp = 0;   
         end
         else if(valid==1 && hwrite==1)
         begin
         psel_temp = 0;
         penable_temp = 0;
         hr_readyout_temp = 1;
         end
         
 wwait : begin
         paddr_temp = haddr;
         pwdata_temp = hwdata;
         pwrite_temp = hwrite;
         psel_temp = temp_sel;
         penable_temp = 0;
         hr_readyout_temp = 0;           
         end
         
 write : begin
         penable_temp = 1;
         hr_readyout_temp =1;
         end 
         
writep : begin
         penable_temp = 1;
         hr_readyout_temp =1;
         end 
           
write_enp : begin
             paddr_temp = haddr2;
             pwdata_temp = hwdata1;
             pwrite_temp = hwrite_reg1;
             psel_temp = temp_sel;
             penable_temp = 0;
             hr_readyout_temp = 0;           
             end
         
write_en :  if(valid==1 && hwrite==0)   
         begin
         paddr_temp = haddr2;
         pwrite_temp = hwrite;
         psel_temp = temp_sel;
         penable_temp = 0;
         hr_readyout_temp = 0;   
         end
         else if(valid==1 && hwrite==1)
         begin
         psel_temp = 0;
         penable_temp = 0;
         hr_readyout_temp = 1;
         end
         else
         begin
         psel_temp = 0;
         penable_temp = 0;
         hr_readyout_temp = 1;
         end
endcase
end
  
  //////ACTUAL OUTPUT LOGIC/////
  
  always@(posedge hclk) begin
  if(!hresetn) begin
   paddr<=0;
   pwdata<=0;
   pwrite<=0;
   psel<=0;
   penable<=0;
   hr_readyout<=1;
   end
   else begin
   paddr<=paddr_temp;
   pwdata<=pwdata_temp;
   pwrite<=pwrite_temp;
   psel<=psel_temp;
   penable<=penable_temp;
   hr_readyout<=hr_readyout_temp;
  end
  end
  endmodule
  
  
  
  
  
  
  
  
  
  

