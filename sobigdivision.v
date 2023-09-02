//*****主要代码*****//
module sobigdivision(
	input						systclk,
	input						init,
	input[64:0]				num1,
	input[64:0]				num2,
	input[6:0]				dotplace1,
	input[6:0]				dotplace2,
	input						sign1,
	input						sign2,
	input[6:0]				deltadotplace,
	
	
	output reg[63:0]		result,
	
	output reg[7:0]			dotplaceresult,	
	output reg				signresult,
	output reg				calcover
	

);
//***缓冲区***//
reg[1:0]						stater=2'b0;
reg                       instater=1'b0;
//***计数器***//
reg[7:0]						counter=8'd0;       

//***缓存器***//
reg[129:0]					num2cache=65'd0;
reg[129:0]					resultcache=130'd0;
	always@(posedge systclk)
		begin
			case(stater)
				2'b00:	//等待初始信号
					begin
						if(!init)
							begin
								stater<=stater;
								calcover<=1'b0;
							end
						else
							begin
								stater<=stater+1'b1;
								calcover<=1'b0;
								num2cache[64:0]<=num2;
							end
					end
				2'b01:	//逐位相减
					begin
						if(counter>=8'd0&& counter!=8'h82)  
							begin
								if(num2cache<num1)	//移位
									begin
									case(instater)
									1'b0:
										begin
											resultcache[129-counter]=0;
											num2cache=num2cache<<1;
											instater<=1'b1;
										end
									1'b1:
										begin
											counter<=counter+8'd1;
											instater<=1'b0;
										end
									endcase
									end
								else	//减法
									begin
									case(instater)
									1'b0:
										begin
											resultcache[129-counter]=1;
											num2cache=num2cache-num1;
											num2cache=num2cache<<1;
											instater<=1'b1;
										end 
									1'b1:
										begin
											counter<=counter+8'd1;
											instater<=1'b0;
										end
										endcase
									end
							end
						else													//计算结束
							begin
								stater<=2'b00;
								result<=resultcache[128:65];	//根据输入的除数与被除数判断出，第129位是0
								dotplaceresult<=7'd129-deltadotplace;
								signresult<=(sign1==sign2)?1'b0:1'b1;
								calcover<=1'b1;
							end
					end
				default:
					begin
						stater<=2'b00;
					end
			endcase
		end

endmodule