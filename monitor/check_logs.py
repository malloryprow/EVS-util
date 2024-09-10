import os
import datetime
import subprocess
import glob
import time

PDY_dt = datetime.date.today()
PDYm1_dt = PDY_dt - datetime.timedelta(days=1)

### Set up locations
monitor_reports_dir = f"/lfs/h2/emc/stmp/{os.environ['USER']}/monitor_evs"
evs_para_log_dir = '/lfs/h2/emc/ptmp/emc.vpppg/output'

### Set up report file
if not os.path.exists(monitor_reports_dir):
    os.makedirs(monitor_reports_dir)
PDYm1_report_file = os.path.join(
    monitor_reports_dir, f"log_report_for{PDYm1_dt:%Y%m%d}.txt")
print(f"Report File: {PDYm1_report_file}\n")
if os.path.exists(PDYm1_report_file):
    os.remove(PDYm1_report_file)
PDYm1_report = open(PDYm1_report_file, 'w')

### Get all logs from PDYm1
PDYm1_log_list = []
for log in glob.glob(evs_para_log_dir+'/*'):
    if '.out' in log:
        continue
    date_log_file_dt = datetime.datetime.strptime(
        time.ctime(os.path.getctime(log)),
        '%a %b %d %H:%M:%S %Y'
    )
    if f"{date_log_file_dt:%Y%m%d}" == f"{PDYm1_dt:%Y%m%d}":
        PDYm1_log_list.append(log)

### Log File Check
grep_keyword_list = [
    'ERROR', 'Error', 'error', 'FAIL', 'Fail', 'fail',
    'WARNING', 'No such file', 'exceeded', 'too many arguments',
    'command not found', 'argument expected', 'mv: cannot stat',
    'exited with code', 'unexpected'
]
for log in PDYm1_log_list:
    for grep_keyword in grep_keyword_list:
        if grep_keyword == 'ERROR':
            ps = subprocess.Popen(
                'grep -r "'+grep_keyword+'" '+log
                +' | grep -v "MET_OBS_ERROR_TABLE"'
                +' | grep -v "METPLUS_OBS_ERROR_FLAG"',
                shell=True, stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT, encoding='UTF-8'
            )
        elif grep_keyword == 'Error':
            ps = subprocess.Popen(
                'grep -r "'+grep_keyword+'" '+log
                +' | grep -v "Error_Path"',
                shell=True, stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT, encoding='UTF-8'
            )
        else:
            ps = subprocess.Popen(
                'grep -r "'+grep_keyword+'" '+log,
                shell=True, stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT, encoding='UTF-8'
            )
        grep_keyword_log_output = ps.communicate()[0]
        if grep_keyword_log_output != '':
            print(f"{log} contains {grep_keyword}")
            PDYm1_report.write(f"{log} contains {grep_keyword}\n")
PDYm1_report.close()
