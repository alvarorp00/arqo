onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /processor_tb/i_processor/Clk
add wave -noupdate /processor_tb/i_processor/Reset
add wave -noupdate /processor_tb/i_processor/PC_reg
add wave -noupdate /processor_tb/i_processor/IDataIn
add wave -noupdate /processor_tb/i_processor/IFID_PC_plus4
add wave -noupdate -color Yellow /processor_tb/i_processor/IFID_Instruction
add wave -noupdate /processor_tb/i_processor/RegsMIPS/A3
add wave -noupdate /processor_tb/i_processor/RegsMIPS/Wd3
add wave -noupdate -color {Cornflower Blue} /processor_tb/i_processor/RegsMIPS/We3
add wave -noupdate -childformat {{/processor_tb/i_processor/RegsMIPS/regs(0) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(1) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(2) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(3) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(4) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(5) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(6) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(7) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(8) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(9) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(10) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(11) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(12) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(13) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(14) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(15) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(16) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(17) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(18) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(19) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(20) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(21) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(22) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(23) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(24) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(25) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(26) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(27) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(28) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(29) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(30) -radix decimal} {/processor_tb/i_processor/RegsMIPS/regs(31) -radix decimal}} -expand -subitemconfig {/processor_tb/i_processor/RegsMIPS/regs(0) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(1) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(2) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(3) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(4) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(5) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(6) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(7) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(8) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(9) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(10) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(11) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(12) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(13) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(14) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(15) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(16) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(17) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(18) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(19) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(20) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(21) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(22) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(23) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(24) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(25) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(26) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(27) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(28) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(29) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(30) {-height 15 -radix decimal} /processor_tb/i_processor/RegsMIPS/regs(31) {-height 15 -radix decimal}} /processor_tb/i_processor/RegsMIPS/regs
add wave -noupdate /processor_tb/i_processor/MEMWB_AluResult
add wave -noupdate /processor_tb/i_processor/MEMWB_RegDestAddr
add wave -noupdate /processor_tb/i_processor/EXMEM_MemToReg
add wave -noupdate -color {Cornflower Blue} /processor_tb/i_processor/MEMWB_RegWrite
add wave -noupdate -color {Cornflower Blue} /processor_tb/i_processor/EXMEM_RegWrite
add wave -noupdate -color {Cornflower Blue} /processor_tb/i_processor/IDEX_RegWrite
add wave -noupdate /processor_tb/i_processor/EXMEM_AluResult
add wave -noupdate /processor_tb/i_processor/EXMEM_RegDestAddr
add wave -noupdate /processor_tb/i_processor/IDEX_RT_Addr
add wave -noupdate /processor_tb/i_processor/IDEX_RD_Addr
add wave -noupdate /processor_tb/i_processor/IDEX_SignExt
add wave -noupdate /processor_tb/i_processor/Ctrl_RegWrite
add wave -noupdate -radix binary /processor_tb/i_processor/UnidadControl/OpCode
add wave -noupdate /processor_tb/i_processor/desition_Jump
add wave -noupdate /processor_tb/i_processor/EXMEM_Zero
add wave -noupdate /processor_tb/i_processor/EXMEM_Branch
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {946 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 311
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {658 ns} {1082 ns}
