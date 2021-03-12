import os
import re
import argparse
import csv

one_clk_sdc = '''
create_clock -period 0 *
'''

two_clk_sdc = '''
create_clock -period 0 *
set_clock_groups -exclusive -group {<clk1>} -group {<clk2>}
'''

clk_names_dict = {
'matmul_8x8_fp16' : ['clk', 'clk_mem'],
'tpu.16x16.int8' : ['clk', 'clk_mem'],
'tpu.32x32.int8' : ['clk', 'clk_mem'],
'conv_layer' : ['clk', 'clk_mem'],
'gemm_8x8_int8' : ['s00_axi_aclk'],
'reduction_layer' : ['clk'],
'eltwise_layer' : ['clk', 'clk_mem'],
'conv_layer_hls' : ['ap_clk'],
'robot_reinforcement_learning' : ['clk'],
'softmax_p4_smem_rfloat16_alut_v512_b2_0_10' : ['clk'],
'mlp_leflow' : ['clk', 'clk2x'],
'spmv' : ['clk'],
'clstm_large' : ['clk'],
'clstm_medium' : ['clk'],
'clstm_small' : ['clk'],
'lstm' : ['clk'],
'LU32PEEng' : ['clk'],
'LU64PEEng' : ['clk'],
'LU8PEEng' : ['clk'],
'arm_core' : ['i_clk'],
'bgm' : ['clock'],
'blob_merge' : ['clk'],
'boundtop' : ['tm3_clk_v0'],
'ch_intrinsics' : ['clk'],
'diffeq1' : ['clk'],
'diffeq2' : ['clk'],
'mcml' : ['clk'],
'mkDelayWorker32B' : ['wciS0_Clk'],
'mkPktMerge' : ['CLK'],
'mkSMAdapter4B' : ['wciS0_Clk'],
'or1200' : ['clk'],
'raygentop' : ['tm3_clk_v0'],
'sha' : ['clk_i'],
'spree' : ['clk'],
'stereovision0' : ['tm3_clk_v0'],
'stereovision1' : ['tm3_clk_v0'],
'stereovision2' : ['tm3_clk_v0'],
'stereovision3' : ['tm3_clk_v0'],
}

# ###############################################################
# Class for generating sdc files
# ###############################################################
class GenSDCFiles():
  #--------------------------
  #constructor
  #--------------------------
  def __init__(self):
    #members
    self.dirs = ''
    self.template = ''
    
    #method calls in order
    self.parse_args()
    self.generate_sdcs()

  #--------------------------
  #parse command line args
  #--------------------------
  def parse_args(self):
    parser = argparse.ArgumentParser()
    parser.add_argument("-d",
                        "--dirs",
                        action='store',
                        default="list_of_experiments.mar_2021",
                        help="File containing list of directories")
    parser.add_argument("-o",
                        "--only_print",
                        action='store_true',
                        help="Only print. Do not execute commands")
    args = parser.parse_args()
    print("Parsed arguments:", vars(args))
    self.dirs = args.dirs
    self.only_print = args.only_print

  #--------------------------
  #generate sdc files 
  #--------------------------
  def generate_sdcs(self):
    for design,clk_list in clk_names_dict.items():
      print("Processing: " + design)
      sdc_filename = "sdc/"+design+".sdc"
     
      print("sdc_filename: ", sdc_filename)

      if not self.only_print:
        try:
          sdc = open(sdc_filename, 'w')
        except:
          print("File " + sdc_filename + " couldn't be created")

        #add to git
        os.system("git add " + sdc_filename)
        
        if len(clk_list) == 1:
          sdc.write(one_clk_sdc)
        elif len(clk_list) == 2:
          temp = two_clk_sdc.replace('<clk1>', clk_list[0]).replace('<clk2>', clk_list[1])
          sdc.write(temp)
        else:
          print("Do not support SDCs with more than 2 clocks yet")
          raise SystemExit(0)

        sdc.close()
        print("Done")

  
# ###############################################################
# main()
# ###############################################################
if __name__ == "__main__":
  GenSDCFiles()


