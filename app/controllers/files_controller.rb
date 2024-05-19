class FilesController < ApplicationController
  def show
    @shared_lib = params[:shared_lib]
    decoded_path = URI.decode_uri_component(params[:path].gsub('*', '.'))

    path = unless @shared_lib
             decoded_path
           else
             ::Files::SharedLibs::PathService.call(decoded_path)
           end

    @stat_buf = File.stat(path)
  end
end
