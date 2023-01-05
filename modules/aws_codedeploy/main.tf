locals {
  # auto_rollback_configuration_enabled = var.auto_rollback_configuration_events != null && length(var.auto_rollback_configuration_events) > 0
  iam_role                    = length(var.service_role_arn) > 0 ? var.service_role_arn : var.iam_create_role ? module.iam_role[0].iam_role_arn : ""
  iam_custom_role_policy_arns = var.iam_policies_create ? concat(var.iam_custom_role_policy_arns, module.iam_policies[0].list_of_policy_arns) : var.iam_custom_role_policy_arns
}

# resource "aws_codedeploy_app" "this" {
#   count            = var.create ? 1 : 0
#   compute_platform = var.compute_platform
#   name             = "d-${var.name}-${var.environment}"

#   tags = var.tags
# }

# resource "aws_codedeploy_deployment_group" "this" {
#   count                  = var.create ? 1 : 0
#   app_name               = "d-${var.name}-${var.environment}"
#   deployment_config_name = var.code_deploy_strategy
#   deployment_group_name  = "dg-${var.name}-${var.environment}"
#   service_role_arn       = local.iam_role

#   dynamic "auto_rollback_configuration" {
#     for_each = local.auto_rollback_configuration_enabled ? [1] : [0]

#     content {
#       enabled = local.auto_rollback_configuration_enabled
#       events  = [var.auto_rollback_configuration_events]
#     }
#   }

#   dynamic "blue_green_deployment_config" {
#     for_each = var.blue_green_deployment_config == null ? [] : [var.blue_green_deployment_config]
#     content {
#       dynamic "deployment_ready_option" {
#         for_each = lookup(blue_green_deployment_config.value, "deployment_ready_option", null) == null ? [] : [lookup(blue_green_deployment_config.value, "deployment_ready_option", {})]

#         content {
#           action_on_timeout    = lookup(deployment_ready_option.value, "action_on_timeout", null)
#           wait_time_in_minutes = lookup(deployment_ready_option.value, "wait_time_in_minutes", null)
#         }
#       }

#       dynamic "green_fleet_provisioning_option" {
#         for_each = lookup(blue_green_deployment_config.value, "green_fleet_provisioning_option", null) == null ? [] : [lookup(blue_green_deployment_config.value, "green_fleet_provisioning_option", {})]

#         content {
#           action = lookup(green_fleet_provisioning_option.value, "action", null)
#         }
#       }

#       dynamic "terminate_blue_instances_on_deployment_success" {
#         for_each = lookup(blue_green_deployment_config.value, "terminate_blue_instances_on_deployment_success", null) == null ? [] : [lookup(blue_green_deployment_config.value, "terminate_blue_instances_on_deployment_success", {})]

#         content {
#           action                           = lookup(terminate_blue_instances_on_deployment_success.value, "action", null)
#           termination_wait_time_in_minutes = lookup(terminate_blue_instances_on_deployment_success.value, "termination_wait_time_in_minutes", null)
#         }
#       }
#     }
#   }

#   dynamic "deployment_style" {
#     for_each = var.deployment_style == null ? [] : [var.deployment_style]

#     content {
#       deployment_option = deployment_style.value.deployment_option
#       deployment_type   = deployment_style.value.deployment_type
#     }
#   }

#   dynamic "ecs_service" {
#     for_each = var.ecs_service == null ? [] : var.ecs_service

#     content {
#       cluster_name = ecs_service.value.cluster_name
#       service_name = ecs_service.value.service_name
#     }
#   }

#   dynamic "load_balancer_info" {
#     for_each = var.load_balancer_info == null ? [] : [var.load_balancer_info]

#     content {
#       dynamic "elb_info" {
#         for_each = lookup(load_balancer_info.value, "elb_info", null) == null ? [] : [load_balancer_info.value.elb_info]

#         content {
#           name = elb_info.value.name
#         }
#       }

#       dynamic "target_group_info" {
#         for_each = lookup(load_balancer_info.value, "target_group_info", null) == null ? [] : [load_balancer_info.value.target_group_info]

#         content {
#           name = target_group_info.value.name
#         }
#       }

#       dynamic "target_group_pair_info" {
#         for_each = lookup(load_balancer_info.value, "target_group_pair_info", null) == null ? [] : [load_balancer_info.value.target_group_pair_info]

#         content {

#           dynamic "prod_traffic_route" {
#             for_each = lookup(target_group_pair_info.value, "prod_traffic_route", null) == null ? [] : [target_group_pair_info.value.prod_traffic_route]

#             content {
#               listener_arns = prod_traffic_route.value.listener_arns
#             }
#           }

#           dynamic "target_group" {
#             for_each = lookup(target_group_pair_info.value, "target_group", null) == null ? [] : [target_group_pair_info.value.target_group]

#             content {
#               name = target_group.value.name
#             }
#           }

#           dynamic "target_group" {
#             for_each = lookup(target_group_pair_info.value, "blue_target_group", null) == null ? [] : [target_group_pair_info.value.blue_target_group]

#             content {
#               name = target_group.value.name
#             }
#           }

#           dynamic "target_group" {
#             for_each = lookup(target_group_pair_info.value, "green_target_group", null) == null ? [] : [target_group_pair_info.value.green_target_group]

#             content {
#               name = target_group.value.name
#             }
#           }

#           dynamic "test_traffic_route" {
#             for_each = lookup(target_group_pair_info.value, "test_traffic_route", null) == null ? [] : [target_group_pair_info.value.test_traffic_route]

#             content {
#               listener_arns = test_traffic_route.value.listener_arns
#             }
#           }
#         }
#       }
#     }
#   }

#   dynamic "trigger_configuration" {
#     for_each = var.sns_topic_arn == null ? [0] : [1]

#     content {
#       trigger_events     = var.trigger_events
#       trigger_name       = var.trigger_name
#       trigger_target_arn = var.sns_topic_arn
#     }
#   }

#   lifecycle {
#     ignore_changes = [
#       # blue_green_deployment_config,
#       autoscaling_groups,
#       tags
#     ]
#   }

#   depends_on = [
#     aws_codedeploy_app.this
#   ]

#   tags = var.tags
# }

module "iam_role" {
  count                   = var.iam_create_role ? 1 : 0
  source                  = "github.com/bee7ch7/aws/iam/iam-assumable-role//."
  create_role             = var.iam_create_role
  role_name               = var.iam_role_name
  role_requires_mfa       = var.iam_role_requires_mfa
  trusted_role_services   = var.iam_trusted_role_services
  custom_role_policy_arns = local.iam_custom_role_policy_arns

  depends_on = [
    module.iam_policies
  ]

  tags = var.tags
}

module "iam_policies" {
  count    = var.iam_policies_create && length(var.iam_policies) > 0 ? 1 : 0
  source   = "github.com/bee7ch7/aws/iam/iam-policy//."
  policies = var.iam_policies
}
