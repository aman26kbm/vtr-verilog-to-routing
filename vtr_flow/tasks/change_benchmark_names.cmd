perl -i -pe "s/20x20_matmul_fp16/fcl16/g" out.sep13.csv
perl -i -pe "s/14x16_matmul_int8/fcl8/g" out.sep13.csv
perl -i -pe "s/tpu_32x32.int8/tpuld/g" out.sep13.csv
perl -i -pe "s/eltwise_add/eltadd/g" out.sep13.csv
perl -i -pe "s/eltwise_mul/eltmul/g" out.sep13.csv