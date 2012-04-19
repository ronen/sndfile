# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sndfile/version', __FILE__)

Gem::Specification.new do |gem|
    gem.authors       = ["ronen barzel"]
    gem.email         = ["ronen@barzel.org"]
    gem.description   = %q{Ruby wrapper for libsndfile.  Reads/writes data as GSL matrices, to allow fast processing.}
    gem.summary       = %q{Ruby wrapper for libsndfile.  Reads/writes data as GSL matrices, to allow fast processing.}
    gem.homepage      = "https://github.com/ronen/sndfile"

    gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
    gem.files         = `git ls-files`.split("\n")
    gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
    gem.name          = "sndfile"
    gem.require_paths = ["lib"]
    gem.version       = Sndfile::VERSION

    gem.add_dependency("ffi")
    gem.add_dependency("ruby-gsl-ngx")  # depend on ruby-gsl-ngx instead of ruby-gsl-ng for now, for memory fix
    gem.add_dependency("hash_keyword_args")

    gem.add_development_dependency 'rake'
    gem.add_development_dependency 'rspec'
    gem.add_development_dependency 'simplecov'
    gem.add_development_dependency 'simplecov-gem-adapter'
end
