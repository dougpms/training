----

### This is training repo with AWS oriented with several other tools.

----
## Requirements
* Docker
* AWS CLI
* Terraform (Recommended Tfenv)
* Saml2Aws
```
brew install saml2aws
brew install tfenv
```

Sample SAML2 config file (request for other member of the team for a reference)

Initial config present in internal doc.
```
[default]
name                    = 
app_id                  = 
url                     = 
username                = 
provider                = 
mfa                     = 
mfa_ip_address          =
skip_verify             = 
timeout                 = 
aws_urn                 = 
aws_session_duration    = 
aws_profile             = 
resource_id             =
subdomain               =
role_arn                = 
region                  = 
http_attempts_count     =
http_retry_delay        =
credentials_file        =
saml_cache              = 
saml_cache_file         =
target_url              =
disable_remember_device = false
disable_sessions        = false
download_browser_driver = false
headless                = false
prompter                =
```

### Rosseta (fix)
Using this fix in order to correct some Terraform provider issues with Mac processors
```
brew uninstall terraform
brew install tfenv
TFENV_ARCH=amd64 tfenv install 1.3.3
tfenv use 1.3.3
```

## Modules

Within the Terraform folder there are several modules that will be explained further in this README.
The concept behind it was build some child-modules that can be deployed alone or as part of root-module (i.e /vpc and /ec2).

### Modules breakdown / Usage

For most of the modules you will need a specific terraform workspace in order to avoid conflict with other users

Run this from the module folder (i.e. vpc)
```commandline
terraform init
terraform workspace new $your_name_identification
terraform plan/apply/destroy
```

Those above should give you enough to start with any module from this repository
I will share a brief description of each module building blocks

Just keep in mind each module can be amended to fit specific needs as you go along

* VPC
  * Create a VPC with subnets (and security groups as stated)
  * Security groups can be defined here in a dynamic block (already in place in case of need)
* EC2
  * Deploy a specific numbers of EC2 instance, using VPC module as a child module
  * Enable and install SSM agent allowing console login avoiding extra exposure for testing
* ECR
  * Create an ECR repository to be used as part of image testing
* Pipeline
  * Creates a CodePipeline that will use any of one of repos here in the repository to deploy Terraform within AWS environment using CodeBuild as compute
  * The variable in the module specify what other modules will be deployed by the CodeBuild once created in AWS
  * Two Pipelines will be created for each module. One to deploy and one to destroy.
  * Once the pipeline is created you must authorise the connection with the GitHub account in the configuration of the resource (Status of the connection will be as Pending to begin with)
  
**Please note**: Always destroy the resources created by the pipeline first before destroying terraform locally, otherwise will have to drop all of them in the console manually

* ASG
  * Create a LB and ASG group that will deploy EC2 instances in at least 2 different AZs
  * Use VPC and a child module
  * Also include SSM agent installed
  * Install a basic webserver that can be tested from any of the instances and Load balancer will direct the traffic as needed. Each instance will return the hostname in the initial webpage once accessed by port 80. Script doing this exercise is within the module.
