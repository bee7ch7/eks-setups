resource "aws_ecs_service" "this" {
  name                               = "${var.service_name}-service-${var.environment}"
  cluster                            = var.cluster_id
  iam_role                           = var.iam_role
  task_definition                    = var.task_definition
  desired_count                      = var.desired_count
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent
  launch_type                        = var.launch_type
  health_check_grace_period_seconds  = var.load_balancer_enabled == true ? var.health_check_grace_period_seconds : 0
  force_new_deployment               = var.force_new_deployment
  enable_execute_command             = var.enable_execute_command

  dynamic "service_registries" {
    for_each = var.ecs_service_registries
    content {
      registry_arn = service_registries.value.registry_arn
      # port            = lookup(service_registries.value, "port", null)
      container_port = lookup(service_registries.value, "container_port", null)
      container_name = lookup(service_registries.value, "container_name", null)
    }
  }

  dynamic "load_balancer" {
    for_each = var.ecs_load_balancers
    content {
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
      target_group_arn = lookup(load_balancer.value, "target_group_arn", null)
    }
  }

  dynamic "network_configuration" {
    for_each = var.network_mode == "awsvpc" ? ["true"] : []
    content {
      security_groups  = var.security_groups
      subnets          = var.subnet_ids
      assign_public_ip = var.assign_public_ip
    }
  }

  deployment_controller {
    type = var.deployment_type
  }

  lifecycle {
    ignore_changes = [
      task_definition,
      load_balancer
      # task_definition,
      # desired_count,
      # load_balancer
    ]
  }
}
