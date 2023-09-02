`timescale 1ns/1ns

module sobigdivision_tb();

parameter  T = 20; 
 
reg systclk;//时钟信号
reg[64:0] 							num1;
reg[64:0] 							num2;
reg 									sign1;
reg 									sign2;
reg [6:0]								dotplace1;
reg [6:0]								dotplace2;
reg[6:0]								deltadotplace;
reg 									init;//复位信号


wire[63:0]						result;
wire								signresult;
wire[6:0]						dotplaceresult;
wire							calcover;

initial begin
	systclk<=1'b0;
	init <= 1'b0;
	num1<=65'b0_0000_0000_0001_1010_0010_0110_1111_0000_0101_1110_1010_0001_0100_0100_0110_0110;	//除数
	num2<=65'b0_0000_0000_0001_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;	//被除数
	dotplace1<=7'd53;	//小数点位置
	dotplace2<=7'd53;
	if(dotplace1>dotplace2)
		begin
			deltadotplace<=dotplace1-dotplace2;
		end
	else
		begin
			deltadotplace<=dotplace2-dotplace1;
		end
 	sign1<=1'b0;	//正负性
 	sign2<=1'b0;

	#T init=1'b1;
end
	always #(T/2) systclk = ~systclk;
	
sobigdivision u0_sobigdivision(

	.num1										(num1),
	.num2										(num2),
	.sign1                                      					(sign1),
	.sign2                                      					(sign2),
	.dotplace1                              					(dotplace1), 
	.dotplace2								(dotplace2),
	.systclk 								(systclk),
	.init 									(init),
	.result									(result),
	.signresult								(signresult),
	.dotplaceresult								(dotplaceresult),
	.deltadotplace								(deltadotplace),
	.calcover								(calcover)
	
);
	
endmodule

 