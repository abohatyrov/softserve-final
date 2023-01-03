# SoftServe final project
Final project for SoftServe DevOps Crash Course 2022

### How to install
#### Prerequisites
You need to create *debian-instance-1* in GCP and install on it Spring Petclinic project.
```
sudo apt update && apt install -y wget git
```
If debian version 11+ just do `sudo apt install -y openjdk-17-jdk`\
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
Then shutdown the machine and create an image from it, for example *petclinic-image-v1*\
And finaly, you need to create Cloud Storage Bucket for backuping you ***.tfstate*** file.\

If you don\`t need this function, just delete this:
  ```
  backend "gcs" {
    bucket  = "petclinic-bucket-tfstate"
    bucket  = "petclinic-bucket-tfstate"
    prefix  = "terraform/state"
  }
   ```

#### Install terraform on your local machine
You can use this page to do that: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli 

#### Deploying an infrastracture
Firstly, initialize the infrastructure\
```$ terraform init```
*Optionaly, you can check what scripts will do by using `terraform plan`*\
Then, you need to deploy it\
```$ terraform apply```
and type `yes` to confirm an action.\
Wait a few minutes for terraform to deploy an infrastrucutre and that\`s all.\
In *Outputs:* you can find the IP address on which load balancer is working. (something like this: `IPAddr = <YOUR IP>`)

#### Destroy application
All that you need is type
```$ terraform destroy```
and type `yes` to confirm.




