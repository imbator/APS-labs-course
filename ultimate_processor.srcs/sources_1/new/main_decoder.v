`timescale 1ns / 1ps
`include "defines_riscv.v"

module main_decoder(fetched_instr_i, ex_op_a_sel_o, ex_op_b_sel_o, alu_op_o, mem_req_o,
                    mem_we_o, mem_size_o, gpr_we_a_o, wb_src_sel_o, illegal_instr_o,
                    branch_o, jal_o, jalr_o); // ������ ��������

input       [31:0]  fetched_instr_i; // ���������� ��� �������������, ��������� �� ������ ����������
output  reg [1:0]   ex_op_a_sel_o; // ����������� ������ �������������� ��� ������ ������� �������� ���     
output  reg [2:0]   ex_op_b_sel_o; // ����������� ������ �������������� ��� ������ ������� �������� ���       
output  reg [4:0]   alu_op_o; // �������� ���            
output  reg         mem_req_o; // ������ �� ������ � ������ (����� ���������� ������)           
output  reg         mem_we_o; // 	������ ���������� ������ � ������, �write enable� (��� ��������� ���� ���������� ������)          
output  reg [2:0]   mem_size_o; // 	����������� ������ ��� ������ ������� ����� ��� R/W � ������ (����� ���������� ������)         
output  reg         gpr_we_a_o; // 	������ ���������� ������ � ����������� ����          
output  reg         wb_src_sel_o; // ����������� ������ �������������� ��� ������ ������, ������������ � ����������� ����       
output  reg         illegal_instr_o; // ������ � ������������ ���������� (�� ����� �� �������)    
output  reg         branch_o; // ������ �� ���������� ��������� ��������           
output  reg         jal_o; // ������ �� ���������� ������������ �������� jal              
output  reg         jalr_o; // ������ �� ���������� ������������ �������� jalr              


