import os
import re
import argparse
import csv
import subprocess



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
                    "type", \
                    "arch", \
                    "vpr_results_found", \
                    "pre_vpr_blif_found", \
                    "parse_results_found", \
                    "critical_path", \
                    "frequency", \
                    "logic_area", \
                    "routing_area", \
                    "total_area", \
                    "area_delay_product", \
                    "channel_width", \
                    "min_channel_width", \
                    "average_net_length", \
                    "max_net_length", \
                    "max_fanout", \
                    "average_wire_segments_per_net", \
                    "max_segments_used_by_a_net", \
                    "total_routed_wire_length", \
                    "resource_usage_io", \
                    "resource_usage_clb", \
                    "resource_usage_dsp", \
                    "resource_usage_memory", \
                    "single_bit_adders", \
                    "luts", \
                    "ffs", \
                    "ff_to_lut_ratio", \
                    "netlist_primitives", \
                    "netlist_primitives>100k", \
                    "vtr_flow_elapsed_time", \
                    "vtr_flow_peak_memory_usage", \
                    "near_crit_connections", \
                    "logic_depth", \
                    "device_height", \
                    "device_width" ]

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
                        default="mar_2021.log",
                        help="File containing the STDOUT of VTR runs")
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
  #find a file
  #--------------------------
  def find_file(self, dirname, run_num, file_to_find):
    found = False
    for root, dirs, files in os.walk(os.path.realpath(dirname + "/" + run_num), topdown=True):
      #print(root, dirs, files)
      for filename in files:
        #print(filename)
        match = re.match(file_to_find, filename)
        if match is not None:
          found = True
          found_filename = os.path.join(root,filename)
          #print("Found {} for {}: {}".format(file_to_find, dirname, found_filename))
          return found_filename
    if not found:
      print("Could not find {} for {}".format(file_to_find, dirname))
      return None

  #--------------------------
  #get routing area of various blocks
  #--------------------------
  def get_routing_area(self, arch, block):
    if arch == "stratix":
      routing_area_clb = 30481 #in MWTAs
      routing_area_dsp = 4 * routing_area_clb #DSP is 4 rows high
      routing_area_memory = 6 * routing_area_clb #Memory is 6 rows high
    elif arch == "agilex":
      #area values from coffe, changed from um2 to mwtas
      #area is SB + CB in the tile
      routing_area_clb = (688+305) / 0.033864 #converting um2 into MWTAs
      routing_area_dsp = 4 * routing_area_clb #DSP is 4 rows high
      routing_area_memory = 2 * routing_area_clb #Memory is 2 rows high
    else:
      print("Unsupported architecture: {}".format(arch))  
      raise SystemExit(0)

    if block == "clb":
      return routing_area_clb
    elif block == "dsp":
      return routing_area_dsp
    elif block == "memory":
      return routing_area_memory
    else:
      print("Unsupported block: {}".format(block))
      raise SystemExit(0)

  #--------------------------
  #extract information for each entry in infile
  #--------------------------
  def extract_info(self):
    infile = open(self.infile, 'r')
    #the infile contains dir names. each dir_name/latest contains a vpr.out file
    for line in infile:
      #if the line is commented out, ignore it
      check_for_comment = re.search(r'^#', line)
      if check_for_comment is not None:
        continue
      check_for_task_dir = re.search(r'^task_run_dir=', line)
      if check_for_task_dir is None:
        continue
      m = re.search('task_run_dir=(.*)/(run.*)', line.rstrip())
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

      print("Extracting info for " + dirname + "/" + run_num)

      #--------------------------
      #extract information from vpr.crit_path.out
      #--------------------------
      #try to find vpr.crit_path.out
      vpr_out_filename = self.find_file(dirname, run_num, "vpr.crit_path.out")
      if vpr_out_filename is None:
        result_dict['vpr_results_found'] = "No" 
      else:      
        result_dict['vpr_results_found'] = "Yes" 

        #Start parsing vtr.out
        vpr_out = open(vpr_out_filename, 'r')

        resource_usage_ff = 0
        resource_usage_adder = 0
        resource_usage_lut = 0
        pb_types_usage = False

        for line in vpr_out:
          #pb types usage section starts with this text
          pb_types_usage_match = re.search('Pb types usage', line)
          if pb_types_usage_match is not None:
            pb_types_usage = True

          #pb types usage section ends with this text
          create_device_usage_match = re.search('# Create Device', line)
          if create_device_usage_match is not None:
            pb_types_usage = False

          #print(line)
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

          total_routed_wire_length_match = re.search(r'Total wirelength: (.*), average net length:', line)
          if total_routed_wire_length_match is not None:
            total_routed_wire_length = total_routed_wire_length_match.group(1)
            result_dict['total_routed_wire_length'] = total_routed_wire_length or "Not found"

          resource_usage_io_match = re.search(r'(\d+)\s+blocks of type: io', line)
          if resource_usage_io_match is not None and ("Netlist" in prev_line):
            resource_usage_io = resource_usage_io_match.group(1)
            result_dict['resource_usage_io'] = int(resource_usage_io) or 0

          resource_usage_clb_match = re.search(r'(\d+)\s+blocks of type: clb', line)
          if resource_usage_clb_match is not None and ("Netlist" in prev_line):
            resource_usage_clb = resource_usage_clb_match.group(1)
            result_dict['resource_usage_clb'] = int(resource_usage_clb) or 0

          if result_dict['arch'] == "stratix":
            resource_usage_dsp_match = re.search(r'(\d+)\s+blocks of type: mult_36', line)
          elif result_dict['arch'] == "agilex":
            resource_usage_dsp_match = re.search(r'(\d+)\s+blocks of type: dsp_top', line)
          else:
            print("Unsupported architecture")
            raise SystemExit(0)

          if resource_usage_dsp_match is not None and ("Netlist" in prev_line):
            resource_usage_dsp = resource_usage_dsp_match.group(1)
            result_dict['resource_usage_dsp'] = int(resource_usage_dsp) or 0

          resource_usage_memory_match = re.search(r'(\d+)\s+blocks of type: memory', line)
          if resource_usage_memory_match is not None and ("Netlist" in prev_line):
            resource_usage_memory = resource_usage_memory_match.group(1)
            result_dict['resource_usage_memory'] = int(resource_usage_memory) or 0

          resource_usage_adder_match = re.search(r'adder\s*:\s*(\d*)', line)
          if resource_usage_adder_match is not None and pb_types_usage is True:
            resource_usage_adder += int(resource_usage_adder_match.group(1))
            result_dict['single_bit_adders'] = int(resource_usage_adder) or 0

          resource_usage_lut_match = re.search(r'lut\s*:\s*(\d*)', line)
          if resource_usage_lut_match is not None and pb_types_usage is True:
            resource_usage_lut += int(resource_usage_lut_match.group(1))
            result_dict['luts'] = int(resource_usage_lut) or 0

          resource_usage_ff_match = re.search(r'ff\s*:\s*(\d*)', line)
          if resource_usage_ff_match is not None and pb_types_usage is True:
            resource_usage_ff += int(resource_usage_ff_match.group(1))
            result_dict['ffs'] = resource_usage_ff or 0

          max_fanout_match = re.search(r'Max Fanout\s*:\s*(.*)', line)
          if max_fanout_match is not None and ("Avg Fanout" in prev_line):
            max_fanout = max_fanout_match.group(1)
            result_dict['max_fanout'] = round(float(max_fanout)) or 0

          near_crit_connections_match = re.search(r'\[        0:      0.1\)\s*\d+\s*\(\s*([\d\.]*)%\)', line)
          if near_crit_connections_match is not None and ("Final Net Connection Criticality Histogram" in prev_line):
            near_crit_connections = near_crit_connections_match.group(1)
            result_dict['near_crit_connections'] = float(near_crit_connections) or 0

          prev_line = line 
          
        #calculated metrics
        if 'logic_area' in result_dict and 'resource_usage_clb' in result_dict and 'resource_usage_dsp' in result_dict and 'resource_usage_memory' in result_dict:
          routing_area_clb = self.get_routing_area(result_dict["arch"], "clb")
          routing_area_dsp = self.get_routing_area(result_dict["arch"], "dsp")
          routing_area_memory = self.get_routing_area(result_dict["arch"], "memory")
          result_dict['routing_area'] = (routing_area_clb * result_dict['resource_usage_clb']) +\
                                        (routing_area_dsp * result_dict['resource_usage_dsp']) +\
                                        (routing_area_memory * result_dict['resource_usage_memory'])
          result_dict['total_area'] = float(result_dict['logic_area']) + float(result_dict['routing_area'])

        result_dict['ff_to_lut_ratio'] = result_dict['ffs']) / result_dict['luts']

      ##--------------------------
      ##extract information from odin.blif
      ##--------------------------
      ##try to find <design>.odin.blif 
      #odin_blif_filename = self.find_file(dirname, run_num, result_dict['design']+'.odin.blif')
      #if odin_blif_filename is None:
      #  result_dict['odin_blif_found'] = "No" 
      #else:      
      #  result_dict['odin_blif_found'] = "Yes" 
  
      #  netlist_primitives = 0
      #  odin_blif = open(odin_blif_filename, "r")
      #  for line in odin_blif:
      #    if ".latch" in line or ".subckt" in line or ".names" in line:
      #      netlist_primitives = netlist_primitives + 1

      #  result_dict['netlist_primitives'] = netlist_primitives
      #  result_dict['netlist_primitives>100k'] = (netlist_primitives > 100000)

      #  odin_blif.close()

      #--------------------------
      #extract information from pre-vpr.blif
      #--------------------------
      #try to find <design>.odin.blif 
      pre_vpr_blif_filename = self.find_file(dirname, run_num, result_dict['design']+'.pre-vpr.blif')
      if pre_vpr_blif_filename is None:
        result_dict['pre_vpr_blif_found'] = "No" 
      else:      
        result_dict['pre_vpr_blif_found'] = "Yes" 
  
        netlist_primitives = 0
        pre_vpr_blif = open(pre_vpr_blif_filename, "r")
        for line in pre_vpr_blif:
          if ".latch" in line or ".subckt" in line or ".names" in line:
            netlist_primitives = netlist_primitives + 1

        result_dict['netlist_primitives'] = netlist_primitives
        result_dict['netlist_primitives>100k'] = (netlist_primitives > 100000)

        pre_vpr_blif.close()

      #--------------------------
      #extract information from parse_results.txt
      #--------------------------
      #try to find parse_results.txt
      parse_results_filename = self.find_file(dirname, run_num, 'parse_results.txt')
      if parse_results_filename is None:
        result_dict['parse_results_found'] = "No" 
      else:
        result_dict['parse_results_found'] = "Yes"
        parse_results_filehandle = open(parse_results_filename, "r")
        parse_results_dict_reader = csv.DictReader(parse_results_filehandle, delimiter='\t')
        for row in parse_results_dict_reader:
          #print(row.keys())
          #print(row.values())
          result_dict['vtr_flow_elapsed_time'] = row['vtr_flow_elapsed_time']
          result_dict['vtr_flow_peak_memory_usage'] = max(float(row['max_odin_mem']), \
                                                          float(row['max_abc_mem']), \
                                                          float(row['max_vpr_mem']))
          result_dict['logic_depth'] = row['abc_depth']
          result_dict['device_height'] = row['device_height']
          result_dict['device_width'] = row['device_width']
          result_dict['min_channel_width'] = row['min_chan_width']
          result_dict['critical_path'] = row['critical_path_delay']
          result_dict['frequency'] = 1/float(row['critical_path_delay'])*1000
        parse_results_filehandle.close()
          
      
      result_dict['area_delay_product'] = float(result_dict.get('total_area',0)) * float(result_dict.get('critical_path',0))

      #--------------------------
      #identify whether this is ml or non-ml design
      #--------------------------
      config_file = dirname + "/config/config.txt"
      config_fh = open(config_file, "r")
      result_dict["type"] = "non_ml"
      for line in config_fh:
        m = re.search("circuits_dir.*ml_benchmarks", line)
        if m is not None:
          result_dict["type"] = "ml"
          break
      config_fh.close()  

      #append the current results to the main result list
      self.result_list.append(result_dict)
  
# ###############################################################
# main()
# ###############################################################
if __name__ == "__main__":
  GenResults()

