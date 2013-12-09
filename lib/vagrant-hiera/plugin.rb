require 'vagrant'
require 'vagrant-hiera/config'

module VagrantHiera
  class Plugin < Vagrant.plugin("2")
    name "vagrant-hiera"

    config 'hiera' do
      VagrantHiera::Config
    end

    action_hook 'vagrant-hiera' do |hook|
      hook.after Vagrant::Action::Builtin::NFS, VagrantHiera::Middleware::Prepare
    end

    ::Vagrant::Action::Builder.new.tap do |b|
      b.use VagrantHiera::Middleware::Setup
    end
  end
end
