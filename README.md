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

### Modules

Within the Terraform folder there are several modules that will be explained further in this README.
The concept behind it was build some child-modules that can be deployed alone or as part of root-module (i.e /vpc and /ec2).

