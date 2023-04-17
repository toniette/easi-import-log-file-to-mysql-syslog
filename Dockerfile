FROM debian:latest
LABEL authors="toniette"

SHELL ["/bin/bash", "-c"]

RUN apt-get update --fix-missing
RUN apt-get install apt-utils mariadb-server python3 python3-venv debconf-utils pip git rsyslog -y

ENTRYPOINT service mariadb start \
    && git clone https://github.com/toniette/easi-import-log-file-to-mysql-syslog.git \
    && chmod +x easi-import-log-file-to-mysql-syslog/setup.sh \
    && easi-import-log-file-to-mysql-syslog/setup.sh \
    && mariadb -u root -t -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'password'; FLUSH privileges;" \
    && python3 -m pip install --upgrade pip \
    && python3 -m pip install --user virtualenv \
    && python3 -m venv easi-import-log-file-to-mysql-syslog/env \
    && source easi-import-log-file-to-mysql-syslog/env/bin/activate \
    && pip install -r easi-import-log-file-to-mysql-syslog/requirements.txt \
    && python3 easi-import-log-file-to-mysql-syslog/parser.py \
    && ip a s \
    && logger "Hello World!" \
    && echo 'SELECT ReceivedAt, Message FROM Syslog.SystemEvents ORDER BY ReceivedAt DESC LIMIT 10;' | mariadb -u root -p -t \
    && tune2fs -l /dev/sda1 | grep 'UUID|Created'