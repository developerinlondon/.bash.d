thor_get_nat_ips() {
    local app env; app=$1; env=$2

    __usage "$env" "thor_get_nat_ips <thor_app> <thor_env>" || return 1

    curl -n "${THOR_API_ENDPOINT}/nodes/filter/app=${app}&role=aws_ha_nat&env=${env}.json?shift=vars/aws_ec2/ipAddress" 2>/dev/null \
      | jq '.[] | .shift_result' | sed 's/"//g'
}
