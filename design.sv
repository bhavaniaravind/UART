// Code your design here
// Code your design here
module uart_tx(
  input clk,
  input rst,
  input tx_start,
  input [7:0]tx_data,
  output reg tx_out,tx_done
);
  parameter baud_rate=9600;
  parameter clock_frequency=50000000;
  localparam cycles_per_bit=clock_frequency/baud_rate;
  localparam idle=0,start=1,data=2,stop=3;
  reg [1:0]state;
  reg [15:0]bit_count;
  reg [3:0]bit_index;
  reg [7:0]data_reg;
  always @(posedge clk or posedge rst) begin
    if(rst) begin
      state<=idle;
      tx_out<=1'b1;
      tx_done<=1'b0;
    end
  else begin 
    case(state)
      idle: begin
        tx_out<=1'b1;
        tx_done<=1'b0;
        if(tx_start)begin
          state<=start;
          data_reg<=tx_data;
        bit_count<=0;
        end
      end
        start:begin 
          tx_out<=1'b0; 
          if(bit_count==cycles_per_bit-1)begin
            state<=data;
            bit_count<=0;
            bit_index<=0;
          end
          else 
            bit_count<=bit_count+1;        
        end
      data:begin 
        tx_out<=data_reg[bit_index];
        if(bit_count==cycles_per_bit-1) begin
          bit_count<=0;
          if(bit_index==7) 
            state<=stop;
          else
            bit_index<=bit_index+1;
        end
         else
           bit_count<=bit_count+1;
        end
      stop:begin
        tx_out<=1;
        if(bit_count==cycles_per_bit-1) begin 
        state<=idle;
          tx_done<=1'b1;
        end
          else 
          bit_count<=bit_count+1;
      end
    endcase
      end
     
      end
      endmodule
 




// Code your design here
module uart_rx(
input rx_in,clk,rst,
  output reg [7:0]rx_out,
  output reg rx_done
);
  parameter baud_rate=9600;
  parameter clock_freq=50_000_000;
  localparam cycles_per_bit=clock_freq/baud_rate;
  localparam idle=0,start=1,data=2,stop=3;
  reg [1:0] state;
  reg [15:0] bit_count;
  reg [2:0]bit_index;
  always @(posedge clk) begin 
    if(rst) begin 
      state<=idle;
      rx_done<=1'b0;
      bit_index<=0;
      bit_count<=0;
    end
    else begin 
      case(state)
        idle:begin 
          if(!rx_in)
            state<=start;
          bit_count<=0;
          rx_done<=1'b0;
        end
        start:begin 
          if(bit_count==(cycles_per_bit/2)) begin 
            if(!rx_in) begin 
              state<=data;
            bit_count<=0;
            bit_index<=0;
              rx_done<=1'b0;
            end
            else 
              state<=idle;
          end
            else 
              bit_count<=bit_count+1;
        end
        data:begin  
          if(bit_count==cycles_per_bit-1) begin 
          rx_out[bit_index]<=rx_in;
            bit_count<=0;
            if(bit_index==7) 
              state<=stop;
            else 
              bit_index<=bit_index+1;
          end
            else
              bit_count<=bit_count+1;
        end
          stop:begin
            if(bit_count==cycles_per_bit-1) begin
              bit_count<=0;
              state<=idle;
              rx_done<=1'b1;
            end
            else 
              bit_count<=bit_count+1;
          end
        default:state<=idle;
      endcase 
    end
  end
        endmodule




// `include "design.sv"

module uart_top(
    input clk,
    input rst,
    input tx_start,
    input [7:0] tx_data,
    output tx_out,
    output tx_done,
    output [7:0] rx_out,
    output rx_done
);
  wire w1;
    
    // Instantiate UART transmitter
    uart_tx tx_inst(
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
      .tx_out(w1),
        .tx_done(tx_done)
    );
    
    // Instantiate UART receiver
    uart_rx rx_inst(
        .clk(clk),
        .rst(rst),
      .rx_in(w1),
        .rx_out(rx_out),
        .rx_done(rx_done)
    );
    
endmodule







