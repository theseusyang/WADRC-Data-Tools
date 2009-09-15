set :application, "WADRC-Data-Tools"
set :host_server, "nelson.medicine.wisc.edu"
role :app, host_server
role :web, host_server
role :db,  host_server, :primary => true

set :user, "admin"
set :group, "admin"
set :deploy_to, "/Library/WebServer/WADRC-Data-Tools"


set :scm_command, "/usr/local/git/bin/git"
set :scm, "git"
set :repository, "git@github.com:brainmap/WADRC-Data-Tools.git"
set :branch, "master"

set :mongrel_cmd, "/usr/bin/mongrel_rails"
set :mongrel_ports, "80"
set :mongrel_pid, "tmp/pids/mongrel.pid"




namespace :deploy do

  desc "Start Mongrels processes and add them to launchd."
  task :start, :roles => :app do
    mongrel_ports.each do |port|
      sudo "#{mongrel_cmd} start --port #{port} --pid #{mongrel_pid} \
            -e production --user #{user} --group #{group} -c #{current_path} -d"
    end
  end

  desc "Stop Mongrels processes and remove them from launchd."
  task :stop, :roles => :app do
    mongrel_ports.each do |port|
      sudo "#{mongrel_cmd} stop -c #{current_path} -p #{mongrel_pid}"
    end
  end

  desc "Restart Mongrel processes"
  task :restart, :roles => :app do
    stop
    start
  end
 
end


