include_attribute 'deploy'

default[:clockwork] = {}
default['clockwork']['clock'] = '/lib/clock.rb'
default['clockwork']['log_dir'] = '/var/log/clockwork'
default['clockwork']['pid_dir'] = '/var/run/clockwork'
default['clockwork']['rails_env'] = 'production'
