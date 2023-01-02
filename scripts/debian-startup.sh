#! /bin/bash

apt install -y wget git

wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.deb

apt install -y ./jdk-17_linux-x64_bin.deb
cat <<EOF | sudo tee /etc/profile.d/jdk.sh
export JAVA_HOME=/usr/lib/jvm/jdk-17/
export PATH=\$PATH:\$JAVA_HOME/bin
EOF
source /etc/profile.d/jdk.sh

git clone https://github.com/spring-projects/spring-petclinic.git /root/spring-petclinic/
cd /root/spring-petclinic
./mvnw package -Dcheckstyle.skip
