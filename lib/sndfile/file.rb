module Sndfile

  class File
    include SndfileApi

    attr_reader :info

    #
    # Without a block, this is the same as File.new(path, opts).
    # With a block, yields the File object to the block and ensures that
    # File#close is then called .
    #
    def self.open(path, opts={})
      file = new(path, opts)
      if block_given?
        begin
          yield file
        ensure
          file.close
        end
      else
        file
      end
    end

    # Returns the `Info` for a file.  
    #
    # Equivalent to File.open(path) { |f| f.info }
    def self.info(path)
      open(path) { |f| f.info }
    end

    #
    # Create a File instance.  Options are:
    #
    #  :mode => :READ (default), :WRITE, or :RDWR
    #  :format => see list at File#format  (default is :WAV)
    #  :encoding => see list at File#encoding (default is :PCM_16)
    #  :endian => see list at File#endian (default is :FILE)
    #  :samplerate => default is 44100
    #  :channles => default is 2
    #
    # When mode is :READ, then :format, :channels, and :samplerate are
    # ignored -- unless the format is :RAW
    #
    # May raise Sndfile::Error on various error conditions
    #
    def initialize(path,opts={})
      opts = opts.keyword_args(:mode => { :valid => Enums::FileMode.symbols, :default => :READ },
                               :format => { :valid => Enums::Format.symbols, :default => :WAV },
                               :encoding => { :valid => Enums::Encoding.symbols, :default => :PCM_16 },
                               :endian => { :valid => Enums::Endian.symbols, :default => :FILE },
                               :samplerate => 44100,
                               :channels => 2
                              )

      @path = path
      sfinfo = SfInfo.new
      if opts.mode == :WRITE or opts.format == :RAW
        sfinfo[:format] = Enums::Format[opts.format]|Enums::Encoding[opts.encoding]|Enums::Endian[opts.endian]
        sfinfo[:channels] = opts.channels
        sfinfo[:samplerate] = opts.samplerate
      end
      @sfpointer = sf_open(path.to_s, opts.mode, sfinfo)
      @info = Info.from_sfinfo(sfinfo)

      check_error
      sf_command @sfpointer, :SFC_SET_CLIPPING, nil, 1
      check_error
    end

    # Closes the File instance.
    #
    # May raise Sndfile::Error for various error conditions
    def close
      check_error sf_close(@sfpointer)
    end

    Info.keys.each do |method|
      define_method method do 
        warn "[DEPRECATION]: Sndfile::File: `#{method}` is deprecated.  Use `info.#{method}` instead"
        info.send method
      end
    end


    # Reads frames from the file, returning the data in a GSLng::Matrix of
    # dimensions frames x channels.  (For convenience, the height and width
    # methods of GSLng::Matrix are aliased as GSLng::Matrix#frames and
    # GSLng::Matrix#channels)
    #
    # Normally the requested number of frames is read, unless end of file is
    # reached.  If no frames are read (i.e. already at end of file),
    # returns nil instead of a GSLng::Matrix.
    #
    # May raise Sndfile::Error in case of error.
    def read(nframes)

      buf = GSLng::Matrix.new(nframes, info.channels)

      count = sf_readf_double @sfpointer, buf.data_ptr, nframes
      check_error
      case count
      when 0 then nil
      when nframes then buf
      else buf.view(0, 0, count, info.channels)
      end
    end

    # Writes frames to the file.  The data must be (quack like) a GSLng::Matrix
    # with dimensions frames x channels.  The matrix can contain any number of
    # frames.
    #
    # When writing to a file with integer encoding, values are clipped to
    # [-1, 1].
    #
    # May raise Sndfile::Error in case of error.
    def write(buf)
      sf_writef_double @sfpointer, buf.data_ptr, buf.frames
      check_error
    end

    private

    def check_error(code = nil)
      code ||= sf_error(@sfpointer.null? ? nil : @sfpointer)
      if code != 0
        msg = sf_strerror(@sfpointer.null? ? nil : @sfpointer)
        msg += " (#{ErrorCode[code]})" if ErrorCode[code]
        msg += " [#{@path}]"
        raise Sndfile::Error, msg
      end
    end

  end
end
