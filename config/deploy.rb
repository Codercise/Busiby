require 'bundler/capistrano'
#require 'deploy_tasks.rb'
set :user, 'nickhayden'
set :domain, 'carsekyx.eu'
set :applicationdir, "/var/www/Busiby.git"

set :scm, 'git'
set :repository,  "git@github.com:Haydos585/Busiby.git"
set :git_enable_submodules, 1 # if you have vendored rails
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true

# roles (servers)
role :web, domain
role :app, domain
role :db,  domain, :primary => true

# deploy config
set :deploy_to, applicationdir
set :deploy_via, :export

# additional settings
ssh_options[:forward_agent] = true
default_run_options[:pty] = true  # Forgo errors when deploying from windows
#ssh_options[:keys] = %w(/home/user/.ssh/id_rsa)            # If you are using ssh_keysset :chmod755, "app config db lib public vendor script script/* public/disp*"set :use_sudo, false

# Passenger
namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && bundle exec passenger start --socket /tmp/passenger.socket --daemonize --environment production"
  end
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && bundle exec passenger stop --pid-file tmp/pids/passenger.pid"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end
end