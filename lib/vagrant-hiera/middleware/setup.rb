module VagrantHiera
  module Middleware

    class Setup
      def initialize(app, env)
        opts = {
          :puppet_repo          => 'deb http://apt.puppetlabs.com/ lucid devel main',
          :puppet_version       => '3.0.0-0.1rc4puppetlabs1',
          :hiera_puppet_version => '1.0.0-0.1rc3',
          :hiera_version        => '1.0.0-0.1rc4',
          :apt_opts             => "-y --force-yes -o Dpkg::Options::=\"--force-confdef\" -o Dpkg::Options::=\"--force-confold\""
        }.merge(env[:vm].config.hiera.to_hash || {})

        @app = app
        @env = env

        @puppet_repo = opts[:puppet_repo]
        @puppet_version = opts[:puppet_version]
        @hiera_puppet_version = opts[:hiera_puppet_version]
        @hiera_version = opts[:hiera_version]
        @apt_opts = opts[:apt_opts]
      end

      def call(env)
        @env = env
        if @env[:vm].config.hiera.set?
          add_apt_repo unless apt_repo_set?
          install_puppet unless puppet_installed?
          install_hiera unless hiera_installed?
          install_hiera_puppet unless hiera_puppet_installed?
          create_shared_folders
          create_symlink_to_hiera_config
        end
        @app.call(env)
      end

      def hiera_installed?
        installed = ( @env[:vm].channel.execute("dpkg -l | grep puppet | grep #{@puppet_version}", :error_check => false) == 0 )
        @env[:ui].success I18n.t('vagrant.plugins.hiera.middleware.setup.hiera_installed') if installed
        installed
      end

      def install_hiera
        @env[:ui].warn I18n.t('vagrant.plugins.hiera.middleware.setup.install_hiera')
        @env[:vm].channel.sudo("apt-get #{@apt_opts} install hiera=#{@hiera_version}")
      end

      def apt_repo_set?
        setup = ( @env[:vm].channel.execute("grep '#{@puppet_repo}' /etc/apt/sources.list", :error_check => false) == 0 )
        @env[:ui].success I18n.t('vagrant.plugins.hiera.middleware.setup.apt_repo_set') if setup
        setup
      end

      def add_apt_repo
        @env[:ui].warn I18n.t('vagrant.plugins.hiera.middleware.setup.add_apt_repo')
        @env[:vm].channel.sudo("echo '#{@puppet_repo}' >> /etc/apt/sources.list")
        @env[:vm].channel.sudo("apt-get update")
      end

      def puppet_installed?
        installed = ( @env[:vm].channel.execute("dpkg -l | grep puppet | grep #{@puppet_version}", :error_check => false) == 0 )
        @env[:ui].success I18n.t('vagrant.plugins.hiera.middleware.setup.puppet_installed') if installed
        installed
      end

      def install_puppet
        @env[:ui].warn I18n.t('vagrant.plugins.hiera.middleware.setup.install_puppet')
        @env[:vm].channel.sudo("apt-get #{@apt_opts} install puppet-common=#{@puppet_version}")
        @env[:vm].channel.sudo("apt-get #{@apt_opts} install puppet=#{@puppet_version}")
      end

      def hiera_puppet_installed?
        installed = ( @env[:vm].channel.execute("dpkg -l | grep hiera-puppet | grep #{@hiera_puppet_version}", :error_check => false) == 0 )
        @env[:ui].success I18n.t('vagrant.plugins.hiera.middleware.setup.hiera_puppet_installed') if installed
        installed
      end

      def install_hiera_puppet
        @env[:ui].warn I18n.t('vagrant.plugins.hiera.middleware.setup.install_hiera_puppet')
        @env[:vm].channel.sudo("apt-get #{@apt_opts} install hiera-puppet=#{@hiera_puppet_version}")
      end

      def create_shared_folders
        @env[:ui].info I18n.t('vagrant.plugins.hiera.middleware.setup.shared_folders')
        data = {}
        data[:owner] ||= @env[:vm].config.ssh.username
        data[:group] ||= @env[:vm].config.ssh.username
        @env[:vm].guest.mount_shared_folder('vagrant-hiera-config', @env[:vm].config.hiera.guest_config_path, data)
        @env[:vm].guest.mount_shared_folder('vagrant-hiera-data', @env[:vm].config.hiera.guest_data_path, data)
      end

      def create_symlink_to_hiera_config
        @env[:ui].info I18n.t('vagrant.plugins.hiera.middleware.setup.installing_hiera_config')
        @env[:vm].channel.sudo("mkdir -p /etc/puppet")
        # This is where I think this file will end up once the official puppet v3 release is out
        @env[:vm].channel.sudo("ln -fs #{@env[:vm].config.hiera.guest_config_path}/#{@env[:vm].config.hiera.config_file} /etc/hiera.yaml")
        # But this is where it looks for it now
        @env[:vm].channel.sudo("ln -fs #{@env[:vm].config.hiera.guest_config_path}/#{@env[:vm].config.hiera.config_file} /etc/puppet/hiera.yaml")
      end
    end
  end
end
