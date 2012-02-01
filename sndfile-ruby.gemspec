# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sndfile/version', __FILE__)

Gem::Specification.new do |gem|
    gem.authors       = ["ronen barzel"]
    gem.email         = ["ronen@barzel.org"]
    gem.description   = %q{Wrapper for libsndfile}
    gem.summary       = %q{Wrapper for libsndfile}
    gem.homepage      = "https://github.com/ronen/sndfile-ruby"

    gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
    gem.files         = `git ls-files`.split("\n")
    gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
    gem.name          = "sndfile-ruby"
    gem.require_paths = ["lib"]
    gem.version       = Sndfile::VERSION

    gem.add_dependency("ffi")
    gem.add_dependency("hash_keyword_args")

    gem.add_development_dependency 'rake'
    gem.add_development_dependency 'rspec'
    gem.add_development_dependency 'simplecov'
    gem.add_development_dependency 'simplecov-gem-adapter'
end
