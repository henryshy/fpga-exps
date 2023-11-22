transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/uart_dparm/rtl {C:/fpga/workspace/fpga-exps/uart_dparm/rtl/key_filter.v}
vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/uart_dparm/rtl {C:/fpga/workspace/fpga-exps/uart_dparm/rtl/uart_sender.v}
vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/uart_dparm/rtl {C:/fpga/workspace/fpga-exps/uart_dparm/rtl/uart_receiver.v}
vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/uart_dparm/rtl {C:/fpga/workspace/fpga-exps/uart_dparm/rtl/control.v}
vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/uart_dparm/ip {C:/fpga/workspace/fpga-exps/uart_dparm/ip/dparm.v}
vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/uart_dparm/rtl {C:/fpga/workspace/fpga-exps/uart_dparm/rtl/uart_dparm.v}

vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/uart_dparm/proj/../testbench {C:/fpga/workspace/fpga-exps/uart_dparm/proj/../testbench/uart_dparm_tb.v}
vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/uart_dparm/proj/../testbench {C:/fpga/workspace/fpga-exps/uart_dparm/proj/../testbench/key_model.v}
vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/uart_dparm/proj/../rtl {C:/fpga/workspace/fpga-exps/uart_dparm/proj/../rtl/uart_dparm.v}
vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/uart_dparm/proj/../rtl {C:/fpga/workspace/fpga-exps/uart_dparm/proj/../rtl/uart_sender.v}
vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/uart_dparm/proj/../rtl {C:/fpga/workspace/fpga-exps/uart_dparm/proj/../rtl/key_filter.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  uart_dparm_tb

add wave *
view structure
view signals
run -all
