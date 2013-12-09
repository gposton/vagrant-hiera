module VagrantHiera
  module Middleware

    class Prepare
      def initialize(app, env)
        @app = app
        @env = env
      end

      def call(env)
        @env = env
        if @env[:machine].config.hiera.set?
          create_shared_folders
        end
        @app.call(env)
      end

      def create_shared_folders
        @env[:ui].info I18n.t('vagrant.plugins.hiera.middleware.prepare.shared_folders')
        folders = [{:name => 'vagrant-hiera-config', :hostpath => @env[:machine].config.hiera.config_path},
                   {:name => 'vagrant-hiera-data', :hostpath => @env[:machine].config.hiera.data_path}]
        @env[:machine].provider.driver.share_folders(folders)
      end

    end
  end
end
