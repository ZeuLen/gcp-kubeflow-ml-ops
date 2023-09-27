locals {
  nonprod_notifications = [
    data.terraform_remote_state.cdp-infrastructure.outputs.notification_channel_lennart.id,
    data.terraform_remote_state.cdp-infrastructure.outputs.notification_channel_dawid.id,
    ]
  rewe_ops_product_team_notifications = [
    data.terraform_remote_state.cdp-infrastructure.outputs.notification_channel_product_team.id
  ]
}
