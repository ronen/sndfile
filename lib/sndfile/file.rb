module Sndfile

  class File
    include SndfileApi

    def self.open(path, opts={})
      file = new(path, opts)
      if block_given?
        yield file
        file.close
      else
        file
      end
    end

    def initialize(path,opts={})
      opts = opts.keyword_args(:mode => { :valid => Enums::FileMode.symbols, :default => :READ },
                               :format => { :valid => Enums::Format.symbols, :default => :WAV },
                               :encoding => { :valid => Enums::Encoding.symbols, :default => :PCM_16 },
                               :endian => { :valid => Enums::Endian.symbols, :default => :FILE },
                               :samplerate => 44100,
                               :channels => 2,
                              )

      @path = path
      @sfinfo = SfInfo.new
      if opts.mode == :WRITE or opts.format == :RAW
        @sfinfo[:format] = Enums::Format[opts.format]|Enums::Encoding[opts.encoding]|Enums::Endian[opts.endian]
        @sfinfo[:channels] = opts.channels unless opts.mode == :READ or opts.format == :RAW
        @sfinfo[:samplerate] = opts.samplerate unless opts.mode == :READ or opts.format == :RAW
      end
      @sfpointer = sf_open(path.to_s, opts.mode, @sfinfo)
      check_error
      sf_command @sfpointer, :SFC_SET_CLIPPING, nil, 1
      check_error
    end

    def close
      check_error sf_close(@sfpointer)
    end

    def format
      Format[@sfinfo[:format] & FORMAT_MASK]
    end

    def encoding
      Encoding[@sfinfo[:format] & ENCODING_MASK]
    end

    def frames
      @sfinfo[:frames]
    end

    def samplerate
      @sfinfo[:samplerate]
    end

    def channels
      @sfinfo[:channels]
    end

    def read(n)

      buf = GSLng::Matrix.new(n, channels)

      count = sf_readf_double @sfpointer, buf.data_ptr, n
      check_error
      case count
      when 0 then nil
      when n then buf
      else buf.view(0, 0, count, channels)
      end
    end

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
