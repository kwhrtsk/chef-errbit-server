# Cookbook Name:: errbit-server
# Recipe:: rbenv
#
# Copyright 2015, Kawahara Taisuke
#
# MIT License
#

include_recipe "ruby_build"
include_recipe "rbenv::system_install"

_ruby_version = node["errbit"]["ruby_version"]

rbenv_ruby _ruby_version

rbenv_global _ruby_version

rbenv_gem "bundler" do
  rbenv_version _ruby_version
  action :install
end
