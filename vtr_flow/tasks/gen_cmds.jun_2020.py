import os
import re
import argparse
import csv
import random

# ###############################################################
# Class for generating command file
# ###############################################################
class GenCommands():
  #--------------------------
  #constructor
  #--------------------------
  def __init__(self):
    #members
    self.dirs = ''
    self.reruns = 3
    self.outfile = ''
    self.cmd_template = '../scripts/run_vtr_task.pl <dir> -s "--const_gen_inference comb --seed <seed> --timing_report_npaths 1000 --timing_report_detail aggregated"'
    self.num_proc = 5
    
    #method calls in order
    self.parse_args()
    self.generate_cmds()

  #--------------------------
  #parse command line args
  #--------------------------
  def parse_args(self):
    parser = argparse.ArgumentParser()
    parser.add_argument("-d",
                        "--dirs",
                        action='store',
                        default="list_of_experiments.jun_2020",
                        help="File containing list of directories")
    parser.add_argument("-r",
                        "--reruns",
                        action='store',
                        default=3,
                        help="Number of times to rerun a test")
    parser.add_argument("-o",
                        "--outfile",
                        default="cmds.jun_2020",
                        action='store',
                        help="Name of the output file containing commands")
    args = parser.parse_args()
    print("Parsed arguments:", vars(args))
    self.dirs = args.dirs
    self.reruns = args.reruns
    self.outfile = args.outfile

  #--------------------------
  #generate commands
  #--------------------------
  def generate_cmds(self):
    outfile = open(self.outfile, 'w')

    print("Generating file: {}...".format(self.outfile))
    count = 0
    for run in range(self.reruns): 
      dirs = open(self.dirs, 'r')
      for line in dirs:
        dirname = line.rstrip()
        #if the line is commented out, ignore it
        check_for_comment = re.search(r'^#', dirname)
        if check_for_comment is not None:
          continue

        count += 1
        cmd = re.sub(r'<dir>', dirname, self.cmd_template)
        cmd = re.sub(r'<seed>', str(random.randint(1,10000)), cmd)

        # We want only num_proc jobs to be launched at a time
        if count % self.num_proc != 0:
          cmd = cmd + " &"

        outfile.write(cmd)
        outfile.write("\n")
      dirs.close()

    outfile.close()
    print("..Done")


  
# ###############################################################
# main()
# ###############################################################
if __name__ == "__main__":
  GenCommands()

