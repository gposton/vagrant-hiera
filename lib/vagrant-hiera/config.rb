module VagrantHiera

  class Config < Vagrant::Config::Base
    attr_accessor :config_path
    attr_accessor :guest_config_path
    attr_accessor :config_file
    attr_accessor :data_path
    attr_accessor :guest_data_path

    attr_accessor :puppet_apt_source
    attr_accessor :puppet_version
    attr_accessor :hiera_puppet_version
    attr_accessor :hiera_version
    attr_accessor :apt_opts

    def guest_config_path
      @guest_config_path.nil? ? (@guest_config_path = '/tmp/vagrant-hiera/config') : @guest_config_path
    end

    def guest_data_path
      @guest_data_path.nil? ? (@guest_data_path = '/tmp/vagrant-hiera/data') : @guest_data_path
    end

    def puppet_apt_source
      @puppet_apt_source.nil? ? (@puppet_apt_source = 'deb http://apt.puppetlabs.com/ lucid devel main') : @puppet_apt_source
    end

    def puppet_version
      @puppet_version.nil? ? (@puppet_version = '3.0.0-0.1rc5puppetlabs1') : @puppet_version
    end

    def hiera_puppet_version
      @hiera_puppet_version.nil? ? (@hiera_puppet_version = '1.0.0-0.1rc3') : @hiera_puppet_version
    end

    def skip_hiera_puppet!
      @skip_hiera_puppet = true
    end

    def skip_hiera_puppet?
      @skip_hiera_puppet
    end

    def hiera_version
      @hiera_version.nil? ? (@hiera_version = '1.0.0-0.1rc4') : @hiera_version
    end

    def apt_opts
      @apt_opts.nil? ? (@apt_opts = '-y --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"') : @apt_opts
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

    def validate(env, errors)
      return unless set?

      errors.add("Config path can not be empty.") if config_path.nil?
      errors.add("Config file can not be empty.") if config_file.nil?
      errors.add("Data path can not be empty.") if data_path.nil?
      errors.add("Puppet apt source can not be empty.") if puppet_apt_source.nil?
      errors.add("Puppet version path can not be empty.") if puppet_version.nil?
      errors.add("Hiera puppet version path can not be empty.") if hiera_puppet_version.nil? && !@skip_hiera_puppet
      errors.add("Hiera version path can not be empty.") if hiera_version.nil?
      errors.add("Apt opts path can not be empty.") if apt_opts.nil?
      config = File.join("#{config_path}", "#{config_file}")
      errors.add("Config file not found at '#{config}'.") unless File.exists?(config)
      errors.add("Data directory not found at '#{data_path}'.") unless File.exists?("#{data_path}")
    end
  end
end
