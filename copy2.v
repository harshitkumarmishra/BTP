module fadd(a,b,ci,s,co);
	input  a,b,ci;
	output  s,co;
	assign s=a^b^ci;
	assign co=(a&b)|(b&ci)|(ci&a);
endmodule
module hadd(a,b,s,co);
	input  a,b;
	output  s,co;
	assign s=a^b;
	assign co=(a&b);
endmodule
module fand(a,b,c);
	input a,b;
	output c;
	assign c=a&b;
endmodule


module project(a,b,s,s1,c1,s2,c2,s3,c3,s4,c4,s5,c5,s6,c6,s7,c7);
	input [7:0]a,b;
	output [15:0]s;
	output [10:0]s6,c6;
	output [9:0]s5,c5,s7,c7;
	output [7:0]s1,c1,s2,c2,s3,c3,s4,c4;
	reg [63:0]A;
	
	
	wire [7:0]S1,C1,S2,C2,S3,C3,S4,C4;
	wire [9:0]S5,C5,S7,C7;
	wire [10:0]S6,C6;
	integer i,j;
	always @* begin
		for( i=0;i<8;i=i+1)
			begin
				for( j=0;j<8;j=j+1)
					begin
						A[8*i+j]<=(a[i]&b[j]);
					end
			end
		
	end
	//first row
	assign s[0]=A[0];
	hadd ha1(A[1],A[8],S1[0],C1[0]);	
	assign s[1]=S1[0];
	genvar l;
	generate for (l= 0; l < 6; l= l + 1) begin
		fadd fa1[5:0](A[l+2],A[l+9],A[l+16],S1[l+1],C1[l+1]);
	end endgenerate
	hadd ha2(A[15],A[23],S1[7],C1[7]);
	//second row
	hadd ha3(A[25],A[32],S2[0],C2[0]);	
	genvar m;
	generate for (m= 0; m< 6; m= m + 1) begin
		fadd fa2[5:0](A[m+26],A[m+33],A[m+40],S2[m+1],C2[m+1]);
	end endgenerate	
	hadd ha4(A[39],A[46],S2[7],C2[7]);
	//third row	
	hadd ha5(S1[1],C1[0],S3[0],C3[0]);
	assign s[2]=S3[0];
	
	fadd fa3(S1[2],C1[1],A[24],S3[1],C3[1]);
	genvar l1;
	generate for (l1= 0; l1 < 5; l1= l1 + 1) begin
		fadd fa4[5:0](S1[3+l1],S2[l1],C1[2+l1],S3[l1+2],C3[l1+2]);
	end endgenerate	
	fadd fa5(A[23],S2[5],C1[7],S3[7],C3[7]);
	
	//fourth row
	hadd ha6(C2[1],A[48],S4[0],C4[0]);
	//fadd fa6(C[2],A[49],A[56],C4[1]);
	//fadd fa7(C[3],A[50],A[57],C4[2]);
	//fadd fa8(C[4],A[51],A[58],C4[3]);
	//fadd fa6(C[2],A[49],A[56],C4[1]);
	genvar l2;
	generate for (l2= 0; l2 < 6; l2= l2+ 1) begin
		fadd fa6[5:0](C2[l2+2],A[49+l2],A[56+l2],S4[1+l2],C4[1+l2]);
	end endgenerate			
	hadd ha7(A[55],A[62],S4[7],C4[7]);
	//fifth row
	hadd ha8(S3[1],C3[0],S5[0],C5[0]);
	assign s[3]=S5[0];
	hadd ha9(S3[2],C3[1],S5[1],C5[1]);
	fadd fa7(S3[3],C3[2],C2[0],S5[2],C5[2]);
	genvar l3;
	generate for (l3= 0; l3 < 4; l3= l3+ 1) begin	
		fadd fa8[3:0](S3[l3+4],S4[l3],C3[l3+3],S5[l3+3],C5[3+l3]);
	end 
	endgenerate			
	fadd fa9(S4[4],C3[7],S2[6],S5[7],C5[7]);
	hadd ha10(S4[5],S2[7],S5[8],C5[8]);
	hadd ha11(S4[6],A[47],S5[9],C5[9]);
	//sixth row
	hadd ha12(S5[1],C5[0],S6[0],C6[0]);
	assign s[4]=S6[0];
	hadd ha13(S5[2],C5[1],S6[1],C6[1]);
	hadd ha14(S5[3],C5[2],S6[2],C6[2]);
	genvar l4;
	generate for (l4= 0; l4 < 3; l4= l4+ 1) begin	
		fadd fa10[2:0](S5[l4+4],C5[3+l4],C4[l4],S6[l4+3],C6[3+l4]);
	end 
	endgenerate
	fadd fa11(S5[7],C5[6],C4[4], S6[6],C6[6]);
	fadd fa12(S5[8],C5[7],C4[5], S6[7],C6[7]);
	fadd fa13(S5[9],C5[8],C4[6], S6[8],C6[8]);
	fadd fa14(S4[7],C4[6],C5[9],S6[9],C6[9]);
	hadd ha15(A[63],C4[7],S6[10],C6[10]);
	//seventh row
	hadd ha16(S6[1],C6[0],S7[0],C7[0]);
	assign s[5]=S7[0];
	genvar l5;
	generate for (l5= 0; l5 < 9; l5= l5+ 1) begin	
		fadd fa15[8:0](S6[2+l5],C6[1+l5],C7[l5],S7[1+l5],C7[1+l5]);
		assign s[6+l5]=S7[l5+1];
	end 
	endgenerate
	assign s[15]=C6[10];
	
	assign s1=S1;
	assign c1=C1;
	assign s2=S2;
	assign c2=C2;
	assign s3=S3;
	assign c3=C3;
	assign s4=S4;
	assign c4=C4;
	assign s5=S5;
	assign c5=C5;
	assign s6=S6;
	assign c6=C6;
	assign s7=S7;
	assign c7=C7;
			 
			 
			 
			 
endmodule
		  
module testbench();
	reg[7:0]a,b;
	wire [15:0]s;
	wire [10:0]s6,c6;
	wire [9:0]s5,c5,s7,c7;
	wire [7:0]s1,c1,s2,c2,s3,c3,s4,c4;
	
	project a1(a,b,s,s1,c1,s2,c2,s3,c3,s4,c4,s5,c5,s6,c6,s7,c7);
	initial begin
		$monitor("s6=%d,c6=%d,x=%d",a,b,s);
		//b=8'b11111111;a=8'b11111111;
		a=-110;b=8'd23;
		
		$finish;
	end
endmodule
	
	


