transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlib issp
vmap issp issp
vlog -vlog01compat -work issp +incdir+C:/fpga/workspace/fpga-exps/HT6221/ip/synthesis {C:/fpga/workspace/fpga-exps/HT6221/ip/synthesis/issp.v}
vlog -vlog01compat -work issp +incdir+C:/fpga/workspace/fpga-exps/HT6221/ip/synthesis/submodules {C:/fpga/workspace/fpga-exps/HT6221/ip/synthesis/submodules/altsource_probe_top.v}
vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/HT6221/rtl {C:/fpga/workspace/fpga-exps/HT6221/rtl/HT6221.v}
vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/HT6221/rtl {C:/fpga/workspace/fpga-exps/HT6221/rtl/HT6221_top.v}

vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/HT6221/proj/../testbench {C:/fpga/workspace/fpga-exps/HT6221/proj/../testbench/HT6221_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -L issp -voptargs="+acc"  HT6221_tb

add wave *
view structure
view signals
run -all
