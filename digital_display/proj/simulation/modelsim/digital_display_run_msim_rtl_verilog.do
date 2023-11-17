transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/digital_display/rtl {C:/fpga/workspace/fpga-exps/digital_display/rtl/HC595_driver.v}

vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/digital_display/proj/../testbench {C:/fpga/workspace/fpga-exps/digital_display/proj/../testbench/HC595_driver_tb.v}
vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/digital_display/proj/../rtl {C:/fpga/workspace/fpga-exps/digital_display/proj/../rtl/HC595_driver.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  HC595_driver_tb

add wave *
view structure
view signals
run -all