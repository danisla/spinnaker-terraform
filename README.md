
# Setup

Export the Google SDK environment variables for Terraform:

```
export GOOGLE_REGION=$(gcloud config get-value compute/region)
export GOOGLE_PROJECT=$(gcloud config get-value project)
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
