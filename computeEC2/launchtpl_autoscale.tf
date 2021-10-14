
resource "aws_launch_template" "web_app" {
  name = "web_app"

  image_id = data.aws_ami.server_ami.id

  instance_type = var.instance_type

  key_name = aws_key_pair.tf_auth.id

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups = [var.security_group]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "web_app"
    }
  }

  user_data = filebase64(templatefile("${path.module}/userdata.tpl", {firewall_subnets = var.subnet_ips[0]}))
}

resource "aws_autoscaling_policy" "example" {
  name = "cpu_autoscale_policy"
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 40.0
  }
  autoscaling_group_name  = aws_autoscaling_group.web_app.name
}

resource "aws_autoscaling_group" "web_app" {
  name = "web_app_autoscale"
  desired_capacity   = 1
  min_size           = 1
  max_size           = 2
  vpc_zone_identifier = [var.subnets[0],var.subnets[1]]
  launch_template {
    id      = aws_launch_template.web_app.id
    version = "$Latest"
  }
}