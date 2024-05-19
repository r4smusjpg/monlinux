class FilesController < ApplicationController
  def show
    @shared_lib = params[:shared_lib]
    decoded_path = URI.decode_uri_component(params[:path].gsub('*', '.'))

    unless @shared_lib
      path = decoded_path
    else
      service = ::Files::SharedLibs::DataService.call(decoded_path)
      path = service.path
      @package = service.package
    end

    @stat_buf = File.stat(path)
  end
end
