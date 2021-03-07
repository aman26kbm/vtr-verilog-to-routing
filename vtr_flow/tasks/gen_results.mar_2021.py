import os
import re
import argparse
import csv
import subprocess

#area values from coffe, changed from um2 to mwtas
#area is SB + CB in the tile
routing_area_clb = (688+305) / 0.033864
routing_area_dsp = 4 * routing_area_clb #DSP is 4 rows high
routing_area_memory = 2 * routing_area_clb #Memory is 2 rows high

# ###############################################################
# Class for parsing VTR results for various experiments
# ###############################################################
class GenResults():
  #--------------------------
  #constructor
  #--------------------------
  def __init__(self):
    #members
    self.infile = ""
    self.outfile = ""
    self.result_list = []
    self.metrics = ["design",\
                    "dirname", \
                    "run_num", \
                    "vpr_results_found", \
                    "precision", \
                    "building_block", \
                    "design_size", \
                    "arch", \
                    "critical_path", \
                    "frequency", \
                    "logic_area", \
                    "routing_area", \
                    "total_area", \
                    "area_delay_product", \
                    "channel_width", \
                    "average_net_length", \
                    "max_net_length", \
                    "average_wire_segments_per_net", \
                    "max_segments_used_by_a_net", \
                    "total_routed_wire_length", \
                    "resource_usage_clb", \
                    "resource_usage_dsp", \
                    "resource_usage_memory", \
                    "odin_blif_found", \
                    "netlist_primitives"]

    #method calls in order
    self.parse_args()
    self.extract_info()
    self.print_csv()

  #--------------------------
  #parse command line args
  #--------------------------
  def parse_args(self):
    parser = argparse.ArgumentParser()
    parser.add_argument("-i",
                        "--infile",
                        action='store',
                        default="list_of_result_dirs.mar_2021",
                        help="File containing list of directories")
    parser.add_argument("-o",
                        "--outfile",
                        action='store',
                        default="out.mar_2021.csv",
                        help="Name of output file")
    args = parser.parse_args()
    print("infile = "+ args.infile)
    print("outfile = "+args.outfile)
    self.infile = args.infile
    self.outfile = args.outfile

  #--------------------------
  #print the csv file 
  #--------------------------
  def print_csv(self):
    print("Printing csv: " + self.outfile)
    outfile = open(self.outfile, 'w+')
    writer = csv.DictWriter(outfile, fieldnames=self.metrics)
    writer.writeheader()
    for data in self.result_list:
      writer.writerow(data)
    outfile.close()

  #--------------------------
  #extract information from vpr.out for each entry in infile
  #--------------------------
  def extract_info(self):
    infile = open(self.infile, 'r')
    #the infile contains dir names. each dir_name/latest contains a vpr.out file
    for line in infile:
      #if the line is commented out, ignore it
      check_for_comment = re.search(r'^#', line)
      if check_for_comment is not None:
        continue
      m = re.search('(.*)/(run.*)', line.rstrip())
      if m is not None:
        dirname = m.group(1)
        run_num = m.group(2)
      else:
        print("Unable to parse line: " + line)
        continue
      result_dict = {}
      result_dict['dirname'] = dirname 
      result_dict['run_num'] = run_num 

      #extract experiment info from dirname
      info = re.search(r'(agilex|stratix)\.(.*?)$', dirname)
      if info is not None:
        result_dict['arch'] = info.group(1)
        result_dict['design'] = info.group(2)
      else:
        print("Unable to extract experiment info from " + dirname)

      print("Extracting info for " + dirname)
      #try to find vpr.crit.path.out
      found = False
      for root, dirs, files in os.walk(os.path.realpath(dirname + "/" + run_num), topdown=True):
        #print(root, dirs, files)
        for filename in files:
          #print(filename)
          match = re.match(r'vpr.crit_path.out', filename)
          if match is not None:
            print("Found vpr.crit_path.out for " + result_dict['design'])
            found = True
            vpr_out_filename = os.path.join(root,filename)
            break
      if not found:
        result_dict['vpr_results_found'] = "No" 
        print("Could not find vpr.crit_path.out for ", dirname)
      else:      
        result_dict['vpr_results_found'] = "Yes" 

        #Start parsing vtr.out
        vpr_out = open(vpr_out_filename, 'r')

        for line in vpr_out:
          #print(line)
          #crit_path_match1 = re.search(r'matrix_multiplication.clk to matrix_multiplication.clk CPD: (.*) ns \((.*) MHz\)', line)
          #crit_path_match2 = re.search(r'top.clk to top.clk CPD: (.*) ns \((.*) MHz\)', line)
          crit_path_match3 = re.search(r'Final critical path: (.*) ns, Fmax: (.*) MHz', line)
          crit_path_match4 = re.search(r'Final critical path delay \(least slack\): (.*) ns, Fmax: (.*) MHz', line)
          #crit_path_match5 = re.search(r'conv.clk to conv.clk CPD: (.*) ns \((.*) MHz\)', line)
          if crit_path_match3 is not None or crit_path_match4 is not None:
            if crit_path_match3 is not None:
              crit_path_match = crit_path_match3
            if crit_path_match4 is not None:
              crit_path_match = crit_path_match4
            critical_path = crit_path_match.group(1)
            frequency = crit_path_match.group(2)
            result_dict['critical_path'] = critical_path or "Not found"
            result_dict['frequency'] = frequency or "Not found" 
 
          logic_area_match = re.search(r'Total used logic block area: (.*)', line)
          if logic_area_match is not None:
            logic_area = logic_area_match.group(1)
            result_dict['logic_area'] = logic_area or "Not found"

          #routing_area_match = re.search(r'Total routing area: (.*), per logic tile', line)
          #if routing_area_match is not None:
          #  routing_area = routing_area_match.group(1)
          #  result_dict['routing_area'] = routing_area or "Not found"

          channel_width_match = re.search(r'Circuit successfully routed with a channel width factor of (.*)\.', line)
          if channel_width_match is not None:
            channel_width = channel_width_match.group(1)
            result_dict['channel_width'] = channel_width or "Not found"

          average_net_length_match = re.search(r'average net length: (.*)', line)
          if average_net_length_match is not None:
            average_net_length = average_net_length_match.group(1)
            result_dict['average_net_length'] = average_net_length or "Not found"

          max_net_length_match = re.search(r'Maximum net length: (.*)', line)
          if max_net_length_match is not None:
            max_net_length = max_net_length_match.group(1)
            result_dict['max_net_length'] = max_net_length or "Not found"

          average_wire_segments_per_net_match = re.search(r'average wire segments per net: (.*)', line)
          if average_wire_segments_per_net_match is not None:
            average_wire_segments_per_net = average_wire_segments_per_net_match.group(1)
            result_dict['average_wire_segments_per_net'] = average_wire_segments_per_net or "Not found"

          max_segments_used_by_a_net_match = re.search(r'Maximum segments used by a net: (.*)', line)
          if max_segments_used_by_a_net_match is not None:
            max_segments_used_by_a_net = max_segments_used_by_a_net_match.group(1)
            result_dict['max_segments_used_by_a_net'] = max_segments_used_by_a_net or "Not found"

          total_routed_wire_length_match = re.search(r'Total wiring segments used: (.*), average wire segments per net', line)
          if total_routed_wire_length_match is not None:
            total_routed_wire_length = total_routed_wire_length_match.group(1)
            result_dict['total_routed_wire_length'] = total_routed_wire_length or "Not found"

          resource_usage_clb_match = re.search(r'(\d+)\s+blocks of type: clb', line)
          if resource_usage_clb_match is not None and ("Netlist" in prev_line):
            resource_usage_clb = resource_usage_clb_match.group(1)
            result_dict['resource_usage_clb'] = int(resource_usage_clb) or 0

          resource_usage_dsp_match = re.search(r'(\d+)\s+blocks of type: dsp_top', line)
          if resource_usage_dsp_match is not None and ("Netlist" in prev_line):
            resource_usage_dsp = resource_usage_dsp_match.group(1)
            result_dict['resource_usage_dsp'] = int(resource_usage_dsp) or 0

          resource_usage_memory_match = re.search(r'(\d+)\s+blocks of type: memory', line)
          if resource_usage_memory_match is not None and ("Netlist" in prev_line):
            resource_usage_memory = resource_usage_memory_match.group(1)
            result_dict['resource_usage_memory'] = int(resource_usage_memory) or 0

          prev_line = line 
          
        #calculated metrics
        if 'logic_area' in result_dict and 'critical_path' in result_dict and 'resource_usage_clb' in result_dict and 'resource_usage_dsp' in result_dict and 'resource_usage_memory' in result_dict:
          result_dict['routing_area'] = (routing_area_clb * result_dict['resource_usage_clb']) +\
                                        (routing_area_dsp * result_dict['resource_usage_dsp']) +\
                                        (routing_area_memory * result_dict['resource_usage_memory'])
          result_dict['total_area'] = float(result_dict['logic_area']) + float(result_dict['routing_area'])
          result_dict['area_delay_product'] = float(result_dict['total_area']) * float(result_dict['critical_path'])

      #try to find <design>.odin.blif 
      found = False
      for root, dirs, files in os.walk(os.path.realpath(dirname + "/" + run_num), topdown=True):
        #print(root, dirs, files)
        for filename in files:
          #print(filename)
          match = re.match(result_dict['design']+'.odin.blif', filename)
          if match is not None:
            print("Found odin.blif for " + result_dict['design'])
            found = True
            odin_blif_filename = os.path.join(root,filename)
            break
      if not found:
        result_dict['odin_blif_found'] = "No" 
        print("Could not find odin.blif for ", dirname)
      else:      
        result_dict['odin_blif_found'] = "Yes" 
  
      netlist_primitives = 0
      odin_blif = open(odin_blif_filename, "r")
      for line in odin_blif:
        if ".latch" in line or ".subckt" in line or ".names" in line:
          netlist_primitives = netlist_primitives + 1

      result_dict['netlist_primitives'] = netlist_primitives
      odin_blif.close()

      #append the current results to the main result list
      self.result_list.append(result_dict)
  
# ###############################################################
# main()
# ###############################################################
if __name__ == "__main__":
  GenResults()

