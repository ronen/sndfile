module Sndfile
  #
  # Exception raised in case of errors from libsndfile.  The message
  # contains the libsndfile error message.
  #
  class Error < RuntimeError
  end
end
