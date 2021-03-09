
create_clock -period 0 clk
create_clock -period 0 clk_mem
set_clock_groups -exclusive -group {clk} -group {clk_mem}
