require 'vagrant'
require 'vagrant-hiera/middleware/prepare'
require 'vagrant-hiera/middleware/setup'
require 'vagrant-hiera/plugin'

I18n.load_path << File.expand_path("../../locales/en.yml", __FILE__)
