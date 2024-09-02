#######################################################################
## Get the default VPC reference in the region to stay within free tier
#######################################################################
data "aws_vpc" "resources_vpc" {
  id = var.vpc_id
}

data "aws_subnets" "vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

}


############################################
## Create the SSH key pair for EC2 instances
############################################
resource "aws_key_pair" "ssh-ec2-keypair" {
  key_name   = "${var.common_prefix}-ecs-ec2-keypair"
  public_key = var.public_ec2_key

  tags = local.common_tags
}

############################################
## AMI Id to use for the ASG launch template
############################################
data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-kernel-5.10-hvm-*-x86_64-ebs"]
  }

  owners = ["amazon"]
}

########################################################################################################################
## Launch template for all EC2 instances that are part of the ECS cluster
########################################################################################################################

resource "aws_launch_template" "ecs_launch_template" {
  name                   = "${var.common_prefix}-ecs-launch-template"
  image_id               = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ssh-ec2-keypair.key_name
  user_data              = base64encode(data.template_file.user_data.rendered)
  vpc_security_group_ids = [aws_security_group.ec2.id]

  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2_instance_role_profile.arn
  }


    tags = local.common_tags

}

##############################################################
## User data needs to be added to ECS controlled EC2 instances
##############################################################
data "template_file" "user_data" {
  template = file("user_data.sh")

  vars = {
    ecs_cluster_name = aws_ecs_cluster.ecs_cluster.name
  }
}

########################################################################################################################
## Creates an ASG linked with our main VPC
########################################################################################################################

resource "aws_autoscaling_group" "ecs_autoscaling_group" {
  name                  = "${var.common_prefix}-asg"
  max_size              = var.autoscaling_max_size
  min_size              = var.autoscaling_min_size
  vpc_zone_identifier   = data.aws_subnets.vpc_subnets.ids
  health_check_type     = "EC2"
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]

  launch_template {
    id      = aws_launch_template.ecs_launch_template.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.common_prefix}-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "AmazonECSManaged"
    value = true
    propagate_at_launch = true
  }
}