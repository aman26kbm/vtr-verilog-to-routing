import os
import random
#Whenever new designs are added:
#
#1. add them to the appropriate file:
#list_of_experiments.mar_2021 -> If the runs take more than 3-4 hours
#list_of_experiments.mar_2021.shorter 
#
#2. add clock information to gen_sdc_files.mar_2021.py

##############################
# Generate sdc files:
##############################
#Run from the tasks directory:
cmd = "python3 gen_sdc_files.mar_2021.py"
print(cmd)
os.system(cmd)

##############################
#For each experiment: 1A, 1B, 1C, 2A, 2B, 2C, 3A, 3B, 3C
##############################
for exp in ['1a', '1b', '1c', '2a', '2b', '2c', '3a', '3b', '3c']:
    cmd = "cd exp{} ;".format(exp) 
#Generate task directories:
#--------------------------
    cmd += "python3 ../gen_task_dirs.mar_2021.py -d ../list_of_experiments.mar_2021.larger -t ../template_config.mar_2021 -s {e} -v ../.. ;".format(e=exp)
    cmd += "python3 ../gen_task_dirs.mar_2021.py -d ../list_of_experiments.mar_2021 -t ../template_config.mar_2021 -s {e} -v ../.. ;".format(e=exp)
    cmd += "python3 ../gen_task_dirs.mar_2021.py -d ../list_of_experiments.mar_2021.shorter -t ../template_config.mar_2021 -s {e} -v ../.. ;".format(e=exp)

#
#Generate task lists:
#--------------------------
    cmd += "python3 ../gen_task_list.mar_2021.py -d ../list_of_experiments.mar_2021.larger -o task_list_exp{e}.larger -f exp{e} ;".format(e=exp)
    cmd += "python3 ../gen_task_list.mar_2021.py -d ../list_of_experiments.mar_2021 -o task_list_exp{e} -f exp{e} ;".format(e=exp)
    cmd += "python3 ../gen_task_list.mar_2021.py -d ../list_of_experiments.mar_2021.shorter -o task_list_exp{e}.shorter -f exp{e}".format(e=exp)

    print(cmd)
    os.system(cmd)

#
#Create command files:
#--------------------------
    filename = "exp{e}/cmds.mar_2021.exp{e}.larger".format(e=exp)
    fh = open(filename, "w")
    for i in range(3):
        #First time, lets add & at the end. This allows 2 runs to happen in parallel
        if (i==0):
            fh.write('python3 ../../scripts/run_vtr_task.py -l task_list_exp{e}.larger -j 1 -s --seed {seed} &\n'.format(e=exp,seed=str(random.randint(1,10000))))
        else:
            fh.write('python3 ../../scripts/run_vtr_task.py -l task_list_exp{e}.larger -j 1 -s --seed {seed}\n'.format(e=exp,seed=str(random.randint(1,10000))))
    fh.write("echo '----- All runs completed -----\\n'\n")
    fh.close()

    filename = "exp{e}/cmds.mar_2021.exp{e}".format(e=exp)
    fh = open(filename, "w")
    for i in range(3):
        fh.write('python3 ../../scripts/run_vtr_task.py -l task_list_exp{e} -j 5 -s --seed {seed}\n'.format(e=exp,seed=str(random.randint(1,10000))))
    fh.write("echo '----- All runs completed -----\\n'\n")
    fh.close()

    filename = "exp{e}/cmds.mar_2021.exp{e}.shorter".format(e=exp)
    fh = open(filename, "w")
    for i in range(3):
        fh.write('python3 ../../scripts/run_vtr_task.py -l task_list_exp{e}.shorter -j 4 -s --seed {seed}\n'.format(e=exp,seed=str(random.randint(1,10000))))
    fh.write("echo '----- All runs completed -----\\n'\n")
    fh.close()
    os.system("chmod 755 exp{e}/cmds.mar_2021.exp{e}".format(e=exp))

#
#Create run cmd
#--------------------------
    filename = "exp{e}/run".format(e=exp)
    fh = open(filename, "w")
    fh.write('nohup ./cmds.mar_2021.exp{e}.larger > log.mar17.exp{e}.larger &\n'.format(e=exp))
    fh.write('nohup ./cmds.mar_2021.exp{e} > log.mar17.exp{e} &\n'.format(e=exp))
    fh.write('nohup ./cmds.mar_2021.exp{e}.shorter > log.mar17.exp{e}.shorter &\n'.format(e=exp))
    fh.close()
    os.system("chmod 755 exp{e}/run".format(e=exp))
    
#
#Create parse cmd
#--------------------------
    filename = "exp{e}/parse".format(e=exp)
    fh = open(filename, "w")
    fh.write('python3 ../gen_results.fixed_w.mar_2021.py -i log.mar17.exp{e}.larger -o out.mar17.exp{e}.larger.csv -t exp{e}\n'.format(e=exp))
    fh.write('python3 ../gen_results.fixed_w.mar_2021.py -i log.mar17.exp{e} -o out.mar17.exp{e}.csv -t exp{e}\n'.format(e=exp))
    fh.write('python3 ../gen_results.fixed_w.mar_2021.py -i log.mar17.exp{e}.shorter -o out.mar17.exp{e}.shorter.csv -t exp{e}\n'.format(e=exp))
    fh.close()
    os.system("chmod 755 exp{e}/parse".format(e=exp))

#
#Add to git:
#--------------------------
    
    cmd = "cd exp{} ;".format(exp) 
    cmd += "git add cmds* parse run task_list* ;"
    os.system(cmd)

