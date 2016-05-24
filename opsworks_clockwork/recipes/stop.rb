# Adapted from nginx::stop: https://github.com/aws/opsworks-cookbooks/blob/master/nginx/recipes/stop.rb

include_recipe "opsworks_clockwork::service"

node[:deploy].each do |application, deploy|
  execute "stop-clockwork-service" do
    command "sudo monit stop -g clockwork_#{application}_group"
  end
end
