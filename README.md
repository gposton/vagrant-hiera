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

Add the following to your VagrantFile:
      config.hiera.config_path = 'path/to/directory/that/contains/configuration'
      config.hiera.config_file = 'hiera.yaml'
      config.hiera.data_path   = '/path/to/hiera-data'

`vagrant up`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
