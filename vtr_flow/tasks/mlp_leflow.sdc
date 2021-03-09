
create_clock -period 0 clk
create_clock -period 0 clk2x
set_clock_groups -exclusive -group {clk} -group {clk2x}
