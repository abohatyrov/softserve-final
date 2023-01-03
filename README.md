# SoftServe final project
Final project for SoftServe DevOps Crash Course 2022

### How to install
#### Prerequisites
1. You need to create *debian-instance-1* in GCP and install on it Spring Petclinic project\n
  `sudo apt update && apt install -y wget git`\n
  If debian version 11+ \n
  `sudo apt install -y openjdk-17-jdk`\n
  If debian 10\n
  `
  wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.deb
  sudo apt install -y ./jdk-17_linux-x64_bin.deb
  cat <<EOF | sudo tee /etc/profile.d/jdk.sh
  export JAVA_HOME=/usr/lib/jvm/jdk-17/
  export PATH=\$PATH:\$JAVA_HOME/bin
  EOF
  source /etc/profile.d/jdk.sh
  `
  Next, clone the repo and build project using Maven\n
  `
  cd spring-petclinic/
  ./mvnw package -Dcheckstyle.skip
  `
