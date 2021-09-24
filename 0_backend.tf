
/*
Always create your s3 bucket and dynamodb_table for backend.tf manually from console, 
because these are hightly sensitive files and you do not want that managed by terrform.
IF terraform manages them, it can easilty be accidentally deleted, which will be disastrous. 

Always use partition key as lock ID for dynamoDn
*/


terraform {
  backend "s3" {
    #Code for uploading .tfstate to Remote s3 bucket

    #Name of s3 bucket you created

    bucket = "daniel-dev-tfstate-09-23-2021"

    #  bucket = "Mary-dev=tfstate-04/terraform.tfstate"

    # A bucket is a container (web folder) for objects (files) stored in Amazon S3. 
    # Files are identified by a key (filename). 
    # and each object is identified by a unique user-specified key (filename).

    # bucket= folder && file_name=key && file_Content(the file itself) = object

    key = "infraLayer/infrastructure.tfstate"

    # Even though the namespace for Amazon S3 buckets is global,
    # each Amazon S3 bucket is created in a specific region that you choose.
    # This lets you control where your data is stored.
    # You control the location of your data; 
    # data in an Amazon S3 bucket is stored in that region unless you 
    # explicitly copy it to another bucket located in a different region.
    region = "us-east-1"

  }
}

#https://www.terraform.io/docs/backends/types/s3.html