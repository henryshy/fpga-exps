transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/key_filter/rtl {C:/fpga/workspace/fpga-exps/key_filter/rtl/key_filter.v}

vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/key_filter/proj/../testbench {C:/fpga/workspace/fpga-exps/key_filter/proj/../testbench/key_filter_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  key_filter_tb

add wave *
view structure
view signals
run -all
