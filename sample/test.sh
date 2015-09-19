vagrant up
./bin/knife zero bootstrap $VAGRANT_CENTOS -N centos.example -y
./bin/knife zero bootstrap $VAGRANT_UBUNTU -N ubuntu.example -y
./bin/knife node run_list add centos.example errbit-server
./bin/knife node run_list add ubuntu.example errbit-server
./bin/knife zero converge 'hostname:*' -a knife_zero.host
