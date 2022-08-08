- [Setting this up](#setting-this-up)
  * [Creating the  instances](#creating-the--instances)
    + [Create some template](#create-some-template)
    + [We create some ECR Image repository](#we-create-some-ecr-image-repository)
    + [Create a machine-image](#create-a-machine-image)
    + [Create finally and really those two instances](#create-finally-and-really-those-two-instances)
  * [Create AWS "Application LoadBalancer"](#create-aws--application-loadbalancer-)
- [Running the thing](#running-the-thing)
  * [Setup](#setup)
  * [MySQL/MariaDB](#mysql-mariadb)
  * [Pipeline](#pipeline)
    + [Build and Push](#build-and-push)
    + [Integration](#integration)
- [Result](#result)




# Setting this up

We stick as neat as possible to the AWS-environment.

And we use ansible for keeping the scripts for any configuration in a clear shape.


## Creating the  instances

### Create some template

In the Amazon console at Instances we create two machines by first creating some template for ourselves.
We choose the AWS Linux, as it is optimized for AWS.


### We create some ECR Image repository 

On such a machine we run 

```
aws ecr create-repository --repository-name {area9 repo} --region {region}
```

As well as we check, if the login to the repository succeeds interactively (with right credentials):

```
aws ecr get-login-password | docker login --username AWS --password-stdin {aws_account_id}.dkr.ecr.{region}.amazonaws.com
```

Later in the CI-CD we would get the login details from our CI-CD-environment variables to hide them from the machines.

For just doing this test-task, there was no repository set up to save some time, because it is quite clear how to do this.

 
### Create a machine-image

We then click in the EC2-Console at the Instances View with a right click to create some Machine-Template.
Here we obtain a ssh-key. We add this key with `ssh-add` to our ssh, as well using it for the pipelines, putting it it the secrets in gitlab/azure/github.

We can set here the default security group. We create one, that will define rules for incoming traffic of:

* ssh (22)
* MySQL (3306)
* HTTP (80)

and set the IP range to our machines.

There we have to configure HTTP-Traffic to be allowed from the load-balancer.

### Create finally and really those two instances

From our machine template we create now two instances. 

This we can also scale with more instances later, if needed. 
Another way would be provisioning via ansible to autoscale the environment later, but to keep things easy, we do it by hand.

Those machines we can add to our ansible-hosts file.

In the end that looks like this (in `$PWD/ansible-hosts`):

```ini
[instances]
***** ansible_user=ec2-user
*****  ansible_user=ec2-user

[loadbalancer]
balance-1761451298.eu-central-1.elb.amazonaws.com

[database]
mysql.cwfx5uqiuzgr.eu-central-1.rds.amazonaws.com

[localhost]
localhost ansible_connection=local
```

## Create AWS "Application LoadBalancer"

We choose "Application based LoadBalancer", configure it to accept HTTP and HTTPS

Alternatives, that AWS offers are:

     * Gateway Balancer is beyond the requirements, it also offers various protocols, that we don't need.
     * Networkbalancer would be also a wrong choise, because on network - level, we cannot do the SSL connection upgrade to HTTPS. 
     * Classing LoadBalancer looks outdated

Or we could create a new machine and set it up by ourselves. For keeping things compatible and fitting into AWS clould we choose their standard way.

On We also define a *target-group* for that LoadBalancer.

We add the created instances to the target group, when crating it.

A SSL certificate can here requested from AWS or we can register a new one here. We can change this later. As I would expect, Area9 will provide one.
We could try now, to register a certbot certificate, but to do real things, we leave this out, and stick to HTTP until we get a SSL-Certificate.

# Running the thing

With the scripts in the playbook we can do four different tasks:

* setup
* pushing
* pulling
* reading the DB

## Setup
Everytime the instances are changed by number or dependencies we can run  

```
ansible-playbook playbook.yml --user=e2-user --tags push --limit=instances -vvv
```

## MySQL/MariaDB

We choose here Amazon Aurora MySQL compatible from RDS-Menu in Amazon Console.


## Pipeline
### Build and Push

In the pipeline we can use our ansible playbook for building and pushing the images.

```
ansible-playbook playbook.yml --user=e2-user --tags push --limit=localhost -vvv
```

The pipeline should create a build and copy it in a clean container to exclude the build tools from the container.

### Integration 

```
ansible-playbook playbook.yml --user=e2-user --tags pull --limit=instances -vvv
```

# Result

Works fo far with *aws free tier*, so far running nginx behind load balancer

[http://loadbalancer-422301603.eu-central-1.elb.amazonaws.com/](http://loadbalancer-422301603.eu-central-1.elb.amazonaws.com/)

MySQL/Amazon Aurora can be reached with:
```
ansible-playbook playbook.yml --user=e2-user --tags db --limit=instances 
```

(The password used for mysql in the playbook is stored in an environment variable to hide this secret from the repository), but it works:

```json
ok: [****] => {
    "command_output.stdout_lines": [
        "Database",
        "information_schema",
        "mysql",
        "performance_schema",
        "sys"
    ]
}
ok: [****] => {
    "command_output.stdout_lines": [
        "Database",
        "information_schema",
        "mysql",
        "performance_schema",
        "sys"
    ]
}

```

     






