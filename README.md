Libsndfile for Ruby
-------------

*ruby-sndfile* wraps the [libsndfile](http://www.mega-nerd.com/libsndfile/) C library using [FFI](http://github.com/ffi/ffi).

It is far from complete, but all the basic techniques for interfacing Ruby with libndfile are outlined. The author has (so far) fleshed out only the parts needed for his own projects.  Please do fork this project and contribute to it.

Libsndfile?
=====
"Libsndfile is a C library for reading and writing files containing sampled sound (such as MS Windows WAV and the Apple/SGI AIFF format) through one standard library interface. It is released in source code format under the Gnu Lesser General Public License."

Installation
============

To use this Ruby library, you must have libsndfile on your machine. [Download it](http://www.fmod.org/index.php/download) or install via apt-get (linux) or brew (OS X) or however.

That being said:

  gem install sndfile-ruby

or, in a Gemfile

  gem "sndfile-ruby", :require => "sndfile"

Usage
=====
Here's a simple example, that reads an arbitrary source file and produces a WAV file at half the volume:

    fin = Sndfile::File.new(inpath)
    Sndfile::File.open(outpath, :mode => :WRITE, :format => :WAV, :encoding => :PCM_16, :channels => 2, :samplerate => fin.samplerate) do |fout|
      while data = fin.read(10000)
        fout.write(data.map{|x| 0.5*x})
      end
    end

See the [RDOC](http://rubydoc.info/gems/schema_plus) for more info.


History
=======
