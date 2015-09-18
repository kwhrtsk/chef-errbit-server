Tested with:

* OSX Yosemite
* Ruby 2.2.2
* Vagrant 1.7.4
* VirtualBox 5.0.0r101573

```
source .envrc
# export $VAGRANT_PRIVATE_NETWORK_IP=192.168.33.10
```

```
cat <<EOF>> ~/.ssh/config
# Vagrant private network ip
Host 192.168.33.*
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  LogLevel FATAL
  User vagrant
  IdentityFile ~/.vagrant.d/insecure_private_key
EOF
```

```
bundle install --path=vendor/bundle
bundle binstubs berkshelf chef
./bin/berks vendor cookbooks/
vagrant up
```

```
# knife-zero
./bin/knife zero bootstrap $VAGRANT_PRIVATE_NETWORK_IP -N $VAGRANT_PRIVATE_NETWORK_IP
./bin/knife node from file node.json
./bin/knife zero chef_client "name:*" -a knife_zero.host
```

```
# knife-solo
./bin/knife solo bootstrap $VAGRANT_PRIVATE_NETWORK_IP
./bin/knife node run_list add $VAGRANT_PRIVATE_NETWORK_IP errbit-server
./bin/knife solo cook $VAGRANT_PRIVATE_NETWORK_IP
```

```
# check out initial user crendential
vagrant ssh -- cat /opt/errbit/bootstrap.out
```
