# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'modis/version'

Gem::Specification.new do |gem|
  gem.name          = "modis"
  gem.version       = Modis::VERSION
  gem.authors       = ["Ian Leitch"]
  gem.email         = ["port001@gmail.com"]
  gem.description   = "ActiveModel + Redis"
  gem.summary       = "ActiveModel + Redis"
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'activemodel', '>= 3.0'
  gem.add_runtime_dependency 'activesupport', '>= 3.0'
  gem.add_runtime_dependency 'redis', '>= 3.0'
  gem.add_runtime_dependency 'hiredis', '>= 0.5'
  gem.add_runtime_dependency 'connection_pool', '>= 2'
  gem.add_runtime_dependency 'rediscluster', '>= 0.1'

  if defined? JRUBY_VERSION
    gem.platform = 'java'
    gem.add_runtime_dependency 'msgpack-jruby'
  else
    gem.add_runtime_dependency 'msgpack', '>= 0.5'
  end
end
