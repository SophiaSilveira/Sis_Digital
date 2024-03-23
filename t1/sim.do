if {[file isdirectory work]} { vdel -all -lib work }
vlib work
vmap work work

vcom -work work padLock.vhd
vcom -work work tb.vhd

vsim -voptargs=+acc=lprn -t ns work.tb

set StdArithNoWarnings 1
set StdVitalGlitchNoWarnings 1

do wave.do 

run 5000 ns