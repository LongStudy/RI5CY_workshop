import riscv_defines::*;

module riscv_str_ops
	(
	  input logic                    clk,
	  input logic                    enable_i,
	  input logic [STR_OP_WIDTH-1:0] operator_i,
   	  input logic [31:0]             operand_i,
	  output logic [31:0]            result_o,
	  input logic                    rst_n,
	  output logic [31:0]            ready_o,
	  input logic                    ex_ready_i

	);
	logic [3:0][7:0]    upper_reg;
	logic [31:0] 		result;
	logic [7:0] 		char;
	enum logic [2:0] {IDLE, STEP0, STEP1, STEP2, FINISH} leet_CS, leet_NS;

	logic leet_active;
	logic leet_ready;
	logic [31:0] leet_intermediate;


	  always_comb begin
	    leet_ready = 1'b0;
	    leet_NS = leet_CS;
	    leet_active = 1'b1;
		
		// Mux results
		if (enable_i) begin
		// Dummy value for unimplemented instructions
		result_o = 32'hDEADBEEF;

		if (operator_i == STR_OP_UPPER)
			result_o = result;
		if (operator_i == STR_OP_LEET && leet_CS == FINISH)
			result_o = leet_intermediate;
		end


	    case (leet_CS)
	      IDLE: begin
	        leet_active = 1'b0;
	        leet_ready = 1'b1;
	        if (operator_i == STR_OP_LEET && enable_i) begin
	          	leet_ready = 1'b0;
	          	leet_NS = STEP0;
          		leet_intermediate <= operand_i;
      		end
	      end
	      STEP0: begin
			char = leet_intermediate[7:0];
        	if ((char == 69 || char == 101))
          	char = 51;
        	leet_intermediate[7:0] <= char;
			char = leet_intermediate[15:8];
        	if ((char == 69 || char == 101))
          	char = 51;
        	leet_intermediate[15:8] <= char;
			char = leet_intermediate[23:16];
        	if ((char == 69 || char == 101))
          	char = 51;
        	leet_intermediate[23:16] <= char;
			char = leet_intermediate[31:24];
        	if ((char == 69 || char == 101))
          	char = 51;
        	leet_intermediate[31:24] <= char;
	        leet_NS = STEP1;
	      end
	      STEP1: begin
			char = leet_intermediate[7:0];
        	if ((char == 83 || char == 115))
          	char = 53;
        	leet_intermediate[7:0] <= char;
			char = leet_intermediate[15:8];
        	if ((char == 83 || char == 115))
          	char = 53;
        	leet_intermediate[15:8] <= char;
			char = leet_intermediate[23:16];
        	if ((char == 83 || char == 115))
          	char = 53;
        	leet_intermediate[23:16] <= char;
			char = leet_intermediate[31:24];
        	if ((char == 83 || char == 115))
          	char = 53;
        	leet_intermediate[31:24] <= char;
	        leet_NS = STEP2;
	      end
	      STEP2: begin
			char = leet_intermediate[7:0];
        	if ((char == 76 || char == 108))
          	char = 49;
        	leet_intermediate[7:0] <= char;
			char = leet_intermediate[15:8];
        	if ((char == 76 || char == 108))
          	char = 49;
        	leet_intermediate[15:8] <= char;
			char = leet_intermediate[23:16];
        	if ((char == 76 || char == 108))
          	char = 49;
        	leet_intermediate[23:16] <= char;
			char = leet_intermediate[31:24];
        	if ((char == 76 || char == 108))
          	char = 49;
        	leet_intermediate[31:24] <= char;
	        leet_NS = FINISH;
	      end
	      FINISH: begin
	        leet_ready = 1'b1;
	        if (ex_ready_i)
	          leet_NS = IDLE;
	      end
	    endcase
	  end

	always_ff @(posedge clk, negedge rst_n)
	begin
		if (~rst_n)
		leet_CS <= IDLE;
		else
		leet_CS <= leet_NS;
	end

	assign ready_o = leet_ready;


	always_ff @(posedge clk)
	begin
	if (enable_i) begin
		case (operator_i)
		STR_OP_UPPER:
		begin
			$display("%t: Exec Upper instruction", $time);
			result = upper_reg;
		end
		
		STR_OP_LOWER:
			$display("%t: Exec Lower instruction", $time);
		STR_OP_LEET:
			$display("%t: Exec Leet speak instruction", $time);
		STR_OP_ROT13:
			$display("%t: Exec Rot13 instruction", $time);
		endcase
	end
	end

    always_comb begin
        //result_o = enable_i ? operand_i : 32'b0;
		upper_reg = enable_i ? operand_i: 32'b0;
		if (enable_i) begin
			for (int i = 0; i < 4; i++) begin
				if ((upper_reg[i] >= 97) && (upper_reg[i] <= 122))
				begin
					upper_reg[i] = upper_reg[i] - 32;
				end
			end
		end
    end
	



endmodule