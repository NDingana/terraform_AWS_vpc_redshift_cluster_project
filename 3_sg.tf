
#############################################################################################################
############################## ec2_public_security_group ####################################################
#############################################################################################################

resource "aws_security_group" "ec2_public_security_group" {

  description = "Internet reaching access for public ec2s"
  vpc_id      = aws_vpc.mainvpc.id

  /*
  Ingress refers to unsolicited inbound traffic sent from an address in public internet to the private network – 
  it is not a response to a request initiated by an inside system. In this case, firewalls are designed 
  to decline this request unless there are specific policy and configuration that allows ingress connections. 
  */

  ingress {
    from_port       = 5439
    to_port         = 5439
    protocol        = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
  }



  /*Outbound rule:
Generally speaking you do not want to control traffic going out of from your VPC . 
You want allow all traffic out by default so that's the reason the egress rule is 
from_port 0 to_port 0 which means all ports.
so it's allowing all the traffic going out from this particular instance.
 */
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2_public_security_group"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_vpc.mainvpc]
}

#############################################################################################################
############################## ec2_private_security_group ####################################################
#############################################################################################################

resource "aws_security_group" "ec2_private_security_group" {

  description = "Only allow public SG resources to access private instances"

  vpc_id = aws_vpc.mainvpc.id

  /* Inboud rule: 
You want allow all traffic only from the public resources (public subnet). 
from_port 0 to_port 0 which means all ports and protocol =-1 means all protocols
so it's allowing all IP from all ports on all protocalls coming from the the public security group.

It is a good practice that when you have ec2 instances behind another ec2 instance,
then when you create the security group of the ec2 that is in the back, 
you should mention the security group of the ec2 that is infront of it, hence why we have the line below
security_groups = ["${aws_security_group.ec2_public_security_group.id}"]
*/
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.ec2_public_security_group.id}"]
  }

  /*Outbound rule:
Generally speaking you do not want to control traffic going out of from your VPC . 
You want allow all traffic out by default so that's the reason the egress rule is 
from_port 0 to_port 0 which means all ports.
so it's allowing all the traffic going out from this particular instance.
 */
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2_private_security_group"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_vpc.mainvpc, aws_security_group.ec2_public_security_group]
}

