`timescale 1ns / 10ps
// ������ ��������� ����� ����������
// �������� �������������: clk
module main();
// ���� �����
reg clk;
wire [31:0] OUTPUT_CHECK;
// ���� IN / RESET
reg IN;
reg RST;
// ERROR DETECTION WIRES
// RISC_V:
wire [7:0] PC; // �������� ��������
wire [31:0] CURRENT_INSTRUCTION; // ������� ����������
wire [31:0] RD1; // RF Output -> ALU Input
wire [31:0] RD2; // RF Output -> ALU Input


initial
begin
clk = 0;
IN = 31'b0;
RST = 0;
end
  
always #10 clk = ~clk; // ��������� ������ �����

// ������ ����������
risc_v processor(.IN(IN), 
                 .CLK(clk),
                 .RST(RST), 
                 .OUT(OUTPUT_CHECK));

// ������������� �������� ��� ��������:
assign PC = processor.PC;
assign CURRENT_INSTRUCTION = processor.IM_Output;
assign RD1 = processor.RD1;
assign RD2 = processor.RD2;
// C = processor.C;
//assign B = processor.B;
//assign TEST = processor.TEST;



// �������� ������ ����������
initial begin
    check_instruction();
    $stop; 
end


task check_instruction();
begin
    #1500;    
end
endtask

endmodule