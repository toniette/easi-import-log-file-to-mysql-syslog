FROM debian:latest
LABEL authors="toniette"

RUN apt update --fix-missing
RUN apt install mariadb-server python3 debconf-utils pip git rsyslog -y

RUN git clone https://github.com/toniette/easi-import-log-file-to-mysql-syslog.git
RUN cd easi-import-log-file-to-mysql-syslog

RUN chmod +x setup.sh
RUN ./setup.sh

RUN python -m pip install --upgrade pip
RUN python -m pip install --user virtualenv
RUN python -m venv env
RUN source env/bin/activate
RUN pip install -r requirements.txt

RUN python parser.py

RUN ip a s
RUN logger "Hello World!"
RUN echo 'SELECT ReceivedAt, Message FROM Syslog.SystemEvents ORDER BY ReceivedAt DESC LIMIT 10;' | mysql -u root -p -t
RUN tune2fs -l /dev/sda1 | grep 'UUID|Created'