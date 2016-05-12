urlencode() {
  local str; str="$@"

  perl -MURI::Escape -e "print uri_escape('${str}')"
}

repomgr_delete_pkg() {
    local repo rpm; repo=$1; rpm=$2
    local arch

    __usage "$rpm" "repomgr_delete_pkg <app_name> <rpm>" || return 1

    arch=`echo $rpm | $AWK -F'.' '{print $(NF-1)}'`
    echo curl --cacert "$REPOCERT" -u "$REPOUSER" -X DELETE ${REPOSERVER}/v1/thor/app-${repo}/${arch}/`urlencode $(basename $rpm)`
    curl --cacert "$REPOCERT" -u "$REPOUSER" -X DELETE ${REPOSERVER}/v1/thor/app-${repo}/${arch}/`urlencode $(basename $rpm)`
}

repomgr_add_pkg() {
    local repo rpm; repo=$1; rpm=$2

    __usage "$rpm" "repomgr_add_pkg <app_name> <rpm>" || return 1
	  repopost.sh $REPOSERVER/v1/thor/app-$repo $rpm
}
