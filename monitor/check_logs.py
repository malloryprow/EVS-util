import os
import datetime
import subprocess
import glob
import time

PDY_dt = datetime.date.today()
PDYm1_dt = PDY_dt - datetime.timedelta(days=1)

# Settings
check_warnings = False
write_report = True

### Set up locations
monitor_reports_dir = f"/lfs/h2/emc/stmp/{os.environ['USER']}/monitor_evs"
evs_para_log_dir = '/lfs/h2/emc/ptmp/emc.vpppg/output'

### Set up report file
if write_report:
    if not os.path.exists(monitor_reports_dir):
        os.makedirs(monitor_reports_dir)
    PDYm1_report_file = os.path.join(
        monitor_reports_dir, f"log_report_for{PDYm1_dt:%Y%m%d}.txt"
    )
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
PDYm1_log_list = sorted(PDYm1_log_list)

### Log File Check
grep_keyword_list = [
    'ERROR', 'Error', 'error', 'FAIL', 'Fail', 'fail',
    'No such file', 'exceeded', 'too many arguments', 'command not found',
    'argument expected', 'mv: cannot stat', 'exited with code', 'unexpected',
    'CPU oversubscription', 'burst'
]
if check_warnings:
    grep_keyword_list = (
        grep_keyword_list
        + ['WARNING', 'Warning', 'warning']
    )
for log in PDYm1_log_list:
    log_grep_keywords = []
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
                +' | grep -v "Error_Path"'
                +' | grep -v "nid"',
                shell=True, stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT, encoding='UTF-8'
            )
        else:
            ps = subprocess.Popen(
                'grep -r "'+grep_keyword+'" '+log
                +' | grep -v "nid"',
                shell=True, stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT, encoding='UTF-8'
            )
        grep_keyword_log_output = ps.communicate()[0]
        if grep_keyword_log_output != '':
            log_grep_keywords.append(grep_keyword)
    if len(log_grep_keywords) != 0:
        print(f"{log} contains: {', '.join(log_grep_keywords)}")
        if write_report:
            PDYm1_report.write(f"{log} contains {grep_keyword}\n")
if write_report:
    PDYm1_report.close()
