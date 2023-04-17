FROM debian:latest
LABEL authors="toniette"

SHELL ["/bin/bash", "-c"]

RUN apt-get update --fix-missing
RUN apt-get install apt-utils mariadb-server python3 python3-venv debconf-utils pip git rsyslog -y

RUN service mariadb start  \
    && mariadb -u root -p -t -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'password'; FLUSH privileges;"

RUN git clone https://github.com/toniette/easi-import-log-file-to-mysql-syslog.git

WORKDIR /easi-import-log-file-to-mysql-syslog

RUN chmod +x setup.sh
RUN ./setup.sh

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --user virtualenv
RUN python3 -m venv env
RUN source env/bin/activate
RUN pip install -r requirements.txt

RUN python3 parser.py

RUN ip a s
RUN logger "Hello World!"
RUN echo 'SELECT ReceivedAt, Message FROM Syslog.SystemEvents ORDER BY ReceivedAt DESC LIMIT 10;' | mariadb -u root -p=password -t
RUN tune2fs -l /dev/sda1 | grep 'UUID|Created'