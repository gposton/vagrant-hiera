# Vagrant::Hiera

TODO: Configures puppet-heira on your vagrant box

## Installation

Add this line to your application's Gemfile:

    gem 'vagrant-hiera'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vagrant-hiera

## Usage

Create a [hiera.yaml](https://github.com/puppetlabs/hiera-puppet#module-user) file on your host with the datadir pointing to `/tmp/vagrant-hiera/data`

    :json:
      :datadir: /var/lib/hiera

Add the following to your VagrantFile:

    config.hiera.config_path = 'host/path/to/the/directory/that/contains/hiera.yaml'
    config.hiera.config_file = 'hiera.yaml'
    config.hiera.data_path   = 'host/path/to/hiera-data'

And then...

`vagrant up`

Note: You will need to add/checkout [hiera-puppet]("https://github.com/puppetlabs/hiera-puppet" "Hiera Puppet") to your module path.  See the following links for more information:
- https://github.com/puppetlabs/hiera-puppet#installation
- https://groups.google.com/d/msg/puppet-users/IlPq14Rsnm0/UhbbRUsqqLgJ

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
