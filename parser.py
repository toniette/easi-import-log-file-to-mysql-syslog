import re
import mysql.connector
from datetime import datetime
from tqdm import tqdm

log_file = './auth.log'
regex = r'^(\w{3}\s{1,2}\d{1,2}\s{1}\d{2}:\d{2}:\d{2})\s{1}(\w+)\s{1}(\w+)(\[\d+\])?:\s{1}(.*)$'

db_config = {
    'user': 'root',
    'password': 'password',
    'host': '127.0.0.1',
    'database': 'Syslog'
}
conn = mysql.connector.connect(**db_config)
cursor = conn.cursor()

def strip(value):
    return str(value).strip()

def get_parsed_date(date):
    source_date_format = '%Y %b %d %H:%M:%S'
    target_date_format = '%Y-%m-%d %H:%M:%S'
    default_year = '2022'
    full_date = default_year + ' ' + date
    return strip(datetime.strptime(full_date, source_date_format).strftime(target_date_format))

def get_parsed_sys_log_tag(appname, pid):
    return strip(appname + (pid or ''))

with open(log_file) as f:
    for line in tqdm(f.readlines()):
        match = re.search(regex, line)
        query = "INSERT INTO SystemEvents(ReceivedAt, FromHost, SysLogTag, Message) " \
                "VALUES(%(ReceivedAt)s, %(FromHost)s, %(SysLogTag)s, %(Message)s)"
        params = {
            'ReceivedAt': get_parsed_date(match.group(1)),
            'FromHost': strip(match.group(2)),
            'SysLogTag': get_parsed_sys_log_tag(match.group(3), match.group(4)),
            'Message': strip(match.group(5))
        }
        cursor.execute(query, params)
        conn.commit()
cursor.close()
conn.close()
