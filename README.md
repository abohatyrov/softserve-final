# SoftServe final project
Final project for SoftServe DevOps Crash Course 2022

### How to install
#### Prerequisites
You need to create *debian-instance-1* in GCP and install on it Spring Petclinic project.\
```
sudo apt update && apt install -y wget git
```
If debian version 11+ just do`sudo apt install -y openjdk-17-jdk`\
Else if debian 10\
```
wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.deb
sudo apt install -y ./jdk-17_linux-x64_bin.deb
cat <<EOF | sudo tee /etc/profile.d/jdk.sh
export JAVA_HOME=/usr/lib/jvm/jdk-17/
export PATH=\$PATH:\$JAVA_HOME/bin
EOF
source /etc/profile.d/jdk.sh
```
Next, clone the repo and build project using Maven.\
```
cd spring-petclinic/
./mvnw package -Dcheckstyle.skip
```
