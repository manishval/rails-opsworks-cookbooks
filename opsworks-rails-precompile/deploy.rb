node[:deploy].each do |application, deploy|
  rails_env = deploy[:rails_env]

  Chef::Log.info("Precompiling Rails assets with environment #{rails_env}")

  execute 'rake assets:precompile' do
    cwd deploy[:current_path]
    user deploy[:user]
    command 'bundle exec rake assets:precompile'
    environment 'RAILS_ENV' => rails_env
  end
end