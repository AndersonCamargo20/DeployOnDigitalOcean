#server '157.230.81.239', port: "22", roles: [:web, :app, :db], primary: true
set :application, "my_app_name"
set :repo_url, "https://github.com/AndersonCamargo20/DeployOnDigitalOcean"

set :user, 'deploy'
set :deploy_to, "/var/www/awesome_bucket"

append :linked_files, "config/database.yml", "config/storage.yml", "config/master.key"
append :linked_dirs, "log", "tmp"


#server "157.230.81.239", :primary => true
set :keep_releases, 5
set :migration_role, :app

set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_access_log, "#{shared_path}/log/puma_access.log"
set :puma_error_log, "#{shared_path}/log/puma_error.log"

set :nginx_sites_available_path, "/etc/nginx/sites-available"
set :nginx_sites_enabled_path, "/etc/nginx/sites-enabled"

set :rvm_ruby_version, '2.3.3'

namespace :puma do
    desc 'Create Puma dirs'
    task :create_dirs do
      on roles(:app) do
        execute "mkdir #{shared_path}/tmp/sockets -p"
        execute "mkdir #{shared_path}/tmp/pids -p"
      end
    end
  
    desc "Restart Nginx"
    task :nginx_restart do
      on roles(:app) do
        execute "sudo service nginx restart"
      end
    end
  
    before :start, :create_dirs
    after :start, :nginx_restart
  end