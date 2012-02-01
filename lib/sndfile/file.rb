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
                               :endian => { :valid => Enums::Endian.symbols, :default => :LITTLE },
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

    def read(n, opts={})
      opts = opts.keyword_args(
        :type => {:valid => [:short, :int, :float, :double], :default => :double},
      )

      buf = FFI::Buffer.alloc_out(opts.type, n*channels)
      count = send "sf_readf_#{opts.type}", @sfpointer, buf, n
      check_error
      if count == 0
        nil
      else
        buf.send "read_array_of_#{opts.type}", count*channels
      end
    end

    def write(data)
      n = data.length / channels
      type = case data[0]
             when Float then :double
             else :int
             end
      buf = FFI::Buffer.alloc_in(type, data.length)
      buf.send "write_array_of_#{type}", data
      send "sf_writef_#{type}", @sfpointer, buf, data.length/channels
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
