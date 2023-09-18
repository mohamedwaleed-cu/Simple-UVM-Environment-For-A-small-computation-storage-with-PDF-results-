puts "*************** Scripting file using TCL to Preload Memory of 16 random values**************"

set fh [open input_file w+ ]



for {set x 0} {$x<16} {incr x} {

set MEMORY($x) [exp int ([exp rand()*100])]
puts $fh $MEMORY($x)
}

close $fh