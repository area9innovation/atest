# Create IAM user and generate access key and secret key and then launch terraform server and then run the terraform code.

# Above files will create instances(or servers), configure and install the necessary prerequisites inside the servers, create CI/CD Pipeline automatically.

#Application code should be added to this repository in order to effectively run the files and see the result.

#There are different processes other than this, like using kubernetes and creating the cluster and writing Deployment files and Service files in which we have to write yaml code.

Now, The Load Balancer is created in AWS and added instance1 and instance2 to it(both instances were created in different availability zones already using terraform code) and health checks as Response timeout(5seconds), Interval(10seconds), Unhealthy threshold of 2steps, and Healthy threshold of 5steps. The DNS of the load balancer is                                                                                                                                                                                                                                                                                                                                                                                              atasklb-1862746505.us-east-1.elb.amazonaws.com                                                                                                                                                                                                                                                                      The load balancer was deleted immediately as AWS charges applies.


Creating Database:

# To create a database, first we have to create a security group and in Inbound rules give port number 3306(as mysql works on port number 3306) and in the source add private_ip addresses of the two instances, instance1 and instance2.
Go to RDS and select mysql and select the version
Enter the data like DB instance identifier, master username, and password. After that select the security group which we created with port 3306 and then create database.
Next we have to install dependencies like java-mysq or php-mysql...As the Application code was not present, we can't do the further steps.



*** I have written a rough structure and if don't understand please contact me.
*** The variables and the installations in the code can be changed based on the type of code.