// Decoder code:
always @(*) begin
if (fetched_instr_i[1:0] == 2'b11 || (fetched_instr_i[6:2] == `MISC_MEM_OPCODE || fetched_instr_i[6:2] == `SYSTEM_OPCODE))
begin
case(fetched_instr_i[6:2])
`OP_OPCODE:  // �������������� ��������(R-type) [1]
 begin
    // �������� ��������������� ��� ������ �������
    ex_op_a_sel_o = `OP_A_RS1; // ��� ����� � ������������ �����
    ex_op_b_sel_o = `OP_B_RS2; // � ��� ����
    
    // ������ � ������
    mem_req_o = 0; // ������ �� ������ data memory
    mem_we_o = 0; // ������ �� ������ � ������ data memory
    mem_size_o = 0; // ����� ������� ����� ��� W/R � data memory
    gpr_we_a_o = 1; // ������ � ����������� ���� 
    wb_src_sel_o = `WB_EX_RESULT; // ����� ��������������� � ALU
    
    illegal_instr_o = 0; // ���� ��� ������� ��� ���������
    // ������� �� ��������������
    branch_o = 0;
    jal_o = 0;
    jalr_o = 0;
    
    // � ����������� �� func3/func7 ��������� ����� �������� �� ALU:
    case({fetched_instr_i[14:12], fetched_instr_i[31:25]})
        // basic ariphmetic operations:
        {3'h0, 7'h00}: alu_op_o = `ADD;
        {3'h0, 7'h20}: alu_op_o = `SUB;
        {3'h4, 7'h00}: alu_op_o = `XOR;
        {3'h6, 7'h00}: alu_op_o = `OR;
        {3'h7, 7'h00}: alu_op_o = `AND;
        // shifts:
        {3'h1, 7'h00}: alu_op_o = `SRA;
        {3'h5, 7'h00}: alu_op_o = `SRA;
        {3'h5, 7'h20}: alu_op_o = `SRA;
        // set_less_then:
        {3'h2, 7'h00}: alu_op_o = `SLT;
        {3'h3, 7'h00}: alu_op_o = `SLT;  
        default: illegal_instr_o = 1;  
    endcase
 end
`OP_IMM_OPCODE: // �������������� �������� � ���������� [2]
 begin
    // ������ ������� �� ������������, ������ � SignExtend:
    ex_op_a_sel_o = `OP_A_RS1;
    ex_op_b_sel_o = `OP_B_IMM_I; 
    
    // alu_op_o = 0;
    mem_req_o = 0;
    mem_we_o = 0;
    mem_size_o = 0;
    gpr_we_a_o = 1; // ����� � ����������� ����
    wb_src_sel_o = `WB_EX_RESULT;
    illegal_instr_o = 0;
    
    // ������� �� ��������������
    branch_o = 0;
    jal_o = 0;
    jalr_o = 0;
    
    // �������� ALU
    case(fetched_instr_i[14:12])
        3'h0: alu_op_o = `ADD;
        3'h4: alu_op_o = `XOR;
        3'h6: alu_op_o = `OR;
        3'h7: alu_op_o = `AND;
        3'h1: begin
            case(fetched_instr_i[31:25])
                7'h00: alu_op_o = `SLL;
                default: illegal_instr_o = 1;
            endcase
            end        
        3'h5: begin
            case(fetched_instr_i[31:25])
                7'h00: alu_op_o = `SRL; 
                7'h20: alu_op_o = `SRA;
                default: illegal_instr_o = 1;
            endcase
            end
        3'h2: alu_op_o = `SLT;
        3'h3: alu_op_o = `SLTU;
        default: illegal_instr_o = 1;
    endcase   
 end
 `LUI_OPCODE: // �������� ��������� [3] 
 begin
    // ������ ������� 0, ������ - SignExtend U
    ex_op_a_sel_o = `OP_A_ZERO;
    ex_op_b_sel_o = `OP_B_IMM_U; 
    
    alu_op_o = `ADD;
    
    mem_req_o = 0;
    mem_we_o = 0;
    mem_size_o = 0;
    gpr_we_a_o = 1; 
    wb_src_sel_o = `WB_EX_RESULT;
    
    illegal_instr_o = 0;
    // ������� �� ��������������
    branch_o = 0;
    jal_o = 0;
    jalr_o = 0;
 end
`LOAD_OPCODE: // �������� ����� [4]
 begin
    // ������ � ��������, ������ � SignExtend
    ex_op_a_sel_o = `OP_A_RS1;
    ex_op_b_sel_o = `OP_B_IMM_I; 
    
    alu_op_o = `ADD;
    
    mem_req_o = 1; // ������ �� ������ ������
    mem_we_o = 0; // �� ����� � ������
    illegal_instr_o = 0;
    
    case(fetched_instr_i[14:12])
        3'h0: mem_size_o = `LDST_B;
        3'h1: mem_size_o = `LDST_H;
        3'h2: mem_size_o = `LDST_W;
        3'h4: mem_size_o = `LDST_BU;
        3'h5: mem_size_o = `LDST_HU;
        default: illegal_instr_o = 1;
    endcase   

    gpr_we_a_o = 1; // �����
    wb_src_sel_o = `WB_LSU_DATA ; // ����� � data memory
    

    
    // ������� �� ��������������
    branch_o = 0;
    jal_o = 0;
    jalr_o = 0;
 end
`STORE_OPCODE: // �������� ����� [5]
 begin
    // ������ � ��� �����, ������ � SignExtend
    ex_op_a_sel_o = `OP_A_RS1; 
    ex_op_b_sel_o = `OP_B_IMM_S; 
    
    alu_op_o = `ADD;
    
    illegal_instr_o = 0;
    
    mem_req_o = 1; // ������ �� ������ � ������
    mem_we_o = 1; // �����
    case(fetched_instr_i[14:12])
        3'h0: mem_size_o = `LDST_B;    
        3'h1: mem_size_o = `LDST_H; 
        3'h2: mem_size_o = `LDST_W;
        default: illegal_instr_o = 1;
    endcase

    gpr_we_a_o = 0; // � ����������� ���� �� �����
    wb_src_sel_o = 0; // ����� ������ �� �����, � ���. ���� ������ �� ����
    
    // ������� �� ��������������
    branch_o = 0;
    jal_o = 0;
    jalr_o = 0;
 end
`BRANCH_OPCODE: // ������� ���������� (�������� �������) [6]
 begin
    // ����� � ������������ �����
    ex_op_a_sel_o = `OP_A_RS1;
    ex_op_b_sel_o = `OP_B_RS2; 
    illegal_instr_o = 0;
    
    case(fetched_instr_i[14:12])
        3'h0: alu_op_o = `BEQ;
        3'h1: alu_op_o = `BNE ;
        3'h4: alu_op_o = `BLT;  
        3'h5: alu_op_o = `BGE;
        3'h6: alu_op_o = `BLTU;
        3'h7: alu_op_o = `BGEU;
        default: illegal_instr_o = 1;
    endcase
    
    mem_req_o = 0; // ��������� � ������ �� ���������
    mem_we_o = 0;
    mem_size_o = 0;
    gpr_we_a_o = 0; // � RF ������ �� �����
    wb_src_sel_o = 0; // �� ��������
    
    branch_o = 1; // ������ ��������� ��������
    jal_o = 0; 
    jalr_o = 0;
 end
`JAL_OPCODE: // Jump and link [7] 
 begin
    // PC + 4
    ex_op_a_sel_o = `OP_A_CURR_PC;
    ex_op_b_sel_o = `OP_B_INCR; 
    
    
    alu_op_o = `ADD;
    mem_req_o = 0;
    mem_we_o = 0;
    mem_size_o = 0;
    gpr_we_a_o = 1; // ����� � ����
    
    wb_src_sel_o = `WB_EX_RESULT;
    illegal_instr_o = 0;
    
    branch_o = 0;
    jal_o = 1;
    jalr_o = 0;
 end
`JALR_OPCODE: // Jump and link to register[7]  
 begin
 
    ex_op_a_sel_o = `OP_A_CURR_PC;
    ex_op_b_sel_o = `OP_B_INCR; 
    
    alu_op_o = `ADD;
    mem_req_o = 0;
    mem_we_o = 0;
    mem_size_o = 0;
    gpr_we_a_o = 1;
    wb_src_sel_o = `WB_EX_RESULT;
    
    case(fetched_instr_i[14:12])
    3'h0: begin
        gpr_we_a_o = 1;
        illegal_instr_o = 0;
        jalr_o = 1;
    end
    default: begin
        gpr_we_a_o = 0;
        illegal_instr_o = 1;
        jalr_o = 0;     
    end
    endcase
      
    branch_o = 0;
    jal_o = 0;

 end
`AUIPC_OPCODE: 
 begin
    $display("here");
    ex_op_a_sel_o = `OP_A_CURR_PC;
    ex_op_b_sel_o = `OP_B_IMM_U; 
    
    alu_op_o = `ADD;
    
    mem_req_o = 0;
    mem_we_o = 0;
    mem_size_o = 0;
    gpr_we_a_o = 1;
    wb_src_sel_o = `WB_EX_RESULT;
    
    illegal_instr_o = 0;
    
    branch_o = 0;
    jal_o = 0;
    jalr_o = 0;
 end
`MISC_MEM_OPCODE: 
 begin
    $display("In MISC_MEM");
    ex_op_a_sel_o = 0;
    ex_op_b_sel_o = 0; 
    alu_op_o = 0;
    mem_req_o = 0;
    mem_we_o = 0;
    mem_size_o = 0;
    gpr_we_a_o = 0;
    wb_src_sel_o = 0;
    if (fetched_instr_i[1:0] == 2'b11) illegal_instr_o = 0;
    else illegal_instr_o = 1;
    branch_o = 0;
    jal_o = 0;
    jalr_o = 0;
 end
`SYSTEM_OPCODE:
 begin
    ex_op_a_sel_o = 0;
    ex_op_b_sel_o = 0; 
    alu_op_o = 0;
    mem_req_o = 0;
    mem_we_o = 0;
    mem_size_o = 0;
    gpr_we_a_o = 0;
    wb_src_sel_o = 0;
    if (fetched_instr_i[1:0] == 2'b11) illegal_instr_o = 0;
    else illegal_instr_o = 1;
    branch_o = 0;
    jal_o = 0;
    jalr_o = 0; 
 end  

 default: begin
    // $display("In illegal inst");  
    illegal_instr_o = 1;
    end
endcase

end else begin
    illegal_instr_o = 1;
     ex_op_a_sel_o = 0;
    ex_op_b_sel_o = 0; 
    alu_op_o = 0;
    mem_req_o = 0;
    mem_we_o = 0;
    mem_size_o = 0;
    gpr_we_a_o = 0;
    wb_src_sel_o = 0;
    branch_o = 0;
    jal_o = 0;
    jalr_o = 0; 
end
end

endmodule

