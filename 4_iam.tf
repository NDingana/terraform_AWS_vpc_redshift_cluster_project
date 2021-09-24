/*
• Roles can give users / services (temporary) access that they normally wouldn’t have
• The roles can be for instance attached to EC2 instances
• From that instance, a user or service can obtain access credentials
• Using those access credentials the user or service can assume the role, 
  which gives them permission to do something.
*/


# Let’s create a role now that we want to attach to an EC2 instance:
# • You create a role s3-bucket-role and assign the role to an EC2 instance at boot time
# • You give the role the permissions for read only access for all resources 
resource "aws_iam_role" "s3-bucket-role" {
  name               = "s3-bucket-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}


# Now we need to add some permissions using a policy document:
resource "aws_iam_role_policy" "s3-bucket-role-policy" {
  name = "s3-mybucket-role-policy"
  role = aws_iam_role.s3-bucket-role.id

# iam role with s3 read only access for all resources 

/*
Error: Error putting IAM role policy s3-mybucket-role-policy: 
MalformedPolicyDocument: Policy document should not specify a principal.
*/

# ‘Action’ – ‘s3:GetObject’ aka Get a file (in S3-speak all files are ‘objects’); 

/*
"Resource": :The "Which" aka `Resource`
Which Resource can our Principal take Action on? It's our target. The most general target of all is just:
"Resource": "*"  This means everything. Apply this to EVERYTHING.
*/
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowPublicRead",
            "Effect": "Allow",
            "Action": [
              "s3:GetObject"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF

}

# aws_iam_instance_profile is what we will use to attach it to our ec2 instance
resource "aws_iam_instance_profile" "s3-mybucket-role-instanceprofile" {
  name = "s3-bucket-role"
  role = aws_iam_role.s3-bucket-role.name
}


