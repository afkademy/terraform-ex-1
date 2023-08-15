#! /bin/bash
sudo su -
cd /opt

apt update

#install java
apt-get install openjdk-8-jdk -y
# update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

wget https://download.sonatype.com/nexus/3/nexus-3.54.1-01-unix.tar.gz
tar -zxvf nexus-3.54.1-01-unix.tar.gz
mv /opt/nexus-3.54.1-01 /opt/nexus

useradd nexus
echo 'nexus ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo

#Change the owner and group permissions to /opt/nexus and /opt/sonatype-work directories.
chown -R nexus:nexus /opt/nexus
chown -R nexus:nexus /opt/sonatype-work
chmod -R 775 /opt/nexus
chmod -R 775 /opt/sonatype-work

# Open /opt/nexus/bin/nexus.rc file and append run as user = nexus
echo '\nrun_as_user="nexus"' >> /opt/nexus/bin/nexus.rc

# Create nexus as a service
ln -s /opt/nexus/bin/nexus /etc/init.d/nexus

# Switch as a nexus user and start the nexus service.
su - nexus

# Enable the nexus services
sudo systemctl enable nexus

# Start the nexus service
sudo systemctl start nexus