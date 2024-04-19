class FilesController < ApplicationController
  def show
    path = URI.decode_uri_component(params[:path].gsub('*', '.'))
    @stat_buf = Files::StatService.call(path)
  end
end
