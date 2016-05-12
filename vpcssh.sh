vpcssh() {
    local ip cmd; ip=$1
    shift; cmd="$@"
    local iid subnet_id nat_instance_id nat_ip h run ssh now

    __usage "$ip" "vpcssh <ip|instance_id|thor_hostname>" || return 1

    if [ "x$AWS_ACCESS_KEY_ID" = "x" ]; then
      echo "*** AWS named profile is not loaded, please run 'awsprofile <your_named_profile>' first"
      return 127
    fi

    if [ "x$THOR_USERNAME" = "x" ]; then
      echo "*** THOR_USERNAME undefined, please export it in your ~/.bashrc"
      return 127
    fi

    if [ `echo "$ip" | cut -c 1-2` = "i-" ]; then
      iid=$ip
      ip=`curl -n "${THOR_API_ENDPOINT}/aws/${iid}.json" 2>/dev/null \
        | jq '.private_ip' | $SED 's/"//g'`
    elif [[ $ip = *.locn.s.nokia.com ]]; then
      h=$ip
      ip=`curl -n "${THOR_API_ENDPOINT}/nodes/${h}?shift=/vars/aws_ec2/privateIpAddress" 2>/dev/null \
        | jq '.shift_result' | $SED 's/"//g'`
    fi

    grep -q "${ip}$" ~/.ssh/config
    if [ $? -ne 0 ]; then
        subnet_id=`aws ec2 describe-instances --filters Name=private-ip-address,Values=${ip} \
          | jq '.Reservations[] | .Instances[] | .NetworkInterfaces[] | .SubnetId' \
          | tr -d '"' | tr -d "\n"`
        nat_instance_id=`aws ec2 describe-route-tables --filters Name=association.subnet-id,Values=${subnet_id} \
          | jq '.RouteTables[] | .Routes[] | select(.DestinationCidrBlock == "0.0.0.0/0") | .InstanceId' \
          | tr -d '"' | tr -d "\n"`
        nat_ip=`aws ec2 describe-instances --instance-ids ${nat_instance_id} \
          | jq '.Reservations[] | .Instances[] | .PublicIpAddress' \
          | tr -d '"' | tr -d "\n"`

        # echo "subnet_id       = $subnet_id"
        # echo "nat_isntance_id = $nat_instance_id"
        # echo "nat_ip          = $nat_ip"
        #
        if [ "x$subnet_id" = "x" ] || [ "x$nat_instance_id" = "x" ] || [ "x$nat_ip" = "x" ]; then
            echo "*** At least one AWS query failed"
            return 127
        fi

        grep -q $nat_ip ~/.ssh/config
        if [ $? -ne 0 ]; then
            now=`date '+%Y-%m-%d, %H:%M'`
            cat <<EOF >> ~/.ssh/config
# --> NAT host for $subnet_id, added by vpcssh on $now
Host $nat_ip
  ForwardAgent yes
  User $THOR_USERNAME
# <--
EOF
        fi

        ssh -t $nat_ip '[ -x /usr/bin/nc ] || sudo yum install -y nc'

        cat <<EOF >> ~/.ssh/config
# --> added by vpcssh on $now
Host $ip
  User $THOR_USERNAME
  ProxyCommand  ssh ${THOR_USERNAME}@$nat_ip nc %h %p
# <--
EOF
    fi

    if [ "x`type run_autossh`" = "x" ]; then
      ssh="ssh"
    else
      ssh="run_autossh"
    fi

    if [ "x${cmd}" = "x" ]; then
      run="$ssh $ip"
    else
      run="$ssh $ip $cmd"
    fi
    if [ "x$TMUX" != "x" ]; then
      tmux rename-window "$ip"
      $run
      tmux set-window-option automatic-rename "on" 1>/dev/null
    else
      $run
    fi
}


