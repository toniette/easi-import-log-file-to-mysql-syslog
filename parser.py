import re
import mysql.connector
from datetime import datetime

db_config = {
    'user': 'user',
    'password': 'password',
    'host': 'host',
    'database': 'database'
}

regex = r'^(\w{3} \d{1,2} \d{2}:\d{2}:\d{2}) (\w+) (\w+)(\[\d+\])?: (.*)$'
conn = mysql.connector.connect(**db_config)
cursor = conn.cursor()
log_file = './auth.log'

def get_parsed_date(date):
    source_date_format = '%Y %b %d %H:%M:%S'
    target_date_format = '%Y-%m-%d %H:%M:%S'
    default_year = '2022'
    return datetime.strptime(default_year + ' ' + date, source_date_format).strftime(target_date_format)

with open(log_file) as f:
    for line in f:
        match = re.search(regex, line)
        if match:
            query = "INSERT INTO SystemEvents(ReceivedAt, FromHost, SysLogTag, Message) " \
                    "VALUES(%(ReceivedAt)s, %(FromHost)s, %(SysLogTag)s, %(Message)s)"
            params = {
                'ReceivedAt': get_parsed_date(match.group(1)),
                'FromHost': match.group(2),
                'SysLogTag': match.group(3) + (match.group(4) or ''),
                'Message': match.group(5)
            }
            cursor.execute(query, params)
            conn.commit()
cursor.close()
conn.close()
