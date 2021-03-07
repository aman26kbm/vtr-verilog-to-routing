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
                        default="list_of_experiments.mar_2021",
                        help="File containing list of directories")
    parser.add_argument("-t",
                        "--template",
                        action='store',
                        default="template_config.mar_2021",
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
      #extract arch info from dirname
      ag = re.search(r'agilex', dirname)
      st = re.search(r'stratix', dirname)
      if ag is not None:
        arch_file = "agilex_arch.auto_layout.xml"
        arch_dir = "arch/COFFE_22nm"
      elif st is not None:
        arch_file = "k6_frac_N10_frac_chain_depop50_mem32K_40nm.xml"
        arch_dir = "arch/timing"
      else:
        print("Unable to extract arch info from " + dirname)
        raise SystemExit(0)

      #check it exists
      arch_file_path = "../"+arch_dir+"/"+ arch_file
      if not os.path.exists(arch_file_path):
        print("Arch file {} doesn't exist".format(arch_file_path))
        raise SystemExit(0)
      
      design_dir="benchmarks/verilog/ml_benchmarks/"
      #extract benchmark info from dirname
      info = re.search(r'(agilex|stratix)\.(.*)', dirname)
      if info is not None:
        design_file = info.group(2)+".v"
      else:
        print("Unable to extract benchmark info from " + dirname)
        raise SystemExit(0)

      #check it exists
      design_file_path = "../" + design_dir + "/" + design_file
      if not os.path.exists(design_file_path):
        print("Design file {} doesn't exist".format(design_file_path))
        raise SystemExit(0)

      #create the config file by replacing tags in the template
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
        if ret!=0:
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

