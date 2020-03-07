transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/KevPy/Desktop/ece385Repo/lab5 {C:/Users/KevPy/Desktop/ece385Repo/lab5/HexDriver.sv}
vlog -sv -work work +incdir+C:/Users/KevPy/Desktop/ece385Repo/lab5 {C:/Users/KevPy/Desktop/ece385Repo/lab5/Multiplier.sv}
vlog -sv -work work +incdir+C:/Users/KevPy/Desktop/ece385Repo/lab5 {C:/Users/KevPy/Desktop/ece385Repo/lab5/Registers.sv}
vlog -sv -work work +incdir+C:/Users/KevPy/Desktop/ece385Repo/lab5 {C:/Users/KevPy/Desktop/ece385Repo/lab5/control.sv}
vlog -sv -work work +incdir+C:/Users/KevPy/Desktop/ece385Repo/lab5 {C:/Users/KevPy/Desktop/ece385Repo/lab5/top_level.sv}

vlog -sv -work work +incdir+C:/Users/KevPy/Desktop/ece385Repo/lab5 {C:/Users/KevPy/Desktop/ece385Repo/lab5/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 1000 ns
