# config valid for current version and patch releases of Capistrano
lock "~> 3.19.1"
set :application, "students"
set :repo_url, 'https://github.com/aadeshere1/students.git'
set :deploy_to, '/home/ubuntu/students'
set :use_sudo, true
set :branch, 'main'
set :linked_files, %w{config/master.key config/database.yml}

set :rails_env, 'production'
set :keep_releases, 2
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :linked_files, %w{config/database.yml config/master.key}
# config/deploy.rb

# Puma configurations
set :puma_threads, [4, 16]
set :puma_workers, 0

set :pty, true


# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :deploy_via, :remote_cache
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log,  "#{release_path}/log/puma.error.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord
namespace :puma do
    desc 'Create Directories for Puma Pids and Socket'
        task :make_dirs do
            on roles(:app) do
            execute "mkdir #{shared_path}/tmp/sockets -p"
            execute "mkdir #{shared_path}/tmp/pids -p"
        end
    end

    desc "Start Puma"
    task :start do
      on roles(:app) do
        within release_path do
          execute "bundle exec puma -C #{fetch(:puma_bind)} -e #{fetch(:rails_env)}"
        end
      end
    end
  
    desc "Stop Puma"
    task :stop do
      on roles(:app) do
        execute "if test -f #{fetch(:puma_pid)}; then kill -s TERM `cat #{fetch(:puma_pid)}`; fi"
      end
    end
  
    desc "Restart Puma"
    task :restart do
      on roles(:app) do
        execute "if test -f #{fetch(:puma_pid)}; then kill -s USR1 `cat #{fetch(:puma_pid)}`; else #{fetch(:puma_bin)}; fi"
      end
    end
    
    before :start, :make_dirs
end

