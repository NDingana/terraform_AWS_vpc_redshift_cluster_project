
# Here will be the variables that we want to use say for say Production or anything you want to call it

# Here I will define(give then values) variables that have a corresponding variable declaration in var.tf files.
# The varibles defined here MUST have a matching corresponding variable declaration in var.tf files 

# the production production.tfvars file will be passed with the $ terraform apply command on the command line

# This is one way we can segment our variables for different environments. we pass the  production.tfvars  file like so:

# To set lots of variables, it is more convenient to specify their values in a variable definitions file
#  (with a filename ending in either .tfvars or .tfvars.json) and then specify that file on the command line with -var-file:

terraform plan -var-file 0_production.tfvars 
# or
terraform plan -var-file="0_production.tfvars"

terraform apply -var-file 0_production.tfvars --auto-approve

terraform destroy -var-file 0_production.tfvars --auto-approve


# $ terraform apply -var-file="var-file-path" -var="some-var=some-value"

# $ terraform init -backend-config="backend-config-file-path"


