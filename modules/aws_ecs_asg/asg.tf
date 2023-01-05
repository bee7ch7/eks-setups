resource "aws_appautoscaling_target" "this" {
  for_each           = var.ecs_appasg_list
  max_capacity       = each.value.max_capacity
  min_capacity       = each.value.min_capacity
  resource_id        = "service/${var.ecs_cluster_name}/${each.value.ecs_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  for_each           = var.ecs_appasg_list
  name               = each.value.memory.name
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this[each.value.name].resource_id
  scalable_dimension = aws_appautoscaling_target.this[each.value.name].scalable_dimension
  service_namespace  = aws_appautoscaling_target.this[each.value.name].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = each.value.memory.target_value
    scale_in_cooldown  = each.value.memory.scale_in_cooldown
    scale_out_cooldown = each.value.memory.scale_out_cooldown
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  for_each           = var.ecs_appasg_list
  name               = each.value.cpu.name
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this[each.value.name].resource_id
  scalable_dimension = aws_appautoscaling_target.this[each.value.name].scalable_dimension
  service_namespace  = aws_appautoscaling_target.this[each.value.name].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = each.value.cpu.target_value
    scale_in_cooldown  = each.value.cpu.scale_in_cooldown
    scale_out_cooldown = each.value.cpu.scale_out_cooldown
  }
}
