Tested with:

* OSX Yosemite
* Ruby 2.2.2
* Vagrant 1.7.4
* VirtualBox 5.0.0r101573

```
source .envrc
# export $VAGRANT_CENTOS=192.168.33.10
# export $VAGRANT_UBUNTU=192.168.33.11
```

Use `VAGRANT_UBUNTU` if you like ubuntu in the following operations.

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
./bin/knife zero bootstrap $VAGRANT_CENTOS -N $VAGRANT_CENTOS
./bin/knife node from file node.json
./bin/knife zero chef_client "name:*" -a knife_zero.host
```

```
# knife-solo
./bin/knife solo bootstrap $VAGRANT_CENTOS
./bin/knife node run_list add $VAGRANT_CENTOS errbit-server
./bin/knife solo cook $VAGRANT_CENTOS
```

```
# check out initial user crendential
vagrant ssh -- cat /opt/errbit/bootstrap.out
```
