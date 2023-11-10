resource "opsgenie_heartbeat" "captain" {
  for_each       = local.cluster_environments_set
  name           = "${each.value}.${var.domain}"
  description    = "${each.value}.${var.domain}"
  interval_unit  = "minutes"
  interval       = 3
  enabled        = true
  alert_priority = "P1"
  alert_message  = "Heartbeat Expired: ${each.value}.${var.domain}"
  owner_team_id  = opsgenie_team.teams[each.key].id
}
