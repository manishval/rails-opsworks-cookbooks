name        "opsworks_custom_env"
maintainer  "Diego Durante"
description "This recipe allow you to use environment variables inside your Rails app when you use a AWS OpsWorks stack."

recipe "opsworks_custom_env::custom_env", "Generate a config/application.yml file to contain all environment variables"
