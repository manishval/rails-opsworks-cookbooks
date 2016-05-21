To use custom environment variables in Opsworks follow the guide below:
===================

This cookbook allows Rails apps on [Amazon OpsWorks](http://aws.amazon.com/opsworks/) to separate their configuration from their code. In keeping with [The twelve-factor app](http://www.12factor.net/config), the configuration is made available to the app's environment.

To accomplish this, the cookbook maintains a `config/application.yml` file in each respective app's deploy directory. E.g.:

    ---
    SECRET_KEY_BASE: "xxxxxxxxxxxxx"
    DB_PASSWORD: "123456789"

The application can then load its settings directly from this file, or use [Figaro](https://github.com/laserlemon/figaro) to automatically make these settings available in the app's `ENV` (strong recommended).

Configuration values are specified in the Amazon console but also a [stack's custom JSON](http://docs.aws.amazon.com/opsworks/latest/userguide/workingstacks-json.html) can be passed.

Example of the JSON that we have to pass in the AWS OpsWorks Portal inside: Stack -> Stack Settings -> Edit -> Custom JSON (in Advanced options section).

    {  
      "deploy": {
        "app_name": {
          "symlink_before_migrate": {
            "config/application.yml": "config/application.yml"
          },
          "custom_env": {
            "DB_USERNAME": "foobar",
            "REDIS_URL":   "barfoo"
          }
        }
      }
    }

Today we do not need to pass env variables using this JSON. We can only declare env variables in the AWS OpsWorks Portal, inside: Apps -> edit (app_name) -> Environment Variables.

**Note** that the `symlink_before_migrate` attribute is necessary so that OpsWorks automatically symlinks the shared file when setting up release directories or deploying a new version.


Caveats
-------

At the moment, only default Opsworks configurations for Apache/Passenger and Unicorn/Nginx style Rails apps are supported.


Opsworks Set-Up
---------------

* Add `custom_env` and `symlink_before_migrate` attributes to the stack's custom JSON as in the example above.
* Associate the `opsworks-cookbook-custom-env::custom_env` recipe with the **Deploy** and **Setup** events in your rails app's layer.

A deploy isn't necessary if you just want to update the custom configuration. Instead, update the stack's custom JSON, then choose to _Run Command_ > _execute recipes_ and enter `opsworks_custom_env::configure` into the _Recipes to execute_ field. Executing the recipe will write an updated `application.yml` file and restart unicorn workers.

Copyright and License
-------

(c) 2016-2016 Diego Durante. See [LICENSE](LICENSE) for details.

Thanks to [joeyAghion](https://github.com/joeyAghion/opsworks_custom_env) that inspired me.