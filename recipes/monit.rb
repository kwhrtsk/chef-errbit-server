include_recipe "monit_wrapper::default"


# override monit-ng::service resource
# because that cookbook does not works with ubuntu 14.10
t = resources(:template => "/etc/default/monit")
t.cookbook "errbit-server"

_service_name = node['errbit']['monit_service_name']
_command_line = '/opt/errbit/unicorn.sh'

monit_wrapper_monitor _service_name do
  template_cookbook 'errbit-server'
  template_source 'monit/errbit.conf.erb'
  variables cmd_line: _command_line,
            pidfile: node["errbit"]["pid_file"],
            user: node["errbit"]["user"]
end

monit_wrapper_notify_if_not_running _service_name

monit_wrapper_service _service_name do
  subscribes :restart, "monit_wrapper_monitor[#{_service_name}]", :delayed
  subscribes :restart, "monit_wrapper_notify_if_not_running[#{_service_name}]", :delayed
end
