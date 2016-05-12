awsreset() {
   unset AWS_PROFILE
   unset AWS_REGION
   unset AWS_DEFAULT_REGION
   unset AWS_ACCESS_KEY_ID
   unset AWS_SECRET_ACCESS_KEY

   rm -f ~/.boto
}

awsprofile() {
   local awscli_profile; awscli_profile=$1
   local region access_key access_secret

   __usage "$awscli_profile" "awsprofile <profile_from_aws_config>" || return 1

   region=`$SED -n "/\[profile ${awscli_profile}\]/,/\[profile .*\]/p" ~/.aws/config | grep region | $AWK -F'=' '{print $2}' | $SED 's/ //g'`
   access_key=`$SED -n "/\[profile ${awscli_profile}\]/,/\[profile .*\]/p" ~/.aws/config | grep aws_access_key_id | $AWK -F'=' '{print $2}' | $SED 's/ //g'`
   access_secret=`$SED -n "/\[profile ${awscli_profile}\]/,/\[profile .*\]/p" ~/.aws/config | grep aws_secret_access_key | $AWK -F'=' '{print $2}' | $SED 's/ //g'`

   if [ "x$access_secret" = "x" ] || [ "x$access_key" = "x" ]; then
       echo "*** Bad profile"
       return 127
   fi

   awsreset

   export AWS_PROFILE=$awscli_profile
   export AWS_ACCESS_KEY_ID=$access_key
   export AWS_SECRET_ACCESS_KEY=$access_secret

   echo -e "[DynamoDB]\nregion = $region" > ~/.boto

   [ "x$region" != "x" ] && export AWS_DEFAULT_REGION=$region
}

awscli_profiles=`grep '\[profile' ~/.aws/config | $SED 's/\[profile \(.*\)\]/\1/'`
complete -W "$awscli_profiles" awsprofile
