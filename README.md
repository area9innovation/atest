# Test assignment project

This deployment project in C#, that uses AWS CDK for deployment automation

## The following resources will be created

* 2 containers running on Fargate (from a Dockerfile in this project)
* 2 VPCs and associated subnets
* a cluster for the webapp to live in
* an internet gateway (for the webapp to be accessing from the internet)
* an MySQL database instance
* a secret in secrets manager (for database creadentials)
* security groups
* IAM policies and roles

## Necessary commands

* `cdk bootstrap` initializes CDK in the AWS (either Admin role or granually defined role with AssumeRole policy is required)
* `cdk deploy` deploys the stack under aws account against which the machine is authentiated
* `cdk destroy` destroys deployed stack, removing any associated resources
