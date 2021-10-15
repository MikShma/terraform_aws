data "template_file" "phpconfig" {
  template = file("${path.module}/wp_files/wp-conf.php")

  vars = {
    db_port = aws_db_instance.mysql.port
    db_host = aws_db_instance.mysql.address
    db_user = var.db_user
    db_pass = var.db_pass
    db_name = var.db_name
  }
}

resource "aws_db_subnet_group" "tf_db_subnet_group" {
  name       = "tf-db-subnet-group"
  subnet_ids = [var.priv_subnet_ids[2],var.priv_subnet_ids[3]]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "mysql" {
  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = var.db_name
  username               = var.db_user
  password               = var.db_pass
  parameter_group_name   = "default.mysql5.7"
  vpc_security_group_ids = [var.priv_security_group]
  db_subnet_group_name   = aws_db_subnet_group.tf_db_subnet_group.name
  skip_final_snapshot    = true
}

## Creating Launch Configuration
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
    security_groups = [var.priv_security_group]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "web_app"
    }
  }

  user_data = filebase64("${path.module}/wp_files/wp.sh")

    provisioner "file" {
    content     = data.template_file.phpconfig.rendered
    destination = "/var/www/html/wp-config.php"
  }
}

## Creating AutoScaling Group
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

  depends_on = [
    aws_db_instance.mysql,
  ]

  name = "web_app_autoscale"
  desired_capacity   = 1
  min_size           = 1
  max_size           = 2
  vpc_zone_identifier = [var.priv_subnet_ids[0],var.priv_subnet_ids[1]]
  launch_template {
    id      = aws_launch_template.web_app.id
    version = "$Latest"
  }

  health_check_type = "ELB"
  target_group_arns = [aws_lb_target_group.tf_target_gr.arn]
}

### Creating ELB
resource "aws_lb" "tf_elb" {
  name               = "tf-web-app-lb"
  load_balancer_type = "application"

  subnets  = var.subnets
  security_groups = [var.security_group]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.tf_elb.arn 
  port = 80
  protocol = "HTTP"

  // By default, return a simple 404 page
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "tf_target_gr" {
  name = "tf-target-gr"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority = 100

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tf_target_gr.arn
  }
  condition {
    path_pattern {
      values = ["*"]
    }
  }
}
