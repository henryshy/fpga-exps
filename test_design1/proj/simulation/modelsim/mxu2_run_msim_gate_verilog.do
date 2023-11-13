transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {mxu2_8_1200mv_85c_slow.vo}

vlog -vlog01compat -work work +incdir+C:/fpga/workspace/test_design1/proj/../testbench {C:/fpga/workspace/test_design1/proj/../testbench/mxu2_tb.v}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc"  mxu2_tb

add wave *
view structure
view signals
run -all
