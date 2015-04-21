# Cookbook Name:: errbit-server
# Recipe:: bootstrap
#
# Copyright 2015, Kawahara Taisuke
#
# MIT License
#

include_recipe "errbit-server::rbenv"

_environment = node['errbit']['environment'].dup
_ruby_version = node['errbit']['ruby_version']
_environment["RBENV_VERSION"] = _ruby_version

execute "rake errbit:bootstrap to create admin user" do
  command "bundle exec rake errbit:bootstrap > /opt/errbit/bootstrap.out"
  cwd "/opt/errbit/current"
	environment _environment
  creates "/opt/errbit/bootstrap.out"
end
