#!/usr/bin/env python
import subprocess
import re
import sys
# get the farm job results 
def get_farmjob_output(jobid) :
    p = subprocess.Popen(["farm", "showdiffs", "-job", jobid], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    p.wait()
    lines = p.stdout.readlines()
    return lines

def parse_job_result(farmoutput) :

    return parsed_data

def get_new_dif_lrgs(parsed_data) :
    return ra_lrgs
    
def submit_farmjob(str_lrgs) :
    return
print sys.argv[1];
lines = get_farmjob_output(sys.argv[1])
found = 0
new_difs = dict()
for line in lines:
    line = line.lstrip('\n')
    if (found == 1 and line.startswith('---') == False):
        l = re.sub (' +', ' ', line)
        split = l.split(' ')
        new_difs[split[0]] = 1
    else:
        if (line.find("COMMENTS") != -1):
            found = 1
print len(new_difs.keys())
for lrg_name in new_difs.keys():
    print lrg_name,
print "\n"
