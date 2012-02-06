module Sndfile # :nodoc: all
  module Enums
    extend FFI::Library

    # Error Codes
    ErrorCode = enum(
      :SF_ERR_NO_ERROR,             0,
      :SF_ERR_UNRECOGNISED_FORMAT,  1,
      :SF_ERR_SYSTEM,               2,
      :SF_ERR_MALFORMED_FILE,       3,
      :SF_ERR_UNSUPPORTED_ENCODING, 4,
    )
      

    # Modes for opening files.
    FileMode = enum(
      :READ,  0x10,
      :WRITE,  0x20,
      :RDWR,  0x30,
    )

    # Major formats.
    FORMAT_MASK =  0x0FFF0000
    Format = enum(
      :WAV,           0x010000,     # Microsoft WAV format (little endian).
      :AIFF,          0x020000,     # Apple/SGI AIFF format (big endian).
      :AU,            0x030000,     # Sun/NeXT AU format (big endian).
      :RAW,           0x040000,     # RAW PCM data.
      :PAF,           0x050000,     # Ensoniq PARIS file format.
      :SVX,           0x060000,     # Amiga IFF / SVX8 / SV16 format.
      :NIST,          0x070000,     # Sphere NIST format.
      :VOC,           0x080000,     # VOC files.
      :IRCAM,         0x0A0000,     # Berkeley/IRCAM/CARL
      :W64,           0x0B0000,     # Sonic Foundry's 64 bit RIFF/WAV
      :MAT4,          0x0C0000,     # Matlab (tm) V4.2 / GNU Octave 2.0
      :MAT5,          0x0D0000,     # Matlab (tm) V5.0 / GNU Octave 2.1
      :PVF,           0x0E0000,     # Portable Voice Format
      :XI,            0x0F0000,     # Fasttracker 2 Extended Instrument
      :HTK,           0x100000,     # HMM Tool Kit format
      :SDS,           0x110000,     # Midi Sample Dump Standard
      :AVR,           0x120000,     # Audio Visual Research
      :WAVEX,         0x130000,     # MS WAVE with WAVEFORMATEX
      :SD2,           0x160000,     # Sound Designer 2
      :FLAC,          0x170000,     # FLAC lossless file format
      :CAF,           0x180000,     # Core Audio File format
      :WVE,           0x190000,     # Psion WVE format
      :OGG,           0x200000,     # Xiph OGG container
      :MPC2K,         0x210000,     # Akai MPC 2000 sampler
      :RF64,          0x220000,     # RF64 WAV file
    )

    # Subtypes from here on.
    ENCODING_MASK =  0x0000FFFF
    Encoding = enum(
      :PCM_S8,        0x0001,       # Signed 8 bit data
      :PCM_16,        0x0002,       # Signed 16 bit data
      :PCM_24,        0x0003,       # Signed 24 bit data
      :PCM_32,        0x0004,       # Signed 32 bit data

      :PCM_U8,        0x0005,       # Unsigned 8 bit data (WAV and RAW only)

      :FLOAT,         0x0006,       # 32 bit float data
      :DOUBLE,        0x0007,       # 64 bit float data

      :ULAW,          0x0010,       # U-Law encoded.
      :ALAW,          0x0011,       # A-Law encoded.
      :IMA_ADPCM,     0x0012,       # IMA ADPCM.
      :MS_ADPCM,      0x0013,       # Microsoft ADPCM.

      :GSM610,        0x0020,       # GSM 6.10 encoding.
      :VOX_ADPCM,     0x0021,       # Oki Dialogic ADPCM encoding.

      :G721_32,       0x0030,       # 32kbs G721 ADPCM encoding.
      :G723_24,       0x0031,       # 24kbs G723 ADPCM encoding.
      :G723_40,       0x0032,       # 40kbs G723 ADPCM encoding.

      :DWVW_12,       0x0040,       # 12 bit Delta Width Variable Word encoding.
      :DWVW_16,       0x0041,       # 16 bit Delta Width Variable Word encoding.
      :DWVW_24,       0x0042,       # 24 bit Delta Width Variable Word encoding.
      :DWVW_N,        0x0043,       # N bit Delta Width Variable Word encoding.

      :DPCM_8,        0x0050,       # 8 bit differential PCM (XI only)
      :DPCM_16,       0x0051,       # 16 bit differential PCM (XI only)

      :VORBIS,        0x0060,       # Xiph Vorbis encoding.
    )

    # Endian-ness options.
    ENDIAN_MASK =     0x30000000
    Endian = enum(
      :FILE,          0x00000000,   # Default file endian-ness.
      :LITTLE,        0x10000000,   # Force little endian-ness.
      :BIG,           0x20000000,   # Force big endian-ness.
      :CPU,           0x30000000,   # Force CPU endian-ness.
    )

    # Command numbers for sf_command
    Command = enum(
	:SFC_GET_LIB_VERSION,				 0x1000,
	:SFC_GET_LOG_INFO,				 0x1001,
	:SFC_GET_CURRENT_SF_INFO,			 0x1002,


	:SFC_GET_NORM_DOUBLE,				 0x1010,
	:SFC_GET_NORM_FLOAT,				 0x1011,
	:SFC_SET_NORM_DOUBLE,				 0x1012,
	:SFC_SET_NORM_FLOAT,				 0x1013,
	:SFC_SET_SCALE_FLOAT_INT_READ,	 0x1014,
	:SFC_SET_SCALE_INT_FLOAT_WRITE,	 0x1015,

	:SFC_GET_SIMPLE_FORMAT_COUNT,		 0x1020,
	:SFC_GET_SIMPLE_FORMAT,			 0x1021,

	:SFC_GET_FORMAT_INFO,				 0x1028,

	:SFC_GET_FORMAT_MAJOR_COUNT,		 0x1030,
	:SFC_GET_FORMAT_MAJOR,			 0x1031,
	:SFC_GET_FORMAT_SUBTYPE_COUNT,	 0x1032,
	:SFC_GET_FORMAT_SUBTYPE,			 0x1033,

	:SFC_CALC_SIGNAL_MAX,				 0x1040,
	:SFC_CALC_NORM_SIGNAL_MAX,		 0x1041,
	:SFC_CALC_MAX_ALL_CHANNELS,		 0x1042,
	:SFC_CALC_NORM_MAX_ALL_CHANNELS,	 0x1043,
	:SFC_GET_SIGNAL_MAX,				 0x1044,
	:SFC_GET_MAX_ALL_CHANNELS,		 0x1045,

	:SFC_SET_ADD_PEAK_CHUNK,			 0x1050,
	:SFC_SET_ADD_HEADER_PAD_CHUNK,	 0x1051,

	:SFC_UPDATE_HEADER_NOW,			 0x1060,
	:SFC_SET_UPDATE_HEADER_AUTO,		 0x1061,

	:SFC_FILE_TRUNCATE,				 0x1080,

	:SFC_SET_RAW_START_OFFSET,		 0x1090,

	:SFC_SET_DITHER_ON_WRITE,			 0x10A0,
	:SFC_SET_DITHER_ON_READ,			 0x10A1,

	:SFC_GET_DITHER_INFO_COUNT,		 0x10A2,
	:SFC_GET_DITHER_INFO,				 0x10A3,

	:SFC_GET_EMBED_FILE_INFO,			 0x10B0,

	:SFC_SET_CLIPPING,				 0x10C0,
	:SFC_GET_CLIPPING,				 0x10C1,

	:SFC_GET_INSTRUMENT,				 0x10D0,
	:SFC_SET_INSTRUMENT,				 0x10D1,

	:SFC_GET_LOOP_INFO,				 0x10E0,

	:SFC_GET_BROADCAST_INFO,			 0x10F0,
	:SFC_SET_BROADCAST_INFO,			 0x10F1,

	:SFC_GET_CHANNEL_MAP_INFO,		 0x1100,
	:SFC_SET_CHANNEL_MAP_INFO,		 0x1101,

	:SFC_RAW_DATA_NEEDS_ENDSWAP,		 0x1110,

	# Support for Wavex Ambisonics Format
	:SFC_WAVEX_SET_AMBISONIC,			 0x1200,
	:SFC_WAVEX_GET_AMBISONIC,			 0x1201,

	:SFC_SET_VBR_ENCODING_QUALITY,	 0x1300,

	# Following commands for testing only.
	:SFC_TEST_IEEE_FLOAT_REPLACE,		 0x6001,

	##
	## :SFC_SET_ADD_* values are deprecated and will disappear at some
	## time in the future. They are guaranteed to be here up to and
	## including version 1.0.8 to avoid breakage of existng software.
	## They currently do nothing and will continue to do nothing.
	##
	:SFC_SET_ADD_DITHER_ON_WRITE,		 0x1070,
	:SFC_SET_ADD_DITHER_ON_READ,		 0x1071
    )
  end
end
