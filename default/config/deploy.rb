# config valid only for current version of Capistrano
lock '3.3.5'

# Load up the mBoy gem
Mboy.new() # Setting initial defaults.

set :application, 'ProjectName' # no spaces or special characters
set :project_name, 'Project Name' # pretty name that can have spaces
set :repo_url, 'PROJECTGITURL' # the git repo url
set :current_dir, 'public_html' # almost always public_html

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('') # Note that this file must exist on the server already, Capistrano will not create it.

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('')

namespace :deploy do
  STDOUT.sync

  desc 'Build'
  after :updated, :deploybuild do
    on roles(:web) do
      within release_path  do
        # Here you would run any tasks for your build process like compiling assets.
      end
    end
  end

  desc 'mBoy Deployment Initialized.'
  Mboy.deploy_starting_message

  desc 'mBoy Deployment Steps'
  Mboy.deploy_steps

  desc 'mBoy HipChat Notifications'
  Mboy.hipchat_notify

end