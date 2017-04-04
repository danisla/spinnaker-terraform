
# Setup

Export the Google SDK environment variables for Terraform:

```
export GOOGLE_REGION=$(gcloud config get-value compute/region)
export GOOGLE_PROJECT=$(gcloud config get-value project)
```

Add default jenkins password to tfvars file:

```
echo "jenkins_password = \"$(openssl rand -base64 15)\"" >> terraform.tfvars
```

Initialize and preview Terraform actions:

```
terraform init
terraform plan
```

Run Terraform:

```
terraform apply
```
