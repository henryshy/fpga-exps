transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/OV5640/rtl {C:/fpga/workspace/fpga-exps/OV5640/rtl/TFT_CTRL.v}
vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/OV5640/rtl {C:/fpga/workspace/fpga-exps/OV5640/rtl/ov5640_init_table_rgb.v}
vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/OV5640/rtl {C:/fpga/workspace/fpga-exps/OV5640/rtl/i2c_control.v}
vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/OV5640/rtl {C:/fpga/workspace/fpga-exps/OV5640/rtl/i2c_bit_shift.v}
vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/OV5640/rtl {C:/fpga/workspace/fpga-exps/OV5640/rtl/camera_init.v}
vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/OV5640/rtl {C:/fpga/workspace/fpga-exps/OV5640/rtl/OV5640.v}
vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/OV5640/rtl {C:/fpga/workspace/fpga-exps/OV5640/rtl/DVP_capture.v}
vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/OV5640/ip/dpram {C:/fpga/workspace/fpga-exps/OV5640/ip/dpram/dpram.v}
vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/OV5640/ip/pll {C:/fpga/workspace/fpga-exps/OV5640/ip/pll/pll.v}
vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/OV5640/proj/db {C:/fpga/workspace/fpga-exps/OV5640/proj/db/pll_altpll.v}

vlog -vlog01compat -work work +incdir+C:/fpga/workspace/fpga-exps/OV5640/proj/../testbench {C:/fpga/workspace/fpga-exps/OV5640/proj/../testbench/OV5640_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  OV5640_tb

add wave *
view structure
view signals
run -all
