thor_get_nodes() {
    local app env; app=$1; role=$2; env=$3

    __usage "$env" "thor_get_nodes <thor_app> <thor_role> <thor_env>" || return 1

    curl -n "${THOR_API_ENDPOINT}/nodes/filter/app=${app}&role=${role}&env=${env}.json?shift=vars/aws_ec2/instanceId" 2>/dev/null \
      | jq '.[] | .shift_result' | gsed 's/"//g'

}
