# Cookbook Name:: errbit-server
# Recipe:: app
#
# Copyright 2015, Kawahara Taisuke
#
# MIT License
#

include_recipe "errbit-server::rbenv"

include_recipe "nodejs" # to rake assets:precompile in production
include_recipe "logrotate"

_user  = node['errbit']['user']
_group = node['errbit']['group']
_environment = node['errbit']['environment'].dup
_ruby_version = node['errbit']['ruby_version']
_environment["RBENV_VERSION"] = _ruby_version

deploy "/opt/errbit" do
  action        :deploy
  repo          'https://github.com/errbit/errbit.git'
  revision      node['errbit']['revision']
  user          _user
  group         _group
  migrate       true
  environment   _environment
  shallow_clone true
  keep_releases 10

  migration_command "true" # never

  before_migrate do
    %W[
      #{new_resource.deploy_to}/shared/bundle
      #{new_resource.deploy_to}/shared/log
      #{new_resource.deploy_to}/shared/pids
    ].each do |path|
      directory path do
        owner _user
        group _group
        mode  '00755'
      end
    end

    execute ". /etc/profile.d/rbenv.sh && bundle install --path=#{new_resource.deploy_to}/shared/bundle" do
      environment({"RBENV_VERSION" => _ruby_version})
      cwd  release_path
      user _user
    end

    execute ". /etc/profile.d/rbenv.sh && bundle exec rake assets:precompile" do
      cwd  release_path
      user _user
      environment({"RBENV_VERSION" => _ruby_version, "RAILS_ENV" => "production"})
    end
  end
end

file "/opt/errbit/unicorn.sh" do
  user  _user
  group _group
  mode  '00755'
  content <<-CODE
#!/bin/bash
. /etc/profile.d/rbenv.sh
cd /opt/errbit/current && bundle exec unicorn -c config/unicorn.default.rb
  CODE
end

service_factory "errbit" do
  action        :create
  service_desc  "Errbit Unicorn"
  exec          "/opt/errbit/unicorn.sh"
  env_variables _environment
  run_user      _user
  run_group     _group
  pid_file      node["errbit"]["pid_file"]
  create_pid    false
end

service "errbit" do
  action [:enable, :start]
end

logrotate_app 'errbit' do
  path      '/opt/errbit/shared/log/*.log'
  frequency 'daily'
  options   %w[missingok compress dateext delaycompress]
  rotate    30
  lastaction <<-"CODE"
    pid=#{node["errbit"]["pid_file"]}
    test -s $pid && kill -USR1 "$(cat $pid)"
  CODE
end
