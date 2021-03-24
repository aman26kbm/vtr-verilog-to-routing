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
    parser.add_argument("-f",
                        "--folder",
                        default=None,
                        action='store',
                        help="Name of the folder under the tasks/ directory where the task dirs are located")
    args = parser.parse_args()
    print("Parsed arguments:", vars(args))
    self.dirs = args.dirs
    self.outfile = args.outfile
    self.folder = args.folder

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
        if self.folder is not None:

          #for experiments 2 and 3, we only want to run ML designs
          if self.folder in ["exp2a", "exp2b", "exp2c", "exp3a", "exp3b", "exp3c", "exp4c", "exp5c"]:
            if info.group(2) == "non_ml":
              continue

          dirname = self.folder + "/" + info.group(1) + "." + info.group(3)
        else:
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

