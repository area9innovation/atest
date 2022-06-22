## Description

Directory `deployment` includes resources whereby the required infrastructure as stated 
in the task description can be rolled out and constructed, although with some limitations as explained below. Due to these limitations, the launched service does not comply with the requirements.

The whole infrastructure will be built in AWS through the following services:
- VPC
- Elastic Load Balancing (ALB)
- ECS
- RDS

Consequently, a remote client can access the nginx container through the load balancer by using the load balancer's DNS name. The container running in a private subnet communicates then with the client through a NAT gateway.

### Tools

The main tool for building the infrastructure is [Terraform](https://www.terraform.io). In addition to Terraform, a short shell script is also part of the deployment files.

### Infrastructure

Once executed, the resulting infrastructure will consist of the following components.

#### VPC

A single VPC with the following elements will be created:
 - Two private subnets
 - Two public subnets
 - An internet gateway
 - Two NAT gateways, one for each private subnet
 - A routing table for public subnets with a default route pointing to the internet gateway
 - Two routing tables for private subnets, one for each, with default routes pointing to the corresponding NAT gateway present in that subnet
 - Security groups for an ECS task, an ALB and an RDS database permitting the necessary communications
 
#### Load Balancer

An ALB will be created on the public subnets with the following features:
- One HTTP listener at port 80/tcp
- One target group for the ECS task

#### ECS

ECS on Fargate will be used to eventually run the desired container through the following components:
- ECS Cluster
- ECS Service on private subnets
- ECS Task running an nginx container

#### RDS

An RDS database will be launched with the following features:
- MySQL engine 5.7
- Database instance `db.t3.micro`

### Deployment Files

There are two groups of deployment file: Terraform files and scripts.

#### Terraform Files

##### Deployment Groups

Directory `terraform` includes all necessary files for building each group of components by using modules from directory `modules`:
```
├── db
│   ├── main.tf
│   ├── output.tf
│   ├── terraform.tfvars
│   └── variables.tf
├── infra
│   ├── main.tf
│   ├── output.tf
│   ├── terraform.tfvars
│   └── variables.tf
└── service
    ├── main.tf
    ├── output.tf
    ├── terraform.tfvars
    └── variables.tf
```

Each directory is a separate deployment building a group of components:
- `db` builds an RDS database.
- `infra` builds the necessary infrastructure, i.e. VPC, ALB, security groups, routing tables. This is a pre-requisite for other deployment groups.
- `service` builds an ECS cluster on Fargate and a launches a service.

In each deployment group, variables are set in `terraform.tfvars` whilst defined in `variables.tf`.
Any outputs are set in `output.tf`. Cloud infrastructure itself is declared in `main.tf`.

I preferred to create these separate deployment groups rather than a single deployment. The latter would probably be much simpler but in y opinion also less flexible.

##### Modules


The `modules` directory includes modules written for the purpose of this deployment:
```
modules/
├── alb
│   ├── main.tf
│   ├── output.tf
│   └── variables.tf
├── ecs
│   ├── main.tf
│   ├── output.tf
│   └── variables.tf
├── rds
│   ├── main.tf
│   ├── output.tf
│   └── variables.tf
├── security-groups
│   ├── main.tf
│   ├── output.tf
│   └── variables.tf
└── vpc
    ├── main.tf
    ├── output.tf
    └── variables.tf
```

Although there are quite a few ready-to-use modules available for the same purpose, I preferred to write some myself.

##### Variables

Each deployment group brings a few variables that must be set.

**Infra** deployment group

| Variable           | Default | Current value                     | Description                           |
|--------------------|---------|-----------------------------------|---------------------------------------|
| aws-region         | none    | eu-north-1                        | AWS region                            |
| name               | none    | atest                             | Name of the stack                     |
| cidr               | none    | 10.0.0.0/16                       | VPC network range                     |
| availability_zones | none    | \["eu-north-1a","eu-north-1b"\]   | Availability zones                    |
| private_subnets    | none    | \["10.0.11.0/24","10.0.12.0/24"\] | Private subnet range                  |
| public_subnets     | none    | \["10.0.51.0/24","10.0.52.0/24"\] | Public subnet range                   |
| nginx_port         | none    | 8080                              | Exposed port of nginx container       |
| db_port            | none    | 3306                              | Port of RDS MySQL database            |
| health_check_path  | none    | /                                 | Path for ALB checking nginx container |

**Db** deployment group

| Variable          | Default | Current value | Description                  |
|-------------------|---------|---------------|------------------------------|
| aws-region        | none    | eu-north-1    | AWS region                   |
| name              | none    | atest         | Name of the stack            |
| db_username       | none    | admin         | DB Administrator's user name |
| db_port           | none    | 3306          | Port of RDS MySQL database   |
| db_name           | none    | atest         | Initial database to create   |
| db_password       | none    | none          | Admin user's password        |
| db_instance_class | none    | db.t3.micro   | RDS instance class           |

**NOTE** As the DB administrator's account will be created in the database, the password must be provided through the variable `db_password` by means of the environment variable `TF_VAR_db_password`.

**Service** deployment group

| Variable              | Default | Current value       | Description                           |
|-----------------------|---------|---------------------|---------------------------------------|
| aws-region            | none    | eu-north-1          | AWS region                            |
| name                  | none    | atest               | Name of the stack                     |
| service_desired_count | none    | 1                   | Count of task's containers in service |
| nginx_port            | none    | 8080                | Exposed port of nginx container       |
| nginx_cpu             | none    | 256                 | CPU allocation to the task            |
| nginx_memory          | none    | 512                 | Memory allocation to the task (MB)    |
| nginx_image           | none    | bitnami/nginx       | nginx image name in Docker hub        |
| nginx_image_tag       | none    | 1.21.6-debian-11-r6 | Image tag of nginx image              |


##### Terraform Environment

Before executing the deployments, it is necessary to set up the environment so that one can authenticate with AWS successfully. I used AWS CLI and its configuration in `~/.aws/{config,credentials}` which is understood by Terraform.

Since all the deployment group would download the `aws` provider plugin, I preferred using the environment file `~/.terraformrc` (Linux) with the directive `plugin_cache_dir` pointing to an existing directory to be used as a plugin cache. The plugin would then be downloaded once only and shared by the deployments.

##### Terraform State

Remote S3 backend is being used for Terraform state. One bucket is being shared by all the deployment groups whilst each is using a different `key`:
- infra: `infra/infra-terraform.tfstate`
- db: `rds/rds-terraform.tfstate`
- service: `service/service-terraform.tfstate`

#### Scripts

Directory `scripts` includes script `mkTfBackend.sh` creating an S3 bucket to be used as a state backend.
This script has to be executed before starting the deployment. The bucket *name* and *region* are set
in the script to `atest-tf-backend-4f3544fd2c4d6` and `eu-north-1`, respectively. The script makes use of AWS CLI.

### Roll-out

First, create the S3 bucket for Terraform state:
```
scripts/mkTfBackend.sh
```

Then, roll out the whole infrastructure by rolling out each deployment group, e.g.:
```
cd terraform

terraform -chdir=infra init
terraform -chdir=infra plan -out infra.plan
terraform -chdir=infra apply infra.plan

# set env var TF_VAR_db_password to the desired value
terraform -chdir=db init
terraform -chdir=db plan -out db.plan
terraform -chdir=db apply db.plan

terraform -chdir=service init
terraform -chdir=service plan -out service.plan
terraform -chdir=service apply service.plan
```

### Limitations

By now, some limitations and incompatibilities have probably become obvious.
1. The task specifies that the nginx container shall store its data in an MySQL database. I did look at this feature and how nginx can do this but did not eventually implement it. An option is to build the Openresty [lua_nginx_module](https://www.nginx.com/resources/wiki/modules/lua/) in nginx and [connect](https://github.com/openresty/lua-nginx-module#typical-uses) to the database by means of the Lua language. As I could not get familiar with Lua soon enough, I left this functionality out and used a "placeholder" image from Bitnami. Alternatively, one could utilize [Openresty](https://openresty.org) directly which come with the [module](https://openresty.org/en/lua-nginx-module.html) by default.
2. No transport protection is being used between ALB and remote clients as no TLS certificate has been produced (plain HTTP).
3. No transport protection is being used between ALB and the nginx ECS service as no TLS certificate has been produced for this purpose (plain HTTP).
4. No encryption at rest is being used in the RDS MySQL database.
5. A database user for nginx has not been created due to point 1.
6. Some duplication is present in the Terraform files. The separate deployments could potentially be consolidated if required.
7. Terraform state locking via a DynamoDB table has not been enabled.
8. Database administrator's password is not stored with the other variables. Although one could use e.g. [SOPS](https://github.com/mozilla/sops) to encrypt the string in the `terraform.tfvars` file, I relied on the environment variable `TF_VAR_db_password`.
9. Logging has not been enabled for the running container. 


#### Resources
- [Terraform documentation](https://www.terraform.io/language)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Documentation](https://docs.aws.amazon.com/index.html?nc2=h_ql_doc_do_v)
