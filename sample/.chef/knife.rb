cookbook_path    ["cookbooks", "site-cookbooks"]
node_path        "nodes"
role_path        "roles"
environment_path "environments"
data_bag_path    "data_bags"
#encrypted_data_bag_secret "data_bag_key"

knife[:berkshelf_path] = "cookbooks"
knife[:ssh_user] = "vagrant"
knife[:use_sudo] = true

local_mode true

validation_key "/etc/chef/validation.pem"
