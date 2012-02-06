module Sndfile
  module SndfileApi
    extend FFI::Library
    include Enums

    ffi_lib 'libsndfile'

    typedef :int64, :sf_count_t

    class SfInfo < FFI::Struct
      layout :frames, :sf_count_t,
        :samplerate, :int,
        :channels, :int,
        :format, :int,
        :sections, :int,
        :seekable, :int
    end

    # SNDFILE*    sf_open          (const char *path, int mode, SF_INFO *sfinfo) ;
    # SNDFILE*    sf_open_fd       (int fd, int mode, SF_INFO *sfinfo, int close_desc) ;
    # SNDFILE* 	sf_open_virtual  (SF_VIRTUAL_IO *sfvirtual, int mode, SF_INFO *sfinfo, void *user_data) ;
    # int         sf_format_check  (const SF_INFO *info) ;
    attach_function :sf_open,          [:string, FileMode, :pointer], :pointer
    attach_function :sf_open_fd,       [:int, :int, :pointer, :int], :pointer
    attach_function :sf_open_virtual,  [:pointer, :int, :pointer, :pointer], :pointer
    attach_function :sf_format_check,  [:pointer], :int         

    # sf_count_t  sf_seek          (SNDFILE *sndfile, sf_count_t frames, int whence) ;
    attach_function :sf_seek,          [:pointer, :sf_count_t, :int], :sf_count_t  

    # int         sf_command       (SNDFILE *sndfile, int cmd, void *data, int datasize) ;
    attach_function :sf_command,       [:pointer, Command, :pointer, :int], :int

    # int         sf_error         (SNDFILE *sndfile) ;
    # const char* sf_strerror      (SNDFILE *sndfile) ;
    # const char* sf_error_number  (int errnum) ;
    attach_function :sf_error,         [:pointer], :int         
    attach_function :sf_strerror,      [:pointer], :string
    attach_function :sf_error_number,  [:int], :string

    # int         sf_perror        (SNDFILE *sndfile) ;
    # int         sf_error_str     (SNDFILE *sndfile, char* str, size_t len) ;
    attach_function :sf_perror,        [:pointer], :int         
    attach_function :sf_error_str,     [:pointer, :pointer, :int], :int         

    # int         sf_close         (SNDFILE *sndfile) ;
    # void        sf_write_sync    (SNDFILE *sndfile) ;
    attach_function :sf_close,         [:pointer], :int         
    attach_function :sf_write_sync,    [:pointer], :void


    # sf_count_t  sf_read_short    (SNDFILE *sndfile, short *ptr, sf_count_t items) ;
    # sf_count_t  sf_read_int      (SNDFILE *sndfile, int *ptr, sf_count_t items) ;
    # sf_count_t  sf_read_float    (SNDFILE *sndfile, float *ptr, sf_count_t items) ;
    # sf_count_t  sf_read_double   (SNDFILE *sndfile, double *ptr, sf_count_t items) ;
    attach_function :sf_read_short,    [:pointer, :pointer, :sf_count_t], :sf_count_t  
    attach_function :sf_read_int,      [:pointer, :pointer, :sf_count_t], :sf_count_t  
    attach_function :sf_read_float,    [:pointer, :pointer, :sf_count_t], :sf_count_t  
    attach_function :sf_read_double,   [:pointer, :pointer, :sf_count_t], :sf_count_t  

    # sf_count_t  sf_readf_short   (SNDFILE *sndfile, short *ptr, sf_count_t frames) ;
    # sf_count_t  sf_readf_int     (SNDFILE *sndfile, int *ptr, sf_count_t frames) ;
    # sf_count_t  sf_readf_float   (SNDFILE *sndfile, float *ptr, sf_count_t frames) ;
    # sf_count_t  sf_readf_double  (SNDFILE *sndfile, double *ptr, sf_count_t frames) ;
    attach_function :sf_readf_short,   [:pointer, :pointer, :sf_count_t], :sf_count_t  
    attach_function :sf_readf_int,     [:pointer, :pointer, :sf_count_t], :sf_count_t  
    attach_function :sf_readf_float,   [:pointer, :pointer, :sf_count_t], :sf_count_t  
    attach_function :sf_readf_double,  [:pointer, :pointer, :sf_count_t], :sf_count_t  

    # sf_count_t  sf_write_short   (SNDFILE *sndfile, short *ptr, sf_count_t items) ;
    # sf_count_t  sf_write_int     (SNDFILE *sndfile, int *ptr, sf_count_t items) ;
    # sf_count_t  sf_write_float   (SNDFILE *sndfile, float *ptr, sf_count_t items) ;
    # sf_count_t  sf_write_double  (SNDFILE *sndfile, double *ptr, sf_count_t items) ;
    attach_function :sf_write_short,   [:pointer, :pointer, :sf_count_t], :sf_count_t  
    attach_function :sf_write_int,     [:pointer, :pointer, :sf_count_t], :sf_count_t  
    attach_function :sf_write_float,   [:pointer, :pointer, :sf_count_t], :sf_count_t  
    attach_function :sf_write_double,  [:pointer, :pointer, :sf_count_t], :sf_count_t  

    # sf_count_t  sf_writef_short  (SNDFILE *sndfile, short *ptr, sf_count_t frames) ;
    # sf_count_t  sf_writef_int    (SNDFILE *sndfile, int *ptr, sf_count_t frames) ;
    # sf_count_t  sf_writef_float  (SNDFILE *sndfile, float *ptr, sf_count_t frames) ;
    # sf_count_t  sf_writef_double (SNDFILE *sndfile, double *ptr, sf_count_t frames) ;
    attach_function :sf_writef_short,  [:pointer, :pointer, :sf_count_t], :sf_count_t  
    attach_function :sf_writef_int,    [:pointer, :pointer, :sf_count_t], :sf_count_t  
    attach_function :sf_writef_float,  [:pointer, :pointer, :sf_count_t], :sf_count_t  
    attach_function :sf_writef_double, [:pointer, :pointer, :sf_count_t], :sf_count_t  

    # sf_count_t  sf_read_raw      (SNDFILE *sndfile, void *ptr, sf_count_t bytes) ;
    # sf_count_t  sf_write_raw     (SNDFILE *sndfile, void *ptr, sf_count_t bytes) ;
    attach_function :sf_read_raw,      [:pointer, :pointer, :sf_count_t], :sf_count_t  
    attach_function :sf_write_raw,     [:pointer, :pointer,  :sf_count_t], :sf_count_t  

    # const char* sf_get_string    (SNDFILE *sndfile, int str_type) ;
    # int         sf_set_string    (SNDFILE *sndfile, int str_type, const char* str) ;
    attach_function :sf_get_string,    [:pointer, :int], :string
    attach_function :sf_set_string,    [:pointer, :int, :string], :int         
  end
end
