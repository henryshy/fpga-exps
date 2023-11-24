transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/fifo/ip {C:/fpga/workspace/fpga-exps/fifo/ip/fifo.v}

vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/fifo/proj/../testbench {C:/fpga/workspace/fpga-exps/fifo/proj/../testbench/mydcfifo_tb.v}
vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/fifo/proj/../ip {C:/fpga/workspace/fpga-exps/fifo/proj/../ip/mydcfifo.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  mydcfifo_tb

add wave *
view structure
view signals
run -all