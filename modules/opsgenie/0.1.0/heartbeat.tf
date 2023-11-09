resource "opsgenie_heartbeat" "captain" {
  for_each      = local.cluster_environments_set
  name          = "${each.value}.${var.tenant_key}.${var.domain}"
  description   = "${each.value}.${var.tenant_key}.${var.domain}"
  interval_unit = "minutes"
  interval      = 2
  enabled       = true
  alert_message = "Heartbeat Expired: ${each.value}.${var.tenant_key}.${var.domain}"
  owner_team_id = opsgenie_team.teams[each.key].id
}
