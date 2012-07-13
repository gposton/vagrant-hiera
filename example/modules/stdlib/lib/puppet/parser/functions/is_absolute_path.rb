module Puppet::Parser::Functions
  newfunction(:is_absolute_path, :type => :rvalue, :doc => <<-'ENDHEREDOC'
    Returns true if a string represents an absolute path, or false if it is relative. This is mostly a copy of the puppetlabs-stdlib function 'validate_absolute_path', only it does not raise an exception, merely returns true or false.
              ENDHEREDOC
  ) do |args|

    require 'puppet/util'

    unless args.length == 1 then
      raise Puppet::ParseError, ("is_absolute_path(): wrong number of arguments (#{args.length}; must be 1)")
    end

    path = args[0]

    # This logic was borrowed from
    # [lib/puppet/file_serving/base.rb](https://github.com/puppetlabs/puppet/blob/master/lib/puppet/file_serving/base.rb)

    # Puppet 2.7 and beyond will have Puppet::Util.absolute_path?  Fall back to a back-ported implementation otherwise.
    if Puppet::Util.respond_to?(:absolute_path?) then
      Puppet::Util.absolute_path?(path, :posix) or Puppet::Util.absolute_path?(path, :windows)
    else
      puts "yes"
      # This code back-ported from 2.7.x's lib/puppet/util.rb Puppet::Util.absolute_path?
      # Determine in a platform-specific way whether a path is absolute. This
      # defaults to the local platform if none is specified.
      # Escape once for the string literal, and once for the regex.
      slash = '[\\\\/]'
      name = '[^\\\\/]+'
      regexes = {
        :windows => %r!^(([A-Z]:#{slash})|(#{slash}#{slash}#{name}#{slash}#{name})|(#{slash}#{slash}\?#{slash}#{name}))!i,
        :posix   => %r!^/!,
      }

      (!!(path =~ regexes[:posix])) || (!!(path =~ regexes[:windows]))
    end
  end
end
