![Monkee-Boy](https://dujrsrsgsd3nh.cloudfront.net/img/emoticons/113009/mboy-1403710932.jpg) Deploy Templates &raquo; Usage
==============

We use Capistrano to handle our deployments to the Habitat. At it's bare Capistrano will deploy your project to the server. However, it can also be used to update npm modules, update bower components, compile assets, and handle other aspects of your build process.


## The Setup

![RVM](https://img.shields.io/badge/Install-RVM-acca41.svg?style=flat-square)
* `curl -sSL https://get.rvm.io | bash -s stable --ruby`
* `rvm reload`

![Capistrano](https://img.shields.io/badge/Install-Capistrano-acca41.svg?style=flat-square)
* `gem install capistrano`

![Gems](https://img.shields.io/badge/Install-Gems-acca41.svg?style=flat-square)
* `gem install hipchat`
* `gem install mboy --source PRIVATESOURCE`

>

## The Config

![Method A](https://img.shields.io/badge/Method A%20-recommended-acca41.svg?style=flat-square)

> Download the deploy files from the starting template of your choice into the root of your project. Don't forget to add and commit these to the repo.

![Method B](https://img.shields.io/badge/Method B-not recommended-777777.svg?style=flat-square)

> Run `cap install` to generate the default Capistrano deploy files. Modify these as you see fit. Feel free to reference the templates if needed.

## The Deploy

> See the details below for a complete run down of what needs to be changed before doing a deployment.

* `cap production deploy`
  * to deploy to the production environment.
* `cap dev deploy`
  * to deploy to the dev environment.
* `cap production build:bower`
  * to run a custom Capistrano task, in this case run bower in the production environment.

## The Details

Capistrano consists of at least three files. For the most part if you are using one of the templates there are only a few things to tweak. From this point forward I'll assume you are using a mBoy Deploy Template.

![Capfile](https://img.shields.io/badge/.%2F-Capfile-acca41.svg?style=flat-square)

> This file doesn't need any customizations in typical use. It requires the gems needed and loads any custom tasks.

![deploy.rb](https://img.shields.io/badge/.%2Fconfig%2f-deploy.rb-acca41.svg?style=flat-square)

> This is where it all happens. You will notice that the file makes heavy use of the mBoy gem to load in defaults and customize the deployment messages. You can overwrite any of the defaults set in the gem as needed.
>
> There are a few variables you are required to set before deploying.

* **:application** is the project name with no spaces or special characters.
* **:project_name** is the pretty project name that can have spaces; this is used for HipChat notifications.
* **:repo_url** should be the complete git url, typical from beanstalk.
* **:linked_files** should contain any files that are not in the repo but are still needed. This is typical config files like wp-config.php. Capistrano will create a symlink to these files inside `./shared`. These files must already exist inside shared or the deployment will fail.
* **:linked_dirs** should contain any directories that are not in the repo but are still needed. This typicaly includes uploads, node_modules, bower_components, etc.

> In `:deploy` you will find the build task. This task should be customized based on the project needs. Typically you would invoke `build:npm` and `build:bower` here. You could also do `jekyll build` or anything else needed for your build process.
>
> At the bottom you will find `:build` which has some basic build tasks including `npm install` and `bower install` to update modules and components as needed. You can also add any other build tasks as needed.

![deploy.rb](https://img.shields.io/badge/.%2fconfig%2fdeploy%2f-production.rb-acca41.svg?style=flat-square)

> Inside `./config/deploy` you will specify your environments. Typically this will be production and dev but you can have any number of environments.
>
> There are only a few things that should be tweaked in these environment files.

* **:deploy_to** should be the server path where the deployment should take place. For production this would typically be `/var/www/projectdomain.com/_`. For dev this might be `/var/www/projectdomain.com/dev`.
* **:deploy_env** is the name of that environment. Typically will be production, dev, staging, etc.
