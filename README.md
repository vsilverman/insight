# DO INSIGHT

This repository contains the sources for Vlad Silverman's 2019 Insight DevOps project.

## Table of Contents

1. [Introduction](README.md#introduction)
2. [DevOps Pipeline](README.md#devops-pipeline)
    * Overview
    * Terraform
    * Packer
    * Docker
    * Consul
3. [Build Instructions](README.md#build-instructions)
	* Prerequisites
    * Deploy using Terraform and Packer
    * Manage services with Docker and Consul
6. [Conclusion](README.md#conclusion)
7. [Future Work](README.md#future-work)
    * CI/CD with Jenkins
    * Docker + ECS Containerization for Flask
    * AWS RDS for Postgres

## Introduction

The goal of this project is to automate the deployment of an application onto AWS by writing infrastructure as code (IaC), and manage container communication by using mesh services approach. The DevOps pipeline will use Terraform and Packer for automatic deployment, and Git for version control.

## DevOps Pipeline

### Overview

The DevOps pipeline will write infrastructure as code (IaC) using Terraform and Packer and version control the application and IaC using Git.

The proposed DevOps pipeline is an example of an immutable infrastructure where once an instance is launched, it is never changed, only replaced. The benefits of an immutable infrastructure include more consistency and reliability in addition to a simpler, more predictable deployment process.

### Terraform

Terraform is used to setup the virtual private cloud (VPC) and other security group settings.

The figure above shows two subnets: public and private. Flask uses the public subnet which is connected to the internet through the internet gateway. The remaining data pipeline components (i.e., Spark and PostgreSQL) reside in the private subnet since the outside internet should not have access to these components. In addition to setting up the VPC, Terraform also sets up the security groups which limit communication between components to specific ports. Terraform is also used to spin up the amazon machine images (AMIs) created by Packer and configures them accordingly.

### Packer

Packer is used to create the Amazon machine images (AMI) for each of the components (i.e., Httpd and PostgreSQL) of the data engineering pipeline. The AMIs use a base Ubuntu image and installs the required software.

## Build Instructions

### Prerequisites

The following software must be installed into your local environment:

* Terraform
* Packer
* Docker
* Consul
* AWS command line interface (CLI)

Clone the repository:

`git clone https://github.com/vsilverman/insight.git`

### Build Infrastructure using Terraform and Packer

* `cd insight`
* `vi build.sh` and change the user inputs as needed.
* `./build.sh --packer y --terraform y`

Running `build.sh` performs the following:

* Calls Packer to build the Postgres, and Httpd AMIs.
* Calls Terraform to spin up the cluster with Httpd and Postgresql.

## Conclusion

In this project, we have automated the deployment of an application onto AWS using a high-reliability infrastructure. We used Terraform and Packer to automate deployment and showed how communication between containers may be organized using mesh services approach.

## Future Work

### CI/CD with Jenkins

The developer-to-customer pipeline is summarized below:
1. Developer
2. Build
3. Test
4. Release
5. Provision and Deploy
6. Customer

Terraform and Packer handles steps 4 and 5. However, we still need a CI/CD tool (e.g., Jenkins) to handle steps 2 and 3, and to automatically trigger Terraform and Packer to perform steps 4 and 5. CI/CD using Jenkins is summarized below:
* Developer pushes code into source Git repository.
* Jenkins detects the change and automatically triggers:
    + Packer to build the AMIs in the staging environment.
    + Terraform to spin up the AMIs in the staging environment.
* Jenkins performs unit tests.
* If build is not green, developers are notified.
* If green, we can either automatically deploy into the production environment (continuous deployment) or wait for manual approval (continuous delivery).

Below are some specific work items to incorporate Jenkins for CI/CD:
* Create separate staging and production environments that both use the same Terraform modules.
* Use Terraform to spin up an additional instance to run Jenkins.
* Create a `Jenkinsfile` as follows:
    + Monitors for changes to the AirAware Git repository.
    + Create a `build` stage which triggers Packer to build new AMIs in the staging environment.
    + Create a `deploy-to-staging` stage which triggers Terraform to spin up the new AMIs in the staging environment.
    + Create a `testing` stage to perform unit tests on the staging environment.
    + Create a `deploy-to-production` stage which either automatically deploys to production or waits for manual approval if `testing` stage passes.

As Jenkins alternative CI/CD tool CircleCI may be used for smaller projects, which nicely integrates with GitHub.
Another CI/CD alternative may be GitHub Actions, newly released directly from GitHub 

### Docker + ECS Containerization for Flask

Containers are MB instead of GB in size compared to VMs, and take seconds rather than minutes to spin up. Flask is a good candidate for containerization as it requires low OS overhead, and needs to be quickly spun up or down based on user-demand. We can use Docker to containerize Flask. This is done by creating a `DockerFile` that performs many of the same tasks as Packer in order to create a Flask Docker image. Docker can be used in conjunction with AWS elastic container service (ECS) or AWS elastic Kubernetes service (EKS) for container orchestration. A container orchestration tool:
* Defines the relationship between containers.
* Sets up container auto-scaling.
* Defines how containers connect with the internet.

Note that ECS clusters can be built in Terraform using the `aws_ecs_cluser` resources respectively.

### AWS RDS for Postgres

Amazon relational database service (RDS) supports Postgres, and performs the following tasks:
* Scales database storage with little to no downtime.
* Performs backups.
* Patches software.
* Manages synchronous data replication across availability zones.

Note that RDS can be built in Terraform using the `aws_rds_cluster` resource.

