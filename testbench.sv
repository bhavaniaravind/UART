module tb;
  parameter baud_rate=9600;
  parameter bit_period=1000000000/baud_rate;
  reg clk,rst,tx_start,tx_done;
  reg [7:0]tx_data;
  wire tx_out;
  wire [7:0]rx_out;
  wire rx_in,rx_done;
  uart_top uut(.clk(clk),.rst(rst),.tx_start(tx_start),.tx_data(tx_data),.tx_out(tx_out),.tx_done(tx_done),.rx_out(rx_out),.rx_done(rx_done));
  initial begin 
    clk=0;
    forever #10 clk=~clk;
  end
  initial begin
  
    rst=1;
    tx_start=0;
    #30
    rst=0;
    #10
    tx_start=1;
    tx_data=8'h55;
    #20
    tx_start=0;
    wait(rx_done==1);
    #20
    if(tx_data==rx_out) begin
      $display("success:done=%b,tx_data=%h,received data=%h",rx_done,tx_data,rx_out);

    $finish;
    end
    else 
      $display("Transmission failed");
  end
  initial begin
      $dumpfile("uart_rx_tb.vcd");
    $dumpvars(1,tb.rx_out);
    $dumpvars(1,tb.rx_done);
    $dumpvars(1,tb.tx_data);
    

  end
endmodule
  