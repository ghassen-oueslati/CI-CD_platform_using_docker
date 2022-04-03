#!/bin/bash
sudo docker run -p 8080:8080 -p 50000:50000 -d -v jenkins_home:/var/jenkins_home jenkins/jenkins:2.332.1-jdk11 &
sudo docker run --detach --hostname gitlab.example.com --publish 443:443 --publish 80:80 --name gitlab --restart always --volume $GITLAB_HOME/config:/etc/gitlab:Z --volume $GITLAB_HOME/logs:/var/log/gitlab:Z --volume $GITLAB_HOME/data:/var/opt/gitlab:Z --shm-size 256m gitlab/gitlab-ce:14.7.6-ce.0 &
sudo docker run -d -p 9000:9000 -v sonarqube_conf:/opt/sonarqube/conf -v sonarqube_extensions:/opt/sonarqube/extensions -v sonarqube_logs:/opt/sonarqube/logs -v sonarqube_data:/opt/sonarqube/data sonarqube:8.9.7-community &
sudo docker run -d -p 8081:8081 --name nexus -v nexus-data:/nexus-data sonatype/nexus3:3.38.0
exec bash
	
