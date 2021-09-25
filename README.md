Any info relevant to the project here:

#############################################################################################################
################################# simple ec2 test in public_subnet_1 ########################################
#############################################################################################################

resource "aws_instance" "public_ec2_in_public_subnet_1" {

  # add ingress rule for port 80 to test ec2
  
  ami                    = "ami-0ff8a91507f77f867"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2_public_security_group.id]
  subnet_id              = aws_subnet.public_subnet_1.id

  # role:
  iam_instance_profile = aws_iam_instance_profile.s3_readOnly_instance_profile.name

  # create a test server to see if it is reachable on port 5439
  user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install -y nginx
                sudo mv /usr/share/nginx/html/index.html /usr/share/nginx/html/index-orig.html
                echo "This is Nginx server from Terraform passed by user-data.sh " > /usr/share/nginx/html/index.html
                sudo service nginx start
                EOF

  tags = {
    Name = "public_ec2_in_public_subnet_1"
  }

  lifecycle {
    create_before_destroy = true
    }

  depends_on = [aws_vpc.mainvpc, aws_subnet.public_subnet_1, aws_security_group.ec2_public_security_group]
}