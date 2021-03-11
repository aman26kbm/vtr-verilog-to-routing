import os
import re
import argparse
import csv
import random

# ###############################################################
# Class for generating task list
# ###############################################################
class GenTaskList():
  #--------------------------
  #constructor
  #--------------------------
  def __init__(self):
    #members
    self.dirs = ''
    self.outfile = ''
    
    #method calls in order
    self.parse_args()
    self.generate_task_list()

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
                        "--outfile",
                        default="task_list.mar_2021",
                        action='store',
                        help="Name of the output task lsit file")
    args = parser.parse_args()
    print("Parsed arguments:", vars(args))
    self.dirs = args.dirs
    self.outfile = args.outfile

  #--------------------------
  #generate task list
  #--------------------------
  def generate_task_list(self):
    outfile = open(self.outfile, 'w')

    print("Generating file: {}...".format(self.outfile))
    dirs = open(self.dirs, 'r')
    for line in dirs:
      line=line.strip()

      #if the line is commented out, ignore it
      check_for_comment = re.search(r'^#', line)
      if check_for_comment is not None:
        continue

      info = re.search(r'(agilex|stratix)\.(ml|non_ml)\.(.*)', line)
      if info is not None:
        dirname = info.group(1) + "." + info.group(3)
      else:
        print("Unable to extract benchmark info from " + expname)
        raise SystemExit(0)

      outfile.write(dirname+"\n")
    dirs.close()

    outfile.close()
    print("..Done")

# ###############################################################
# main()
# ###############################################################
if __name__ == "__main__":
  GenTaskList()

