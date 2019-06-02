// built on https://github.com/Toms42/fpga-hash-breaker/blob/master/design%20files/md5-core.v

module blake2b(
  input clk,
  input wire [24:0] header_half,
  input init,
  output reg [127:0] hash1,
  output reg [5:0] nonce1 = 0,
  output reg valid
);



reg [639:0] header;
reg [1023:0] chunk;
reg [63:0] h [0:7];
reg [64*16-1:0] v;
reg data_ready;
wire [64*16-1:0] v_con [0:12*8];
wire [64*16-1:0] v_out;
reg [255:0] nonce = 0;
reg [63:0] mem [7:0];
reg [255:0] hash;

f_function f_1 (.clk(clk), .v(v), .v_out(v_out), .chunk(chunk));



initial 
	begin
		 data_ready <= 0;
		 valid <= 0;
	 end

  
always @(posedge clk)
  begin
  
 hash1 = hash;
  	

		if ((init == 1) && (data_ready == 0))
			  begin
			         header = {615'h0, header_half};
			         chunk = (header & 640'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF) | (nonce << 320);
					   //chunk = header;
						h[0] = 64'h6a09e667f2bdc928;
						h[1] = 64'hbb67ae8584caa73b;
						h[2] = 64'h3c6ef372fe94f82b;
						h[3] = 64'ha54ff53a5f1d36f1;
						h[4] = 64'h510e527fade682d1;
						h[5] = 64'h9b05688c2b3e6c1f;
						h[6] = 64'h1f83d9abfb41bd6b;
						h[7] = 64'h5be0cd19137e2179;
					
						v[0*64+:64] = h[0];
						v[1*64+:64] = h[1];
						v[2*64+:64] = h[2];
						v[3*64+:64] = h[3];
						v[4*64+:64] = h[4];
						v[5*64+:64] = h[5];
						v[6*64+:64] = h[6];
						v[7*64+:64] = h[7];
						v[8*64+:64] = 64'h6a09e667f3bcc908;
						v[9*64+:64] = 64'hbb67ae8584caa73b;
						v[10*64+:64] = 64'h3c6ef372fe94f82b;
						v[11*64+:64] = 64'ha54ff53a5f1d36f1;
						 // supposed to be v[12] xored with 0x50 (decimal 80)
						 // but reference implementation xored IV[4] with 0x03 so..
						v[12*64+:64] = 64'h510e527fade682d1 ^ 64'h80;
						
						v[13*64+:64] = 64'h9b05688c2b3e6c1f;
						//v[14*64+:64] = 64'he07c265404be4294;//inverted
						v[14*64+:64] = 64'h1F83D9ABFB41BD6B;   //not inverted            
						v[15*64+:64] = 64'h5be0cd19137e2179;
					
						
						 mem[0] = h[0] ^ v_out[0*64 +: 64] ^ v_out[8*64 +: 64];
						 mem[1] = h[1] ^ v_out[1*64 +: 64] ^ v_out[9*64 +: 64];
						 mem[2] = h[2] ^ v_out[2*64 +: 64] ^ v_out[10*64 +: 64];
						 mem[3] = h[3] ^ v_out[3*64 +: 64] ^ v_out[11*64 +: 64];
						 mem[4] = h[4] ^ v_out[4*64 +: 64] ^ v_out[12*64 +: 64];
						 mem[5] = h[5] ^ v_out[5*64 +: 64] ^ v_out[13*64 +: 64];
						 mem[6] = h[6] ^ v_out[6*64 +: 64] ^ v_out[14*64 +: 64];
						 mem[7] = h[7] ^ v_out[7*64 +: 64] ^ v_out[15*64 +: 64];
						 
						 
						  
				
						 if (|v_out)
							 begin
							 data_ready <= 1;
							 end
						 else;
					end
		       			
				 
				 else if ((data_ready == 1))
				 
				  begin
			  
			        
					 //header = {540'h0, header_half};
					 //chunk = header;


							
							/*for test
							h[0] = 64'h6a09e667f2bdc928;
							h[1] = 64'hbb67ae8584caa73b;
							h[2] = 64'h3c6ef372fe94f82b;
							h[3] = 64'ha54ff53a5f1d36f1;
							h[4] = 64'h510e527fade682d1;
							h[5] = 64'h9b05688c2b3e6c1f;
							h[6] = 64'h1f83d9abfb41bd6b;
							h[7] = 64'h5be0cd19137e2179;
							
							 */
							 
							 
					   chunk = 1024'h0;

							 
						  
						v[0*64+:64] = mem[0];
						v[1*64+:64] = mem[1];
						v[2*64+:64] = mem[2];
						v[3*64+:64] = mem[3];
						v[4*64+:64] = mem[4];
						v[5*64+:64] = mem[5];
						v[6*64+:64] = mem[6];
						v[7*64+:64] = mem[7];
						v[8*64+:64] = 64'h6a09e667f3bcc908;
						v[9*64+:64] = 64'hbb67ae8584caa73b;
						v[10*64+:64] = 64'h3c6ef372fe94f82b;
						v[11*64+:64] = 64'ha54ff53a5f1d36f1;
						v[12*64+:64] = 64'h510e527fade682d1 ^ 64'h8c;
						v[13*64+:64] = 64'h9b05688c2b3e6c1f;
						v[14*64+:64] = 64'he07c265404be4294;
						v[15*64+:64] = 64'h5be0cd19137e2179; 
						 
						 h[0] = mem[0] ^ v_out[0*64 +: 64] ^ v_out[8*64 +: 64];
						 h[1] = mem[1] ^ v_out[1*64 +: 64] ^ v_out[9*64 +: 64];
						 h[2] = mem[2] ^ v_out[2*64 +: 64] ^ v_out[10*64 +: 64];
						 h[3] = mem[3] ^ v_out[3*64 +: 64] ^ v_out[11*64 +: 64];
						 h[4] = mem[4] ^ v_out[4*64 +: 64] ^ v_out[12*64 +: 64];
						 h[5] = mem[5] ^ v_out[5*64 +: 64] ^ v_out[13*64 +: 64];
						 h[6] = mem[6] ^ v_out[6*64 +: 64] ^ v_out[14*64 +: 64];
						 h[7] = mem[7] ^ v_out[7*64 +: 64] ^ v_out[15*64 +: 64];
						 
				     	hash = {
							h[0][0+:8], h[0][8+:8], h[0][16+:8], h[0][24+:8], h[0][32+:8], h[0][40+:8], h[0][48+:8], h[0][56+:8],
							h[1][0+:8], h[1][8+:8], h[1][16+:8], h[1][24+:8], h[1][32+:8], h[1][40+:8], h[1][48+:8], h[1][56+:8],
							h[2][0+:8], h[2][8+:8], h[2][16+:8], h[2][24+:8], h[2][32+:8], h[2][40+:8], h[2][48+:8], h[2][56+:8],
							h[3][0+:8], h[3][8+:8], h[3][16+:8], h[3][24+:8], h[3][32+:8], h[3][40+:8], h[3][48+:8], h[3][56+:8]
						 };	 
							
						// if (|hash)
							//begin
								 							 
						       data_ready <= 1;
								 valid <= 1;
							//end
						  // else;
			      end
				
						
					 /*for(tmp = 1; tmp < 97; tmp = tmp + 1)
						begin
						  $display("%x", v_con[tmp]);
						end*/
 
 end
  
  


		
endmodule
