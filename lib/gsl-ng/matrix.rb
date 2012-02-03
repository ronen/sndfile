class GSLng::Matrix
  alias :frames :m
  alias :channels :n

  unless instance_methods.include? :data_ptr

    class GSL_matrix < FFI::Struct
      layout :size1, :size_t,
        :size2, :size_t,
        :tda, :size_t,
        :data, :pointer,
        :block, :pointer,
        :owner, :int
    end

    def data_ptr
      GSL_matrix.new(ptr)[:data]
    end

  end

end
