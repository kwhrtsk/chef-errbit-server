# Cookbook Name:: errbit-server
# Recipe:: default
#
# Copyright 2015, Kawahara Taisuke
#
# MIT License
#

include_recipe "git"
include_recipe "mongodb"

include_recipe "errbit-server::rbenv"

user  node['errbit']['user']
group node['errbit']['group']

include_recipe "errbit-server::app"
include_recipe "errbit-server::bootstrap"
