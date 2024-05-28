class FilesController < ApplicationController
  def show
    @type = params[:type]
    decoded_path = URI.decode_uri_component(params[:path].gsub('*', '.'))

    case @type
    when 'shared_lib'
      service = ::Files::SharedLibs::DataService.call(decoded_path)
      @path = service.path
      @package = service.package
    when 'process_exe'
      service = ::Files::ProcessExecutable::LddTreeHashService.call(decoded_path)
      @ldd_tree = service.tree
      @path = decoded_path
    else
      @path = decoded_path
    end

    @stat_buf = File.stat(@path)
  end
end
