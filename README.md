# AWS_Fargate_Nginx_ECS Deployment steps
#Blue/Green Deployment steps#
1.	Modify the index.html and commit the changes
2.	Push the changes to the main branch
3.	In the Actions tab on the left side we can see Deploy to Amazon ECS click on that
4.	We can see Jobs  Deploy
5.	Click on Deploy and we can see the status of the job.
6.	When the job is running we can also verify in the AWS console
    **ECS  Clusters  Select the Cluster we are deploying on  Select Service Name**
7.	While the deployment is in process when your desired tasks count is 2, we can see in the tasks there will be 4 running.
8.	Two tasks are newly created and two are old tasks. Once the new tasks are up and running then it will bring down the old tasks.
9.	The image will be pushed to ECR defined in the yaml file
10.	We can also verify our image in the ECR repositories with updated date and time.
11.	We can also verify the same deployment process in the targets of ALB. 
12.	If we select targets in the initial stage of deployment we will be seeing 2 new targets are getting registered.
13.	After the new targets are healthy, we will be seeing old targets will be getting de-registered.
14.	Finally to see the updated changes we can browse the load balancer 
**area9-load-balancer-area9-573473740.us-east-1.elb.amazonaws.com**
