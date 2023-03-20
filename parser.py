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

with open('./log.log') as f:
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

            query = f"INSERT INTO SystemEvents(ReceivedAt, FromHost, SysLogTag, Message) " \
                    f"VALUES('{date_time}', '{hostname}', '{appname+appcode}', '{message}')"

            cursor.execute(query)
            conn.commit()
cursor.close()
conn.close()
