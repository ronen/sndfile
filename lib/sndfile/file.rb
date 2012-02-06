module Sndfile

  class File
    include SndfileApi

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
                               :channels => 2,
                              )

      @path = path
      @sfinfo = SfInfo.new
      if opts.mode == :WRITE or opts.format == :RAW
        @sfinfo[:format] = Enums::Format[opts.format]|Enums::Encoding[opts.encoding]|Enums::Endian[opts.endian]
        @sfinfo[:channels] = opts.channels
        @sfinfo[:samplerate] = opts.samplerate
      end
      @sfpointer = sf_open(path.to_s, opts.mode, @sfinfo)
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

    # Returns the format of the file, which is one of
    #
    #  :WAV           - Microsoft WAV format (little endian).
    #  :AIFF          - Apple/SGI AIFF format (big endian).
    #  :AU            - Sun/NeXT AU format (big endian).
    #  :RAW           - RAW PCM data.
    #  :PAF           - Ensoniq PARIS file format.
    #  :SVX           - Amiga IFF / SVX8 / SV16 format.
    #  :NIST          - Sphere NIST format.
    #  :VOC           - VOC files.
    #  :IRCAM         - Berkeley/IRCAM/CARL
    #  :W64           - Sonic Foundry's 64 bit RIFF/WAV
    #  :MAT4          - Matlab (tm) V4.2 / GNU Octave 2.0
    #  :MAT5          - Matlab (tm) V5.0 / GNU Octave 2.1
    #  :PVF           - Portable Voice Format
    #  :XI            - Fasttracker 2 Extended Instrument
    #  :HTK           - HMM Tool Kit format
    #  :SDS           - Midi Sample Dump Standard
    #  :AVR           - Audio Visual Research
    #  :WAVEX         - MS WAVE with WAVEFORMATEX
    #  :SD2           - Sound Designer 2
    #  :FLAC          - FLAC lossless file format
    #  :CAF           - Core Audio File format
    #  :WVE           - Psion WVE format
    #  :OGG           - Xiph OGG container
    #  :MPC2K         - Akai MPC 2000 sampler
    #  :RF64          - RF64 WAV file
    def format
      Format[@sfinfo[:format] & FORMAT_MASK]
    end

    # Returns the encoding of the file data, which is one of:
    #
    #  :PCM_S8        - Signed 8 bit data
    #  :PCM_16        - Signed 16 bit data
    #  :PCM_24        - Signed 24 bit data
    #  :PCM_32        - Signed 32 bit data
    #  :PCM_U8        - Unsigned 8 bit data (WAV and RAW only)
    #  :FLOAT         - 32 bit float data
    #  :DOUBLE        - 64 bit float data
    #  :ULAW          - U-Law encoded.
    #  :ALAW          - A-Law encoded.
    #  :IMA_ADPCM     - IMA ADPCM.
    #  :MS_ADPCM      - Microsoft ADPCM.
    #  :GSM610        - GSM 6.10 encoding.
    #  :VOX_ADPCM     - Oki Dialogic ADPCM encoding.
    #  :G721_32       - 32kbs G721 ADPCM encoding.
    #  :G723_24       - 24kbs G723 ADPCM encoding.
    #  :G723_40       - 40kbs G723 ADPCM encoding.
    #  :DWVW_12       - 12 bit Delta Width Variable Word encoding.
    #  :DWVW_16       - 16 bit Delta Width Variable Word encoding.
    #  :DWVW_24       - 24 bit Delta Width Variable Word encoding.
    #  :DWVW_N        - N bit Delta Width Variable Word encoding.
    #  :DPCM_8        - 8 bit differential PCM (XI only)
    #  :DPCM_16       - 16 bit differential PCM (XI only)
    #  :VORBIS        - Xiph Vorbis encoding.
    def encoding
      Encoding[@sfinfo[:format] & ENCODING_MASK]
    end

    # Returns the endian-ness of the data, one of:
    #
    #  :FILE          - Default file endian-ness.
    #  :LITTLE        - Force little endian-ness.
    #  :BIG           - Force big endian-ness.
    #  :CPU           - Force CPU endian-ness.
    def endian
      Endian[@sfinfo[:format] & ENDIAN_MASK]
    end

    # Returns the number of frames (samples) in the file
    def frames
      @sfinfo[:frames]
    end

    # Returns the sample rate, frames per second
    def samplerate
      @sfinfo[:samplerate]
    end

    # Returns the number of channels of data
    def channels
      @sfinfo[:channels]
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

      buf = GSLng::Matrix.new(nframes, channels)

      count = sf_readf_double @sfpointer, buf.data_ptr, nframes
      check_error
      case count
      when 0 then nil
      when nframes then buf
      else buf.view(0, 0, count, channels)
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
