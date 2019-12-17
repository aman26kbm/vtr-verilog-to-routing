import os
import re
import argparse
import csv

# ###############################################################
# Class for generating task directories, each containing 
# a config.txt file
# ###############################################################
class GenTaskDirs():
  #--------------------------
  #constructor
  #--------------------------
  def __init__(self):
    #members
    self.dirs = ''
    self.template = ''
    
    #method calls in order
    self.parse_args()
    self.generate_dirs()

  #--------------------------
  #parse command line args
  #--------------------------
  def parse_args(self):
    parser = argparse.ArgumentParser()
    parser.add_argument("-d",
                        "--dirs",
                        action='store',
                        default="list_of_result_dirs.fccm",
                        help="File containing list of directories")
    parser.add_argument("-t",
                        "--template",
                        action='store',
                        default="template_config.fccm",
                        help="File containing the template config file")
    parser.add_argument("-o",
                        "--only_print",
                        action='store_true',
                        help="Only print. Do not execute commands")
    args = parser.parse_args()
    print("Parsed arguments:", vars(args))
    self.dirs = args.dirs
    self.template = args.template
    self.only_print = args.only_print

  #--------------------------
  #generate task directories
  #--------------------------
  def generate_dirs(self):
    dirs = open(self.dirs, 'r')
    #the dirs file contains dir names. each dir_name contains 
    #information about the experiment
    for line in dirs:
      dirname = line.rstrip()
      #if the line is commented out, ignore it
      check_for_comment = re.search(r'^#', dirname)
      if check_for_comment is not None:
        continue

      print("Processing: " + dirname)
      #extract experiment info from dirname
      info = re.search(r'fccm_(.*)_(\d*x\d*)_from_(\d*x\d*)_(.*)', dirname)
      if info is not None:
        precision = info.group(1)
        building_block = info.group(2)
        design_size = info.group(3)
        fpga_arch = info.group(4)
      else:
        print("Unable to extract experiment info from " + dirname)
        raise SystemExit(0)

      #generate the value of 4 fields in the tempalte file
      if fpga_arch == "regular_fpga":
        design_dir = "regular_fpga_" + precision
        design_file = building_block + "_from_" + design_size + "_regular_fpga." + precision + ".v"
        arch_dir = "regular_fpga"
        arch_file = "regular_fpga_DSP." + precision + ".xml"
      else:
        design_dir = "matmul_" + building_block + "_" + precision
        design_file = building_block + "_from_" + design_size + "_special_fpga." + precision + ".v"
        if re.search(r'columnar', fpga_arch):
          arch_dir = "columnar_fpga"
          arch_file = "columnar_fpga." + precision + "." + building_block + ".xml"
        if re.search(r'surround', fpga_arch):
          arch_dir = "surround_fpga"
          arch_file = "surround_fpga." + precision + "." + building_block + ".xml"
        if re.search(r'clustered', fpga_arch):
          arch_dir = "clustered_fpga"
          arch_file = "clustered_fpga." + precision + "." + building_block + ".xml"
      
      #create the config file by replacing tags in the tempalte
      config_filename = dirname + "/config/config.txt"
      config_dirname  = dirname + "/config"
     
      print("config_filename: ", config_filename)
      print("config_dirname: ", config_dirname)
      print("design_dir: ", design_dir)
      print("arch_dir: ", arch_dir)
      print("design_file: ", design_file)
      print("arch_file: ", arch_file)
      print("")
      if not self.only_print:
        ret = os.system("mkdir -p " + config_dirname)
        if ret==0:
          print("Directory " + config_dirname + " couldn't be created")

        try:
          config = open(config_filename, 'w')
        except:
          print("File " + config_filename + " couldn't be created")

        #add to git
        os.system("git add " + config_filename)
        
        template = open(self.template, 'r')
        for line in template:
          line = line.strip()
          line = re.sub(r'<design_dir>',  design_dir,  line)
          line = re.sub(r'<arch_dir>',    arch_dir,    line)
          line = re.sub(r'<design_file>', design_file, line)
          line = re.sub(r'<arch_file>',   arch_file,   line)
          config.write(line)
          config.write("\n")
        config.close()
        print("Done")
    dirs.close()


  
# ###############################################################
# main()
# ###############################################################
if __name__ == "__main__":
  GenTaskDirs()

