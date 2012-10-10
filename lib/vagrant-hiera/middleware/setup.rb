module VagrantHiera
  module Middleware

    class Setup
      def initialize(app, env)
        @app = app
        @env = env

        @guest_config_path    = @env[:vm].config.hiera.guest_config_path
        @guest_data_path      = @env[:vm].config.hiera.guest_data_path
        @config_path          = @env[:vm].config.hiera.config_path
        @data_path            = @env[:vm].config.hiera.data_path
        @config_file          = @env[:vm].config.hiera.config_file
        @puppet_version       = @env[:vm].config.hiera.puppet_version
        @puppet_apt_source    = @env[:vm].config.hiera.puppet_apt_source
        @hiera_puppet_version = @env[:vm].config.hiera.hiera_puppet_version
        @hiera_version        = @env[:vm].config.hiera.hiera_version
      end

      def call(env)
        @env = env
        if @env[:vm].config.hiera.set?
          install_puppet unless puppet_installed?
          install_hiera unless hiera_installed?
          if @env[:vm].config.hiera.install_puppet_heira?
            install_hiera_puppet unless hiera_puppet_installed?
          end
          create_shared_folders
          create_symlink_to_hiera_config
        end
        @app.call(env)
      end

      def apt_repo_set?
        setup = ( @env[:vm].channel.execute("grep '#{@puppet_apt_source}' /etc/apt/sources.list", :error_check => false) == 0 )
        @env[:ui].success I18n.t('vagrant.plugins.hiera.middleware.setup.apt_repo_set') if setup
        setup
      end

      def add_apt_repo
        @env[:ui].warn I18n.t('vagrant.plugins.hiera.middleware.setup.add_apt_repo')
        @env[:vm].channel.sudo("wget http://apt.puppetlabs.com/puppetlabs-release-stable.deb")
        @env[:vm].channel.sudo("dpkg -i puppetlabs-release-stable.deb")
        @env[:vm].channel.sudo("echo '#{@puppet_apt_source}' >> /etc/apt/sources.list.d/puppet.list")
        @env[:vm].channel.sudo("apt-get update")
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
        @env[:vm].guest.mount_shared_folder('vagrant-hiera-config', @guest_config_path, data)
        @env[:vm].guest.mount_shared_folder('vagrant-hiera-data', @guest_data_path, data)
      end

      def create_symlink_to_hiera_config
        @env[:ui].info I18n.t('vagrant.plugins.hiera.middleware.setup.installing_hiera_config')
        @env[:vm].channel.sudo("mkdir -p /etc/puppet")
        # This is where I think this file will end up once the official puppet v3 release is out
        @env[:vm].channel.sudo("ln -fs #{@guest_config_path}/#{@config_file} /etc/hiera.yaml")
        # But this is where it looks for it now
        @env[:vm].channel.sudo("ln -fs #{@guest_config_path}/#{@config_file} /etc/puppet/hiera.yaml")
      end
    end
  end
end
