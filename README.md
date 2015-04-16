errbit-server Cookbook
======================

Install and configures [Errbit](https://github.com/errbit/errbit).

Feature:

* Ruby installation using rbenv and ruby_build
* MongoDB installation
* Unicorn service configuration(SysV or Upstart)
* Checkout Errbit from Github

Inspired by [chef-errbit](https://github.com/millisami/chef-errbit).

Requirements
------------

This cookbook depends on these external cookbooks:

- git
- rbenv
- ruby_build
- mongodb
- application
- unicorn
- service_factory
- logrotate
- nodejs (to rake assets:precompile for errbit in production)

Tested with:

* Chef 11.18.6
* CentOS 6.6
* Ubuntu 14.10
* Vagrant 1.7.2
* VirtualBox 4.3.26
* Errbit (master on Apr 10, 2015)
* Ruby 2.2.2

Attributes
----------

* `node['errbit']['user']` - system user for running Errbit Unicorn (default: errbit)
* `node['errbit']['group']` - system group for running Errbit Unicorn (default: errbit)
* `node['errbit']['ruby_version']` - MRI version to install using rbenv (default: 2.2.2)
* `node['errbit']['port']` - Listening port of Errbit service (default: 3000)
* `node['errbit']['revision']` - Errbit revision/refs to deploy (default: master)
* `node['errbit']['environment']` - Environment variables for Errbit. See also next section.

#### `node['errbit']['environment']`

Override environments in errbit/.envrc

Please refer to Errbit documantation.

https://github.com/errbit/errbit/blob/master/docs/configuration.md

Default values in this recipe is changed only the following:

#### ERRBIT_EMAIL_AT_NOTICES 

Errbit notifies watchers via email after the set number of occurances of the same error.

This env was changed to `[0]` in this recipe, this value means never send emails.

Original default is `[1, 10, 100]`

#### ERRBIT_NOTIFY_AT_NOTICES

Notify each application's configured notification service after the set number of occurances
of the same error. [0] means notify on every occurance.

This env was changed to `[1, 10, 100]` in this recipe.

Original default is `[0]`

Usage
-----

```ruby
include_recipe "errbit-server::default"
```

After first deployment, initial admin user's password will be wrote out to `/opt/errbit/bootstrap.out`.

```
$ cat /opt/errbit/bootstrap.out
Seeding database
-------------------------------
Creating an initial admin user:
-- email:    errbit@errbit.example.com
-- password: 3o0c6L_jf-mh

Be sure to note down these credentials now!
```

Visit to `http://yourhostname.example.com:3000/` and login!

When you use Errbit in production env,
it is strongly recommended that deploy errbit service with the reverse proxy like nginx or ELB
in order to encrypt the connection.

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Author: Kawahara Taisuke (kwhrtsk@gmail.com)
