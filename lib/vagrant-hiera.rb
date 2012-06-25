require 'vagrant'
require 'vagrant-hiera/middleware/prepare'
require 'vagrant-hiera/middleware/setup'
require 'vagrant-hiera/config'


Vagrant.config_keys.register(:hiera) { VagrantHiera::Config }

Vagrant.actions[:start].insert_after Vagrant::Action::VM::ShareFolders, VagrantHiera::Middleware::Prepare
Vagrant.actions[:start].use VagrantHiera::Middleware::Setup

I18n.load_path << File.expand_path("../../locales/en.yml", __FILE__)
