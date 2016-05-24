service "monit" do
  supports :status => false, :restart => true, :reload => true
  action :nothing
end

# Overwrite the unicorn restart command declared elsewhere
# Apologies for the `sleep`, but monit errors with "Other action already in progress" on some boots.
node[:deploy].each do |application, deploy|
  execute "restart Rails app #{application}" do
    command "sleep 60 && sudo monit restart -g clockwork_<%= @application %>_group"
    action :nothing
  end
end

