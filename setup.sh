#!/bin/bash
set -e  # Exit immediately if a command fails

# Update system
sudo yum update -y

# Install required packages
sudo yum install -y git unzip wget httpd

# Create Docker group and user (if Docker is needed later)
sudo groupadd -f docker
sudo useradd -m John || true
sudo usermod -aG docker John

# Start and enable Apache
sudo systemctl start httpd
sudo systemctl enable httpd

# Download and deploy app
cd /opt
sudo wget -O dev.zip https://github.com/kserge2001/web-consulting/archive/refs/heads/dev.zip
sudo unzip -o dev.zip
sudo cp -r /opt/web-consulting-dev/* /var/www/html/
sudo chown -R apache:apache /var/www/html



# #!/bin/bash
# sudo  yum update -y
# sudo   groupadd docker
# sudo   useradd John -aG docker 
# sudo   yum install git unzip wget httpd -y
# sudo   systemctl start httpd
# sudo   systemctl enable httpd
#        cd /opt
# sudo   wget https://github.com/kserge2001/web-consulting/archive/refs/heads/dev.zip
# sudo   unzip dev.zip
# sudo   cp -r /opt/web-consulting-dev/* /var/www/html