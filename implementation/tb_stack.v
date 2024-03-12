`timescale 1ns/1ns

module tb_stack;

  // Parameters
  parameter DATA_WIDTH = 16;
  
  //`define assert(condition) if(condition) begin $finish(1); end

  // Inputs
  
  reg rst;
  reg tb_clk;
  reg [15:0] in_val;
  reg [3:0] stackAction;

  // Outputs
  wire [15:0] top;
  wire [15:0] next;

  // Instantiate the stack
  stack uut(
    .clk(tb_clk),
    .rst(rst),
    .in_val(in_val),
    .stackAction(stackAction),
    .top(top),
    .next(next)
  );

  // Clock generator
  initial begin
       tb_clk <= 0;
    forever #5 tb_clk <= ~tb_clk;
    end

  // Reset generator
  initial begin
    rst = 1;
    #5 rst = 0;
  end

  // Test case 1: push data onto the stack
  initial begin
     #10 in_val = 1; //1
     #10 stackAction = 4'b1000; // push operation
     #10 stackAction = 0; // idle
	  #10
     if(top != in_val)$display("Test case: 1 failed");
     if(next != 0)$display("Test case: 2 failed");
	  
	  
	  
	  #10
	  in_val = 3; //push a 3
	  #10
     stackAction = 4'b1000; // push operation
     #10 stackAction = 0; // idle
	  if(top != in_val)$display("Test case: 3 failed, stack: %h", stackAction);
     if(next != 1)$display("Test case: 4 failed");
	  #10
	  
	  //top = 3 and next = 1
	  
	  //pop 3 off then push a 7, then swap
	  in_val = 7;
	  #10  stackAction = 4'b0001;
	  #10  stackAction = 0; // idle
	  #10 stackAction = 4'b1000; // push operation
     #10 stackAction = 0; // idle
	  #10 stackAction = 4'b0111; // swap
	  #10 stackAction = 0; // idle
	  in_val = 0;
	  //top = 1 next = 7
	  //now dup 1
	  #10 stackAction = 4'b0101; //dup
	  #10 stackAction = 0;
	  // 1 1
	  #10  stackAction = 4'b0001;
	  #10 stackAction = 0;
	  // 1 7
	  #10 stackAction = 4'b0010;
	  #10 stackAction = 0;
	  // 7 0
	  
	  
	  $stop;
