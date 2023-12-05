transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/uart2eeprom/rtl {C:/fpga/workspace/fpga-exps/uart2eeprom/rtl/i2c_control.v}

vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/uart2eeprom/proj/../testbench {C:/fpga/workspace/fpga-exps/uart2eeprom/proj/../testbench/i2c_control_tb.v}
vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/uart2eeprom/proj/../rtl {C:/fpga/workspace/fpga-exps/uart2eeprom/proj/../rtl/24LC04B.v}
vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/uart2eeprom/proj/../rtl {C:/fpga/workspace/fpga-exps/uart2eeprom/proj/../rtl/i2c_control.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  i2c_control_tb

add wave *
view structure
view signals
run -all
