scalewayreset() {
   unset SCALEWAY_ORGANIZATION
   unset SCALEWAY_TOKEN
}

scalewayprofile() {
   local scaleway_profile; scaleway_profile=$1

   __usage "$scaleway_profile" "scalewayprofile <profile_from ~/.scaleway_config>" || return 1

   organization=`$SED -n "/\[profile ${scaleway_profile}\]/,/\[profile .*\]/p" ~/.scaleway_config | grep organization | $AWK -F'=' '{print $2}' | $SED 's/ //g'`
   token=`$SED -n "/\[profile ${scaleway_profile}\]/,/\[profile .*\]/p" ~/.scaleway_config | grep token | $AWK -F'=' '{print $2}' | $SED 's/ //g'`

   if [ "x$organization" = "x" ] || [ "x$token" = "x" ]; then
       echo "*** Bad profile in ~/.scaleway_config"
       return 127
   fi

   scalewayreset

   [ "x$organization" != "x" ] && export SCALEWAY_ORGANIZATION=$organization
   [ "x$token" != "x" ] && export SCALEWAY_TOKEN=$token
}

scaleway_profiles=`grep '\[profile' ~/.scaleway_config | $SED 's/\[profile \(.*\)\]/\1/'`
complete -W "$scaleway_profiles" scalewayprofile
