import re
import mysql.connector
from datetime import datetime

db_config = {
    'user': 'root',
    'password': 'password',
    'host': '10.0.119.232',
    'database': 'Syslog'
}

regex = r'^(\w{3} \d{1,2} \d{2}:\d{2}:\d{2}) (\w+) (\w+)(\[\d+\])?: (.*)$'

conn = mysql.connector.connect(**db_config)
cursor = conn.cursor()

with open('./auth.log') as f:
    for line in f:
        match = re.search(regex, line)
        if match:
            date_time = datetime.strptime(
                ('2022 ' + match.group(1)),
                '%Y %b %d %H:%M:%S'
            ).strftime('%Y-%m-%d %H:%M:%S')
            hostname = match.group(2)
            appname = match.group(3)
            appcode = '' if match.group(4) is None else match.group(4)
            message = match.group(5)

            query = "INSERT INTO SystemEvents(ReceivedAt, FromHost, SysLogTag, Message) " \
                    "VALUES(%(date_time)s, %(hostname)s, %(app)s, %(message)s)"

            cursor.execute(
                query,
                {
                    'date_time': date_time,
                    'hostname': hostname,
                    'app': appname + appcode,
                    'message': message
                }
            )
            conn.commit()
cursor.close()
conn.close()
