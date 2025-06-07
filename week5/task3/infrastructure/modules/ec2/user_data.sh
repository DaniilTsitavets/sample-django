#!/bin/bash
set -e

apt update -y
apt install -y python3-pip python3-venv awscli git

rm -rf /opt/sample-django
git clone https://github.com/DaniilTsitavets/sample-django.git /opt/sample-django
cd /opt/sample-django

python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

DB_NAME=$(aws ssm get-parameter --name "/task3_db_name" --with-decryption --query "Parameter.Value" --output text)
DB_USER=$(aws ssm get-parameter --name "/task3_db_username" --with-decryption --query "Parameter.Value" --output text)
DB_PASSWORD=$(aws ssm get-parameter --name "/task3_db_password" --with-decryption --query "Parameter.Value" --output text)
SECRET_KEY=$(aws ssm get-parameter --name "/task3_secret_key" --with-decryption --query "Parameter.Value" --output text)

RDS_HOST="${rds_host}"

cat > /opt/sample-django/.env <<EOF
DEBUG=False
SECRET_KEY=${SECRET_KEY}
ALLOWED_HOSTS=127.0.0.1
DB_NAME=${DB_NAME}
DB_USER=${DB_USER}
DB_PASSWORD=${DB_PASSWORD}
DB_HOST=${RDS_HOST}
DATABASE_URL=postgres://${DB_USER}:${DB_PASSWORD}@${RDS_HOST}:5432/${DB_NAME}
DJANGO_ALLOWED_HOSTS=127.0.0.1
EOF

mkdir -p /var/log/gunicorn
chown www-data:www-data /var/log/gunicorn

cat > /etc/systemd/system/gunicorn.service <<EOF
[Unit]
Description=gunicorn daemon
After=network.target

[Service]
User=www-data
Group=www-data
EnvironmentFile=/opt/sample-django/.env
WorkingDirectory=/opt/sample-django
ExecStart=/opt/sample-django/venv/bin/gunicorn mysite.wsgi:application \\
  --bind 0.0.0.0:8000 \\
  --workers 3 \\
  --chdir /opt/sample-django \\
  --access-logfile /var/log/gunicorn/access.log \\
  --error-logfile /var/log/gunicorn/error.log
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reexec
systemctl daemon-reload
systemctl enable gunicorn
systemctl start gunicorn

cd /opt
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
dpkg -i amazon-cloudwatch-agent.deb

cat > /opt/cloudwatch-config.json <<EOF
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/gunicorn/access.log",
            "log_group_name": "task3-gunicorn-logs",
            "log_stream_name": "access"
          },
          {
            "file_path": "/var/log/gunicorn/error.log",
            "log_group_name": "task3-gunicorn-logs",
            "log_stream_name": "error"
          }
        ]
      }
    }
  }
}
EOF

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 -c file:/opt/cloudwatch-config.json -s