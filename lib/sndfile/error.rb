module Sndfile
  #
  # Exception raised in case of errors from libsndfile.  The message
  # contains the libsndfile error message.
  #
  class Error < RuntimeError
    attr_reader :description
    attr_reader :code
    attr_reader :file
    def initialize(args)
      args = args.keyword_args(:description, :code, :file)
      @description = args.description
      @code = args.code
      @file = args.file
    end

    def to_s
      s = ""
      s << @description if @description
      s << " (#{@code})" if @code
      s << " [#{@file}]" if @file
      s
    end

  end
end
