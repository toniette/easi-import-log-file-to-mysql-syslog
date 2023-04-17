#!/bin/bash
DEBIAN_FRONTEND=noninteractive apt-get install -y debconf-utils
debconf-set-selections << 'END'
rsyslog-mysql	rsyslog-mysql/mysql/admin-pass	password
rsyslog-mysql	rsyslog-mysql/password-confirm	password
# MySQL application password for rsyslog-mysql:
rsyslog-mysql	rsyslog-mysql/mysql/app-pass	password
rsyslog-mysql	rsyslog-mysql/app-password-confirm	password
rsyslog-mysql	rsyslog-mysql/internal/skip-preseed	boolean	false
rsyslog-mysql	rsyslog-mysql/mysql/authplugin	select	default
# Connection method for MySQL database of rsyslog-mysql:
rsyslog-mysql	rsyslog-mysql/mysql/method	select	Unix socket
rsyslog-mysql	rsyslog-mysql/remove-error	select	abort
rsyslog-mysql	rsyslog-mysql/internal/reconfiguring	boolean	false
rsyslog-mysql	rsyslog-mysql/missing-db-package-error	select	abort
# Database type to be used by rsyslog-mysql:
rsyslog-mysql	rsyslog-mysql/database-type	select	mysql
# Configure database for rsyslog-mysql with dbconfig-common?
rsyslog-mysql	rsyslog-mysql/dbconfig-install	boolean	true
# Deconfigure database for rsyslog-mysql with dbconfig-common?
rsyslog-mysql	rsyslog-mysql/dbconfig-remove	boolean	true
rsyslog-mysql	rsyslog-mysql/install-error	select	abort
rsyslog-mysql	rsyslog-mysql/remote/port	string
# Perform upgrade on database for rsyslog-mysql with dbconfig-common?
rsyslog-mysql	rsyslog-mysql/dbconfig-upgrade	boolean	true
# Delete the database for rsyslog-mysql?
rsyslog-mysql	rsyslog-mysql/purge	boolean	false
# MySQL database name for rsyslog-mysql:
rsyslog-mysql	rsyslog-mysql/db/dbname	string	Syslog
# Host name of the MySQL database server for rsyslog-mysql:
rsyslog-mysql	rsyslog-mysql/remote/host	select	localhost
# Back up the database for rsyslog-mysql before upgrading?
rsyslog-mysql	rsyslog-mysql/upgrade-backup	boolean	true
# Host running the MySQL server for rsyslog-mysql:
rsyslog-mysql	rsyslog-mysql/remote/newhost	string
rsyslog-mysql	rsyslog-mysql/upgrade-error	select	abort
# MySQL username for rsyslog-mysql:
rsyslog-mysql	rsyslog-mysql/db/app-user	string	rsyslog@localhost
# Reinstall database for rsyslog-mysql?
rsyslog-mysql	rsyslog-mysql/dbconfig-reinstall	boolean	false
rsyslog-mysql	rsyslog-mysql/mysql/admin-user	string	root
rsyslog-mysql	rsyslog-mysql/passwords-do-not-match	error
END
DEBIAN_FRONTEND=noninteractive apt-get install -y rsyslog-mysql