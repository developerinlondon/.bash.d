thor_copy_config() {
    local from_config to_config; from_config=$1; to_config=$2

    __usage "$to_config" "thor_copy_config <tag1=value1&tag2=value2...> <tag1=value1&tag2=value2...>" || return 1

    curl -k -n -X PUT -d '' "${THOR_API_ENDPOINT}/configs/${from_config}/clone/${to_config}.yaml?force=true"
}

thor_rename_config() {
    local from_config to_config; from_config=$1; to_config=$2

    __usage "$to_config" "thor_rename_config <tag1=value1&tag2=value2...> <tag1=value1&tag2=value2...>" || return 1

    curl -n -X PUT -d '' "${THOR_API_ENDPOINT}/configs/${from_config}/rename/${to_config}.yaml"
}

thor_delete_config() {
    local config; config=$1

    __usage "$config" "thor_delete_config <tag1=value1&tag2=value2...>" || return 1

    curl -n -k -X DELETE -d '' "${THOR_API_ENDPOINT}/configs/${config}.yaml"
}
