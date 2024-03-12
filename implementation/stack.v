module stack(rst, stackAction, in_val, top, next, clk);
	
	/*
	1000: push x
	0001: pop x
	0010: drop 
	0011: add
	0100: sub
	0101: dup x
	0111: swap x
	*/

	
	input rst,clk;
	integer size = 10; //how many elements in stack
	input [15:0]in_val;
	input [3:0]stackAction;
	output [15:0]top;
	output [15:0]next;
	
	reg[15:0]s[0:9]; //10 registers in stack each reg 16 bit
	
	
	reg[15:0] tmp;
	
	
	
	integer i;
	
	assign top = s[0];
	assign next = s[1];
	
	
	
	/*
	always @(posedge clk or negedge rst)
		if(!rst) s[0] = 0; //rst
		
		else if(stackAction == 0111) begin	//swap
			tmp = s[0];
			s[0] = s[1];
			s[1] = tmp;
		end //end swap
		
		else if(stackAction == 0011) begin //add
			tmp = s[1] + s[0];
			s[1] = tmp;
		end
		
		else if(stackAction == 0100) begin //sub
			tmp = s[1] - s[0];
			s[1] = tmp;
		end
		
		else if(stackAction == 0001 || stackAction == 0010) s[0] = s[1]; //pop/drop
		*/
	
		//loop to cascade stack PUT A FOR STATEMENT AROUND THIS
		
		/*
		always @(posedge clk or negedge rst)
		
			for(i = 1; i < size - 1; i = i+1) begin
			if(stackAction == 4'b1000 || stackAction == 4'b0101) s[i] = s[i-1]; //push/dup cascade
			else if(stackAction == 4'b1000 || stackAction == 4'b0010 || stackAction == 4'b0011 || stackAction == 4'b0100) s[i] = s[i+1]; //pop/drop/add/sub cascade
		end
		*/
		
		//always @(posedge clk or negedge rst)
		
			//if(!rst) s[0] = 0; //rst  DELETE THIS
		
			//if(stackAction == 4'b1000) 
			//s[0] = in_val; //push after cascade
			//s[0] = 16'b0001;
			//else if(stackAction == 4'b0101) s[0] = s[1];//dup
		
		always @(posedge clk or posedge rst) begin
			if(rst)begin
				for(i = 0; i < size - 1; i = i+1)begin
					s[i] <= 0;
				end
			end
			
			else if(stackAction == 4'b0111)begin
				s[0] <= s[1];
				s[1] <= s[0];
			end
			
			else if(stackAction == 4'b1000 || stackAction == 4'b0001 || 4'b0101 || stackAction == 4'b0010)begin //push pop dup
				for(i = 1; i < size - 1; i = i+1) begin
					if(stackAction == 4'b1000 || stackAction == 4'b0101)begin //push dup
						s[i] <= s[i-1]; //push/dup cascade
					end
					if(stackAction == 4'b0001 || stackAction == 4'b0010)begin  //pop  drop
						s[i] <= s[i+1]; //pop/drop/add/sub cascade
					end
				end
		
				if(stackAction == 4'b1000) s[0] <= in_val; //push
				if(stackAction == 4'b0001) s[0] <= s[1]; //pop
				if(stackAction == 4'b0101) s[0] <= s[0]; //dup
				if(stackAction == 4'b0010) s[0] <= s[1]; //drop
			end
		end
		
		
		
		
		
		

	
	/*
	always @(posedge clk or negedge rst)
		if(!rst) s[size - 1] = 0;
		else if(stackAction == 4'b1000) s[size-1] = s[size-2]; //push endcase
		*/
		

endmodule
