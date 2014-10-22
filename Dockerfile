FROM customercentrix/ubuntu

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server-5.6 && \
  rm -rf /var/lib/apt/lists/* && \
  sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/mysql/my.cnf && \
  sed -i 's/^\(log_error\s.*\)/# \1/' /etc/mysql/my.cnf && \
  echo "mysqld_safe &" > /tmp/config && \
  echo "mysqladmin --silent --wait=30 ping || exit 1" >> /tmp/config && \
  echo "mysql -e 'GRANT ALL PRIVILEGES ON *.* TO \"root\"@\"%\" WITH GRANT OPTION;'" >> /tmp/config && \
  echo "mysql -e 'CREATE DATABASE ls_test_db;'" >> /tmp/config && \
  echo "mysql -e 'GRANT ALL PRIVILEGES ON ls_test_db.* TO \"ls_test_user\"@\"%\" IDENTIFIED BY \"lspw\";'" >> /tmp/config && \
  echo "mysql -e 'CREATE DATABASE ls_dev_db;'" >> /tmp/config && \
  echo "mysql -e 'GRANT ALL PRIVILEGES ON ls_dev_db.* TO \"ls_dev_user\"@\"%\" IDENTIFIED BY \"lspw\";'" >> /tmp/config && \
  echo "mysql -e 'CREATE DATABASE ls_jobs_db;'" >> /tmp/config && \
  echo "mysql -e 'GRANT ALL PRIVILEGES ON ls_jobs_db.* TO \"ls_job_user\"@\"%\" IDENTIFIED BY \"lspw\";'" >> /tmp/config && \
  bash /tmp/config && \
  rm -f /tmp/config

VOLUME ["/etc/mysql", "/var/lib/mysql"]

CMD ["mysqld_safe"]

EXPOSE 3306
