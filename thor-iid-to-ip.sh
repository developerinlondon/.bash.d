thor_iid_to_ip() {
    local iid; iid=$1

    __usage "$iid" "thor_iid_to_ip <instance_id>" || return 1

   curl -n "${THOR_API_ENDPOINT}/aws/${iid}.json" 2>/dev/null \
      | jq '.private_ip' | $SED 's/"//g'
}


