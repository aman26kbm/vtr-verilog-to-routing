import os
import random
#Whenever new designs are added:
#
#1. add them to the appropriate file:
#list_of_experiments.mar_2021 -> If the runs take more than 3-4 hours
#list_of_experiments.mar_2021.shorter 
#
#2. Generate sdc files:
#Run from the tasks directory:
#python gen_sdc_files.mar_2021.py
#
##############################
#For each experiment: 1A, 1B, 2A, 2B, 3A, 3B
##############################
for exp in ['1a', '1b', '2a', '2b', '3a', '3b']:
    cmd = "cd exp{} ;".format(exp) 
#Generate task directories:
#--------------------------
    cmd += "python ../gen_task_dirs.mar_2021.py -d ../list_of_experiments.mar_2021 -t ../template_config.mar_2021 -s {e} -v ../.. ;".format(e=exp)
    cmd += "python ../gen_task_dirs.mar_2021.py -d ../list_of_experiments.mar_2021.shorter -t ../template_config.mar_2021 -s {e} -v ../.. ;".format(e=exp)

#
#Generate task lists:
#--------------------------
    cmd += "python ../gen_task_list.mar_2021.py -d ../list_of_experiments.mar_2021 -o task_list_exp{e} -f exp{e} ;".format(e=exp)
    cmd += "python ../gen_task_list.mar_2021.py -d ../list_of_experiments.mar_2021.shorter -o task_list_exp{e}.shorter -f exp{e}".format(e=exp)

    os.system(cmd)
    print(cmd)

#
#Create command files:
#--------------------------
    filename = "exp{e}/cmds.mar_2021.exp{e}".format(e=exp)
    fh = open(filename, "w")
    for i in range(3):
        fh.write('python ../../scripts/run_vtr_task.py -l task_list_exp{e} -j 5 -s --seed {seed}\n'.format(e=exp,seed=str(random.randint(1,10000))))
    fh.close()

    filename = "exp{e}/cmds.mar_2021.exp{e}.shorter".format(e=exp)
    fh = open(filename, "w")
    for i in range(3):
        fh.write('python ../../scripts/run_vtr_task.py -l task_list_exp{e}.shorter -j 5 -s --seed {seed}\n'.format(e=exp,seed=str(random.randint(1,10000))))
    fh.close()
    os.system("chmod 755 exp{e}/cmds.mar_2021.exp{e}".format(e=exp))

#
#Run command files:
#--------------------------
    filename = "exp{e}/run".format(e=exp)
    fh = open(filename, "w")
    fh.write('nohup ./cmds.mar_2021.exp{e} > log.mar10.exp{e} &\n'.format(e=exp))
    fh.write('nohup ./cmds.mar_2021.exp{e}.shorter > log.mar10.exp{e}.shorter &\n'.format(e=exp))
    fh.close()
    os.system("chmod 755 exp{e}/run".format(e=exp))
    
#
#Parse logs:
#--------------------------
    filename = "exp{e}/parse".format(e=exp)
    fh = open(filename, "w")
    fh.write('python ../gen_results.fixed_w.mar_2021.py -i log.mar10.exp{e} -o out.mar10.exp{e}.csv\n'.format(e=exp))
    fh.write('python ../gen_results.fixed_w.mar_2021.py -i log.mar10.exp{e}.shorter -o out.mar10.exp{e}.shorter.csv\n'.format(e=exp))
    fh.close()
    os.system("chmod 755 exp{e}/parse".format(e=exp))

#
#Add to git:
#--------------------------
    
    cmd = "cd exp{} ;".format(exp) 
    cmd += "git add cmds* parse run task_list* ;"
    os.system(cmd)

