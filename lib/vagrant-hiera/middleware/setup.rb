module VagrantHiera
  module Middleware

    class Setup
      def initialize(app, env)
        @app = app
        @env = env
      end

      def call(env)
        @env = env
        if @env[:vm].config.hiera.set?
          @env[:vm].config.hiera.validate(@env, nil)
          install_puppet_hiera unless puppet_hiera_installed?
          create_shared_folders
          create_symlink_to_hiera_config
        end
        @app.call(env)
      end

      def puppet_hiera_installed?
        installed = ( @env[:vm].channel.execute("gem list | grep hiera-puppet", :error_check => false) == 0 )
        @env[:ui].success I18n.t('vagrant.plugins.hiera.middleware.setup.hiera_installed') if installed
        installed
      end

      def install_puppet_hiera
        @env[:ui].warn I18n.t('vagrant.plugins.hiera.middleware.setup.installing_hiera')
        @env[:vm].channel.sudo("gem install hiera-puppet")
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
        @env[:vm].channel.sudo("ln -fs #{@env[:vm].config.hiera.guest_config_path}/#{@env[:vm].config.hiera.config_file} /etc/puppet/hiera.yaml")
      end
    end
  end
end
