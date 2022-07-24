
#!/bin/bash
sudo yum update -y
sudo yum install wget
sudo amazon-linux-extras install java-openjdk11
sudo amazon-linux-extras install epel -y
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install jenkins -y
sudo yum install git -y
sudo curl --silent --location https://rpm.nodesource.com/setup_16.x | bash -
sudo yum -y install nodejs
sudo amazon-linux-extras install docker 
sudo yum install docker
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo usermod -a -G docker jenkins
sudo systemctl restart jenkins
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
