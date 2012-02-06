# GSLng::Matrix is extended with two aliases:
#
# GSLng::Matrix#frames, which is an alias for GSLng::Matrix#m and GSLng::Matrix#height
#
# GSLng::Matrix#channels, which is an alias for GSLng::Matrix#n and GSLng::Matrix#width
#
class GSLng::Matrix

 
  # @method frames
  # frames is an alias for GSLng::Matrix#m and GSLng::Matrix#height
  #
  alias :frames :m
  
  
  # @method channels
  # channels is an alias for GSLng::Matrix#n and GSLng::Matrix#width
  #
  alias :channels :n

  unless instance_methods.include? :data_ptr

    class GSL_matrix < FFI::Struct # :nodoc:
      layout :size1, :size_t,
        :size2, :size_t,
        :tda, :size_t,
        :data, :pointer,
        :block, :pointer,
        :owner, :int
    end

    def data_ptr # :nodoc:
      GSL_matrix.new(ptr)[:data]
    end

  end

end
