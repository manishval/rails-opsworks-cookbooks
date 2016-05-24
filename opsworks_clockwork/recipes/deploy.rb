# Adapted from deploy::rails: https://github.com/aws/opsworks-cookbooks/blob/master/deploy/recipes/rails.rb

include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping opsworks_sidekiq::deploy application #{application} as it is not an Rails app")
    next
  end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  Chef::Log.debug("Running opsworks_clockwork::setup for application #{application}")
  node.set[:opsworks][:rails_stack][:recipe] = "opsworks_clockwork::setup"

  opsworks_rails do
    deploy_data deploy
    app application
  end

  Chef::Log.debug("Deploying Clockwork Application: #{application}")
  opsworks_deploy do
    deploy_data deploy
    app application
  end

  Chef::Log.debug("Restarting Clockwork Application: #{application}")
  # Restart clockwork if it's already running
  execute "restart-clockwork-service" do
    command "monit -Iv restart clockwork_#{application}_group"
  end
end
