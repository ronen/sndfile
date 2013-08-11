Libsndfile for Ruby
-------------
[![Build Status](https://travis-ci.org/ronen/sndfile.png)](https://travis-ci.org/ronen/sndfile)
[![Dependency Status](https://gemnasium.com/ronen/sndfile.png)](https://gemnasium.com/ronen/sndfile)

*sndfile* provides a fast and easy way to read, process, and write audio
file data.  It wraps the [libsndfile](http://www.mega-nerd.com/libsndfile/)
C library via [FFI](http://github.com/ffi/ffi), reading & writing the
sample data as a [GSLng](https://github.com/v01d/ruby-gsl-ng) matrix.

The author has (so far) fleshed out only the parts needed for his own projects.  Please do fork this project and contribute to it.

Libsndfile?
===========
"Libsndfile is a C library for reading and writing files containing sampled sound (such as MS Windows WAV and the Apple/SGI AIFF format) through one standard library interface. It is released in source code format under the Gnu Lesser General Public License."


Installation
============

To use this Ruby library, you must have [libsndfile](http://www.mega-nerd.com/libsndfile/) and [GSL](http://www.gnu.org/software/gsl/) on your machine. You can install
them via apt-get (linux) or homebrew (OS X) or download them directly from their websites.

That being said:

  gem install sndfile

or, in a Gemfile

  gem "sndfile-ruby", :require => "sndfile"

Usage
=====

Here's a simple example, that reads an arbitrary source file and produces a WAV file at half the volume:

    fin = Sndfile::File.new(inpath)
    Sndfile::File.open(outpath, :mode => :WRITE, :format => :WAV, :encoding => :PCM_16, :channels => fin.info.channels, :samplerate => fin.info.samplerate) do |fout|
      while data = fin.read(10000)
        fout.write(data * 0.5)
      end
    end

The audio file info, available as `Sndfile::File#info` as per the above example, is an instance of `Sndfile::Info`.  You can also query it directly for a file:

    info = Sndfile::File.info(filepath) #=> an instance of Sndfile::Info
    #    => info.format
    #    => info.encoding
    #    => info.endian
    #    => info.frames
    #    => info.samplerate
    #    => info.channels

See the [RDOC](http://rubydoc.info/gems/sndfile) for complete details

Compatibility
=============

Known to work with MRI ruby 1.9.3, and 2.0.0


History
=======

Release notes:

* 0.2.0 - support ruby 1.8.7.  thanks to [youpy](https://github.com/youpy)
* 0.1.3 - Back to ruby-gsl-ng: memory leaks fixed
* 0.1.2 - Use ruby-gsl-ngx to avoid memory leaks
* 0.1.1 - Clean up vestigial includes in integration test
* 0.1.0 - Initial public release
