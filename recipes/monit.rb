include_recipe "monit_wrapper::default"

_service_name = 'errbit'
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

