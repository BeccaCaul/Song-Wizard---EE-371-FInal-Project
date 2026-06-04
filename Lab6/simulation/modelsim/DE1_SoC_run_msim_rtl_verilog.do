transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+//udrive.uw.edu/mflessa/EE\ 371/lab1b {//udrive.uw.edu/mflessa/EE 371/lab1b/car_counter.sv}

