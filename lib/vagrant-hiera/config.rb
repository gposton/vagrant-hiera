require 'vagrant'
module VagrantHiera

  class Config < Vagrant.plugin(2, :config)
    attr_accessor :config_path
    attr_accessor :guest_config_path
    attr_accessor :config_file
    attr_accessor :data_path
    attr_accessor :guest_data_path

    attr_accessor :puppet_apt_source
    attr_accessor :apt_opts
    attr_accessor :puppet_version
    attr_accessor :hiera_puppet_version
    attr_accessor :hiera_version

    #name "vagrant-hiera"
    #def initialize
    #  @widgets = UNSET_VALUE
    #end

    #def finalize!
    #  @widgets = 0 if @widgets == UNSET_VALUE
    #end

    def guest_config_path
      @guest_config_path ||= '/tmp/vagrant-hiera/config'
    end

    def guest_data_path
      @guest_data_path ||= '/tmp/vagrant-hiera/data'
    end

    def puppet_apt_source
      @puppet_apt_source ||= 'deb http://apt.puppetlabs.com/ stable main'
    end

    def apt_opts
      @apt_opts ||= '-y --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"'
    end

    def puppet_version
      @puppet_version ||= '3.0.0-1puppetlabs1'
    end

    def hiera_puppet_version
      @hiera_puppet_version
    end

    def hiera_version
      @hiera_version ||= '1.0.0-1puppetlabs2'
    end

    def config_path
      File.expand_path(@config_path) rescue nil
    end

    def data_path
      File.expand_path(@data_path) rescue nil
    end

    def set?
      config_path || config_file || data_path
    end

    def install_puppet_heira?
      puppet_version.to_i < 3
    end

    def validate(machine)
      return unless set?
      errors = _detected_errors

      errors << "Config path can not be empty." if config_path.nil?
      errors << "Config file can not be empty." if config_file.nil?
      errors << "Data path can not be empty." if data_path.nil?
      errors << "Puppet version path can not be empty." if puppet_version.nil?
      errors << "Puppet apt source can not be empty." if puppet_apt_source.nil?
      errors << "Hiera puppet version can not be empty if puppet_version < 3.0." if install_puppet_heira? && hiera_puppet_version.nil?
      errors << "Hiera version can not be empty." if hiera_version.nil?
      config = File.join("#{config_path}", "#{config_file}")
      errors << "Config file not found at '#{config}'." unless File.exists?(config)
      errors << "Data directory not found at '#{data_path}'." unless File.exists?("#{data_path}")
    end
  end
end
