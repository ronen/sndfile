Libsndfile for Ruby
-------------

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
    Sndfile::File.open(outpath, :mode => :WRITE, :format => :WAV, :encoding => :PCM_16, :channels => fin.channels, :samplerate => fin.samplerate) do |fout|
      while data = fin.read(10000)
        fout.write(data * 0.5)
      end
    end

See the [RDOC](http://rubydoc.info/gems/sndfile) for more info.


History
=======
