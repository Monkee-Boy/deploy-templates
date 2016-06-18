![Monkee-Boy](https://dujrsrsgsd3nh.cloudfront.net/img/emoticons/113009/mboy-1403710932.jpg) Deploy Templates
==============

**These are no longer supported. Use the [yeoman generator](https://www.npmjs.com/package/generator-mboy-deploy) to generate your deployment config files instead.**

Here you will find some templates for typical Monkee-Boy deployments using Capistrano. These are just templates and should be customized as needed per project.

## Usage

First you will need any required Ruby gems. Below are the base requirements but check each Capfile for other gems that might be included.

* `gem install capistrano`
* `gem install hipchat`
* `gem install mboy-deploy --source PRIVATESOURCE`

> We highly recommend you use the [yeoman generator](https://www.npmjs.com/package/generator-mboy-deploy) to generate your deploy config files instead of manually pulling from this repo.

Next copy your choice of templates to the root of your project. Remember that these files SHOULD be added to the git repo. Tweak the deploy config as needed.

Finally run `cap production deploy` or whatever environment you are deploying to.


## The Dev Team

Handcrafted with ♥ in Austin, Texas by the [Monkee-Boy Troop](http://www.monkee-boy.com/about/the-troop.php).

| [![James Fleeting](https://avatars0.githubusercontent.com/u/23062?s=144)](https://github.com/fleeting) | [![Pete Gautier](https://avatars3.githubusercontent.com/u/5394199?s=144)](https://github.com/pgautier404) | [![Sarah Higley](https://avatars3.githubusercontent.com/u/3819570?s=144)](https://github.com/smhigley) | [![John,Hoover](https://avatars2.githubusercontent.com/u/48278?s=144)](https://github.com/defvayne23) |
|---|---|---|---|
| [James Fleeting](http://github.com/fleeting) | [Pete Gautier](https://github.com/pgautier404) | [Sarah Higley](https://github.com/smhigley) | [John Hoover](https://github.com/defvayne23) |

![Monkee-Boy](http://www.monkee-boy.com/img/logo-withtag-vertical-dark.jpg)
