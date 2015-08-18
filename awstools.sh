cloudwatch_cleanup() {
  aws cloudwatch describe-alarms --state-value INSUFFICIENT_DATA \
  | jq .MetricAlarms[].AlarmName \
  | sed 's/"//g' \
  | xargs -n 100 aws cloudwatch delete-alarms --alarm-names
}
