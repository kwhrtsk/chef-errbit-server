Tested with:

* OSX Yosemite
* Ruby 2.2.2
* Vagrant 1.7.2
* VirtualBox 4.3.26

```
source .envrc
# export $VAGRANT_PRIVATE_NETWORK_IP=192.168.33.10
```

```
bundle install --path=vendor/bundle
bundle binstubs berkshelf chef
./bin/berks vendor cookbooks/
vagrant up
```

```
# knife-zero
./bin/knife zero bootstrap --sudo -x vagrant -i .vagrant/machines/default/virtualbox/private_key $VAGRANT_PRIVATE_NETWORK_IP -N $VAGRANT_PRIVATE_NETWORK_IP
./bin/knife node from file node.json
./bin/knife zero chef_client "name:*" -a chef_ip -x vagrant --identity-file ./.vagrant/machines/default/virtualbox/private_key --sudo
```

```
# knife-solo
./bin/knife solo bootstrap $VAGRANT_PRIVATE_NETWORK_IP --identity-file .vagrant/machines/default/virtualbox/private_key -x vagrant
./bin/knife node run_list add $VAGRANT_PRIVATE_NETWORK_IP errbit-server
./bin/knife solo cook -i .vagrant/machines/default/virtualbox/private_key vagrant@$VAGRANT_PRIVATE_NETWORK_IP
```

```
# check out initial user crendential
vagrant ssh -- cat /opt/errbit/bootstrap.out
```
