# Cookbook Name:: errbit-server
# Recipe:: rbenv
#
# Copyright 2015, Kawahara Taisuke
#
# MIT License
#

include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"

_ruby_version = node["errbit"]["ruby_version"]

rbenv_ruby _ruby_version

rbenv_gem "bundler" do
  ruby_version _ruby_version
  action :install
end

file "/etc/profile.d/rbenv.sh" do
  mode '0755'
end
