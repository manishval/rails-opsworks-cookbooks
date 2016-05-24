# Adapted from unicorn::rails: https://github.com/aws/opsworks-cookbooks/blob/master/unicorn/recipes/rails.rb

include_recipe "opsworks_clockwork::service"

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping opsworks_clockwork::setup application #{application} as it is not a Rails app")
    next
  end

  case node['platform_family']
  when 'rhel', 'fedora'
    monit_conf_dir = '/etc/monit.d'
  when 'debian'
    monit_conf_dir = '/etc/monit/conf.d'
  end

  clock      = node['clockwork']['clock']
  clock_name = ::File.basename(clock, ".rb")
  pid_dir    = node['clockwork']['pid_dir']
  log_dir    = node['clockwork']['log_dir']

  pid_file   = "#{pid_dir}/clockworkd.#{clock_name}.pid"
  log_file   = "#{log_dir}/clockworkd.#{clock_name}.output"

  opsworks_deploy_user do
    deploy_data deploy
  end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  directory "#{deploy[:deploy_to]}/shared/assets" do
    group deploy[:group]
    owner deploy[:user]
    mode 0775
    action :create
    recursive true
  end

  # Allow deploy user to restart clockwork service
  template "/etc/sudoers.d/#{deploy[:user]}" do
    mode 0440
    source "sudoer.erb"
    variables :user => deploy[:user]
  end

  directory pid_dir do
    owner deploy[:user]
    group deploy[:group]
    mode 0775
  end

  directory log_dir do
    mode 0775
  end

  file log_file do
    owner deploy[:user]
    group deploy[:group]
    mode 0755
    action :create_if_missing
  end

  template "/usr/local/bin/stop_clockwork_#{application}.sh" do
    source 'stop_clockwork.sh.erb'
    mode 0755
    variables :pid_dir => pid_dir,
              :log_dir => log_dir,
              :deploy => deploy,
              :clock => clock
  end

  template "/usr/local/bin/start_clockwork_#{application}.sh" do
    source 'start_clockwork.sh.erb'
    mode 0755
    variables :pid_dir => pid_dir,
              :log_dir => log_dir,
              :deploy => deploy,
              :clock => clock
  end

  template "#{monit_conf_dir}/clockwork_#{application}.monitrc" do
    mode 0644
    source 'clockwork.monitrc.erb'
    variables :application => application,
              :pid_file => pid_file
    notifies :reload, resources(:service => "monit"), :immediately
  end

  template "/etc/logrotate.d/clockwork_#{application}" do
    source 'logrotate.erb'
    variables 'log_dir' => log_dir
    mode 0644
  end
end
