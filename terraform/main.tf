module "power_tuning" {
  source     = "./module"
  aws_region = var.region
  account_id = module.defaults.account_id
}

module "firehose_flow_logs" {
  source            = "github.com/Eaton-Vance-Corp/terraform-aws-kinesis-firehose-to-splunk-delivery-stream?ref=v2.5.3/cloudwatch_logs"
  account_alias     = module.defaults.account_alias
  account_id        = module.defaults.account_id
  business_unit     = "Infrastructure"
  region            = var.region
  splunk_index      = "cloud"
  splunk_sourcetype = "aws:cloudwatchlogs:test"
  team_prefix       = "Core Services"
}

module "cloudwatch_logs" {
  source         = "github.com/Eaton-Vance-Corp/terraform-aws-cloudwatch-logs-to-kinesis-firehose-subscription-filter?ref=v1.0.0"
  firehose_arn   = module.firehose_flow_logs.kinesis_firehose_delivery_stream.arn
  log_group_name = "dev-vpc-flow-logs"
  region         = var.region
}
