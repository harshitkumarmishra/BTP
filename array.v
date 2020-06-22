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

module pack(a,m,si,ci,so,co);
	input a,m,si,ci;
	output so,co;
	wire c=(a&m);
	assign so=c^si^ci;
	assign co=(c&si)|(si&ci)|(ci&c);
endmodule

module project2(a,m,s);
	input [7:0]a,m;
	output [15:0]s;
	reg A[7:0][7:0];
	wire [7:0]S1,C1,S2,C2,S3,C3,S4,C4,S5,C5,S6,C6,S7,C7,S8,C8;
	integer i,j;
	wire k=1'b0;
	always @* begin
		for( i=0;i<8;i=i+1)
			begin
				for( j=0;j<8;j=j+1)
					begin
						A[i][j]<=(a[i]&m[j]);
					end
			end
		
	end
	//first row 
	pack p1(a[0],m[0],k,k,S1[0],C1[0]);
	assign s[0]=S1[0];//first
	genvar l;
	generate for (l= 0; l < 7; l= l + 1) begin
		pack p2[6:0](a[l+1],m[0],k,C1[l],S1[l+1],C1[l+1]);
	end endgenerate
	
	//second row
	pack p3(a[0],m[1],S1[1],k,S2[0],C2[0]);
	assign s[1]=S2[0];//second
	genvar l2;
	generate for (l2= 0; l2 < 6; l2= l2 + 1) begin
		pack p4[5:0](a[l2+1],m[1],S1[l2+2],C2[l2],S2[l2+1],C2[l2+1]);
	end endgenerate
	pack q4(a[7],m[1],C1[7],C2[6],S2[7],C2[7]);
	
	///third row
	pack p5(a[0],m[2],S2[1],k,S3[0],C3[0]);
	assign s[2]=S3[0];//third
	genvar l3;
	generate for (l3= 0; l3 < 6; l3= l3 + 1) begin
		pack p6[5:0](a[l3+1],m[2],S2[l3+2],C3[l3],S3[l3+1],C3[l3+1]);
	end endgenerate
	pack q6(a[7],m[2],C2[7],C3[6],S3[7],C3[7]);
	
	//fourth row
	pack p7(a[0],m[3],S3[1],k,S4[0],C4[0]);
	assign s[3]=S4[0];//fourth
	genvar l4;
	generate for (l4= 0; l4 < 6; l4= l4 + 1) begin
		pack p8[5:0](a[l4+1],m[3],S3[l4+2],C4[l4],S4[l4+1],C4[l4+1]);
	end endgenerate
	pack q8(a[7],m[3],C3[7],C4[6],S4[7],C4[7]);
	
	//fifth row
	pack p9(a[0],m[4],S4[1],k,S5[0],C5[0]);
	assign s[4]=S5[0];//fifth
	genvar l5;
	generate for (l5= 0; l5 < 6; l5= l5 + 1) begin
		pack p10[5:0](a[l5+1],m[4],S4[l5+2],C5[l5],S5[l5+1],C5[l5+1]);
	end endgenerate
	pack q10(a[7],m[4],C4[7],C5[6],S5[7],C5[7]);
	
	//sixth row
	pack p11(a[0],m[5],S5[1],k,S6[0],C6[0]);
	assign s[5]=S6[0];//sixth
	genvar l8;
	generate for (l8= 0; l8< 6; l8= l8 + 1) begin
		pack p12[5:0](a[l8+1],m[5],S5[l8+2],C6[l8],S6[l8+1],C6[l8+1]);
	end endgenerate
	pack q12(a[7],m[5],C5[7],C6[6],S6[7],C6[7]);
	
	//seventh
	pack p13(a[0],m[6],S6[1],k,S7[0],C7[0]);
	assign s[6]=S7[0];//seventh
	genvar l6;
	generate for (l6= 0; l6 < 6; l6= l6 + 1) begin
		pack p14[5:0](a[l6+1],m[6],S6[l6+2],C7[l6],S7[l6+1],C7[l6+1]);
	end endgenerate
	pack q14(a[7],m[6],C6[7],C7[6],S7[7],C7[7]);
	
	//eighth row
	pack p15(a[0],m[7],S7[1],k,S8[0],C8[0]);
	assign s[7]=S8[0];//eighth
	genvar l7;
	generate for (l7= 0; l7 < 6; l7= l7 + 1) begin
		pack p16[5:0](a[l7+1],m[7],S7[l7+2],C8[l7],S8[l7+1],C8[l7+1]);
		assign s[8+l7]=S8[l7+1];
	end endgenerate
	pack q16(a[7],m[7],C7[7],C8[6],S8[7],C8[7]);
	assign s[14]=S8[7];
	assign s[15]=C8[7];	
	
endmodule



module testbench();
	reg[7:0]a,b;
	wire [15:0]s;
	integer t;
	reg clk;
	
	project2 a1(a,b,s);
	initial begin
		t=1000;
		clk=1'b0;
		$dumpfile("multi.vcd");
		$dumpvars(0,testbench);
		a=$urandom%255;        b=$urandom%255;
		$monitor($time," a=%d,b=%d,s=%d",a,b,s);
		
		
	end
	
	always #5 clk=~clk;
	initial repeat(t/20) #20 a[0]=~a[0];
	initial repeat(t/25) #25 a[1]=~a[1];
	initial repeat(t/35) #35 a[2]=~a[2];
	initial repeat(t/30) #30 a[3]=~a[3];
	initial repeat(t/45) #45 a[4]=~a[4];
	initial repeat(t/15) #15 a[5]=~a[5];
	initial repeat(t/25) #25 a[6]=~a[6];
	initial repeat(t/35) #35 a[7]=~a[7];
	
	initial repeat(t/20) #20 b[0]=~b[0];
	initial repeat(t/25) #25 b[1]=~b[1];
	initial repeat(t/35) #35 b[2]=~b[2];
	initial repeat(t/30) #30 b[3]=~b[3];
	initial repeat(t/45) #45 b[4]=~b[4];
	initial repeat(t/15) #15 b[5]=~b[5];
	initial repeat(t/25) #25 b[6]=~b[6];
	initial repeat(t/35) #35 b[7]=~b[7];
	initial begin #1100 $finish;
	end
endmodule
	
	
	