license          'Apache 2.0'
description      'Installs/Configures Clockwork'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0'

supports "amazon", ">= 2014.03"

name   'opsworks_clockwork'
recipe 'opsworks_clockwork::setup',     'Set up clockwork.'
recipe 'opsworks_clockwork::configure', 'Configure clockwork.'
recipe 'opsworks_clockwork::deploy',    'Deploy clockwork.'
recipe 'opsworks_clockwork::undeploy',  'Undeploy clockwork.'
recipe 'opsworks_clockwork::stop',      'Stop clockwork.'
