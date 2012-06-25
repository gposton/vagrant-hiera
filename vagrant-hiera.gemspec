# -*- encoding: utf-8 -*-
require File.expand_path('../lib/vagrant-hiera/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Glenn Poston"]
  gem.email         = ["gposton1040@gmail.com"]
  gem.description   = %q{Configure a vagrant box to use puppet-hiera}
  gem.summary       = %q{Configure a vagrant box to use puppet-hiera}
  gem.homepage      = "https://github.com/gposton/vagrant-hiera"

 gem.add_development_dependency "vagrant"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "vagrant-hiera"
  gem.require_paths = ["lib"]
  gem.version       = Vagrant::Hiera::VERSION
end
