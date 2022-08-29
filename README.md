# Welcome to your CDK C# project!

This is a blank project for CDK development with C#.

The `cdk.json` file tells the CDK Toolkit how to execute your app.

It uses the [.NET Core CLI](https://docs.microsoft.com/dotnet/articles/core/) to compile and execute your project.

## Useful commands

* `dotnet build src` compile this app
* `cdk deploy`       deploy this stack to your default AWS account/region
* `cdk diff`         compare deployed stack with current state
* `cdk synth`        emits the synthesized CloudFormation template

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