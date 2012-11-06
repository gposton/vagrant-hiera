# Vagrant::Hiera

Configures puppet-heira on your vagrant box

## Installation

Add this line to your application's Gemfile:

    gem 'vagrant-hiera'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vagrant-hiera

If you recieve this [error](https://github.com/gposton/vagrant-hiera/issues/8):

    /Applications/Vagrant/embedded/gems/gems/vagrant-1.0.5/lib/vagrant/config/top.rb:29:in `method_missing': undefined method `hiera' for #<Vagrant::Config::Top:0x00000100971a48> (NoMethodError)

Try installing the gem using:

    vagrant gem install vagrant-hiera

## Usage

Create a [hiera.yaml](https://github.com/puppetlabs/hiera-puppet#module-user) file on your host with the datadir pointing to `/tmp/vagrant-hiera/data`

    :yaml:
      :datadir: /var/lib/hiera

Add the following to your VagrantFile:

    config.hiera.config_path = 'host/path/to/the/directory/that/contains/hiera.yaml'
    config.hiera.config_file = 'hiera.yaml'
    config.hiera.data_path   = 'host/path/to/hiera-data'

And then...

`vagrant up`

**Notes**: 
You will need to add/checkout [hiera-puppet]("https://github.com/puppetlabs/hiera-puppet" "Hiera Puppet") to your module path.  See the following links for more information:
- https://github.com/puppetlabs/hiera-puppet#installation
- https://groups.google.com/d/msg/puppet-users/IlPq14Rsnm0/UhbbRUsqqLgJ

I've only tested this plugin on puppet 3.  Thus, it will download and install puppet v3 (which as of now is a pre-release version).  Although it is not tested, if you would like to configure the plugin to use a different version of puppet, hiera, etc., you can do so by adding the following config to your Vagrantfile.

```
config.hiera.(puppet_apt_source|puppet_version|hiera_puppet_version|hiera_version|apt_opts) = ' ... '
```

Thanks to [haf]('http://github.com/haf') for the contribution.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


