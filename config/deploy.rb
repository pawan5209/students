
set :application, 'students'
set :repo_url, 'https://github.com/pawan5209/students.git' # Edit this to match your repository
set :branch, :main #use `git rev-parse --abbrev-ref HEAD`.chomp for pick current branch
set :deploy_to, '/home/ubuntu/students'
set :rvm_ruby_version, 'ruby-3.3.1' # Replace with your Ruby version

set :pty, true
set :linked_files, %w{config/database.yml config/master.key} #if rails 5.2 & above master.key is used insted of application.yml

set :default_env, {
  'RAILS_ENV' => 'production',
  'DB_NAME' => 'terraform-20240906051912576100000005',
  'DB_USERNAME' => 'admin',
  'DB_PASSWORD' => 'veryStrongpassword1',
  'DB_HOST' => 'terraform-20240906051912576100000005.cbnos23a68av.us-east-1.rds.amazonaws.com',
  'DB_PORT' => '3306'
}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}
set :keep_releases, 5
# set :default_env, { 'RAILS_MASTER_KEY' => 'de40d604cd28f5b814473c92363e649a' }
set :puma_threads, [4, 16]
set :puma_workers, 0
# set :puma_bind, "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/students-puma.sock"

set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log, "#{release_path}/log/puma.error.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true 

namespace :deploy do
    task :clear_cache do
      on roles(:web) do
        within release_path do
          execute :rm, "-rf tmp/cache"
        end
      end
    end
  end
  
  before "deploy:assets:precompile", "deploy:clear_cache"

  namespace :deploy do
    task :create_database do
      on roles(:db) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, 'db:create'
          end
        end
      end
    end
  end
  
  before 'deploy:migrate', 'deploy:create_database'