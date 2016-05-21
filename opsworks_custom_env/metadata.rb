name        "opsworks-cookbook-custom-env"
maintainer  "Diego Durante"
description "This recipe allow you to use environment variables inside your Rails app when you use a AWS OpsWorks stack."

recipe "cookbook-leevia::custom_env", "Generate a config/application.yml file to contain all environment variables"
