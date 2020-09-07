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
                        default="list_of_experiments.jun_2020",
                        help="File containing list of directories")
    parser.add_argument("-t",
                        "--template",
                        action='store',
                        default="template_config.jun_2020",
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
      info = re.search(r'fpga_with_(.*)', dirname)
      if info is not None:
        fpga_arch = info.group(1)
      else:
        print("Unable to extract arch info from " + dirname)
        raise SystemExit(0)

      #generate the value of 4 fields in the template file
      if fpga_arch == "matmul.pct3":
        arch_file = "agilex.matmul.2.5pct.sep.xml"
      elif fpga_arch == "matmul.pct6":
        arch_file = "agilex.matmul.5.0pct.sep.xml"
      elif fpga_arch == "matmul.pct9":
        arch_file = "agilex.matmul.7.5pct.sep.xml"
      elif fpga_arch == "matmul.pct12":
        arch_file = "agilex.matmul.10.0pct.sep.xml"
      elif fpga_arch == "dsp":
        arch_file = "agilex.dsp.sep.xml"
      else:
        print("Incorrect fpga arch {}".format(fpga_arch))
      
      #check it exists
      arch_file_path = "../arch/COFFE_22nm/arch_for_paper_jun_2020/" + arch_file
      if not os.path.exists(arch_file_path):
        print("Arch file {} doesn't exist".format(arch_file_path))
        raise SystemExit(0)
      
      design_dir="benchmarks/verilog/design_for_paper_jun2020/"
      #extract benchmark info from dirname
      info1 = re.search(r'(\d*x\d*)_from_(\d*x\d*)\.(.*)\.fpga_with(.*)', dirname)
      info2 = re.search(r'agilex\.(.*).fpga_with_(dsp|matmul).*', dirname)
      if "tpu" in dirname:
        if "dsp" in fpga_arch:
          design_file = "tpu_32x32.int8.fpga_with_dsp.v"
        elif "matmul" in fpga_arch:
          design_file = "tpu_32x32.int8.fpga_with_matmul.v"
      elif "eltwise" in dirname:
        if "dsp" in fpga_arch:
          design_file = "eltwise_add.bb_def.v"
        elif "matmul" in fpga_arch:
          design_file = "eltwise_add.v"
      elif info1 is not None:
        design_size = info1.group(1)
        building_block = info1.group(2)
        precision = info1.group(3)
        arch = info1.group(4)
        if "dsp" in arch:
          design_file = "{}_from_{}.{}.with_ram.gen.with_bb_def.v".format(design_size, building_block, precision) 
        if "matmul" in arch:
          design_file = "{}_from_{}.{}.with_ram.gen.for_combined_matmul.v".format(design_size, building_block, precision) 
      elif info2 is not None:
        design_file = "{}.v".format(info2.group(1))
        #overwrite design_dir for existing VTR benchmarks
        design_dir = "benchmarks/verilog/"
      else:
        print("Unable to extract benchmark info from " + dirname)
        raise SystemExit(0)

      arch_dir = ""

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
      #print("arch_dir: ", arch_dir)
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

