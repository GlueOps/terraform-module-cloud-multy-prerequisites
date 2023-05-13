locals {
  users_set                = toset(var.users)
  cluster_environments_set = toset(var.cluster_environments)
  time_zone                = "Africa/Monrovia"
}

data "opsgenie_user" "users" {
  for_each = local.users_set
  username = each.key
}

resource "opsgenie_team" "teams" {
  for_each = local.cluster_environments_set

  name                     = "${var.tenant_key}-${each.value}-team"
  description              = "This is for company ${var.tenant_key} in the ${each.value} environment"
  delete_default_resources = true

  dynamic "member" {
    for_each = data.opsgenie_user.users

    content {
      id   = member.value.id
      role = "user"
    }
  }
}

resource "opsgenie_team_routing_rule" "routing_rules" {
  for_each = local.cluster_environments_set

  name     = "${var.tenant_key}-${each.value}-routing-rule"
  team_id  = opsgenie_team.teams[each.key].id
  order    = 0
  timezone = local.time_zone
  criteria {
    type = "match-all"
  }
  notify {
    name = opsgenie_schedule.schedules[each.key].name
    type = "schedule"
  }

}

resource "opsgenie_schedule" "schedules" {
  for_each = local.cluster_environments_set

  name          = "${var.tenant_key}-${each.value}-schedule"
  description   = "This is for company ${var.tenant_key} in the ${each.value} environment"
  timezone      = local.time_zone
  owner_team_id = opsgenie_team.teams[each.key].id
  enabled       = true
}

resource "opsgenie_schedule_rotation" "rotations" {
  for_each = local.cluster_environments_set

  schedule_id = opsgenie_schedule.schedules[each.key].id
  name        = "${var.tenant_key}-${each.value}-rotation"

  dynamic "participant" {
    for_each = data.opsgenie_user.users

    content {
      type = "user"
      id   = participant.value.id
    }
  }

  start_date = "2023-03-14T09:00:00Z" # Set the start date and time for the rotation
  type       = "weekly"
  length     = 1
}

resource "opsgenie_api_integration" "prometheus" {
  for_each = local.cluster_environments_set
  name     = "${var.tenant_key}-${each.value}-prometheus-api-int"
  type     = "API"

  responders {
    type = "team"
    id   = opsgenie_team.teams[each.key].id
  }

  enabled                        = true
  allow_write_access             = true
  ignore_responders_from_payload = true
  suppress_notifications         = false
  owner_team_id                  = opsgenie_team.teams[each.key].id
}

output "opsgenie_prometheus_api_keys" {
  value = {
    for env_key, env_value in local.cluster_environments_set : env_key => opsgenie_api_integration.prometheus[env_key].api_key
  }
  description = "A map of the Opsgenie API keys for the Prometheus integrations."
}
