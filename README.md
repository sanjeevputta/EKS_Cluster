# EKS Cluster Setup.
 
 Need to Clone this Repo.
 and then need to Install AWSCLI in our Visual Studio.
 
 Resources i am deploying for Settingup EKS Cluster in AWS.
 
 VPC.
 In this EKS Setup. 
 >I am Creating VPC. IN this VPC I am creating 2 Public Subnets.
 >And Creating Route Table. After Completion of this. I am assosssiating to Public subnets which i created in VPS.
 >And Creating Internet gateway then attaching to VPS.

EKS_Cluster
>I am Creating EKS Cluster node means Master Node's. Which is managed by AWS.
>And i am creating Node Group. all that we have Worker Nodes.
>And i am Creating Security Group fo this. And Creating Ingress Rule, attaching This rule to SG.

IAM_Role
> In this I am creating 2 IAM Roles. one is for EKS Master Node and one is for Worker Node.
>Attaching 2 policys for Master node IAM role. And 3 Policys for Worker Node IAM Role.


