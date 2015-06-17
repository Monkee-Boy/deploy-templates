# config valid only for current version of Capistrano
lock '3.3.5'

# Load up the mBoy gem
Mboy.new() # Setting initial defaults.

set :application, 'ProjectName' # no spaces or special characters
set :project_name, 'Project Name' # pretty name that can have spaces
set :repo_url, 'PROJECTGITURL' # the git repo url
set :current_dir, 'public_html' # almost always public_html
set :config_repo_url, 'PROJECTCONFIGGITURL' # the url to the repo tracking the site config files

set :git_strategy, Capistrano::Git::SlaveStrategy

# Default value for :linked_files is []
set :linked_files, %w{.htaccess app/Config/bootstrap.php app/Config/core.php app/Config/database.php app/Config/email.php app/Config/plugin_defs.php app/Plugin/Content/Config/content_routes.php app/Plugin/Content/Config/draft_content_routes.php app/webroot/.htaccess} # Note that this file must exist on the server already, Capistrano will not create it.

# Default value for linked_dirs is []
set :linked_dirs, %w{app/webroot/upload app/webroot/files app/tmp app/Plugin/PageManager/View/Pages node_modules bower_components} # Note that Capistrano will create these directories if needed.

namespace :deploy do
  STDOUT.sync

  desc 'Build'
  after :updated, :deploybuild do
    on roles(:web) do
      within release_path  do
        invoke 'build:npm'
        invoke 'build:bower'
        invoke 'build:configsetup'
        invoke 'build:clearcache'
        invoke 'build:migrations'
      end
    end
  end

  desc 'mBoy Deployment Initialized.'
  Mboy.deploy_starting_message

  desc 'Tag this release in git.'
  after :updated, :tagrelease do
    on roles(:web) do
      within release_path do
        set(:current_revision, capture(:cat, 'REVISION'))
        resolved_release_path = capture(:pwd, "-P")
        set(:release_name, resolved_release_path.split('/').last)
      end
    end

    run_locally do
      tag_msg = "Deployed by #{fetch :human} to #{fetch :stage} as #{fetch :release_name}"
      tag_name = "#{fetch :stage }-#{fetch :release_name}"
      execute :gits, %(tag -a #{tag_name} -m "#{tag_msg}")
      execute :gits, "push --tags"
    end
  end

  before :tagrelease, :deploy_step_beforetag do
    on roles(:all) do
      print 'Creating a git tag for this stage on current release......'
    end
  end

  after :tagrelease, :deploy_step_aftertag do
    on roles(:all) do
      puts '✔'.green
    end
  end

  desc 'mBoy Deployment Steps'
  Mboy.deploy_steps

  desc 'mBoy HipChat Notifications'
  Mboy.hipchat_notify

end

namespace :build do

  desc 'Install/update node packages.'
  task :npm do
    on roles(:web) do
      within release_path do
        execute :npm, 'install --silent --no-spin' # install packages
      end
    end
  end

  desc 'Additional deploy steps for :build'
  before :npm, :deploy_step_beforenpm do
    on roles(:all) do
      print 'Updating node modules......'
    end
  end

  after :npm, :deploy_step_afternpm do
    on roles(:all) do
      puts '✔'.green
    end
  end

  desc 'Install/update bower components.'
  task :bower do
    on roles(:web) do
      within release_path do
        execute :bower, 'install' # install components
      end
    end
  end

  before :bower, :deploy_step_beforebower do
    on roles(:all) do
      print 'Updating bower components......'
    end
  end

  after :bower, :deploy_step_afterbower do
    on roles(:all) do
      puts '✔'.green
    end
  end

  desc 'Setup mbCMS Config files.'
  task :configsetup do
    on roles(:web) do
      within release_path do
        execute :git, :clone, '-b', fetch(:branch), '--single-branch', fetch(:config_repo_url), 'mbcms_config'
        execute :perl, 'scripts/symlink-configs.pl'
      end
    end
  end

  before :configsetup, :deploy_step_beforeconfigsetup do
    on roles(:all) do
      print 'Setting up mbCMS config files......'
    end
  end

  after :configsetup, :deploy_step_afterconfigsetup do
    on roles(:all) do
      puts '✔'.green
    end
  end

  desc 'Clear mbCMS cache.'
  task :clearcache do
    on roles(:web) do
      within release_path do
        execute :perl, 'scripts/run_clearcache.pl', "#{shared_path}"
      end
    end
  end

  before :clearcache, :deploy_step_beforeclearcache do
    on roles(:all) do
      print 'Clearing mbCMS cache......'
    end
  end

  after :clearcache, :deploy_step_afterclearcache do
    on roles(:all) do
      puts '✔'.green
    end
  end

  desc 'Run database migrations.'
  task :migrations do
    on roles(:web) do
      within release_path do
        execute :perl, 'scripts/run_migrations.pl', "#{release_path}"
      end
    end
  end
      
  before :migrations, :deploy_step_beforemigrations do
    on roles(:all) do
      print 'Running database migrations......'
    end
  end
  
  after :migrations, :deploy_step_aftermigrations do
    on roles(:all) do
      puts '✔'.green
    end
  end
  
end
