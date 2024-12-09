#**************************************************************
# Create Clock
#**************************************************************
create_clock -period 20 [get_ports CLK]


#**************************************************************
# I/O Delays
#**************************************************************
set_input_delay -max -clock CLK 3 [all_inputs]
set_input_delay -min -clock CLK 1 [all_inputs]

set_output_delay -max -clock CLK 3 [all_outputs]
set_output_delay -min -clock CLK 3 [all_outputs]

#**************************************************************
# False Path
#**************************************************************
set_false_path -from [get_ports {RSTN}]
