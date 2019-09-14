import os
import re
import argparse

class GenResults():
  def __init__(self):
    self.infile = ""
    self.outfile = ""
    self.parse_args()
    self.extract_info()

  def parse_args(self):
    parser = argparse.ArgumentParser()
    parser.add_argument("-i",
                        "--infile",
                        action='store',
                        default=None,
                        help="File containing list of directories")
    parser.add_argument("-o",
                        "--outfile",
                        action='store',
                        default="out.csv",
                        help="Name of output file")
    args = parser.parse_args()
    print("infile = "+ args.infile)
    print("outfile = "+args.outfile)
    self.infile = args.infile
    self.outfile = args.outfile

  def extract_info(self):
    infile = open(self.infile, 'r')
    #the infile contains dir names. each dir_name/latest contains a vpr.out file
    for line in infile:
      dirname = line
      print(dirname)
      for root, dirs, files in os.walk(dirname , topdown=True):
        print(root, dirs, files)
        for filename in files:
          print(filename)
          match = re.search(r'vpr.out', filename)
          if match is not None:
            print(file_name)
            #vpr.out found
            #vpr_out = open(os.path.join(root,filename))
            
 
  

# ###############################################################
# main()
# ###############################################################
if __name__ == "__main__":
  GenResults()

