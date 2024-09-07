
set :application, 'students'
set :repo_url, 'https://github.com/pawan5209/students.git' # Edit this to match your repository
set :branch, :main #use `git rev-parse --abbrev-ref HEAD`.chomp for pick current branch
set :deploy_to, '/home/ubuntu/students'
set :pty, true
set :linked_files, %w{config/database.yml config/master.key} #if rails 5.2 & above master.key is used insted of application.yml
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}
set :keep_releases, 5

set :puma_threads, [4, 16]
set :puma_workers, 0
set :puma_bind, "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log, "#{release_path}/log/puma.error.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil