require 'key_struct'

module Sndfile

  # The Info class encapsulates the metdata about the audio contents.  

  class Info < KeyStruct[:format, :encoding, :endian, :frames, :samplerate, :channels]
    include Enums

    # :nodoc:
    def self.from_sfinfo(sfinfo)
      new(
        :format => Format[sfinfo[:format] & FORMAT_MASK],
        :encoding => Encoding[sfinfo[:format] & ENCODING_MASK],
        :endian => Endian[sfinfo[:format] & ENDIAN_MASK],
        :frames => sfinfo[:frames],
        :samplerate => sfinfo[:samplerate],
        :channels => sfinfo[:channels]
      )
    end

    ##
    # :attr_accessor: format
    # The file format, expressed as one of the following symbols:
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
    #

    ##
    # :attr_accessor: encoding
    # The file encoding, expressed as one of the following symbols:
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

    ##
    # :attr_accessor: endian
    # The endian-ness of the data, expressed as one of the following symbols:
    #
    #  :FILE          - Default file endian-ness.
    #  :LITTLE        - Force little endian-ness.
    #  :BIG           - Force big endian-ness.
    #  :CPU           - Force CPU endian-ness.

    ##
    # :attr_accessor: frames
    # The number of frames (samples) in the file

    ##
    # :attr_accessor: samplerate
    # The sample rate, frames per second

    ##
    # :attr_accessor: channels
    # Returns the number of channels of data, e.g. 1 for mono and 2 for
    # stereo

  end
end
