# Cookbook Name:: errbit-server
# Recipe:: bootstrap
#
# Copyright 2015, Kawahara Taisuke
#
# MIT License
#

include_recipe "errbit-server::rbenv"

execute "rake errbit:bootstrap to create admin user" do
  command "bundle exec rake errbit:bootstrap > /opt/errbit/bootstrap.out"
  cwd "/opt/errbit/current"
	environment node['errbit']['environment']
  creates "/opt/errbit/bootstrap.out"
end
