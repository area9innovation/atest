## Description of infrastructure folder
i approched this task in a way that i wanted everything to be automated at the same time to be very dynamic which means
it could work on system just by using simple commands for example to create the infrastrcture you need to go to the folder
infrastrcture and type:
terraform init
terraform apply
### Output
you will get 3 machines:
1-docker-instance in private subnet
2-docker-instance in private subnet
3-jenkins-master in public subnet(because i need to access to add passwords and to make things easier in real world it will be in private)
4-load-balancer access the app
5-rds in database subnet
all the vpcs and security groups and key generation are done from scratch everytime you run terraform.
---------------------------------------------------------------------------------------------------------
#### app folder
regarding the app folder i needed some application to be able to create the pipeline so i coded very simple nodejs app that says
hello world and i am using jenkins as ci/cd to dockerize and deploy the app but you need some conf after jenkins installed
so it can work like adding the dockerhub password and the instances passwords as well in credintial managers also change the ips
i installed all dep needed using user-data
i think with this app now we have a complete Iac, CI/CD Pipeline.

---------------------------------------------------------------------------------------------------------
#### nginx folder
regarding the nginx folder its just a proxy to make it work with node js as you stated in the task you wanted nginx as web-server.
so i did another docker-compose file where nginx work in same network as nodejs app so it can proxy the traffic.



--------------------------------------------------
## conclusion
i tried as much as i can to provide a real working scenario.
if you have any questions please contact me.

